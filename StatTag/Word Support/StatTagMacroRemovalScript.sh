#!/bin/sh

#  StatTagMacroInstallationScript.sh
#  StatTag
#
#  Created by Eric Whitley on 10/24/16.
#  Copyright © 2016 StatTag. All rights reserved.



#For sandboxed Word 2016, we're required to place AppleScript files in the following path
#* `~/Library/Application Scripts/com.microsoft.Word/`
#For consistency, we're also going to place scripts in the same location for 2011


#### Word Macro Templates ####
#For 2011
#* `/Applications/Microsoft Office 2011/Office/Startup/Word/`
#For 2016
#* `~/Library/Group Containers/UBF8T346G9.Office/User Content/Templates/`


#let's just rm the files...

#line below intentionally throws an error for testing
#lets_throw_an_error

#should probably re-evaluate how we obtain these file paths
rm -f "/Users/$USER/Library/Application Scripts/com.microsoft.Word/StatTagScriptSupport.scpt"
rm -f "/Applications/Microsoft Office 2011/Office/Startup/Word/StatTagMacros.dotm"
rm -f "/Users/$USER/Library/Group Containers/UBF8T346G9.Office/User Content.localized/Startup.localized/Word/StatTagMacros.dotm"
