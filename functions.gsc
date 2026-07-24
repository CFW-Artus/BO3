/*
*    Infinity Loader :: Created By AgreedBog381 && SyGnUs Legends
*
*    Project : AIO Base
*    Author : 
*    Game : Call of Duty: Black Ops 3
*    Description : An empty canvas for anything you want!
*    Date : 09/10/2020 06:45:47
*
*/

InfiniteHealth(print)//DO NOT REMOVE THIS FUNCTION
{
    self.InfiniteHealth = booleanOpposite(self.InfiniteHealth);
    if(print) self iPrintlnBold(booleanReturnVal(self.InfiniteHealth, "God Mode ^1OFF", "God Mode ^2ON"));
    
    if(self.InfiniteHealth)
        self enableInvulnerability();
    else 
        if(!self.menu.open)
    self disableInvulnerability();
}

killPlayer(player)//DO NOT REMOVE THIS FUNCTION
{
       if(player!=self)
    {
        if(isAlive(player))
        {
            //Only the God Mode flag should block a kill. The original also required player.menu.open, which both
            //made kills only work while the target had their menu open AND errored on unverified targets (no player.menu).
            if(!player.InfiniteHealth)
            {
                self iPrintlnBold(getPlayerName(player) + " ^1Was Killed!");
                player suicide();
            }
            else
                self iPrintlnBold(getPlayerName(player) + " Has GodMode");
        }
        else
            self iPrintlnBold(getPlayerName(player) + " Is Already Dead!");
    }
    else
        self iprintlnBold("Your protected from yourself");
}

//Below: Sub Menu 1 features, adapted from the Apparition project's Functions/basic.gsc into this base's own toggle style (self.xxx booleans + iPrintlnBold feedback, same as InfiniteHealth above)

UnlimitedAmmo(print)
{
    self.UnlimitedAmmo = booleanOpposite(self.UnlimitedAmmo);
    if(print) self iPrintlnBold(booleanReturnVal(self.UnlimitedAmmo, "Unlimited Ammo ^1OFF", "Unlimited Ammo ^2ON"));

    if(self.UnlimitedAmmo)
        self thread doUnlimitedAmmo();
}

doUnlimitedAmmo()
{
    self notify("stop_unlimitedammo");//kill any previous instance so re-toggling never stacks duplicate loops
    self endon("stop_unlimitedammo");
    self endon("disconnect");
    self endon("death");

    while(self.UnlimitedAmmo)
    {
        weapon = self GetCurrentWeapon();

        if(isDefined(weapon) && weapon != level.weaponnone)
            self GiveMaxAmmo(weapon);

        wait 0.5;
    }
}

MovementSpeed(print)
{
    self.MovementSpeed = booleanOpposite(self.MovementSpeed);
    if(print) self iPrintlnBold(booleanReturnVal(self.MovementSpeed, "Speed Boost ^1OFF", "Speed Boost ^2ON"));

    if(self.MovementSpeed)
        self thread doMovementSpeed();
    else
        self SetMoveSpeedScale(1);
}

//Re-applied on a loop, not set once -- other systems (perks, downs, stance changes) can silently reset the move speed scale mid-game
doMovementSpeed()
{
    self notify("stop_movementspeed");//kill any previous instance so re-toggling never stacks duplicate loops
    self endon("stop_movementspeed");
    self endon("disconnect");
    self endon("death");

    while(self.MovementSpeed)
    {
        self SetMoveSpeedScale(1.5);
        wait 0.5;
    }
}

MultiJump(print)
{
    self.MultiJump = booleanOpposite(self.MultiJump);
    if(print) self iPrintlnBold(booleanReturnVal(self.MultiJump, "Multi Jump ^1OFF", "Multi Jump ^2ON"));

    if(self.MultiJump)
        self thread doMultiJump();
}

doMultiJump()
{
    self notify("stop_multijump");//kill any previous instance so re-toggling never stacks duplicate loops
    self endon("stop_multijump");
    self endon("disconnect");
    self endon("death");

    firstJump = true;

    while(self.MultiJump)
    {
        if(self IsOnGround())
            firstJump = true;

        if(self JumpButtonPressed() && !self IsOnGround() && firstJump)
        {
            while(self JumpButtonPressed())
                wait 0.01;

            firstJump = false;
        }

        if(isAlive(self) && !self IsOnGround() && !firstJump)
        {
            if(self JumpButtonPressed())
            {
                while(self JumpButtonPressed())
                    wait 0.01;

                self SetVelocity(self GetVelocity() + (0, 0, 250));
            }
        }

        wait 0.05;
    }
}

NoSpread(print)
{
    self.NoSpread = booleanOpposite(self.NoSpread);
    if(print) self iPrintlnBold(booleanReturnVal(self.NoSpread, "Perfect Accuracy ^1OFF", "Perfect Accuracy ^2ON"));

    if(self.NoSpread)
        self SetSpreadOverride(1);
    else
        self ResetSpreadOverride();
}

Invisibility(print)
{
    self.Invisibility = booleanOpposite(self.Invisibility);
    if(print) self iPrintlnBold(booleanReturnVal(self.Invisibility, "Invisibility ^1OFF", "Invisibility ^2ON"));

    if(self.Invisibility)
        self Hide();
    else
        self Show();
}

ThirdPersonView(print)
{
    self.ThirdPersonView = booleanOpposite(self.ThirdPersonView);
    if(print) self iPrintlnBold(booleanReturnVal(self.ThirdPersonView, "Third Person ^1OFF", "Third Person ^2ON"));

    self SetClientThirdPerson(self.ThirdPersonView);
}

ZombiesIgnoreYou(print)
{
    self.ZombiesIgnoreYou = booleanOpposite(self.ZombiesIgnoreYou);
    if(print) self iPrintlnBold(booleanReturnVal(self.ZombiesIgnoreYou, "Zombies Ignore You ^1OFF", "Zombies Ignore You ^2ON"));

    if(self.ZombiesIgnoreYou)
        self thread doZombiesIgnoreYou();
    else
        self.ignoreme = false;
}

//Re-applied on a loop, not set once -- the AI target-selection think cycle clears .ignoreme on its own
doZombiesIgnoreYou()
{
    self notify("stop_zombiesignore");//kill any previous instance so re-toggling never stacks duplicate loops
    self endon("stop_zombiesignore");
    self endon("disconnect");
    self endon("death");

    while(self.ZombiesIgnoreYou)
    {
        self.ignoreme = true;
        wait 0.5;
    }
}

SprintFire(print)
{
    self.SprintFire = booleanOpposite(self.SprintFire);
    if(print) self iPrintlnBold(booleanReturnVal(self.SprintFire, "Shoot While Sprinting ^1OFF", "Shoot While Sprinting ^2ON"));

    if(self.SprintFire)
        self SetPerk("specialty_sprintfire");
    else
        self UnSetPerk("specialty_sprintfire");
}

UnlimitedSprint(print)
{
    self.UnlimitedSprint = booleanOpposite(self.UnlimitedSprint);
    if(print) self iPrintlnBold(booleanReturnVal(self.UnlimitedSprint, "Unlimited Sprint ^1OFF", "Unlimited Sprint ^2ON"));

    if(self.UnlimitedSprint)
        self SetPerk("specialty_unlimitedsprint");
    else
        self UnSetPerk("specialty_unlimitedsprint");
}

//Local downed check -- BO3 has no bare isDown() native; this mirrors Apparition's proven helper (Menu/utilities.gsc) using only engine natives so the revive options are self-contained
isDown()
{
    if(!isDefined(self) || !isPlayer(self) || !isAlive(self))
        return false;

    return isDefined(self.revivetrigger);
}

SelfRevive()
{
    if(self isDown())
    {
        self zm_laststand::auto_revive(self);
        self iPrintlnBold("^2You Were Revived!");
    }
    else
        self iPrintlnBold("^1ERROR: ^7You're Not Downed");
}

takeWeapons(player)//DO NOT REMOVE THIS FUNCTION
{
    if(player != self)
    {
        foreach(weapon in player GetWeaponsList(1))
        {
            if(!isDefined(weapon) || weapon == level.weaponnone)
                continue;

            player TakeWeapon(weapon);
        }

        self iPrintlnBold(getPlayerName(player) + "'s Weapons Were Taken!");
    }
}

revivePlayer(player)//DO NOT REMOVE THIS FUNCTION
{
    if(player isDown())
    {
        player zm_laststand::auto_revive(player);
        self iPrintlnBold(getPlayerName(player) + " Was Revived!");
    }
    else
        self iPrintlnBold(getPlayerName(player) + " Is Not Downed!");
}

//Below: Utility group (self) -- points, weapon drop, and a single well-known perk grant

GivePoints()
{
    self zm_score::add_to_player_score(1000);
    self iPrintlnBold("^2+1000 Points");
}

TakeCurrentWeapon()
{
    weapon = self GetCurrentWeapon();

    if(isDefined(weapon) && weapon != level.weaponnone)
    {
        self TakeWeapon(weapon);
        self iPrintlnBold("Current Weapon Taken");
    }
}

//Below: Weaponry group (self), adapted from Apparition's Functions/weaponry.gsc. The originals carry build-kit/camo/
//attachment plumbing; these keep the verified upgrade/drop/take core (zm_weapons + natives) for a clean, safe port.

PackCurrentWeapon()
{
    self endon("disconnect");

    weapon = self GetCurrentWeapon();

    if(!isDefined(weapon) || weapon == level.weaponnone || !zm_weapons::can_upgrade_weapon(weapon))
        return self iPrintlnBold("^1ERROR: ^7This Weapon Can't Be Packed");

    newWeapon = !zm_weapons::is_weapon_upgraded(weapon) ? zm_weapons::get_upgrade_weapon(weapon) : zm_weapons::get_base_weapon(weapon);

    if(!isDefined(newWeapon))
        return self iPrintlnBold("^1ERROR: ^7This Weapon Can't Be Packed");

    self TakeWeapon(weapon);
    self GiveWeapon(newWeapon);
    self GiveMaxAmmo(newWeapon);
    self SwitchToWeapon(newWeapon);
    self iPrintlnBold("^2Weapon Pack-a-Punched");
}

DropCurrentWeapon()
{
    weapon = self GetCurrentWeapon();

    if(isDefined(weapon) && weapon != level.weaponnone)
    {
        self DropItem(weapon);
        self iPrintlnBold("Weapon Dropped");
    }
}

TakeAllWeapons()
{
    foreach(weapon in self GetWeaponsList(1))
        if(isDefined(weapon) && weapon != level.weaponnone)
            self TakeWeapon(weapon);

    self iPrintlnBold("All Weapons Taken");
}

//Below: Lobby Tools group (Host/Co-Host) -- same actions as above, applied to every connected player

giveAllPoints()//DO NOT REMOVE THIS FUNCTION
{
    foreach(player in level.players)
        player zm_score::add_to_player_score(1000);

    self iPrintlnBold("Gave +1000 Points To All Players");
}

reviveAllPlayers()//DO NOT REMOVE THIS FUNCTION
{
    foreach(player in level.players)
        if(player isDown())
            player zm_laststand::auto_revive(player);

    self iPrintlnBold("Revived All Downed Players");
}

giveAllQuickRevive()//DO NOT REMOVE THIS FUNCTION
{
    foreach(player in level.players)
        if(!player HasPerk("specialty_quickrevive"))
            player zm_perks::give_perk("specialty_quickrevive", true);

    self iPrintlnBold("Gave Quick Revive To All Players");
}

giveAllPerksToAll()//DO NOT REMOVE THIS FUNCTION
{
    if(!isDefined(level._custom_perks))
        return self iPrintlnBold("^1ERROR: ^7No Perks Available On This Map");

    perks = getArrayKeys(level._custom_perks);

    foreach(player in level.players)
        for(i = 0; i < perks.size; i++)
            if(!player HasPerk(perks[i]) && !player zm_perks::has_perk_paused(perks[i]))
                player zm_perks::give_perk(perks[i], true);

    self iPrintlnBold("Gave All Perks To All Players");
}

killAllPlayers()//DO NOT REMOVE THIS FUNCTION
{
    foreach(player in level.players)
        if(!player isHost() && isAlive(player) && !player.InfiniteHealth)
            player suicide();

    self iPrintlnBold("Killed All Players");
}

//Give Max Ammo All -- new feature. Refills the current weapon of every connected player.
giveAllPointsBig()//DO NOT REMOVE THIS FUNCTION
{
    foreach(player in level.players)
        player zm_score::add_to_player_score(100000);

    self iPrintlnBold("Gave +100000 Points To All Players");
}

//Message Menu -- broadcasts a preset message to every player (adapted from Apparition's Message Menu, using preset
//strings instead of its saved-text-input system since our framework has no text entry).
broadcastMessage(msg)//DO NOT REMOVE THIS FUNCTION
{
    foreach(player in level.players)
        player iPrintlnBold(msg);

    self iPrintlnBold("Message Sent");
}

//Below: extra Movement toggles (self) -- all use plain engine movement natives, same call shapes as Apparition's Functions/fun.gsc

MoonGravity(print)
{
    self.MoonGravity = booleanOpposite(self.MoonGravity);
    if(print) self iPrintlnBold(booleanReturnVal(self.MoonGravity, "Moon Gravity ^1OFF", "Moon Gravity ^2ON"));

    if(self.MoonGravity)
        self SetPlayerGravity(136);
    else
        self ClearPlayerGravity();
}

IceSkating(print)
{
    self.IceSkating = booleanOpposite(self.IceSkating);
    if(print) self iPrintlnBold(booleanReturnVal(self.IceSkating, "Ice Skating ^1OFF", "Ice Skating ^2ON"));

    self ForceSlick(self.IceSkating);
}

WallRun(print)
{
    self.WallRun = booleanOpposite(self.WallRun);
    if(print) self iPrintlnBold(booleanReturnVal(self.WallRun, "Wall Run ^1OFF", "Wall Run ^2ON"));

    self AllowWallRun(self.WallRun);
    self AllowDoubleJump(self.WallRun);
}

//Below: fly modes (Noclip / UFO), adapted from Apparition's Functions/basic.gsc. Apparition uses its own
//menu-instruction overlay + DisableMenuControls; here we request a clean menu close via self.forceCloseMenu
//(honored on the menu thread) and reuse the base's spawnModel() helper for the invisible mover entity.
//Controls in-world: [Attack]=forward/up, [ADS]=back/down, [Frag]=forward (UFO), [Melee]=exit.

Noclip(print)
{
    //Both fly modes share one mover entity, so refuse to enable one while the other is active
    if(!self.Noclip && self.UFOMode)
        return self iPrintlnBold("^1ERROR: ^7Disable UFO Mode First");

    self.Noclip = booleanOpposite(self.Noclip);
    if(print) self iPrintlnBold(booleanReturnVal(self.Noclip, "Noclip ^1OFF", "Noclip ^2ON"));

    if(self.Noclip)
        self thread doNoclip();
}

doNoclip()
{
    self notify("stop_noclip");
    self endon("stop_noclip");
    self endon("disconnect");
    //NOTE: intentionally NOT endon("death") -- we want the loop to fall through its isAlive() check on death so
    //stopFlyMode() runs and cleans up the mover entity/weapons instead of the thread dying and leaking them.

    self.forceCloseMenu = true;//ask the menu thread to close, then wait until it has

    while(self.menu.open)
        wait 0.05;

    self DisableWeapons();
    self SetStance("stand");

    self.flyLinker = spawnModel(self.origin, "tag_origin");
    self PlayerLinkTo(self.flyLinker, "tag_origin");

    while(self.Noclip && isAlive(self))
    {
        if(self AttackButtonPressed())
            self.flyLinker.origin = self.flyLinker.origin + AnglesToForward(self GetPlayerAngles()) * 40;
        else if(self AdsButtonPressed())
            self.flyLinker.origin = self.flyLinker.origin - AnglesToForward(self GetPlayerAngles()) * 40;

        if(self MeleeButtonPressed())
            break;

        wait 0.01;
    }

    self stopFlyMode("Noclip");
}

UFOMode(print)
{
    if(!self.UFOMode && self.Noclip)
        return self iPrintlnBold("^1ERROR: ^7Disable Noclip First");

    self.UFOMode = booleanOpposite(self.UFOMode);
    if(print) self iPrintlnBold(booleanReturnVal(self.UFOMode, "UFO Mode ^1OFF", "UFO Mode ^2ON"));

    if(self.UFOMode)
        self thread doUFOMode();
}

doUFOMode()
{
    self notify("stop_ufo");
    self endon("stop_ufo");
    self endon("disconnect");
    //NOTE: intentionally NOT endon("death") -- let the loop exit via isAlive() so stopFlyMode() cleans up.

    self.forceCloseMenu = true;

    while(self.menu.open)
        wait 0.05;

    self DisableWeapons();
    self SetStance("stand");

    self.flyLinker = spawnModel(self.origin, "tag_origin");
    self PlayerLinkTo(self.flyLinker, "tag_origin");

    while(self.UFOMode && isAlive(self))
    {
        self.flyLinker.angles = (0, self GetPlayerAngles()[1], 0);

        if(self AttackButtonPressed())
            self.flyLinker.origin = self.flyLinker.origin + (0, 0, 40);
        else if(self AdsButtonPressed())
            self.flyLinker.origin = self.flyLinker.origin - (0, 0, 40);

        if(self FragButtonPressed())
            self.flyLinker.origin = self.flyLinker.origin + AnglesToForward(self.flyLinker.angles) * 40;

        if(self MeleeButtonPressed())
            break;

        wait 0.01;
    }

    self stopFlyMode("UFO");
}

//Shared teardown for both fly modes -- unlink, remove the mover, restore weapons, clear the flag.
stopFlyMode(mode)
{
    if(mode == "Noclip")
        self.Noclip = false;
    else
        self.UFOMode = false;

    self Unlink();

    if(isDefined(self.flyLinker))
    {
        self.flyLinker delete();
        self.flyLinker = undefined;
    }

    if(isAlive(self))
        self EnableWeapons();
}

//Jetpack, adapted from Apparition's Functions/fun.gsc. Hold [Frag] to boost upward. The Apparition original also
//plays a fire effect (PlayFX with a precached effect); dropped here so there's no map effect dependency.
Jetpack(print)
{
    self.Jetpack = booleanOpposite(self.Jetpack);
    if(print) self iPrintlnBold(booleanReturnVal(self.Jetpack, "Jetpack ^1OFF", "Jetpack ^2ON"));

    if(self.Jetpack)
        self thread doJetpack();
}

doJetpack()
{
    self notify("stop_jetpack");
    self endon("stop_jetpack");
    self endon("disconnect");
    self endon("death");

    while(self.Jetpack)
    {
        if(self FragButtonPressed())
        {
            if(self IsOnGround())
                self SetOrigin(self.origin + (0, 0, 5));

            self SetVelocity(self GetVelocity() + (0, 0, 50));
        }

        wait 0.05;
    }
}

//Grappling Gun, adapted from Apparition's Functions/fun.gsc -- shoot to pull yourself to where you're aiming.
//This one needs no FX/models, so it ports 1:1 (reuses the base's spawnModel() for the invisible mover).
GrapplingGun(print)
{
    self.GrapplingGun = booleanOpposite(self.GrapplingGun);
    if(print) self iPrintlnBold(booleanReturnVal(self.GrapplingGun, "Grappling Gun ^1OFF", "Grappling Gun ^2ON"));

    if(self.GrapplingGun)
        self thread doGrapplingGun();
}

doGrapplingGun()
{
    self notify("stop_grapplinggun");
    self endon("stop_grapplinggun");
    self endon("disconnect");
    //no endon("death") -- if a grapple is in progress on death we still want the cleanup at the end to run

    while(self.GrapplingGun && isAlive(self))
    {
        self waittill("weapon_fired");

        if(!self.GrapplingGun || isDefined(self.grapplingent))
            continue;

        trace = BulletTrace(self GetEye(), self GetEye() + VectorScale(AnglesToForward(self GetPlayerAngles()), 1000000), 0, self);
        origin = trace["position"];
        surface = trace["surfacetype"];

        if(surface == "none" || surface == "default")
            continue;

        self.grapplingent = spawnModel(self.origin, "tag_origin");
        self PlayerLinkTo(self.grapplingent);
        self.grapplingent MoveTo(origin, 1);
        self.grapplingent waittill("movedone");

        self Unlink();

        if(isDefined(self.grapplingent))
        {
            self.grapplingent delete();
            self.grapplingent = undefined;
        }
    }

    //safety cleanup if the loop exits mid-grapple
    if(isDefined(self.grapplingent))
    {
        self Unlink();
        self.grapplingent delete();
        self.grapplingent = undefined;
    }
}

//Force Field, adapted from Apparition's Functions/fun.gsc. Apparition spawns 4 spinning powerup-skull models around
//the player (pure visual, clientfield FX + models); dropped here for stability. This keeps the verified core: a
//protective aura that instantly kills any zombie within ~100 units. No FX = no map effect-precache dependency.
ForceField(print)
{
    self.ForceField = booleanOpposite(self.ForceField);
    if(print) self iPrintlnBold(booleanReturnVal(self.ForceField, "Force Field ^1OFF", "Force Field ^2ON"));

    if(self.ForceField)
        self thread doForceField();
}

doForceField()
{
    self notify("stop_forcefield");
    self endon("stop_forcefield");
    self endon("disconnect");
    self endon("death");

    while(self.ForceField)
    {
        zombies = GetAITeamArray(level.zombie_team);

        for(a = 0; a < zombies.size; a++)
            if(isDefined(zombies[a]) && isAlive(zombies[a]) && Distance(self.origin, zombies[a].origin) <= 100)
                zombies[a] DoDamage(zombies[a].health + 666, self.origin);

        wait 0.1;
    }
}

//Below: extra Combat toggles (self)

RapidFire(print)
{
    self.RapidFire = booleanOpposite(self.RapidFire);
    if(print) self iPrintlnBold(booleanReturnVal(self.RapidFire, "Rapid Fire ^1OFF", "Rapid Fire ^2ON"));

    if(self.RapidFire)
        self thread doRapidFire();
}

doRapidFire()
{
    self notify("stop_rapidfire");//kill any previous instance so re-toggling never stacks duplicate loops
    self endon("stop_rapidfire");
    self endon("disconnect");
    self endon("death");

    while(self.RapidFire)
    {
        self waittill("weapon_fired");

        weapon = self GetCurrentWeapon();

        if(!isDefined(weapon) || weapon == level.weaponnone)
            continue;

        while(self.RapidFire && self AttackButtonPressed() && self GetCurrentWeapon() == weapon)
        {
            start = self GetEye();
            end = self traceBullet();
            MagicBullet(weapon, start, end, self);
            wait 0.1;
        }
    }
}

HeadDrama(print)
{
    self.HeadDrama = booleanOpposite(self.HeadDrama);
    if(print) self iPrintlnBold(booleanReturnVal(self.HeadDrama, "Headshot Anywhere ^1OFF", "Headshot Anywhere ^2ON"));

    if(self.HeadDrama)
        self SetPerk("specialty_locdamagecountsasheadshot");
    else
        self UnSetPerk("specialty_locdamagecountsasheadshot");
}

//Below: grenade mods + equipment, adapted from Apparition's Functions/fun.gsc & basic.gsc. The Apparition
//originals add powerup FX/models and zm_utility mine checks; these keep the verified core mechanics only (natives)
//so there is no effect-precache dependency to break on any map.

NukeGrenades(print)
{
    self.NukeGrenades = booleanOpposite(self.NukeGrenades);
    if(print) self iPrintlnBold(booleanReturnVal(self.NukeGrenades, "Nuke Grenades ^1OFF", "Nuke Grenades ^2ON"));

    if(self.NukeGrenades)
        self thread doNukeGrenades();
}

doNukeGrenades()
{
    self notify("stop_nukegrenades");//single-instance guard, same pattern as the other loops
    self endon("stop_nukegrenades");
    self endon("disconnect");
    self endon("death");

    while(self.NukeGrenades)
    {
        self waittill("grenade_fire", grenade, weapon);

        if(isDefined(grenade))
            self thread nukeGrenadeDamage(grenade);
    }
}

nukeGrenadeDamage(grenade)
{
    self endon("disconnect");

    origin = grenade.origin;

    while(isDefined(grenade))//follow the grenade until it detonates
    {
        origin = grenade.origin;
        wait 0.05;
    }

    zombies = GetAITeamArray(level.zombie_team);

    for(a = 0; a < zombies.size; a++)
        if(isDefined(zombies[a]) && isAlive(zombies[a]) && Distance(origin, zombies[a].origin) <= 500)
            zombies[a] DoDamage(zombies[a].health + 666, origin);
}

ClusterGrenades(print)
{
    self.ClusterGrenades = booleanOpposite(self.ClusterGrenades);
    if(print) self iPrintlnBold(booleanReturnVal(self.ClusterGrenades, "Cluster Grenades ^1OFF", "Cluster Grenades ^2ON"));

    if(self.ClusterGrenades)
        self thread doClusterGrenades();
}

doClusterGrenades()
{
    self notify("stop_clustergrenades");
    self endon("stop_clustergrenades");
    self endon("disconnect");
    self endon("death");

    while(self.ClusterGrenades)
    {
        self waittill("grenade_fire", grenade, weapon);

        if(!isDefined(grenade) || !isDefined(weapon))
            continue;

        while(isDefined(grenade))
        {
            origin = grenade.origin;
            wait 0.1;
        }

        for(a = 0; a < 10; a++)
            self MagicGrenadeType(weapon, origin, (randomIntRange(-200, 200), randomIntRange(-200, 200), randomIntRange(200, 400)), ((30 + a) / 10));
    }
}

UnlimitedEquipment(print)
{
    self.UnlimitedEquipment = booleanOpposite(self.UnlimitedEquipment);
    if(print) self iPrintlnBold(booleanReturnVal(self.UnlimitedEquipment, "Unlimited Equipment ^1OFF", "Unlimited Equipment ^2ON"));

    if(self.UnlimitedEquipment)
        self thread doUnlimitedEquipment();
}

doUnlimitedEquipment()
{
    self notify("stop_unlimitedequip");
    self endon("stop_unlimitedequip");
    self endon("disconnect");
    self endon("death");

    while(self.UnlimitedEquipment)
    {
        lethal = self zm_utility::get_player_lethal_grenade();
        tactical = self zm_utility::get_player_tactical_grenade();

        if(isDefined(lethal) && lethal != level.weaponnone)
        {
            if(!self HasWeapon(lethal))
                self GiveWeapon(lethal);

            self GiveMaxAmmo(lethal);
        }

        if(isDefined(tactical) && tactical != level.weaponnone)
        {
            if(!self HasWeapon(tactical))
                self GiveWeapon(tactical);

            self GiveMaxAmmo(tactical);
        }

        self waittill("grenade_fire");
    }
}

//Explosive Bullets, adapted from Apparition's Bullet Menu. Apparition's version plays an impact FX; dropped here.
//Keeps the verified core: on each shot, AoE-kill zombies near where the crosshair was pointing. No FX dependency.
ExplosiveBullets(print)
{
    self.ExplosiveBullets = booleanOpposite(self.ExplosiveBullets);
    if(print) self iPrintlnBold(booleanReturnVal(self.ExplosiveBullets, "Explosive Bullets ^1OFF", "Explosive Bullets ^2ON"));

    if(self.ExplosiveBullets)
        self thread doExplosiveBullets();
}

doExplosiveBullets()
{
    self notify("stop_explosivebullets");
    self endon("stop_explosivebullets");
    self endon("disconnect");
    self endon("death");

    while(self.ExplosiveBullets)
    {
        self waittill("weapon_fired");

        origin = self traceBullet();
        zombies = GetAITeamArray(level.zombie_team);

        for(a = 0; a < zombies.size; a++)
            if(isDefined(zombies[a]) && isAlive(zombies[a]) && Distance(origin, zombies[a].origin) <= 200)
                zombies[a] DoDamage(zombies[a].health + 666, origin);
    }
}

GiveAllPerks()
{
    if(!isDefined(level._custom_perks))
        return self iPrintlnBold("^1ERROR: ^7No Perks Available On This Map");

    perks = getArrayKeys(level._custom_perks);

    for(i = 0; i < perks.size; i++)
        if(!self HasPerk(perks[i]) && !self zm_perks::has_perk_paused(perks[i]))
            self zm_perks::give_perk(perks[i], true);

    self iPrintlnBold("^2All Perks Given");
}

//Toggle a single perk on/off (adapted from Apparition's GivePlayerPerk). Uses the perks already included in main.gsc.
togglePerk(perk)
{
    if(self HasPerk(perk) || self zm_perks::has_perk_paused(perk))
    {
        self notify(perk + "_stop");
        self iPrintlnBold("^1Removed ^7" + perkName(perk));
    }
    else
    {
        self zm_perks::give_perk(perk, true);
        self iPrintlnBold("^2Gave ^7" + perkName(perk));
    }
}

//Maps a raw perk key to a friendly name (subset of Apparition's ReturnPerkName); falls back to the cleaned key.
perkName(perk)
{
    key = perk;

    if(isSubStr(key, "specialty_"))
        key = getSubStr(key, 10);//strip the "specialty_" prefix (10 chars)

    switch(key)
    {
        case "armorvest":                return "Jugger-Nog";
        case "fastreload":               return "Speed Cola";
        case "doubletap2":               return "Double Tap";
        case "quickrevive":              return "Quick Revive";
        case "deadshot":                 return "Deadshot Daiquiri";
        case "staminup":                 return "Stamin-Up";
        case "additionalprimaryweapon":  return "Mule Kick";
        case "widowswine":               return "Widow's Wine";
        case "electriccherry":           return "Electric Cherry";
        case "flakjacket":               return "PhD Flopper";
        case "phdflopper":               return "PhD Flopper";
        case "scavenger":                return "Vulture Aid";
        case "vultureaid":               return "Vulture Aid";
        case "widows_wine":              return "Widow's Wine";
        default:                         return key;
    }
}

//Below: Teleport group (self) -- traceBullet()-based crosshair aim, plus save/load. No map FX so it's safe on every map

traceBullet()//returns the world position your crosshair is pointing at
{
    return BulletTrace(self GetEye(), self GetEye() + VectorScale(AnglesToForward(self GetPlayerAngles()), 1000000), 0, self)["position"];
}

TeleportCrosshair()
{
    self SetOrigin(self traceBullet());
    self iPrintlnBold("Teleported To Crosshair");
}

TeleportSky()
{
    self SetOrigin(self.origin + (0, 0, 5000));
    self iPrintlnBold("Teleported To Sky");
}

SaveLocation()
{
    self.SavedOrigin = self.origin;
    self.SavedAngles = self.angles;
    self iPrintlnBold("^2Location Saved");
}

LoadLocation()
{
    if(!isDefined(self.SavedOrigin))
        return self iPrintlnBold("^1ERROR: ^7No Saved Location");

    self SetOrigin(self.SavedOrigin);
    self SetPlayerAngles(self.SavedAngles);
    self iPrintlnBold("Location Loaded");
}

TeleportGun(print)
{
    self.TeleportGun = booleanOpposite(self.TeleportGun);
    if(print) self iPrintlnBold(booleanReturnVal(self.TeleportGun, "Teleport Gun ^1OFF", "Teleport Gun ^2ON"));

    if(self.TeleportGun)
        self thread doTeleportGun();
}

doTeleportGun()
{
    self notify("stop_teleportgun");//kill any previous instance so re-toggling never stacks duplicate loops
    self endon("stop_teleportgun");
    self endon("disconnect");
    self endon("death");

    while(self.TeleportGun)
    {
        self waittill("weapon_fired");
        self SetOrigin(self traceBullet());
    }
}

//Below: Power-Ups group (self) -- drops a standard powerup at your crosshair. All six exist on every zombies map

dropPowerup(powerup)
{
    trace = BulletTrace(self GetEye(), self GetEye() + VectorScale(AnglesToForward(self GetPlayerAngles()), 1000000), 0, self);
    origin = trace["position"];
    surface = trace["surfacetype"];

    if(isDefined(surface) && (surface == "none" || surface == "default"))
        return self iPrintlnBold("^1ERROR: ^7Invalid Surface, Aim At The Ground");

    level zm_powerups::specific_powerup_drop(powerup, origin);
}

//Below: tiered Admin Panel functions -- server/lobby-wide tools. All use bare engine natives (GetAITeamArray, DoDamage, SetDvar/GetDvar, SetJumpHeight, Map, exitlevel), so no extra includes are required. Level-scope toggles live on level.xxx and booleanOpposite() safely handles their first (undefined) call, exactly like the self toggles.

killAllZombies()
{
    zombies = GetAITeamArray(level.zombie_team);

    if(!isDefined(zombies))
        return;

    for(i = 0; i < zombies.size; i++)
        if(isDefined(zombies[i]) && isAlive(zombies[i]))
            zombies[i] DoDamage(zombies[i].health + 666, zombies[i].origin);

    self iPrintlnBold("Killed All Zombies");
}

freezeZombies(print)
{
    level.freezeZombies = booleanOpposite(level.freezeZombies);
    if(print) self iPrintlnBold(booleanReturnVal(level.freezeZombies, "Freeze Zombies ^1OFF", "Freeze Zombies ^2ON"));

    if(level.freezeZombies)
        SetDvar("g_ai", "0");
    else
        SetDvar("g_ai", "1");
}

//Adapted from Apparition's TeleportZombies -- keeps the ForceTeleport core, drops the internal AI-state pokes
//(find_flesh_struct_string etc.) which are behaviour-internal; the zombies re-path on their own after teleport.
teleportZombiesToYou()
{
    origin = self traceBullet();

    zombies = GetAITeamArray(level.zombie_team);

    for(a = 0; a < zombies.size; a++)
        if(isDefined(zombies[a]) && isAlive(zombies[a]))
            zombies[a] ForceTeleport(origin);

    self iPrintlnBold("Teleported Zombies To Crosshair");
}

//Adapted from Apparition's SetZombieRunSpeed. Applies to the zombies currently alive (new spawns use the map
//default unless a spawn hook is added -- deliberately omitted to keep this a stable, self-contained action).
setZombieSpeed(speed)
{
    zombies = GetAITeamArray(level.zombie_team);

    for(a = 0; a < zombies.size; a++)
        if(isDefined(zombies[a]) && isAlive(zombies[a]))
            zombies[a] zombie_utility::set_zombie_run_cycle(speed);

    self iPrintlnBold("Zombie Speed Set: ^3" + speed);
}

superJump(print)
{
    level.superJump = booleanOpposite(level.superJump);
    if(print) self iPrintlnBold(booleanReturnVal(level.superJump, "Super Jump ^1OFF", "Super Jump ^2ON"));

    if(level.superJump)
        SetJumpHeight(1023);
    else
        SetJumpHeight(39);
}

lowGravity(print)
{
    level.lowGravity = booleanOpposite(level.lowGravity);
    if(print) self iPrintlnBold(booleanReturnVal(level.lowGravity, "Low Gravity ^1OFF", "Low Gravity ^2ON"));

    if(level.lowGravity)
        SetDvar("bg_gravity", "200");
    else
        SetDvar("bg_gravity", "800");
}

superSpeed(print)
{
    level.superSpeed = booleanOpposite(level.superSpeed);
    if(print) self iPrintlnBold(booleanReturnVal(level.superSpeed, "Super Speed ^1OFF", "Super Speed ^2ON"));

    if(level.superSpeed)
        SetDvar("g_speed", "350");
    else
        SetDvar("g_speed", "190");
}

//Adapted from Apparition's OpenAllDoors -- keeps the door-triggering logic (SetDvar + GetEntArray + notify),
//drops the Apparition-only menu-refresh calls. One-shot server action.
openAllDoors()
{
    self endon("disconnect");

    SetDvar("zombie_unlock_all", 1);

    types = [];
    types[0] = "zombie_door";
    types[1] = "zombie_airlock_buy";
    types[2] = "zombie_debris";

    for(i = 0; i < 2; i++)//run twice to catch doors gated behind other doors
    {
        for(a = 0; a < types.size; a++)
        {
            doors = GetEntArray(types[a], "targetname");

            if(!isDefined(doors))
                continue;

            for(b = 0; b < doors.size; b++)
            {
                if(!isDefined(doors[b]))
                    continue;

                if(types[a] == "zombie_debris")
                    doors[b] notify("trigger", self, 1);
                else
                {
                    doors[b] notify("trigger");

                    if(types[a] == "zombie_door" && isDefined(doors[b].script_noteworthy) && (doors[b].script_noteworthy == "electric_door" || doors[b].script_noteworthy == "electric_buyable_door"))
                    {
                        doors[b] notify("power_on");
                        doors[b].power_on = true;
                    }
                }

                wait 0.05;
            }
        }

        wait 1;
    }

    level.local_doors_stay_open = 1;
    level.power_local_doors_globally = 1;
    level notify("open_sesame");
    SetDvar("zombie_unlock_all", 0);

    self iPrintlnBold("Opened All Doors");
}

setGameSpeed(speed)
{
    SetDvar("timescale", speed);
    self iPrintlnBold("Game Speed Set");
}

restartMap()
{
    self iPrintlnBold("^3Restarting Map...");
    wait 1;
    Map(level.script);
}

endGame()
{
    self iPrintlnBold("^3Ending Game...");
    wait 1;
    exitlevel(false);
}

//Below: host dvar toggles, adapted from Apparition's Menu/utilities.gsc (DisableFog/ServerCheats/SetDeveloperMode).
//Simple GetDvar/SetDvar flips, stored at level scope so state stays consistent for the host who set them.

disableFog(print)
{
    level.disableFog = booleanOpposite(level.disableFog);
    if(print) self iPrintlnBold(booleanReturnVal(level.disableFog, "Disable Fog ^1OFF", "Disable Fog ^2ON"));

    SetDvar("r_fog", booleanReturnVal(level.disableFog, "1", "0"));
}

serverCheats(print)
{
    level.serverCheats = booleanOpposite(level.serverCheats);
    if(print) self iPrintlnBold(booleanReturnVal(level.serverCheats, "SV Cheats ^1OFF", "SV Cheats ^2ON"));

    SetDvar("sv_cheats", booleanReturnVal(level.serverCheats, "0", "1"));
}

developerMode(print)
{
    level.developerMode = booleanOpposite(level.developerMode);
    if(print) self iPrintlnBold(booleanReturnVal(level.developerMode, "Developer Mode ^1OFF", "Developer Mode ^2ON"));

    SetDvar("developer", booleanReturnVal(level.developerMode, "0", "2"));
}

//Field of view -- discrete presets (adapted from Apparition's FieldOfView slider). Plain cg_fov dvar, host/local.
setFOV(value)
{
    SetDvar("cg_fov", value);
    self iPrintlnBold("FOV Set: ^3" + value);
}
