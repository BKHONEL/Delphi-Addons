//---------------------------------------------------------------------------

#include <basepch.h>
#pragma hdrstop
USEFORMNS("spPngImageEditor.pas", Sppngimageeditor, spPNGEditorForm);
USEFORMNS("spRootEdit.pas", Sprootedit, spRootPathEditDlg);
USEFORMNS("spNBPagesEditor.pas", Spnbpageseditor, NBPagesForm);
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
