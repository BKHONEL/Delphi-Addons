// TRegware 4.00
// Compiler directives and customized settings

// You may change these values to customize your programs for greater security.
// However, it is entirely optional and only for advanced users.

{ *********************** Compiler Options *********************** }

// PACKED_RECORDS specifies the use of packed records to store info in registry.
// It is recommended to have this feature turned on in case record alignment
// settings change on the compiler
//
{$DEFINE PACKED_RECORDS}


// If HIDE_SEED is defined, TRegware encrypts the Seed property using the
// SEED_STORAGE constant.  This makes the Seed value more difficult to find
// in the executable.
//
{$DEFINE HIDE_SEED}


// TRegware ignores site license settings if SITE_LICENSES is undefined
//
{$UNDEF SITE_LICENSES}


// if defined then TRegware checks reg. code for expiration dates
// if undefined then TRegware does not check reg. codes for expiration dates
//
{$DEFINE CHECK_EXPIRATION}


// if defined, the program allows registration codes without expiration dates
// if undefined, the program will not accept "no-expiration" codes
// the highest expiration date available is 12/12/4095
//
{$UNDEF ALLOW_NOEXPIRE}

const

// IT IS RECOMMENDED THAT YOU CHANGE ALL OF THE FOLLOWING VALUES FOR YOUR
// YOUR COMPANY'S PROGRAMS.  IT WILL MAKE IT MORE DIFFICULT FOR CRACKERS
// TO BREAK YOUR SOFTWARE.  IT IS ONLY NECESSARY TO CHANGE THESE VALUES
// ONCE.  NOTE THAT CHANGING THESE VALUES WILL AFFECT THE REGISTRATION CODES -
// KEEP A BACKUP COPY OF THIS FILE!!!


// These values are used to help protect the seed values.  The Seed values
// are XOR'ed with SEED_STORAGE to make it harder for hackers to find
// and patch.  These values can be any four-digit hex number.
//
SEED_STORAGE1=$541D;
SEED_STORAGE2=$9C41;
SEED_STORAGE3=$A460;

// SEED_D is used in encoding the date.  Set this to any 4 digit hex number.
SEED_D=$45B7;


// Values read from the registry to determing whether the registered
// license is a site license or single-user license.  These values
// can be changed to any number.  The main reason for this is to make it
// difficult for a cracker to change the registry setting to a different
// license.
//
SITE_LICENSE=integer($625B620F);
SINGLE_USER_LICENSE=integer($311D80E5);

// Codes used internally by TRegware for fail and success values
FAIL_CODE='542264156124568746123';
OK_CODE=  '645364631365423154824';


// Leave the following line alone
{$DEFINE PRO_VERSION}