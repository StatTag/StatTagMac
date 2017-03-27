script WordASOC
  property parent : class "NSObject"
  
  on findText:searchText atRangeStart:rangeStart andRangeEnd:rangeEnd
      --log "findText..."
      
      -- coerce types
      set searchText to searchText as text
      set rangeStart to rangeStart as integer
      set rangeEnd to rangeEnd as integer
      set rangeContent to "" as text
      
      log "looking for : " & searchText
      log "range start : " & rangeStart
      log "range end : " & rangeEnd
      
      set foundIt to false as boolean

      if searchText is equal to "" then
        return foundIt
      end if

      tell application "Microsoft Word"
        tell active document
          set searchRange to create range start rangeStart end rangeEnd
          set rangeContent to content of searchRange
          set findObject to (find object of searchRange)

          set forward of findObject to true
          set wrap of findObject to find stop
          
          tell findObject
            set foundIt to execute find find text searchText
          end tell
          if foundIt equals false and rangeContent equals searchText then
            foundIt = true
          end if
        end tell
      end tell
      
      log "range content : " & rangeContent
      log "foundIt : " & foundIt
      
      return foundIt
      
  end findText:atRangeStart:andRangeEnd:
  
  on createOrUpdateDocumentVariableWithName:variableName andValue:variableValue
    
    set variableName to variableName as text
    set variableValue to variableValue as text

    set logMessage to "" as text

    tell application "Microsoft Word"
        set myVar to (get variable variableName of active document)
        set myVarName to name of myVar
        
        if myVarName is equal to missing value then
          make new variable at active document with properties {name:variableName, variable value:variableValue}
          set logMessage to "APPLESCRIPT : creating variable : " & variableName
        else
          set (value of variable variableName) to variableValue
          set logMessage to "APPLESCRIPT : found variable : " & variableName
        end if
    end tell
    
  end createOrUpdateDocumentVariableWithName:andValue:


  on UpdateLinkFormat:link
    
    set logMessage to "initial log message" as text
    set loopCount to 0
    tell application "Microsoft Word"
        set loopCount to loopCount + 1
        repeat with aShape in (get inline shapes of active document)
          set logMessage to " field : " & source path of link format of aShape
          
          if auto update of link format of aShape is true then
            set logMessage to logMessage & "\r\n" & "looping (updated) (AUTO-UPDATE = TRUE) : " & loopCount
          else
            set logMessage to logMessage & "\r\n" & "looping (updated) (AUTO-UPDATE = FALSE-ISH) : " & loopCount
            set myName to "" & source path of link format of aShape
            set logMessage to logMessage & "\r\n" & " myName : " & myName
            
            if source path of link format of aShape is missing value then
              set logMessage to logMessage & "\r\n" & "(MISSING link format source name) "
            else
              update link format of aShape
              set logMessage to logMessage & "\r\n" & "got link format source name : " & myName
            end if
          end if
        end repeat

    end tell
    
    log logMessage

  end UpdateLinkFormat

  on UpdateAllImageLinks()
    tell application "Microsoft Word"
      repeat with aShape in (get inline shapes of active document)
        if auto update of link format of aShape is false then
          update link format of aShape
        else
          if source full name of link format of aShape is not missing value then
            set source full name of link format of aShape to source full name of link format of aShape
            set source full name of link format of aShape to source full name of link format of aShape
          end if
        end if
      end repeat
    end tell
  end UpdateAllImageLinks


  on insertImageAtPath:filePath
    --https://discussions.apple.com/thread/3047908?tstart=0
    --http://www.grasmash.com/article/applescript-add-images-microsoft-word-table
    --https://discussions.apple.com/thread/5255148?tstart=0 //replace picture
    --http://www.mactech.com/articles/mactech/Vol.23/23.01/2301applescript/index.html
    --https://groups.google.com/forum/#!topic/microsoft.public.mac.office.word/yrbnSHFPtsI
    set filePath to filePath as text
    log "filePath : " & filePath
    tell application "Microsoft Word"
        set rangeStart to (selection start of selection)
        set rangeEnd to (selection end of selection)
        set myRange to create range active document start rangeStart end rangeEnd
        
        make new inline picture at myRange with properties {file name:filePath, link to file: true, save with document:true}
    end tell
  end insertImageAtPath


  --works in Excel
  -- http://lists.apple.com/archives/applescript-users/2011/Apr/msg00129.html
  --broken in Word
  -- http://answers.microsoft.com/en-us/mac/forum/macoffice2011-macword/screen-updating-applescript/230edaf6-49fe-4b8c-981f-7697a335f11b
#  on disableScreenUpdates()
#    tell application "Microsoft Word"
#      --tell active document
#      activate
#      run VB macro macro name "StatTagDisableScreenUpdates"
#        --set screen updating to false
#      --do script "Application.ScreenUpdating = False"
#      --end tell
#    end tell
#  end disableScreenUpdates
#
#  on enableScreenUpdates()
#    tell application "Microsoft Word"
#      --tell active document
#      activate
#      run VB macro macro name "StatTagEnableScreenUpdates"
#        --set screen updating to true
#      --do script "Application.ScreenUpdating = True"
#      --end tell
#    end tell
#  end enableScreenUpdates


  on createTableAtRangeStart:theRangeStart andRangeEnd:theRangeEnd withRows:numRows andCols:numCols
    set theRangeStart to theRangeStart as integer
    set theRangeEnd to theRangeEnd as integer
    set numRows to numRows as integer
    set numCols to numCols as integer
    tell application "Microsoft Word"
      set theDoc to active document
      set theRange to create range active document start theRangeStart end theRangeEnd
      set theTable to make new table at theDoc with properties {text object: theRange, number of rows:numRows, number of columns:numCols}
      return true --theTable
    end tell
    return false
  end createTableAtRangeStart:andRangeEnd:withRows:andCols:


  on insertParagraphAtRangeStart:theRangeStart andRangeEnd:theRangeEnd
    set theRangeStart to theRangeStart as integer
    set theRangeEnd to theRangeEnd as integer
    tell application "Microsoft Word"
      set theRange to create range active document start theRangeStart end theRangeEnd
      insert paragraph at theRange
      return true
    end tell
    return false
  end insertParagraphAndNewLineAtRangeStart:andRangeEnd:
  
  on getFieldDataForFieldAtIndex:theIndex
    set theIndex to theIndex as integer
    tell application "Microsoft Word"
      
      --breaks in Word
      --set thePath to the path of the front document
      --tell me to log thePath
      
      set pathList to path of documents
      tell me to log pathList
      
      set theField to field theIndex of active document
      return field text of theField
    end tell
    return missing value
  end getFieldDataForFieldAtIndex:
  
  
  (*
  on getFieldDataForFieldAtIndexUsingScript:theIndex
    set theIndex to theIndex as integer
    set myScript to load script ("/Users/ewhitley/Documents/work_other/NU/Word Plugin/_code/StatTag_AppleScripts/STAdditions.scpt" as POSIX file)
    set scriptResult to myScript's getFieldDataForFieldAtIndex(theIndex)
  end getFieldDataForFieldAtIndexUsingScript:
*)

  on getFieldDataFileForFieldAtIndex:theIndex
    
    set strVarName to "STMacFieldCodeIndex"
    set gstrVBAMacroName to "StatTag_GetFieldDataTest" as text
    set theIndex to theIndex as integer
    set strVarValue to theIndex as text
    
    tell application "Microsoft Word"
      
      tell active document
        
        if (name of (variable strVarName) is missing value) then -- does NOT exist
          set bolVarExists to false
          else -- var DOES exist
          set bolVarExists to true
        end if -- Variable doesn't exist
        
      end tell -- active document
      
      
      if bolVarExists then --- the Variable DOES exist, so just set the value ---
        
        tell active document to set oVar to variable strVarName
        set strName to name of oVar
        set strValue to variable value of oVar
        log oVar
        
        --- UPDATE THE VBA Variable Value ---
        set variable value of oVar to strVarValue
        
        
        else --- Create New Doc Variable And Set The Variable Value To The KM Variable value ---
        
        make new variable at active document with properties {name:strVarName, variable value:strVarValue}
        set strName to strVarName
        set strValue to "<Variable Didn't exist>"
        
      end if
      
      run VB macro macro name gstrVBAMacroName
      
      set fileName to "StatTag.txt"
      set targetFile to (path to temporary items as string) & fileName
      set theFileContents to (read file targetFile)

      return theFileContents
      
    end tell

    
  end getFieldDataFileForFieldAtIndex


  on updateAllFields()
    --tell application "StatTagTestUI" to run
    activate application "StatTagTestUI"
    tell application "StatTagTestUI"
      return updateFields
    end tell
  end updateAllFields


(*
  on setActiveDocumentByDocPath:thePath
    set thePath to thePath as string
  end setActiveDocumentByDocPath:
*)

  on setActiveDocumentByDocName:theName
    set theName to theName as string
    --display dialog theName
    --activate application "Microsoft Word"
    tell application "Microsoft Word"
      set names to name of documents
      repeat with currentName in names
        if ((currentName as string) is equal to theName) then
          activate object document theName
          return
        end if
      end repeat
    end tell
  end setActiveDocumentByDocName:


end script
