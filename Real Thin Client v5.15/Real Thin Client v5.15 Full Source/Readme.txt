RealThinClient SDK - Copyright (c) 2004-2012 by Danijel Tkalcec

http://www.realthinclient.com

--------------------------------
********************************

1.) License Agreement

2.) Install RTC SDK components in Delphi

3.) Make the RTC SDK accessible from XCode (for iOS development)

4.) Update RTC SDK components in Delphi

5.) Help

6.) Demos

7.) Support

********************************
--------------------------------

---------------------
1.) License Agreement
---------------------

Please read the RTC SDK License Agreement before using RTC SDK components.

You will find the RTC SDK License Agreement in the "License.txt" file.

--------------------------------
2.) INSTALL RTC SDK components in Delphi
--------------------------------

After you have unpacked the files in a folder of your choice 
and started Delphi, open the "rtcSDK.dpk" package from the "Lib" folder.

Click the "Install" button to compile and install the package.
When compiled, you will see a message listing all components installed.

After that, from the Delphi menu, under "Tools / Environment Options", 
select the "Library" tab and add the full path to the "Lib" folder to "Library path".

-------------------------------
3.) Make the RTC SDK accessible from XCode (for iOS development)
-------------------------------

For the FPC compiler to find RTC SDK files, you can either copy the complete "Lib" folder
from the RTC SDK package into the "/Developer/Embarcadero/fmi" folder (quick and dirty solution), or ... 

You can add the path to the RTC SDK “Lib” folder (located on your Windows PC, made accessible to Mac over LAN) 
to the FPC search path. Unfortunatelly, there  is no “parameter” for adding FPC search paths in XCode directly, 
so you will need to do this manually for every XCode Project. And not only once, but every time you recreate 
XCode Project files by using the “dpr2xcode” tool, because all your changes will be overwritten by "dpr2xcode". 

To avoid having to make these changes too often, use "dpr2xcode" ONLY if you have made changes to the Project 
file itself (changed the Project icon, for example). There is no need to recreate XCode Project files if you 
have only changed forms or units inside the Project.

To add the RTC SDK paths to FPC, you will need to modify the file "xcode/<ProjectName>.xcodeproj/project.pbxproj". 
The path to the RTC SDK “Lib” folder needs to be added as two new “-Fu” parameters. Once for iOS-Simulator and 
once for iOS-Device compilation, both of are configured through the “shellScript” parameter.

The best place to add the RTC SDK Lib path is after the FireMonkey path, so you should search for 
“-Fu/Developer/Embarcadero/fmi” in the above mentioned XCode Project file. You will find 2 such 
instances in the "ShellScript" line and you should add the path to the RTC SDK Lib folder directly 
after each "-Fu/Developer/Embarcadero/fmi" instance.

For example, if you have made the complete RTC SDK folder on your Windows PC available to your Mac OSX 
through a network share named “RTC_SDK” (read/write access rights to that folder will be required for FPC 
compilation to work), you should add “-Fu/Volumes/RTC_SDK/Lib” after both “-Fu/Developer/Embarcaedro/fmi” locations. 
One is for the iOS-Simulator, the other one for the iOS device. 

That will be enough to let FPC know where to look for RTC SDK files.

Should you still get "File not found" errors when trying to compile a Project using RTC files, 
make sure the path you have used is correct and that Mac OSX has read and write access to that folder.

PS. Before configuring access to the RTC SDK, you will need to have OSX 10.6 or 10.7, the latest XCode 4.x 
version and both packages provided by Embarcadero (included with RAD Studio XE2) installed on your Mac. 

To make sure your Mac OSX configuration is correct, create an empty "FireMonkey iOS HD" Project, use "dpr2xcode" 
to create XCode Project files and try to run that Project from XCode,
either inside the iOS-Simulator or directly on your iOS device (iPhone or iPad).

-------------------------------
4.) UPDATE RTC SDK components in Delphi
-------------------------------

Download the latest version of the RTC SDK from the RTC Support Forum:
http://realthinclient.com/sf

Information about recent RTC SDK updates is in the "Updates*.txt" file(s).

To update RTC SDK components, it's adviseable to uninstall 
the old package before installing the new package.

To uninstall RTC SDK components, after you start Delphi, 
open the menu "Component / Install Packages ..." where you 
will see a list of all packages currently installed in your Delphi. 

Scroll down to find "RealThinClient SDK" and click on it (single click). 
When you select it, click the button "Remove" and Delphi will ask you 
if you want to remove this package. Clicking "Yes" will uninstall the RTC SDK.

After that, *close* Delphi and follow step (2.a) to install the new RTC SDK package.

NOTE: Uninstalling the RTC SDK package will also uninstall all packages which are 
using the RTC SDK (for example, packages from "Nexus Portal"). So ... if you are 
using "Nexus Portal" or any other product using the RTC SDK, you will need to
Build and Install all related packages again, after you reinstall the RTC SDK.

-------------
5.) Help
-------------

The best place to start learning about RTC SDK is the QuickStart guide. After going through the 
online lessons, you should also go through the QuickStart examples included in the RTC SDK package. 

When you are done examining QuickStart examples, I suggest browsing through the FAQ. Even if you won't
be reading all the articles, you should at least get the feeling about the information included there.

RTC SDK Demos are another good source of information, including a lot of examples and best practices 
for using the RealThinClient SDK. And the most extensive source of information on the RealThinClient SDK 
are Help files. Some of the information is spread across the files, but if you know which class you need, 
you will most likely be able to find what you are looking for.

When you start working on your project, the FAQ will come in handy when you have to do something 
specific (use Sessions, accept form post data, write and call remote functions, etc). The FAQ is 
continualy being extended, as more questions come in.

If you have a question for which you were unable to find the answer in the QuickStart guide, QuickStart 
examples or the FAQ … and searching through the Help files didn't give you the answers you need, don't 
hesitate to post your question(s) on Developer Support groups.

The latest Help file for Off-line viewing is in the "Help" folder:
- "Help\RTCSDK_Help.chm"

-------------------
6.) Demos
-------------------

You can find Demos using RTC SDK components in the "Demos" folder.

Inside the "Demos" folder are 3 Project Group files:

  * VCL_Projects -> RTC Demos using the VCL for Win32 and Win64 (Delphi 6 - XE2)
  * FMX_Projects -> RTC Demos using FireMonkey for Win32, Win64 and Mac OSX (Delphi XE2)
  * iOS_Projects -> RTC Demos using FireMonkey for iOS (Delphi XE2 with XCode)

You will find a "Readme_Demos.txt" file there, 
with a short description of each Demo.

-------------
7.) Support
-------------

More information on RTC SDK:
> http://www.realthinclient.com/about.htm

Download the latest RTC SDK version and get Support
for using the RTC SDK through RTC PRO Support Forums:
> http://www.realthinclient.com/sf

If you have an active Silver or Gold RealThinClient subscription,
you can also contact Technical Support directly by E-Mail:
> http://www.realthinclient.com/contact.htm
