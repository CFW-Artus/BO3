<meta charset="utf-8">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<body>

<style>
body
{
background-color: #191919 !important;
font-size: 18px;
color: #cccccc;
}

.block-style
{
background-color: #303030;
border-color: #bce8f1;
padding-left: 15px;
border: 1px solid;
border-radius: 4px
}

.text-live
{
color: #8492a6;
}

.content
{
padding: 0px 40px 40px 40px;
}

.scrollbar
{
height: 100%;
width: 100%;
overflow-y: auto;
overflow-x: hidden;
}

#style-1::-webkit-scrollbar
{
width: 12px;
background-color: #191919;
}

#style-1::-webkit-scrollbar-thumb
{
border-radius: 2px;
-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
box-shadow: inset 0 0 6px rgba(0,0,0,.3);
background-color: #555;
}

#style-1::-webkit-scrollbar-track
{
-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
border-radius: 2px;
background-color: #303030;
}
</style>

<div class="scrollbar" id="style-1">
<div class="content">

## :sparkles: TODO :sparkles:

:::{.alert .block-style .text-muted}
- Fill the tiered Admin sub-menus with any server-specific tools you want
- Optional: per-user saved theme preference across matches
:::

## :fire: Changelog :fire:

<!-- current version -->
:::{.alert .block-style .text-live}
Version - Nougat :candy:
- Fixed the menu never appearing: root menu was registered under an unused key, corrupting every option lookup
- Fixed PS4/GoldHEN silent close: entry point restructured to match a proven-working reference (single system::register + callback::on_spawned, no redundant self-threading), #include instead of #using for zm_ scripts
- resetBooleans() now clears every persistent toggle on respawn, not just God Mode
- Note: this is the exact set of features last confirmed working in-game. Everything added after this point (extra Combat/Lobby Tools functions, diagnostic logging) has been rolled back after a regression that couldn't be isolated -- re-add features one at a time with an in-game test after each, not in batches.
- Removed leftover debug logging and duplicate spawn-handler threads
:::

<!-- version -->
:::{.alert .block-style .text-live}
Version - Marshmallow :sparkles:
- Apparition feature port (self-contained + stable only): Noclip, UFO, Jetpack, Grappling Gun, Force Field
- Combat: Explosive Bullets, Nuke/Cluster Grenades, Unlimited Equipment, Rapid Fire, Head Drama
- Weaponry: Pack-a-Punch, Drop / Take current, Take all weapons
- Dynamic Perks menu (per-map), Zombie Control (kill/freeze/teleport/speed), Message Menu, expanded Lobby Tools
- Host Tools: Disable Fog, SV Cheats, Developer Mode, FOV presets, Open All Doors
- Framework: added self.forceCloseMenu (clean menu-close request honored on the menu thread) for the fly modes
:::

<!-- version -->
:::{.alert .block-style .text-live}
Version - Lollipop :lollipop:
- Redesigned HUD: slate panel, theme accent dividers, selection tab, live option counter
- Rewrote the option list as a windowed scroller that handles menus of any length (fixes the original 7-vs-10 row crash)
- Themes: Azure / Crimson / Emerald / Violet / Amber / Rose + Demon V6 + Flashing, all synced across every accent element
- Premium polish: smoothly gliding selection highlight, snappier open/close animations, opaque high-contrast panel
- Stability pass: guarded every unverified-player code path (spawn handler, overflow fix, kill/client menus) against crashes
:::

<!-- previous version -->
:::{.alert .block-style .text-live}
Version - Doughnut :doughnut:
- Player Features: Movement, Combat, Stealth, Teleport, Power-Ups and Utility groups
- Admin Panel: Zombie Control, Server Options, Game Speed, Host Tools, Client Options and Lobby Tools (all tier-gated)
- Per-player admin actions: Kill, Take Weapons, Revive
:::

<!-- base -->
:::{.alert .block-style .text-live}
Version - Icecream :icecream:
- Infinity Loader AIO Base foundation (menu framework, verification tiers, HUD helpers)
:::

![Infinity Loader](https://www.youtube.com/watch?v=OgtJ8_wQXi0)

[MarkDown Cheat Sheet](https://www.digitaltapestry.net/posts/markdig-cheat-sheet)

</div>
</div>
</body>