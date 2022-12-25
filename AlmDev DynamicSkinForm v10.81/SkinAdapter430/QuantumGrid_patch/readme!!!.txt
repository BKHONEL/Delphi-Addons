************************************************
* How to add skin support for Quantum Grid 5,6 *
************************************************

1. Patch files of QuantmGrid 5, 6 (cxControls, cxLookAndFeelPainters units).
     Run QG5[6]_patch_dsf.exe to patch QG5[6] *.pas or *.dcu files.
2. Set LookAndFeel.Kind properties to lfUltraFlat.
3. Set LookAndFeel.NativeStyle properties to False.
4. Remove old styles, which you define for controls.
5. Find in skinadapter.pas line with  {$DEFINE DEVEX_SUPPORT} directive 
     and remove comment symbols in this line.
6. Put TdsaSkinAdapter component on the form and set SkinData property.



