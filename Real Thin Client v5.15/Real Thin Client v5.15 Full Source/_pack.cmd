cd Lib
call _clear
cd ..

cd Demos
call _clear
cd ..

cd LibPlugins
call _clear
cd ..

cd QuickStart
call _clear
cd ..

cd Tools
call _clear
cd ..

call ..\Bin\BuildSDKHelp.cmd
copy MyHelp\Docs.chm Help\RTCSDK_Help.chm

del ..\Bin\Help\*.* /Q
del MyHelp\Docs.* /Q
move MyHelp\*.* ..\Bin\Help
rd MyHelp

del ..\RealThinClientSDK_Current.zip /Q

call "%ProgramFiles%\7-zip\7z.exe" a -r -x!.svn -tZIP ..\RealThinClientSDK_Current.zip *.*

pause