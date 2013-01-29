Google-Picasa-Photo-Browser-for-iOS
===================================

Uses Google GData Photo to access Google Picasa photos


This projects uses the Google GData Objective C Client library to create an iOS static library.

The iOS static library is used in the iOS Picasa Photo Browser app. 
The iOS application access the Google Picasa Photos (both public and private photos).
The public photos are accessed without the user account's password. 
The private photos do require the google account password.

This project demonstrates the usage of the Google GData Objective C Client library.
The library is available as OS X static library, but it is not readily useable
for the iOS application usage.  An iOS static library project is created to use
the only Google GData/Photo module, but you may add additional modules,
including the Google Youtbue module, Google Analytics, etc, to the iOS static library.

The iOS Static library project creates the iOS device static library
or the iOS Simulator static library, automatically.

The Picasa Photo Browser app for iOS uses this iOS static library to access
the Google GData Photo module.  The Picasa Photo Browser project compiles
the iOS static library of Google GData/Photo module, automatically.

And, it will create an iOS Simulator static library or the iOS armv6 and armv7 static
library.
