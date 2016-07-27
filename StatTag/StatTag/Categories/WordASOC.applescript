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


end script