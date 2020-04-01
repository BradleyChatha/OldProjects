// START Types
typedef unsigned int uint;
typedef unsigned char byte;

uint CONTROL_Button = 0; // The control's color changes whether the mouse is over it or not, and the control's update command is only called when it is left-clicked
uint CONTROL_Image = 1; // The control is only drawn
uint CONTROL_UpdateImage = 2; // The control is drawn and updated every loop

uint TEXT_String = 0; // The Text should be treated as a string
uint TEXT_Int = 1; // The text should be treated as an int

uint TEXT_POSITION_InImage = 0xFF0000F0; // Center the text inside the image of the control
uint POSITION_InScreen     = 0xFF0000F1; // Center whatever in the center of the screen

typedef struct
{
	byte R;
	byte G;
	byte B;
	byte A;
} Color;

typedef struct
{
	int X;
	int Y;
} Vector2i;

typedef struct
{
	float X;
	float Y;
} Vector2f;

typedef struct
{
	char* 		Text;
	Color 		FontColor;
	uint  		FontSize;
	Vector2f	Postion;

	uint        Type;
} Text;

typedef struct
{
	char* 		Texture;
	Color 		Tint;
	Vector2f 	Position;
} Image;
// END Types

// START Prototypes
Color       MakeColor(byte r, byte g, byte b, byte a);
Vector2f    MakeVector2f(float x, float y);
Text        MakeText(char* text, Color fontColor, uint fontSize, Vector2f position, uint type);
Image       MakeImage(char* texture, Color color, Vector2f position);
// END Prototypes

// START Main Types
typedef struct
{
	Vector2f    Position;

	Image       Sprite;
	Text        Label;

	char*       UpdateCommand;

	uint        Type;
} Control;

typedef struct
{
    Control Controls[20];
    uint    ControlCount;
} Screen;
// END Main Types

// START Methods
Color       MakeColor(byte r, byte g, byte b, byte a)
{
    Color ToReturn;
    ToReturn.R = r;
    ToReturn.G = g;
    ToReturn.B = b;
    ToReturn.A = a;

    return ToReturn;
}

Vector2f    MakeVector2f(float x, float y)
{
    Vector2f ToReturn;
    ToReturn.X = x;
    ToReturn.Y = y;

    return ToReturn;
}

Text        MakeText(char* text, Color fontColor, uint fontSize, Vector2f position, uint type)
{
    Text ToReturn;
    ToReturn.Text = text;
    ToReturn.FontColor = fontColor;
    ToReturn.FontSize = fontSize;
    ToReturn.Postion = position;
    ToReturn.Type = type;

    return ToReturn;
}

Image       MakeImage(char* texture, Color color, Vector2f position)
{
    Image ToReturn;
    ToReturn.Texture = texture;
    ToReturn.Tint = color;
    ToReturn.Position = position;

    return ToReturn;
}
// END Methods