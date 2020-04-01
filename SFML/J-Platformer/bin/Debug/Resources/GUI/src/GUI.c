#include "JGUI.h"

#define SCREEN_COUNT 1
#define TEXTURE_COUNT 1

Screen Screens[SCREEN_COUNT];
char*  TexturePaths[TEXTURE_COUNT];

int GetScreenCount()
{
   return SCREEN_COUNT;
}

int GetTextureCount()
{
    return TEXTURE_COUNT;
}

Screen* GetScreens()
{
    return Screens;
}

void Setup()
{
    Control Screen0Button0;
    Screen0Button0.Sprite = MakeImage("TestButton", MakeColor(255, 255, 255, 255), MakeVector2f(POSITION_InScreen, POSITION_InScreen));
    Screen0Button0.Label = MakeText("X", MakeColor(128, 128, 128, 255), 18, MakeVector2f(TEXT_POSITION_InImage, TEXT_POSITION_InImage), TEXT_String);
    Screen0Button0.Type = CONTROL_Button;
    Screen0Button0.UpdateCommand =
    "FLAG:ShouldClose:True"
    ;

    Screens[0].ControlCount = 1;
    Screens[0].Controls[0] = Screen0Button0;
}