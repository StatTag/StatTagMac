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
    
    --log logMessage
    
  end createOrUpdateDocumentVariableWithName:andValue:


  --keeping this here as an example
--  on UpdateInlineShapes:doc
--    set docName to "" as text
--    tell application "Microsoft Word"
--      set docName to |name| of doc --as text
--    end tell
--    log "doc name : " & docName
--  end UpdateInlineShapes


  on UpdateLinkFormat:link
    
    set logMessage to "initial log message" as text
    set loopCount to 0
--    log logMessage
    tell application "Microsoft Word"
--      repeat with thisShape in (get inline shapes of active document)
--        --if auto update of link format of thisShape is false then
--          update link format of thisShape
--          set logMessage to "updated?" as text
--        --end if
--      end repeat
        set loopCount to loopCount + 1
        --set logMessage = "looping (pre) : " & loopCount
        repeat with aShape in (get inline shapes of active document)
          --set logMessage to " field : " & hyperlink address of hyperlink of aField
--          set isUpdatable to auto update of link format of aShape as boolean
          set logMessage to " field : " & source path of link format of aShape
          
--          set logMessage to "looping (pre) : " & loopCount & " auto update is " & isUpdatable
          if auto update of link format of aShape is true then
            set logMessage to logMessage & "\r\n" & "looping (updated) (AUTO-UPDATE = TRUE) : " & loopCount
          --else if auto update of link format of aShape is in {missing value, true} then
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
--          else if auto update of link format of aShape is true then
--            update link format of aShape
--            set logMessage to "looping (updated) (AUTO-UPDATE = TRUE) : " & loopCount
          end if
        end repeat

    end tell
    
    log logMessage

--    set logMessage to "initial log message" as text
--    log logMessage
--    tell application "Microsoft Word"
--      update link
--      set logMessage to "updated?" as text
--    end tell
--    log logMessage
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
--  on disableScreenUpdates()
--    tell application "Microsoft Word"
--      tell active document
--        --set screen updating to false
--      end tell
--    end tell
--  end disableScreenUpdates
--
--  on enableScreenUpdates()
--    tell application "Microsoft Word"
--      tell active document
--        --set screen updating to true
--      end tell
--    end tell
--  end enableScreenUpdates

end script