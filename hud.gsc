/*
*    Infinity Loader :: Created By AgreedBog381 && SyGnUs Legends
*
*    Project : AIO Base
*    Author : vampy
*    Game : Call of Duty: Black Ops 3
*    Description : An empty canvas for anything you want!
*    Date : 09/10/2020 06:43:10
*
*/

StoreHuds()
{
    //The live accent color -- every theme function keeps this in sync; it seeds the colour of every accent element created below (highlight bar, edge tab, dividers, top/bottom bars)
    self.themeColor = (0.20, 0.55, 1.00);

    //Panel shell -- deep slate body with a soft graphite trim instead of flat black/white
    self.AIO["background"] = createRectangle("LEFT", "CENTER", -380, 27, 0, 190, (0.035, 0.04, 0.055), "white", 1, 0);
    self.AIO["backgroundouter"] = createRectangle("LEFT", "CENTER", -384, 24, 0, 193, (0.09, 0.10, 0.14), "white", 1, 0);

    //Accent elements -- recolored to the live theme (kept in sync by the theme functions below)
    self.AIO["scrollbar"] = createRectangle("CENTER", "CENTER", -300, -50, 160, 0, self.themeColor, "white", 2, 0);
    self.AIO["scrolltab"] = createRectangle("LEFT", "CENTER", -380, -50, 3, 0, self.themeColor, "white", 4, 0);
    self.AIO["headerdivider"] = createRectangle("CENTER", "CENTER", -300, -64, 148, 1, self.themeColor, "white", 4, 0);
    self.AIO["footerdivider"] = createRectangle("CENTER", "CENTER", -300, 114, 148, 1, self.themeColor, "white", 4, 0);
    self.AIO["bartop"] = createRectangle("CENTER", "CENTER", -300, .2, 160, 30, self.themeColor, "white", 3, 0);
    self.AIO["barbottom"] = createRectangle("CENTER", "CENTER", -300, .2, 160, 30, self.themeColor, "white", 3, 0);
    self.AIO["barclose"] = createRectangle("CENTER", "CENTER", -299, .2, 162, 32, (0.09, 0.10, 0.14), "white", 1, 0);

    //Text Elements. Title/status/closeText are LEFT-anchored at the panel's left edge; the counter is RIGHT-anchored
    //near the panel's right edge so "X / Y" sits in the header's empty right side and never runs past the panel border.
    self.AIO["title"] = drawText("", "objective", 1.8, "LEFT", "CENTER", -376, -80, (1, 1, 1), 0, 5);
    self.AIO["counter"] = drawText("", "objective", 1.2, "RIGHT", "CENTER", -224, -80, (0.65, 0.68, 0.75), 0, 5);
    self.AIO["closeText"] = drawText("[{+speed_throw}]+[{+melee}] to Open " + self.AIO["menuName"], "objective", 1.3, "LEFT", "CENTER", -376, .2, (1, 1, 1), 0, 5);
    self.AIO["status"] = drawText("^7Status:  " + verificationToColor(self.status), "objective", 1.5, "LEFT", "CENTER", -376, 128, (1, 1, 1), 0, 5);

    //Makes the closed menu bar visible when it's first given
    self.AIO["barclose"] affectElement("alpha", .2, .9);
    self.AIO["bartop"] affectElement("alpha", .2, .9);
    self.AIO["barbottom"] affectElement("alpha", .2, .9);
    self.AIO["closeText"] affectElement("alpha", .2, 1);
}

StoreText(menu, title)
{
    self.AIO["title"] setSafeText(title);

    //Only (re)creates the row HUDs. All option text/colour/scrolling is owned by updateScrollbar(), which always runs right after StoreText -- so a menu with fewer than VISIBLE rows never tries to setText() an undefined option index.
    if(self.recreateOptions)
        for (i = 0; i < level.AIO_visibleRows; i++)
        {
            self.AIO["options"][i] = drawText("", "objective", 1.3, "LEFT", "CENTER", -376, -50 + (i * 25), (1, 1, 1), 0, 7);
            self.AIO["options"][i].archived = false;
        }
}

showHud()//opening menu effects
{
    self endon("destroyMenu");

    self.AIO["closeText"] affectElement("alpha", .1, 0);
    self.AIO["closeText"].archived = false;
    
    self.AIO["barclose"] affectElement("alpha", 0, 0);
    self.AIO["barclose"].archived = false;
    
    self.AIO["bartop"] affectElement("y", .35, -80);
    self.AIO["bartop"].archived = false;

    self.AIO["barbottom"] affectElement("y", .35, 128);
    self.AIO["barbottom"].archived = false;

    //Snappier staged reveal (~0.6s total): each stage's animation still finishes before its wait ends, so the
    //choreography is preserved -- just faster and more responsive for a menu that gets opened constantly.
    wait .35;

    //Fill is fairly opaque so option text stays crisp over any in-game background; the outer frame is lighter and reads as a subtle border
    self.AIO["background"] affectElement("alpha", .2, .82);
    self.AIO["background"].archived = false;

    self.AIO["backgroundouter"] affectElement("alpha", .2, .55);
    self.AIO["backgroundouter"].archived = false;

    self.AIO["background"] scaleOverTime(.35, 160, 230);
    self.AIO["background"].archived = false;

    self.AIO["backgroundouter"] scaleOverTime(.3, 168, 244);
    self.AIO["backgroundouter"].archived = false;

    wait .35;
    
    self.AIO["scrollbar"] affectElement("alpha", .2, .9);
    self.AIO["scrollbar"] scaleOverTime(.5, 160, 25);
    self.AIO["scrollbar"].archived = false;

    self.AIO["scrolltab"] affectElement("alpha", .2, 1);
    self.AIO["scrolltab"] scaleOverTime(.5, 3, 25);
    self.AIO["scrolltab"].archived = false;

    self.AIO["headerdivider"] affectElement("alpha", .2, .5);
    self.AIO["headerdivider"].archived = false;

    self.AIO["footerdivider"] affectElement("alpha", .2, .5);
    self.AIO["footerdivider"].archived = false;

    self.AIO["title"] affectElement("alpha", .2, 1);
    self.AIO["title"].archived = false;

    self.AIO["counter"] affectElement("alpha", .2, .7);
    self.AIO["counter"].archived = false;

    self.AIO["status"] affectElement("alpha", .2, 1);
    self.AIO["status"].archived = false;
}

hideHud()//closing menu effects
{
    self endon("destroyMenu");
    
    self.AIO["title"] affectElement("alpha", .2, 0);
    self.AIO["counter"] affectElement("alpha", .2, 0);
    self.AIO["status"] affectElement("alpha", .2, 0);
    self.AIO["headerdivider"] affectElement("alpha", .2, 0);
    self.AIO["footerdivider"] affectElement("alpha", .2, 0);

    if(isDefined(self.AIO["options"]))//do not remove this
    {
        //Quick sequential fade -- keeps the tasteful top-to-bottom cascade but at a snappier step
        for(a = 0; a < self.AIO["options"].size; a++)
        {
            self.AIO["options"][a] affectElement("alpha", .2, 0);
            wait 0.03;
        }

        for(i = 0; i < self.AIO["options"].size; i++)
            self.AIO["options"][i] destroy();

        //Clear the reference so a later teardown (e.g. destroyMenu on re-verification while the menu is closed)
        //sees isDefined()==false and does NOT destroy() these already-freed elements a second time.
        self.AIO["options"] = undefined;
    }

    //Faster close (~1.1s vs the old ~1.75s). Same staged collapse, shorter durations/waits -- the panel is
    //blocked from reopening until this finishes, so keeping it brisk makes the menu feel far more responsive.
    self.AIO["scrollbar"] scaleOverTime(.35, 2, 0);
    self.AIO["scrollbar"] affectElement("alpha", .2, 0);
    self.AIO["scrolltab"] scaleOverTime(.35, 3, 0);
    self.AIO["scrolltab"] affectElement("alpha", .2, 0);
    wait .25;
    self.AIO["backgroundouter"] scaleOverTime(.35, 1, 193);
    self.AIO["background"] scaleOverTime(.25, 1, 190);
    wait .25;
    self.AIO["backgroundouter"] affectElement("alpha", .2, 0);
    self.AIO["background"] affectElement("alpha", .2, 0);
    wait .15;
    self.AIO["barbottom"] affectElement("y", .3, .2);
    self.AIO["bartop"] affectElement("y", .3, .2);
    wait .25;
    self.AIO["barclose"] affectElement("alpha", .1, .9);
    self.AIO["closeText"] affectElement("alpha", .1, 1);
}

//Clean windowed scroller -- shows level.AIO_visibleRows rows at a time and slides a window over menus of ANY length.
//Replaces the original logic, which created 7 row HUDs but indexed up to 10 (breaking any menu over 7 items).
updateScrollbar()
{
    total = self.menu.menuopt[self.CurMenu].size;
    visible = self.AIO["options"].size;

    //Wrap the cursor around the ends of the list
    if(self.menu.curs[self.CurMenu] < 0)
        self.menu.curs[self.CurMenu] = total - 1;
    if(self.menu.curs[self.CurMenu] > total - 1)
        self.menu.curs[self.CurMenu] = 0;

    cursor = self.menu.curs[self.CurMenu];

    self.AIO["counter"] setSafeText((cursor + 1) + " / " + total);

    //Slide the visible window so the cursor stays on screen (roughly centred), clamped to the list bounds
    if(total <= visible)
        top = 0;
    else
    {
        top = cursor - int(visible / 2);
        if(top < 0)
            top = 0;
        if(top > total - visible)
            top = total - visible;
    }

    for(r = 0; r < visible; r++)
    {
        idx = top + r;

        if(idx < total)
        {
            self.AIO["options"][r] setSafeText(self.menu.menuopt[self.CurMenu][idx]);

            //Text stays white for maximum readability on every theme; the theme-coloured highlight bar (drawn
            //behind the selected row) is what marks the selection. Only alpha varies -- bright selected, dim rest.
            if(idx == cursor)
                self.AIO["options"][r] affectElement("alpha", .2, 1);//selected row: full-bright white over the coloured bar
            else
                self.AIO["options"][r] affectElement("alpha", .2, .55);//unselected rows: dimmed for clear hierarchy
        }
        else
        {
            self.AIO["options"][r] setSafeText("");//blank out rows past the end of a short menu
            self.AIO["options"][r] affectElement("alpha", .2, 0);
        }
    }

    //Highlight bar + edge tab glide to the cursor's position WITHIN the visible window.
    //affectElement("y") animates via moveOverTime (same proven path showHud() uses on the top/bottom bars),
    //so the selection slides smoothly between rows instead of snapping -- the core of the premium feel.
    //0.09s settle is just under the 0.124s scroll-repeat, so holding a direction steps cleanly without lag.
    targetY = -50 + (25 * (cursor - top));
    self.AIO["scrollbar"] affectElement("y", 0.09, targetY);
    self.AIO["scrolltab"] affectElement("y", 0.09, targetY);
}

//Applies an accent color across every themed panel element (bars, highlight, tab, dividers) and remembers it for the selected-row text tint
setAccentColor(color)
{
    self.themeColor = color;
    self.AIO["scrollbar"] elemcolor(1, color);
    self.AIO["scrolltab"] elemcolor(1, color);
    self.AIO["bartop"] elemcolor(1, color);
    self.AIO["barbottom"] elemcolor(1, color);
    self.AIO["headerdivider"] elemcolor(1, color);
    self.AIO["footerdivider"] elemcolor(1, color);
}

applyAzureTheme()
{
    self setAccentColor((0.20, 0.55, 1.00));
}

applyCrimsonTheme()
{
    self setAccentColor((0.90, 0.15, 0.22));
}

applyEmeraldTheme()
{
    self setAccentColor((0.10, 0.78, 0.45));
}

applyVioletTheme()
{
    self setAccentColor((0.58, 0.35, 0.98));
}

applyAmberTheme()
{
    self setAccentColor((1.00, 0.68, 0.15));
}

applyRoseTheme()
{
    self setAccentColor((0.98, 0.40, 0.65));
}

applyDemonTheme()
{
    self.themeColor = (0.85, 0.05, 0.10);
    self.AIO["scrollbar"] elemcolor(1, (0.25, 0.35, 0.95));
    self.AIO["scrolltab"] elemcolor(1, (0.25, 0.35, 0.95));
    self.AIO["bartop"] elemcolor(1, (0.85, 0.05, 0.10));
    self.AIO["barbottom"] elemcolor(1, (0.85, 0.05, 0.10));
    self.AIO["headerdivider"] elemcolor(1, (0.85, 0.05, 0.10));
    self.AIO["footerdivider"] elemcolor(1, (0.85, 0.05, 0.10));
}

toggleFlashingTheme()
{
    if(self.isFlashingTheme == 0)
    {
        self.isFlashingTheme = 1;
        self thread doFlashingTheme();
        self iprintlnbold("Flashing Theme ^2ON");
    }
    else
    {
        self.isFlashingTheme = 0;
        self notify("stopflash");
        self iprintlnbold("Flashing Theme ^1OFF");
    }
}

doFlashingTheme()
{
    self endon("disconnect");
    self endon("death");
    self endon("stopflash");
    colors = [];
    colors[0] = (0.20, 0.55, 1.00);//Azure
    colors[1] = (0.90, 0.15, 0.22);//Crimson
    colors[2] = (0.10, 0.78, 0.45);//Emerald
    colors[3] = (0.58, 0.35, 0.98);//Violet
    colors[4] = (1.00, 0.68, 0.15);//Amber
    colors[5] = (0.98, 0.40, 0.65);//Rose

    for(;;)
    {
        for(i = 0; i < colors.size; i++)
        {
            self setAccentColor(colors[i]);
            wait 1;
        }
    }
}

elemcolor(time, color)
{
    self fadeovertime(time);
    self.color = color;
}

