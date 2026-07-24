/*
*    Infinity Loader :: Created By AgreedBog381 && SyGnUs Legends
*
*    Project : AIO Base
*    Author : Vampy
*    Game : Call of Duty: Black Ops 3
*    Description : Starts Multiplayer code execution!
*    Date : 09/10/2020 06:30:47
*
*/

#include scripts\codescripts\struct;
#include scripts\shared\callbacks_shared;
#include scripts\shared\clientfield_shared;
#include scripts\shared\math_shared;
#include scripts\shared\system_shared;
#include scripts\shared\util_shared;
#include scripts\shared\hud_util_shared;
#include scripts\shared\hud_message_shared;
#include scripts\shared\hud_shared;
#include scripts\shared\array_shared;
#include scripts\shared\flag_shared;
// Switched from #using to #include: Apparition (github.com/CF4x99/Apparition), confirmed working on PS4 via the
// exact same hot-injection method, #includes every one of these zm_ scripts directly and has no issue with it.
// The earlier #using-only approach was an untested assumption, not a confirmed requirement.
#include scripts\zm\_zm_laststand;
#include scripts\zm\_zm_score;
#include scripts\zm\_zm_perks;
#include scripts\zm\_zm_powerups;
#include scripts\zm\_zm_utility;
#include scripts\zm\_zm_weapons;
#include scripts\shared\ai\zombie_utility;

#namespace infinityloader;

//required -- runs the instant the script loads. Mirrors Apparition's __init__system__: registers with system::
//and does nothing else. callback::on_spawned (registered below) catches players already spawned at inject time
//on its own -- no extra self-threading needed here.
autoexec __init__system__()
{
    system::register("infinityloader", ::__init__, undefined, undefined);
}

//required -- registered by system::register. Hooks callback::on_spawned, which calls onPlayerSpawned() fresh on
//every player spawn -- including players already spawned at the moment of injection.
__init__()
{
    callback::on_spawned(::onPlayerSpawned);
}

//Level-wide init, guarded to run exactly once no matter which path reaches it first.
ensureLevelInit()
{
    if(isDefined(level.AIO_started))
        return;
    level.AIO_started = true;

    level.result = 1;//set to 1 for the overflow fix string
    level.AIO_visibleRows = 7;//how many option rows the panel shows at once; scroller windows longer menus
    level.firstHostSpawned = false;
}

//First-time-only per-player setup: assign access level and build the menu. Called from onPlayerSpawned.
setupMenuPlayer()
{
    //Solo (a single player) is always treated as Host so the menu appears with no extra config. In co-op the normal
    //host check applies -- "Utilisateur1" is a name-based fallback for offline PS4 profiles (isHost() can be
    //unreliable when not signed into PSN), matching the local profile name used for testing.
    if(self isHost() || getPlayerName(self) == "Utilisateur1" || level.players.size <= 1)
        self.status = "Host";
    else
        self.status = "Unverified";

    if(self isVerified())
        self giveMenu();
}

//callback::on_spawned calls this fresh on EVERY spawn (initial catch-up for players already in at inject time,
//round start, respawn) -- it is NOT a persistent loop, matching Apparition's onPlayerSpawned exactly. The guard
//below only protects against this same spawn's dispatch re-entering concurrently, not against future spawns.
onPlayerSpawned()
{
    //notify-then-endon on the SAME string (same idiom as doNoclip/doUnlimitedAmmo/etc. elsewhere in this project)
    //instead of a persistent self.xxx boolean guard: a boolean set true at the top and only cleared at the very
    //end can get stuck true forever on this player entity if anything in between errors out mid-run (entity
    //fields persist across re-injection within the same session) -- silently blocking every future spawn/re-inject
    //with an early return, even once the underlying bug is fixed. This pattern can never get stuck: each new
    //invocation just supersedes whichever one was running before, with no state left behind to go stale.
    self notify("AIO_onPlayerSpawned");
    self endon("AIO_onPlayerSpawned");
    self endon("disconnect");

    ensureLevelInit();

    self unfreeze();

    if(!isDefined(self.status))//first time this player is seen -- assign access level and build the menu
        self setupMenuPlayer();

    self unArchiveMenuHuds();
    self onSpawnPass();
}

//Un-hides the persistent menu HUD elements. self.AIO only exists for players who have a menu (verified), so the
//guard stops unverified players -- who have no HUD -- from erroring here and killing their spawn handler thread.
unArchiveMenuHuds()
{
    if(!isDefined(self.AIO))
        return;

    self.AIO["closeText"].archived = false;
    self.AIO["barclose"].archived = false;
    self.AIO["bartop"].archived = false;
    self.AIO["barbottom"].archived = false;
    self.AIO["background"].archived = false;
    self.AIO["backgroundouter"].archived = false;
    self.AIO["scrollbar"].archived = false;
    self.AIO["scrolltab"].archived = false;
    self.AIO["headerdivider"].archived = false;
    self.AIO["footerdivider"].archived = false;
    self.AIO["title"].archived = false;
    self.AIO["counter"].archived = false;
    self.AIO["status"].archived = false;
}

//Everything that must happen on (or immediately after) a player spawn. Called once on inject if already alive, and
//again on every real spawn -- so it must stay idempotent-safe (the firstHostSpawned / isFirstSpawn guards handle that).
onSpawnPass()
{
    if(!level.firstHostSpawned && self.status == "Host")//the first host spawn kicks off the overflow fix
    {
        self thread overflowfix();
        level.firstHostSpawned = true;
    }

    self resetBooleans();//resets variable bools

    if(self isVerified())
    {
        self iPrintln("Welcome to " + self.AIO["menuName"]);

        if(self.menu.open)//if the menu is open when you spawn
            self freezeControlsallowlook(true);
    }

    if(!self.isFirstSpawn)//First official spawn
    {
        if(self isHost())
            self freezecontrols(false);

        self.isFirstSpawn = true;
    }
}

MenuInit()
{
    //Supersede any previous MenuInit() instance instead of relying on a self.MenuInit boolean that could get stuck
    //true forever if a prior run errored out partway (see giveMenu() in menu.gsc for the full explanation).
    self notify("AIO_MenuInit");
    self endon("AIO_MenuInit");
    self endon("disconnect");
    self endon("destroyMenu");
    level endon("game_ended");

    self.isOverflowing = false;

    self.menu = spawnstruct();
    self.menu.open = false;

    self.AIO = [];
    self.AIO["menuName"] = "AIO Menu Base";//Put your menu name here

    //Setting the menu position for when it's first open
    self.CurMenu = self.AIO["menuName"];
    self.CurTitle = self.AIO["menuName"];

    self StoreHuds();
    self CreateMenu();

    for(;;)
    {
        //A feature (e.g. Noclip/UFO) can request the menu close by setting self.forceCloseMenu -- it is honored HERE,
        //on the menu's own thread, so the close animation never runs concurrently with the input loop touching the HUD.
        if(isDefined(self.forceCloseMenu) && self.forceCloseMenu)
        {
            self.forceCloseMenu = false;

            if(self.menu.open)
                self _closeMenu();
        }

        if(self adsButtonPressed() && self meleeButtonPressed() && !self.menu.open)
        {
            wait 0.1;
            self _openMenu();
        }
        if(self.menu.open)
        {
            if (self stanceButtonPressed()) 
                self _closeMenu();
        
            if(self meleeButtonPressed())
            {
                if(isDefined(self.menu.previousmenu[self.CurMenu]))
                {
                    self submenu(self.menu.previousmenu[self.CurMenu], self.menu.subtitle[self.menu.previousmenu[self.CurMenu]]);
                }
                else 
                    self _closeMenu();
                    
                wait 0.20;
            }
            if(self actionSlotOneButtonPressed())//scrolls up
            {
                self.menu.curs[self.CurMenu]--;
                self updateScrollbar();
                wait 0.124;
            }
            if(self actionSlotTwoButtonPressed())//scrolls down
            {
                self.menu.curs[self.CurMenu]++;
                self updateScrollbar();
                wait 0.124;
            }
            if(self useButtonPressed())
            {
                //Debounce applies to BOTH branches -- it used to live only in the else, so any option carrying a
                //second argument (every ::submenu navigation, since submenu(input, title) always passes two) had
                //no cooldown at all: holding the button for more than one 0.05s tick re-triggered the selection
                //repeatedly, cascading through several menu levels from a single press.
                if(isDefined(self.menu.menuinput1[self.CurMenu][self.menu.curs[self.CurMenu]]))
                    self thread [[self.menu.menufunc[self.CurMenu][self.menu.curs[self.CurMenu]]]](self.menu.menuinput[self.CurMenu][self.menu.curs[self.CurMenu]], self.menu.menuinput1[self.CurMenu][self.menu.curs[self.CurMenu]]);
                else
                    self thread [[self.menu.menufunc[self.CurMenu][self.menu.curs[self.CurMenu]]]](self.menu.menuinput[self.CurMenu][self.menu.curs[self.CurMenu]]);

                wait 0.20;
            }
        }
        wait 0.05;
    }
}

unfreeze()
{
       self freezeControlsallowlook(false);
       self freezeControls(false);
}


