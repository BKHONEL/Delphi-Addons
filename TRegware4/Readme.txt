WAK Productions Presents:
TRegware Shareware Security Component for Delphi
Version 4.00
Copyright ©2003 - WAK Productions
------------------------------------------------
Programmed by Winston Kotzan
Email: wak@wakproductions.com
Website URL: http://www.wakproductions.com/

This program helps developers of shareware include a timebomb/registration for their program.  The end-user will enter a License ID and a serial number (like Winzip).  If their registration information is correct, then the program becomes registered.  TRegware hides data in the Windows registry to check if program was registered.

If you have any difficulties using this component, suggestions, or compliments about
this component, I would be glad to hear them!  Please send an Email to wak@wakproductions.com.
The more user responses received, the more TRegware can be improved to keep it the
best shareware security component for Delphi developers!


IF YOU HAVE A TECHNICAL QUESTION, PLEASE READ FAQ.TXT BEFORE SENDING AN EMAIL.  THANK YOU!



Release Notes
-------------

Version 4.00
- NOTE THAT THE TREGWARE 4.00 ALGORITHM IS INCOMPATIBLE WITH PREVIOUS VERSIONS
- New and revised demo programs included in distribution package
Major revisions:
- New feature allows an expiration date to be included in the registration code.
  This would help prevent the illegal spread of codes over a period of time.  If
  a user enters a registration code beyond the expieration date, TRegware will
  not accept the code.
- Now uses completely different, more secure algorithm.  The registration code
  now consists of a combination of several code generating algorithms to make it
  harder for crackers to create keygens.
- The TRegware class can no longer generate its own registration codes.  To
  create registration codes use the TRegCodeGenerator class.  (See demo program)
- Now has option to use an expiration date in code.  Check the documentation
  for more information.
- Class name has been changed from TRegwareII to TRegware4 because of
  incompatibilities with past versions.
- The TRegware class no longer has the ability to generate registration codes.
  The program now uses the function named E89CE8E0 to verify codes.

Minor revisions:
- Removed hard drive serial number related LicenseSource options.  It was
  unreliable under Windows XP.
- If the registry data is corrupted or unrecognized TRegware sets itself
  unregistered

Version 3.20:
- A set of compiler-time options are now available in the unit reg_opts.pas
  It is suggested to configure this file for each of your programs for
  greater security.  Please read the comments in reg_opts.pas for further
  description.
- Added Email property to contain user's email address. See DoRegistration()
  function documentation for details.
- Licensing options (LicenseType, LicenseSource properties) have been moved
  to a special class, TLicenseOptions.  They will now appear under the
  LicenseOptions property. LicenseOptions are only available in the
  professional edition.

Version 3 of TRegware includes many features to improve its flexibility and security.
In particular, TRegware has been modified to operate on Windows 2000 and XP systems.

New features in version 3.0:

- FSeed is now encrypted to protect from hackers.  To turn this option off,
  remove the '$DEFINE HIDE_SEED' line from regware2.pas.  Having this option
  on may cause TRegware to not recognize already existing registrations from
  previous versions.  (Only available in source code edition)
- Windows 2000 / XP registry is now supported.  Information is stored
  under HKEY_CLASSES_ROOT for 2000/XP systems.
- New ban-list features allows you to ban certain users from using
  the next version of your software
- Added 1 second-delay for registration attempts to prevent cracking by
  brute-force.  This option does not have a property to disable it so that
  it is a little more difficult to patch.
- Added spaghetti code in CalculateCode() for the purpose of confusing hackers
- Option to use system-generated license id  (uses Windows system ID or hard drive serial #)
- Option to set site-licenses and single-user licenses.


New features in version 2.0:

-Detects if the user attempted to deceive the timebomb by setting their
computer's clock backwards.  In this case, the component will signal an
OnClockChange event and report that the program has expired.  When the
user decides to put his clock back within the remaining 'x' days of his
evaluation period, the timebomb will continue to operate.
-TRegware now comes packaged with a Perl file (regware200.pl) so that 
registration codes can be generated on a UNIX-based web server.  You 
can use the Perl script if you would like to give registration codes 
to customers via a CGI program.


Bug reports? Suggestions? Comments?
Email to: wak@wakproductions.com

or visit website

http://www.wakproductions.com/

