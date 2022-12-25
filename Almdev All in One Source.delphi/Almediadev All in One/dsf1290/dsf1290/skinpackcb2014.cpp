//---------------------------------------------------------------------------

#include <basepch.h>
#pragma hdrstop





































USEFORMNS("spRootEdit.pas", Sprootedit, spRootPathEditDlg);
USEFORMNS("spNBPagesEditor.pas", Spnbpageseditor, NBPagesForm);
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
