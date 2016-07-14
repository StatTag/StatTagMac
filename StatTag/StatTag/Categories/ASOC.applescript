script ASOC
  property parent : class "NSObject"
  
  on thinkdifferent()
    log "think different."
  end
  
  on square_(aNumber)
    log "squaring..."
    set aNumber to aNumber as integer
    set aNumber to aNumber ^ 2
    log aNumber
    return aNumber
  end square_


  on doSomethingTo:someString andTo:anotherString
    -- coerce parameters from Cocoa to AppleScript
    set someString to someString as text
    set anotherString to anotherString as text
    set newString to someString & space & anotherString
    --display dialog newString buttons {"OK"}
    
    set foundIt to false as boolean
    set FindText to "asdf" as string
    
    tell application "Microsoft Word"
      set textObject to (text object of active document)
      set findObject to (find object of textObject)
      
      set forward of findObject to true
      set wrap of findObject to find stop
      
      tell findObject
        set foundIt to execute find find text FindText
      end tell
    end tell
    
    log "foundIt... " & foundIt
    
    return newString
  end doSomethingTo:andTo:

  on findText:searchText atRangeStart:rangeStart andRangeEnd:rangeEnd
      log "findText..."
      
      -- coerce types
      set searchText to searchText as text
      set rangeStart to rangeStart as integer
      set rangeEnd to rangeEnd as integer
      
      set foundIt to false as boolean
--      set testString to "hi" as string

      tell application "Microsoft Word"
        tell active document
          set searchRange to create range start rangeStart end rangeEnd
          set testString to content of searchRange
          --set textObject to (content object of searchRange)
--          set textObject to content of searchRange
--          set findObject to (find object of textObject)
          set findObject to (find object of searchRange)

--          set findObject to findObject of searchRange

--
          set forward of findObject to true
          set wrap of findObject to find stop
          
          tell findObject
            set foundIt to execute find find text searchText
          end tell          
        end tell
      end tell
      
--      log "testString... " & testString
      log "looking for... " & searchText
      log "foundIt... " & foundIt
      
      return foundIt
      
  end findText:atRangeStart:andRangeEnd:

--  on findText_(content, rangeStart, rangeEnd)
--    
--    log "findText..."

--    set content to content as text
--    set rangeStart to rangeStart as integer
--    set rangeEnd to rangeEnd as integer
--
--    log "content..."
--    log content
--
--    log "rangeStart..."
--    log rangeStart
--
--    log "rangeEnd..."
--    log rangeEnd
--
--    set found to true
--    log "found..."
--    log found
--    
--    return found

--  end findText_

end script