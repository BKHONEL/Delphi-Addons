//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("skinpackCB5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("SPUtils.pas");
USEUNIT("SkinBoxCtrls.pas");
USEUNIT("SkinCtrls.pas");
USEUNIT("SkinData.pas");
USEUNIT("SkinGrids.pas");
USEUNIT("SkinHint.pas");
USEUNIT("SkinMenus.pas");
USEUNIT("SkinTabs.pas");
USEUNIT("SPEffBmp.pas");
USEUNIT("spreg.pas");
USERES("spreg.dcr");
USEUNIT("DynamicSkinForm.pas");
USEPACKAGE("VCLJPG50.bpi");
USEUNIT("spTrayIcon.pas");
USEUNIT("spSkinZip.pas");
USEUNIT("spSkinUnZip.pas");
USEUNIT("spMessages.pas");
USEUNIT("spSkinShellCtrls.pas");
USEUNIT("spfilectrl.pas");
USEUNIT("spzlib.pas");
USEFORMNS("spNBPagesEditor.pas", Spnbpageseditor, spNBPagesForm);
USEUNIT("spcalendar.pas");
USEUNIT("spColorCtrls.pas");
USEUNIT("spDialogs.pas");
USEUNIT("spzlibcompress.pas");
USEUNIT("spconst.pas");
USEFORMNS("spRootEdit.pas", Sprootedit, spRootPathEditDlg);
USEPACKAGE("dsnide50.bpi");
USEUNIT("SkinPrinter.pas");
USEUNIT("spbuttongroup.pas");
USEUNIT("spcategorybuttons.pas");
USEUNIT("SkinExCtrls.pas");
USEFORMNS("spPngImageEditor.pas", Sppngimageeditor, spPNGEditorForm);
USEUNIT("sppngimagelist.pas");
USEUNIT("sppngimage.pas");
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
