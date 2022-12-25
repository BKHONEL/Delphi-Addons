//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("sfcb5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("sf_winapi.pas");
USEUNIT("sf_bitmap.pas");
USEUNIT("sf_flash.pas");
USEUNIT("sf_flashreg.pas");
USERES("sf_flashreg.dcr");
USEUNIT("sf_utils.pas");
USEPACKAGE("dsnide50.bpi");
USEPACKAGE("vcljpg50.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
