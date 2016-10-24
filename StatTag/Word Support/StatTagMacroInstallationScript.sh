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


AppBundleResourceMacroFile="/Applications/StatTag.app/Contents/Resources/StatTagMacros.dotm"
AppBundleResourceAppleScriptFile="/Applications/StatTag.app/Contents/Resources/StatTagScriptSupport.scpt"

Word2016AppleScriptPath="/Users/$USER/Library/Application Scripts/com.microsoft.Word/"
Word2011MacroPath="/Applications/Microsoft Office 2011/Office/Startup/Word"
Word2016MacroPath="/Users/$USER/Library/Group Containers/UBF8T346G9.Office/User Content.localized/Templates.localized"

[ -e "`eval echo ${AppBundleResourceMacroFile//>}`" ]
MacroFileAvailable=$?
[ -e "`eval echo ${AppBundleResourceMacroFile//>}`" ]
AppleScriptFileAvailable=$?

testing=1

#let's make sure our two required files exist
if (( MacroFileAvailable == 0 && AppleScriptFileAvailable == 0)); then
  echo "install files available"

  #============ WORD AppleScript Files ==============
  #if we have Word2011 installed then we need to copy the macros over
  mkdir -p "$Word2016AppleScriptPath"
  cp "$AppBundleResourceAppleScriptFile" "$Word2016AppleScriptPath"
  echo "Installing AppleScript file"

  #============ WORD Macro Files ==============

  #------------- WORD 2011 -------------
  #if we have Word2011 installed then we need to copy the macros over
  [ -e "`eval echo ${Word2011MacroPath//>}`" ]
  Word2011Installed=$?

  if (( Word2011Installed == 0 )); then
    echo "Word 2011 Installed - installing macro file"
    cp "$AppBundleResourceMacroFile" "$Word2011MacroPath"
    #copy our bundle resources to the target path
  else
    echo "Word 2011 NOT installed"
  fi

  #------------- WORD 2016 -------------
  #if we have Word2016 installed then we need to copy the macros over
  [ -e "`eval echo ${Word2016MacroPath//>}`" ]
  Word2016Installed=$?

  if (( Word2016Installed == 0 )); then
    echo "Word 2016 Installed - installing macro file"
    cp "$AppBundleResourceMacroFile" "$Word2016MacroPath"
    #copy our bundle resources to the target path
  else
    echo "Word 2016 NOT installed"
  fi

else
  echo "install files NOT available"
fi


