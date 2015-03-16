# Introduction #

The ZIP archive contains two utilities that allow you to export and import iPhoto keywords to and from IPTC
keywords.

Each utility acts only on the image(s) you have selected in iPhoto.

The latest version of the utilities can be found at http://code.google.com/p/iphotokeywordutilities/.

## Export iPhoto keywords ##

This utility exports the iPhoto keywords from the currently selected image(s) in iPhoto to IPTC keywords
embedded in the image file.

## Import IPTC keywords ##

This utilitiy IPTC keywords from selected image(s) in your iPhoto library and assigns them as iPhoto keywords.

Note that iPhoto 6 automatically imports IPTC keywords when you import an image into the iPhoto library.
This script is only needed for iPhoto 5 or if you are adding/removing keywords to images within your iPhoto
library with software other than iPhoto.

# Requirements #

  * [iPhoto](http://www.apple.com/iphoto) version 5 or 6

  * [iPhoto Keyword Assistant](http://homepage.mac.com/kenferry/software.html)

  * [Graphic Converter](http://lemkesoft.de/en/graphcon.htm)

# Installation #

Both utilities are AppleScript Studio applications so there is no requirement to install them in any particular location.
The most convenient location for them is in the Script Menu.

If you choose not to install them there then to use them you must select your image(s) in iPhoto then locate the
applications in the Finder and run them.

## Script Menu ##

Both utilities are suitable for use in the Script Menu. To install them there:
  * First enable the Script Menu using the AppleScript Utility.
  * Copy the applications to one of the following locations:
    * `~/Library/Scripts` to enable the utilities for yourself only.
    * `/Library/Scripts` to enable the utlities for all users.
  * You may prefer to create an `iPhoto` subfolder within the `Scripts` folder.

To use them from here simply select the images you wish to export/import keywords from and choose the
respective utility from the Script Menu.