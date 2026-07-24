/*
*    Infinity Loader :: Created By AgreedBog381 && SyGnUs Legends
*
*    Project : AIO Base
*    Author : 
*    Game : Call of Duty: Black Ops 3
*    Description : An empty canvas for anything you want!
*    Date : 09/10/2020 06:47:59
*
*/

CreateMenu()
{
    //Root menu MUST be registered under self.AIO["menuName"] -- that's the key every add_option/add_menu call
    //below uses (and what self.CurMenu is initialized to in MenuInit). Registering it under a different literal
    //key (as this used to do) leaves self.menu.getmenu[self.AIO["menuName"]] undefined, so the very first
    //add_option() call below indexes every menu array with an undefined key -- silent hard crash on PS4/GoldHEN.
    //No previous menu (undefined) -- pressing back at the root correctly falls through to _closeMenu().
    self add_menu(self.AIO["menuName"], undefined, self.AIO["menuName"]);

            //Player Features -- split into Movement/Combat/Stealth so no single screen exceeds the panel's 7-row display capacity
            A = "A";
            add_option(self.AIO["menuName"], "Player Features", ::submenu, A, "Player Features");
                add_menu(A, self.AIO["menuName"], "Player Features");

                    AM = "AM";
                    add_option(A, "Movement", ::submenu, AM, "Movement");
                        add_menu(AM, A, "Movement");
                            add_option(AM, "Speed Boost", ::MovementSpeed, true);
                            add_option(AM, "Multi Jump", ::MultiJump, true);
                            add_option(AM, "Third Person", ::ThirdPersonView, true);
                            add_option(AM, "Sprint Fire", ::SprintFire, true);
                            add_option(AM, "Unlimited Sprint", ::UnlimitedSprint, true);
                            add_option(AM, "Moon Gravity", ::MoonGravity, true);
                            add_option(AM, "Ice Skating", ::IceSkating, true);
                            add_option(AM, "Wall Run", ::WallRun, true);

                    AC = "AC";
                    add_option(A, "Combat", ::submenu, AC, "Combat");
                        add_menu(AC, A, "Combat");
                            add_option(AC, "God Mode", ::InfiniteHealth, true);
                            add_option(AC, "Unlimited Ammo", ::UnlimitedAmmo, true);
                            add_option(AC, "Unlimited Equipment", ::UnlimitedEquipment, true);
                            add_option(AC, "Perfect Accuracy", ::NoSpread, true);
                            add_option(AC, "Rapid Fire", ::RapidFire, true);
                            add_option(AC, "Explosive Bullets", ::ExplosiveBullets, true);
                            add_option(AC, "Headshot Anywhere", ::HeadDrama, true);
                            add_option(AC, "Nuke Grenades", ::NukeGrenades, true);
                            add_option(AC, "Cluster Grenades", ::ClusterGrenades, true);
                            add_option(AC, "Self Revive", ::SelfRevive);

                    AS = "AS";
                    add_option(A, "Stealth", ::submenu, AS, "Stealth");
                        add_menu(AS, A, "Stealth");
                            add_option(AS, "Invisibility", ::Invisibility, true);
                            add_option(AS, "Zombies Ignore You", ::ZombiesIgnoreYou, true);

                    AT = "AT";
                    add_option(A, "Teleport", ::submenu, AT, "Teleport");
                        add_menu(AT, A, "Teleport");
                            add_option(AT, "To Crosshair", ::TeleportCrosshair);
                            add_option(AT, "To Sky", ::TeleportSky);
                            add_option(AT, "Save Location", ::SaveLocation);
                            add_option(AT, "Load Location", ::LoadLocation);
                            add_option(AT, "Teleport Gun", ::TeleportGun, true);

                    AP = "AP";
                    add_option(A, "Power-Ups", ::submenu, AP, "Power-Ups");
                        add_menu(AP, A, "Power-Ups");
                            add_option(AP, "Nuke", ::dropPowerup, "nuke");
                            add_option(AP, "Insta-Kill", ::dropPowerup, "insta_kill");
                            add_option(AP, "Max Ammo", ::dropPowerup, "full_ammo");
                            add_option(AP, "Double Points", ::dropPowerup, "double_points");
                            add_option(AP, "Carpenter", ::dropPowerup, "carpenter");
                            add_option(AP, "Fire Sale", ::dropPowerup, "fire_sale");

                    AW = "AW";
                    add_option(A, "Weaponry", ::submenu, AW, "Weaponry");
                        add_menu(AW, A, "Weaponry");
                            add_option(AW, "Pack-a-Punch Weapon", ::PackCurrentWeapon);
                            add_option(AW, "Drop Current Weapon", ::DropCurrentWeapon);
                            add_option(AW, "Take Current Weapon", ::TakeCurrentWeapon);
                            add_option(AW, "Take All Weapons", ::TakeAllWeapons);

                    AF = "AF";
                    add_option(A, "Fun", ::submenu, AF, "Fun");
                        add_menu(AF, A, "Fun");
                            add_option(AF, "Noclip", ::Noclip, true);
                            add_option(AF, "UFO Mode", ::UFOMode, true);
                            add_option(AF, "Jetpack", ::Jetpack, true);
                            add_option(AF, "Grappling Gun", ::GrapplingGun, true);
                            add_option(AF, "Force Field", ::ForceField, true);

                    AU = "AU";
                    add_option(A, "Utility", ::submenu, AU, "Utility");
                        add_menu(AU, A, "Utility");
                            add_option(AU, "Give Points", ::GivePoints);
                            add_option(AU, "Perks Menu", ::submenu, "PerkMenu", "Perks");
                                add_menu("PerkMenu", AU, "Perks");//options filled dynamically by updatePerksMenu()

    if(self isVerified())//Verified Menu
    {
            THEME="THEME";
            add_option(self.AIO["menuName"], "Theme Menu", ::submenu, THEME, "Theme Menu");
                add_menu(THEME, self.AIO["menuName"], "Theme Menu");

                    COLORS = "COLORS";
                    add_option(THEME, "Colors", ::submenu, COLORS, "Colors");
                        add_menu(COLORS, THEME, "Colors");
                            add_option(COLORS, "^4Azure", ::applyAzureTheme);
                            add_option(COLORS, "^1Crimson", ::applyCrimsonTheme);
                            add_option(COLORS, "^2Emerald", ::applyEmeraldTheme);
                            add_option(COLORS, "^5Violet", ::applyVioletTheme);
                            add_option(COLORS, "^3Amber", ::applyAmberTheme);
                            add_option(COLORS, "^6Rose", ::applyRoseTheme);

                    add_option(THEME, "^1Demon ^4V6", ::applyDemonTheme);
                    add_option(THEME, "^1F^2l^3a^4s^5h^6i^7n^8g", ::toggleFlashingTheme);
    }
    if(self.status == "Host" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP")//Admin Panel -- wraps every tiered menu below under one entry so Main Menu itself never exceeds 7 rows; each item inside keeps its original per-tier gate
    {
            ADM = "ADM";
            add_option(self.AIO["menuName"], "Admin Panel", ::submenu, ADM, "Admin Panel");
                add_menu(ADM, self.AIO["menuName"], "Admin Panel");

                    B="B";
                    add_option(ADM, "Zombie Control", ::submenu, B, "Zombie Control");
                        add_menu(B, ADM, "Zombie Control");
                            add_option(B, "Kill All Zombies", ::killAllZombies);
                            add_option(B, "Freeze Zombies", ::freezeZombies, true);
                            add_option(B, "Teleport To You", ::teleportZombiesToYou);
                            add_option(B, "Speed: Walk", ::setZombieSpeed, "walk");
                            add_option(B, "Speed: Run", ::setZombieSpeed, "run");
                            add_option(B, "Speed: Sprint", ::setZombieSpeed, "sprint");

                    if(self.status == "Host" || self.status == "Co-Host" || self.status == "Admin")//Server Options (Admin+)
                    {
                            C="C";
                            add_option(ADM, "Server Options", ::submenu, C, "Server Options");
                                add_menu(C, ADM, "Server Options");
                                    add_option(C, "Super Jump", ::superJump, true);
                                    add_option(C, "Super Speed", ::superSpeed, true);
                                    add_option(C, "Low Gravity", ::lowGravity, true);
                                    add_option(C, "Open All Doors", ::openAllDoors);
                    }
                    if(self.status == "Host" || self.status == "Co-Host")//Game Speed (Co-Host+)
                    {
                            D="D";
                            add_option(ADM, "Game Speed", ::submenu, D, "Game Speed");
                                add_menu(D, ADM, "Game Speed");
                                    add_option(D, "Fast Motion", ::setGameSpeed, "2");
                                    add_option(D, "Slow Motion", ::setGameSpeed, "0.5");
                                    add_option(D, "Normal Speed", ::setGameSpeed, "1");
                    }
                    if(self isHost())//Host Tools (Host only)
                    {
                            E="E";
                            add_option(ADM, "Host Tools", ::submenu, E, "Host Tools");
                                add_menu(E, ADM, "Host Tools");
                                    add_option(E, "Disable Fog", ::disableFog, true);
                                    add_option(E, "SV Cheats", ::serverCheats, true);
                                    add_option(E, "Developer Mode", ::developerMode, true);
                                    add_option(E, "FOV 65 (Default)", ::setFOV, "65");
                                    add_option(E, "FOV 90", ::setFOV, "90");
                                    add_option(E, "FOV 120", ::setFOV, "120");
                                    add_option(E, "Restart Map", ::restartMap);
                                    add_option(E, "End Game", ::endGame);
                    }
                    if(self.status == "Host" || self.status == "Co-Host")//only co-host has access to the player menu
                    {
                            add_option(ADM, "Client Options", ::submenu, "PlayersMenu", "Client Options");
                                add_menu("PlayersMenu", ADM, "Client Options");
                                    for (i = 0; i < 18; i++)
                                    add_menu("pOpt " + i, "PlayersMenu", "");

                            F="F";
                            add_option(ADM, "All Clients", ::submenu, F, "All Clients");
                                add_menu(F, ADM, "All Clients");
                                    add_option(F, "Unverify All", ::changeVerificationAllPlayers, "Unverified");
                                    add_option(F, "Verify All", ::changeVerificationAllPlayers, "Verified");

                            LT = "LT";
                            add_option(ADM, "Lobby Tools", ::submenu, LT, "Lobby Tools");
                                add_menu(LT, ADM, "Lobby Tools");
                                    add_option(LT, "Give Points To All", ::giveAllPoints);
                                    add_option(LT, "Big Points To All", ::giveAllPointsBig);
                                    add_option(LT, "Revive All Players", ::reviveAllPlayers);
                                    add_option(LT, "All Quick Revive", ::giveAllQuickRevive);
                                    add_option(LT, "All Perks To All", ::giveAllPerksToAll);
                                    add_option(LT, "Kill All Players", ::killAllPlayers);

                            MSG = "MSG";
                            add_option(ADM, "Message Menu", ::submenu, MSG, "Message Menu");
                                add_menu(MSG, ADM, "Message Menu");
                                    add_option(MSG, "^2GG Everyone", ::broadcastMessage, "^2GG Everyone!");
                                    add_option(MSG, "^5Welcome To The Lobby", ::broadcastMessage, "^5Welcome To The Lobby!");
                                    add_option(MSG, "^3Have Fun", ::broadcastMessage, "^3Have Fun Everyone!");
                                    add_option(MSG, "^1Behave Yourself", ::broadcastMessage, "^1Behave Yourself!");
                                    add_option(MSG, "^6Powered By AIO", ::broadcastMessage, "^6Powered By AIO Base");
                    }
    }
}

//Rebuilt each time the Perks menu is opened -- lists exactly the perks that exist on the current map (level._custom_perks),
//so it works on every map with no hardcoded perk list. Same dynamic-rebuild pattern as updatePlayersMenu below.
updatePerksMenu()
{
    self endon("disconnect");

    self.menu.menucount["PerkMenu"] = 0;

    add_option("PerkMenu", "^2Give All Perks", ::GiveAllPerks);

    if(isDefined(level._custom_perks))
    {
        perks = getArrayKeys(level._custom_perks);

        for(i = 0; i < perks.size; i++)
            add_option("PerkMenu", perkName(perks[i]), ::togglePerk, perks[i]);
    }
}

updatePlayersMenu()
{
    self endon("disconnect");

    self.menu.menucount["PlayersMenu"] = 0;
    
    for (i = 0; i < 18; i++)
    {
        player = level.players[i];

        //Zombies lobbies hold at most 4 players, so slots past level.players.size are undefined -- skip them instead of calling getPlayerName() on an undefined entity (which would error and break this whole menu)
        if(!isDefined(player))
            continue;

        playerName = getPlayerName(player);
        playersizefixed = level.players.size - 1;

        if(self.menu.curs["PlayersMenu"] > playersizefixed)
        {
            self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
            self.menu.curs["PlayersMenu"] = playersizefixed;
        }

        add_option("PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName, ::submenu, "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
            add_menu("pOpt " + i, "PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName);
                add_option("pOpt " + i, "Status", ::submenu, "pOpt " + i + "_3", "[" + verificationToColor(player.status) + "^7] " + playerName);
                    add_menu("pOpt " + i + "_3", "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
                        add_option("pOpt " + i + "_3", "Unverify", ::changeVerificationMenu, player, "Unverified");
                        add_option("pOpt " + i + "_3", "^3Verify", ::changeVerificationMenu, player, "Verified");
                        add_option("pOpt " + i + "_3", "^4VIP", ::changeVerificationMenu, player, "VIP");
                        add_option("pOpt " + i + "_3", "^1Admin", ::changeVerificationMenu, player, "Admin");
                        add_option("pOpt " + i + "_3", "^5Co-Host", ::changeVerificationMenu, player, "Co-Host");
                        
        if(!player isHost())//makes it so no one can harm the host
        {
                add_option("pOpt " + i, "Options", ::submenu, "pOpt " + i + "_2", "[" + verificationToColor(player.status) + "^7] " + playerName);
                    add_menu("pOpt " + i + "_2", "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
                        add_option("pOpt " + i + "_2", "Kill Player", ::killPlayer, player);
                        add_option("pOpt " + i + "_2", "Take Weapons", ::takeWeapons, player);
                        add_option("pOpt " + i + "_2", "Revive Player", ::revivePlayer, player);
        }
    }
}

add_menu(Menu, prevmenu, menutitle)
{
    self.menu.getmenu[Menu] = Menu;
    self.menu.scrollerpos[Menu] = 0;
    self.menu.curs[Menu] = 0;
    self.menu.menucount[Menu] = 0;
    self.menu.subtitle[Menu] = menutitle;
    self.menu.previousmenu[Menu] = prevmenu;
}

add_option(Menu, Text, Func, arg1, arg2)
{
    Menu = self.menu.getmenu[Menu];
    Num  = self.menu.menucount[Menu];
    self.menu.menuopt[Menu][Num] = Text;
    self.menu.menufunc[Menu][Num] = Func;
    self.menu.menuinput[Menu][Num] = arg1;
    self.menu.menuinput1[Menu][Num] = arg2;
    self.menu.menucount[Menu] += 1;
}

_openMenu()
{
    self.recreateOptions = true;
    self freezeControlsallowlook(false);
    // self setClientUiVisibilityFlag("hud_visible", false);
    self enableInvulnerability();//do not remove
    self showHud();//opening menu effects 
    self thread StoreText(self.CurMenu, self.CurTitle);
    self updateScrollbar(); 
    self.menu.open       = true;
    self.recreateOptions = false;
}

_closeMenu()
{
    self freezeControlsallowlook(false);

    //do not remove
    if(!self.InfiniteHealth)
    self disableInvulnerability();

    //Mark closed BEFORE the ~1.1s close animation runs. overflowfix() only rebuilds menus it sees as open, so this
    //stops it from touching option elements while hideHud() is fading/freeing them (avoids a freed/undefined access).
    self.menu.open = false;

    self hideHud();//closing menu effects
    // self setClientUiVisibilityFlag("hud_visible", true);
}

giveMenu()
{
    if(self isVerified())
        self thread MenuInit();
}

destroyMenu()
{
    self notify("destroyMenu");
    
    self freezeControlsallowlook(false);
    
    //do not remove
    if(!self.InfiniteHealth) 
        self disableInvulnerability();
    
    if(isDefined(self.AIO["options"]))//do not remove this
    {
        for(i = 0; i < self.AIO["options"].size; i++)
            self.AIO["options"][i] destroy();

        self.AIO["options"] = undefined;//clear so the freed elements can't be destroyed twice
    }

        //self setClientUiVisibilityFlag("hud_visible", true);
    self.menu.open = false;
    
    wait 0.01;//do not remove this
    //destroys hud elements
    self.AIO["backgroundouter"] hud::destroyElem();
    self.AIO["barclose"] hud::destroyElem();
    self.AIO["background"] hud::destroyElem();
    self.AIO["scrollbar"] hud::destroyElem();
    self.AIO["scrolltab"] hud::destroyElem();
    self.AIO["headerdivider"] hud::destroyElem();
    self.AIO["footerdivider"] hud::destroyElem();
    self.AIO["bartop"] hud::destroyElem();
    self.AIO["barbottom"] hud::destroyElem();

    //destroys text elements
    self.AIO["title"] destroy();
    self.AIO["counter"] destroy();
    self.AIO["closeText"] destroy();
    self.AIO["status"] destroy();
}

submenu(input, title)
{
    if(!self.isOverflowing)
    {
        if(isDefined(self.AIO["options"]))//do not remove this
        {
            for(i = 0; i < self.AIO["options"].size; i++)
                self.AIO["options"][i] affectElement("alpha", 0, 0);
        }
        self.AIO["title"] affectElement("alpha", 0, 0);
        self.AIO["counter"] affectElement("alpha", 0, 0);
    }

    if (input == self.AIO["menuName"])
        self thread StoreText(input, self.AIO["menuName"]);
    else
        if (input == "PlayersMenu")
        {
            self updatePlayersMenu();
            self thread StoreText(input, "Client Options");
        }
        else
        if (input == "PerkMenu")//dynamic perk list, rebuilt from the current map's perks each time it's opened
        {
            self updatePerksMenu();
            self thread StoreText(input, "Perks");
        }
        else
            self thread StoreText(input, title);
            
    self.CurMenu = input;
    self.CurTitle = title;
    
    self.menu.scrollerpos[self.CurMenu] = self.menu.curs[self.CurMenu];
    self.menu.curs[input] = self.menu.scrollerpos[input];
    
    if(!self.isOverflowing)
    {
        if(isDefined(self.AIO["options"]))//do not remove this
        {
            for(i = 0; i < self.AIO["options"].size; i++)
                self.AIO["options"][i] affectElement("alpha", .2, 1);
        }
        self.AIO["title"] affectElement("alpha", .2, 1);
        self.AIO["counter"] affectElement("alpha", .2, .7);
    }
    
    self updateScrollbar();
    self.isOverflowing = false;
}