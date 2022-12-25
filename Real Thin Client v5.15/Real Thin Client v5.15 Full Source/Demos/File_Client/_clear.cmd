rd ModelSupport /S /Q

rd __history /S /Q

rd download /S /Q

rd LOG /S /Q

rd xcode /S /Q

del fmx*.res
del ios*.res
del *.plist

del *_Icon.ico
del *.tvsconfig

del *.txt
del *.cfg
del *.dof
del *.ddp
del *.bdsproj
del *.rsm
del *.m*
del *.local
del *.identcache
del *.tgs
del *.tgw
del *.dcu
del *.~*
del *.log
del *.stat
del *.drc
del *.obj
del *.hpp
del *.tds
del *.dproj*
del *.dsk

call _Pack
copy *.exe ..\..\..\Bin\RTCSDK
del *.exe
del *.
