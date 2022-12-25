This is a smartflash.dll API calls:

function LoadMovie(fileName: PChar; const Width, Height: integer): cardinal; stdcall;
- load player and movie (swf or flv)

procedure PlayMovie(const APlayer: cardinal); stdcall;
- play movie after Stop calling

procedure StopMovie(const APlayer: cardinal); stdcall;
- stop movie

procedure GrabCurrentFrame(const APlayer: cardinal; var Bits: Pointer); stdcall;
- grab current flash frame and return a pointer to the buffer. The buffer must keeped after using.

procedure FreeMovie(var APlayer: cardinal); stdcall;
- free player and dispose all used memory


Use dll from D2010 folder in Rad Studio 2010, XE, XE2, XE3 !!!