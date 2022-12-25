//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USEFORMNS("spNBPagesEditor.pas", Spnbpageseditor, spNBPagesForm);
USEFORMNS("spRootEdit.pas", Sprootedit, spRootPathEditDlg);
USEFORMNS("spPngImageEditor.pas", Sppngimageeditor, spPNGEditorForm);
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
 