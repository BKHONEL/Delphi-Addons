//---------------------------------------------------------------------------

#include <basepch.h>
#pragma hdrstop
USEFORMNS("spNBPagesEditor.pas", Spnbpageseditor, NBPagesForm);
USEFORMNS("spPngImageEditor.pas", Sppngimageeditor, spPNGEditorForm);
USEFORMNS("spRootEdit.pas", Sprootedit, spRootPathEditDlg);
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
