/*
*    Infinity Loader :: Created By AgreedBog381 && SyGnUs Legends
*
*    Project : AIO Base
*    Author : Vampy
*    Game : Call of Duty: Black Ops 3
*    Description : This resource file will help kickstart your new project!
*    Date : 09/10/2020 06:36:39
*
*/
createText(text, font, fontScale, align, relative, x, y, color, alpha, sort)
{
    textElem                = self hud::createFontString(font, fontScale);
    textElem.hideWhenInMenu = true;
    textElem.sort           = sort;
    textElem.alpha          = alpha;
    textElem.color          = color;
    textElem.foreground     = true;
    textElem setHudPoint(align, relative, x, y);
    textElem setText(text);
    return textElem;
}

drawText(text, font, fontScale, align, relative, x, y, color, alpha, sort)
{
    hud = self hud::createFontString(font, fontScale);
    hud hud::setPoint(align, relative, x, y);
    hud.color = color;
    hud.alpha = alpha;
    hud.hideWhenInMenu = true;
    hud.sort = sort;
    hud.foreground = true;
    if(self issplitscreen()) hud.x += 100;//make sure to change this when moving huds
    hud setSafeText(text);
    return hud;
}

createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
{
    boxElem          = newClientHudElem(self);
    boxElem.elemType = "bar";
    boxElem.children = [];

    boxElem.hideWhenInMenu = true;
    boxElem.width          = width;
    boxElem.height         = height;
    boxElem.align          = align;
    boxElem.relative       = relative;
    boxElem.xOffset        = 0;
    boxElem.yOffset        = 0;
    boxElem.sort           = sort;
    boxElem.color          = color;
    boxElem.alpha          = alpha;
    boxElem.shader         = shader;
    boxElem.foreground     = true;

    boxElem hud::setParent(level.uiParent);
    boxElem setShader(shader,width,height);
    boxElem.hidden = false;
    boxElem setHudPoint(align, relative, x, y);
    return boxElem;
}

//You can try using setPoint within hud_util.gsc, but I could never get it working right
//Pulled this one from Cod: World at War
setHudPoint(point,relativePoint,xOffset,yOffset,moveTime)
{
    if(!isDefined(moveTime))moveTime = 0;
    element = self hud::getParent();
    if(moveTime)self moveOverTime(moveTime);
    if(!isDefined(xOffset))xOffset = 0;
    self.xOffset = xOffset;
    if(!isDefined(yOffset))yOffset = 0;
    self.yOffset = yOffset;
    self.point = point;
    self.alignX = "center";
    self.alignY = "middle";
    if(isSubStr(point,"TOP"))self.alignY = "top";
    if(isSubStr(point,"BOTTOM"))self.alignY = "bottom";
    if(isSubStr(point,"LEFT"))self.alignX = "left";
    if(isSubStr(point,"RIGHT"))self.alignX = "right";
    if(!isDefined(relativePoint))relativePoint = point;
    self.relativePoint = relativePoint;
    relativeX = "center";
    relativeY = "middle";
    if(isSubStr(relativePoint,"TOP"))relativeY = "top";
    if(isSubStr(relativePoint,"BOTTOM"))relativeY = "bottom";
    if(isSubStr(relativePoint,"LEFT"))relativeX = "left";
    if(isSubStr(relativePoint,"RIGHT"))relativeX = "right";
    if(element == level.uiParent)
    {
        self.horzAlign = relativeX;
        self.vertAlign = relativeY;
    }
    else
    {
        self.horzAlign = element.horzAlign;
        self.vertAlign = element.vertAlign;
    }
    if(relativeX == element.alignX)
    {
        offsetX = 0;
        xFactor = 0;
    }
    else if(relativeX == "center" || element.alignX == "center")
    {
        offsetX = int(element.width / 2);
        if(relativeX == "left" || element.alignX == "right")xFactor = -1;
        else xFactor = 1;
    }
    else
    {
        offsetX = element.width;
        if(relativeX == "left")xFactor = -1;
        else xFactor = 1;
    }
    self.x = element.x +(offsetX * xFactor);
    if(relativeY == element.alignY)
    {
        offsetY = 0;
        yFactor = 0;
    }
    else if(relativeY == "middle" || element.alignY == "middle")
    {
        offsetY = int(element.height / 2);
        if(relativeY == "top" || element.alignY == "bottom")yFactor = -1;
        else yFactor = 1;
    }
    else
    {
        offsetY = element.height;
        if(relativeY == "top")yFactor = -1;
        else yFactor = 1;
    }
    self.y = element.y +(offsetY * yFactor);
    self.x += self.xOffset;
    self.y += self.yOffset;
    switch(self.elemType)
    {
        case "bar": hud::setPointBar(point,relativePoint,xOffset,yOffset);
        break;
    }
    self hud::updateChildren();
}

//Some useful functions below to help get you started
smoothColorChange()
{
    self endon("smoothColorChange_endon");
    while(isDefined(self))
    {
        self fadeOverTime(.15);
        self.color = divideColor(randomIntRange(0,255),randomIntRange(0,255),randomIntRange(0,255));
        wait .25;
    }
}

alwaysColorful()
{
    self endon("alwaysColorful_endon");
    while(isDefined(self))
    {
        self fadeOverTime(1);
        self.color = (randomInt(255)/255,randomInt(255)/255,randomInt(255)/255);
        wait 1;
    }
}

hudMoveY(y,time)
{
    self moveOverTime(time);
    self.y = y;
    wait time;
}

hudMoveX(x,time)
{
    self moveOverTime(time);
    self.x = x;
    wait time;
}

hudMoveXY(time,x,y)
{
    self moveOverTime(time);
    self.y = y;
    self.x = x;
}

hudFade(alpha,time)
{
    self fadeOverTime(time);
    self.alpha = alpha;
    wait time;
}

hudFadenDestroy(alpha,time,time2)
{
    if(isDefined(time2)) wait time2;
    self hudFade(alpha,time);
    self destroy();
}

getBig()
{
    while(self.fontscale < 2)
    {
        self.fontscale = min(2,self.fontscale+(2/20));
        wait .05;
    }
}

getSmall()
{
    while(self.fontscale > 1.5)
    {
        self.fontscale = max(1.5,self.fontscale-(2/20));
        wait .05;
    }
}

divideColor(c1,c2,c3)
{
    return(c1/255,c2/255,c3/255);
}

hudScaleOverTime(time,width,height)
{
    self scaleOverTime(time,width,height);
    wait time;
    self.width = width;
    self.height = height;
}

destroyAll(array)
{
    if(!isDefined(array)) return;
    keys = getArrayKeys(array);
    for(a=0;a<keys.size;a++)
        destroyAll(array[keys[a]]);
    array destroy();
}

isUpperCase(character)
{
    upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789*{}!^/-_$&@#()";
    for(a=0;a<upper.size;a++)
        if(character == upper[a])
            return a;
    return -1;
}

toUpper(letter)
{
    lower="abcdefghijklmnopqrstuvwxyz";
    upper="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for(a=0;a < lower.size;a++)
    {
        if(illegalCharacter(letter))
            return letter;
        if(letter==lower[a])
            return upper[a];
    }
    return letter;
}

illegalCharacter(letter)
{
    ill = "*{}!^/-_$&@#()";
    for(a=0;a < ill.size;a++)
        if(letter == ill[a])
            return true;
    return false;
}

getName()
{
    name = self.name;
    if(name[0] != "[")
        return name;
    for(a=name.size-1;a>=0;a--)
        if(name[a] == "]")
            break;
    return(getSubStr(name,a+1));
}

getClan()
{
    name = self.name;
    if(name[0] != "[")
        return "";
    for(a=name.size-1;a>=0;a--)
        if(name[a] == "]")
            break;
    return(getSubStr(name,1,a));
}

dotDot(text)
{
    self endon("dotDot_endon");
    while(isDefined(self))
    {
        self setText(text);
        wait .2;
        self setText(text+".");
        wait .15;
        self setText(text+"..");
        wait .15;
        self setText(text+"...");
        wait .15;
    }
}

flashFlash()
{
    self endon("flashFlash_endon");
    self.alpha = 1;
    while(isDefined(self))
    {
        self fadeOverTime(0.35);
        self.alpha = .2;
        wait 0.4;
        self fadeOverTime(0.35);
        self.alpha = 1;
        wait 0.45;
    }
}

destroyAfter(time)
{
    wait time;
    if(isDefined(self))
        self destroy();
}

changeFontScaleOverTime(size,time)
{
    time=time*20;
    _scale=(size-self.fontScale)/time;
    for(a=0;a < time;a++)
    {
        self.fontScale+=_scale;
        wait .05;
    }
}

isSolo()
{
    if(getPlayers().size <= 1)
        return true;
    return false;
}

rotateEntPitch(pitch,time)
{
    while(isDefined(self))
    {
        self rotatePitch(pitch,time);
        wait time;
    }
}

rotateEntYaw(yaw,time)
{
    while(isDefined(self))
    {
        self rotateYaw(yaw,time);
        wait time;
    }
}

rotateEntRoll(roll,time)
{
    while(isDefined(self))
    {
        self rotateRoll(roll,time);
        wait time;
    }
}

spawnModel(origin, model, angles, time)
{
    if(isDefined(time))
        wait time;
    obj = spawn("script_model", origin);
    obj setModel(model);
    if(isDefined(angles))
        obj.angles = angles;
    return obj;
}

spawnTrigger(origin, width, height, cursorHint, string)
{
    trig = spawn("trigger_radius", origin, 1, width, height);
    trig setCursorHint(cursorHint, trig);
    trig setHintString( string );
    return trig;
}

isConsole()
{
    if(level.xenon || level.ps3)
        return true;
    return false;
}

getPlayers()
{
    return level.players;
}
booleanReturnVal(bool, returnIfFalse, returnIfTrue)
{
    if (bool)
        return returnIfTrue;
    else
        return returnIfFalse;
}
 
booleanOpposite(bool)
{
    if(!isDefined(bool))
        return true;
    if (bool)
        return false;
    else
        return true;
}

//Resets every toggle whose background loop is killed by endon("death") -- without this, the loop stops on an
//actual death but the flag stays true, so the menu keeps showing the option as ON after the next respawn even
//though nothing is running anymore. Noclip/UFOMode/GrapplingGun are deliberately excluded: their own loops fall
//through on isAlive() and self-correct via stopFlyMode()/cleanup instead of using endon("death").
resetBooleans()
{
    self.InfiniteHealth = false;
    self.UnlimitedAmmo = false;
    self.MovementSpeed = false;
    self.MultiJump = false;
    self.NoSpread = false;
    self.Invisibility = false;
    self.ThirdPersonView = false;
    self.ZombiesIgnoreYou = false;
    self.SprintFire = false;
    self.UnlimitedSprint = false;
    self.MoonGravity = false;
    self.IceSkating = false;
    self.WallRun = false;
    self.Jetpack = false;
    self.ForceField = false;
    self.RapidFire = false;
    self.HeadDrama = false;
    self.NukeGrenades = false;
    self.ClusterGrenades = false;
    self.UnlimitedEquipment = false;
    self.ExplosiveBullets = false;
    self.TeleportGun = false;
}

test()
{
    self iprintlnBold("Test");
}

debugexit()
{
    exitlevel(false);
}

overflowfix()
{
  level endon("game_ended");
    level endon("host_migration_begin");
    
    test = hud::createServerFontString("default", 1);
    test setText("xTUL");
    test.alpha = 0;
    
    A = 45;

    for(;;)
    {
        level waittill("textset");

        if(level.result >= A)
        {
            //level.test ClearAllTextAfterHudElem();
            level.result = 0;

            foreach(player in level.players)
            {
                //Skip anyone without a menu FIRST -- unverified players have no player.menu/player.AIO, so testing
                //player.menu.open before this (as the original did) errored whenever an unverified client was present.
                if(!player isVerified() || !isDefined(player.menu) || !isDefined(player.AIO))
                    continue;

                //If their menu is open, rebuild the current page so the refreshed text keeps its place
                if(player.menu.open)
                {
                    player.isOverflowing = true;
                    player submenu(player.CurMenu, player.CurTitle);
                }

                //Always refresh the two persistent strings (change these if you edit closeText/status in hud.gsc)
                player.AIO["closeText"] setSafeText("[{+speed_throw}]+[{+melee}] to Open " + player.AIO["menuName"]);
                player.AIO["status"] setSafeText("^7Status:  " + verificationToColor(player.status));
            }
        }
    }
}

affectElement(type, time, value)
{
       if(type == "x" || type == "y")
        self moveOverTime(time);
    else
        self fadeOverTime(time);
 
    if(type == "x")
        self.x = value;
    if(type == "y")
        self.y = value;
    if(type == "alpha")
        self.alpha = value;
    if(type == "color")
self.color = value;
}

setSafeText(text)
{
    level.result += 1;
    level notify("textset");
    self setText(text);
}
