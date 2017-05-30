

Word:
----
sdef /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app/ | sdp -fh --basename STWord2011

Which will generate an error: "enumerator of enumeration "e183": missing required "name" attribute"


OPTION 1:
-----
Read instructions here: http://stackoverflow.com/questions/15338454/scripting-bridge-and-generate-microsoft-word-header-file

sdef /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app/ > STMSWord2011.sdef

(add missing name fields to e315 and e183)

sdp -fh STMSWord2011.sdef --basename STMSWord2011

NOTE: the missing ENUM e183 has a missing name for what appears to be FieldMacroButton

https://msdn.microsoft.com/en-us/library/office/ff192211.aspx?f=255&MSPPError=-2147217396

enum STMSWord2011E183 {
...
STMSWord2011E183FieldMacroButton = '\002G\0003',


OPTION 2:
-----
Read instructions here: https://github.com/rameshkumarpb/LinkMSWord/wiki/LinkMSWord

1. Create header for MicrosoftWord app

You cannot create Microsoft Word header file for one line code.

$ sdef /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app | sdp -fh --basename MicrosoftWord

That won’t work, to achieve little bit tricky.

First use the command sdef "$INPUT_FILE_PATH" > MicrosoftWord.sdef.

Open the MicrosoftWord.sdef file and search for the enumeration named e315 and e183. The enumeration looks like:

e183 is missing one name field, so I just added a string to it. e315 is missing all its name fields, so I added them.

Or use this example code

$ sdef /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app | sed 's/<enumerator code="0x02470033"/<enumerator name="def0" code="0x02470033"/g' |  sed 's/<enumerator code="0x02caffff"/<enumerator name="def1" code="0x02caffff"/g' | sed 's/<enumerator code="0x02cb0000"/<enumerator name="def2" code="0x02cb0000"/g' | sed 's/<enumerator code="0x02cb0001"/<enumerator name="def3" code="0x02cb0001"/g' | sed 's/<enumerator code="0x02cb0002"/<enumerator name="def4" code="0x02cb0002"/g' | sed 's/<enumerator code="0x02cb0003"/<enumerator name="def5" code="0x02cb0003"/g' | sed 's/<enumerator code="0x02cb0004"/<enumerator name="def6" code="0x02cb0004"/g' | sed 's/<enumerator code="0x02cb0005"/<enumerator name="def7" code="0x02cb0005"/g' | sed 's/<enumerator code="0x02cb0006"/<enumerator name="def8" code="0x02cb0006"/g' | sed 's/<enumerator code="0x02cb0007"/<enumerator name="def9" code="0x02cb0007"/g' | sed 's/<enumerator code="0x02cb0008"/<enumerator name="def10" code="0x02cb0008"/g' | sed 's/<enumerator code="0x02cb0009"/<enumerator name="def11" code="0x02cb0009"/g' | sed 's/<enumerator code="0x02cb000a"/<enumerator name="def12" code="0x02cb000a"/g' | sed 's/<enumerator code="0x02cb000b"/<enumerator name="def13" code="0x02cb000b"/g' | sed 's/<enumerator code="0x02cb000c"/<enumerator name="def14" code="0x02cb000c"/g' | sed 's/<enumerator code="0x02cb000d"/<enumerator name="def15" code="0x02cb000d"/g' | sed 's/<enumerator code="0x02cb000e"/<enumerator name="def16" code="0x02cb000e"/g' | sed 's/<enumerator code="0x02cb000f"/<enumerator name="def17" code="0x02cb000f"/g' | sed 's/<enumerator name="format document97" code="0x02310000"/<enumerator name="format document97i" code="0x023100a0"/' | sed 's/<enumerator name="format template97" code="0x02310001"/<enumerator name="format template97i" code="0x023100a1"/' | sed 's/enumerator name="format Unicode text" code="0x02310007"/enumerator name="format Unicode texti" code="0x023100a7"/' | sed 's/<command name="get border" code="sTXTwBtr"/<command name="get borderi" code="sTXTwBtr"/' | sed 's/command name="reset" code="sTXTmFBr"/command name="reseti" code="sTXTmFBr"/' | sed 's/<command name="get border" code="sTBLwBtr"/<command name="get borderi2" code="sTBLwBtr"/' | sed 's/property name="char" code="14Aj"/property name="char1" code="14Aj"/' | sed 's/property name="case" code="1721" type="e125"/property name="case1" code="1721" type="e125"/' >> MicrosoftWord.sdef
Then use the command

$ sdp -fh MicrosoftWord.sdef --basename MicrosoftWord

file is now generated.

Note: At the end you may get two warnings, just ignore. Warnings sdp: warning: property "cells" of class "revision" refers to undefined type 'null'; assuming type 'id'. sdp: warning: property "style" of class "revision" refers to undefined type 'null'; assuming type 'id'.

2. Add into project

Just drag into project and make sure check copy items into destination group folder’s, check Add target to project.

3. Import header and use it

Import MicrosoftWord.h file into your project file and use it.

Finally, drag the Micorsoft word app into Xcode uncheck Copy items into destination group folder’s and check Add target to project

Add build rules

Xcode Editor Menu select Add build rules and configure the following area,

Process -> Source files with names matching:

textbox: *.app

Using -> Custom script:

Textarea paste this script

$ sdef "$INPUT_FILE_PATH" | sed 's/<enumerator code="0x02470033"/<enumerator name="def0" code="0x02470033"/g' | sed 's/<enumerator code="0x02caffff"/<enumerator name="def1" code="0x02caffff"/g' | sed 's/<enumerator code="0x02cb0000"/<enumerator name="def2" code="0x02cb0000"/g' | sed 's/<enumerator code="0x02cb0001"/<enumerator name="def3" code="0x02cb0001"/g' | sed 's/<enumerator code="0x02cb0002"/<enumerator name="def4" code="0x02cb0002"/g' | sed 's/<enumerator code="0x02cb0003"/<enumerator name="def5" code="0x02cb0003"/g' | sed 's/<enumerator code="0x02cb0004"/<enumerator name="def6" code="0x02cb0004"/g' | sed 's/<enumerator code="0x02cb0005"/<enumerator name="def7" code="0x02cb0005"/g' | sed 's/<enumerator code="0x02cb0006"/<enumerator name="def8" code="0x02cb0006"/g' | sed 's/<enumerator code="0x02cb0007"/<enumerator name="def9" code="0x02cb0007"/g' | sed 's/<enumerator code="0x02cb0008"/<enumerator name="def10" code="0x02cb0008"/g' | sed 's/<enumerator code="0x02cb0009"/<enumerator name="def11" code="0x02cb0009"/g' | sed 's/<enumerator code="0x02cb000a"/<enumerator name="def12" code="0x02cb000a"/g' | sed 's/<enumerator code="0x02cb000b"/<enumerator name="def13" code="0x02cb000b"/g' | sed 's/<enumerator code="0x02cb000c"/<enumerator name="def14" code="0x02cb000c"/g' | sed 's/<enumerator code="0x02cb000d"/<enumerator name="def15" code="0x02cb000d"/g' | sed 's/<enumerator code="0x02cb000e"/<enumerator name="def16" code="0x02cb000e"/g' | sed 's/<enumerator code="0x02cb000f"/<enumerator name="def17" code="0x02cb000f"/g' | sed 's/<enumerator name="format document97" code="0x02310000"/<enumerator name="format document97i" code="0x023100a0"/' | sed 's/<enumerator name="format template97" code="0x02310001"/<enumerator name="format template97i" code="0x023100a1"/' | sed 's/enumerator name="format Unicode text" code="0x02310007"/enumerator name="format Unicode texti" code="0x023100a7"/' | sed 's/<command name="get border" code="sTXTwBtr"/<command name="get borderi" code="sTXTwBtr"/' | sed 's/command name="reset" code="sTXTmFBr"/command name="reseti" code="sTXTmFBr"/' | sed 's/<command name="get border" code="sTBLwBtr"/<command name="get borderi2" code="sTBLwBtr"/' | sed 's/property name="char" code="14Aj"/property name="char1" code="14Aj"/' | sed 's/property name="case" code="1721" type="e125"/property name="case1" code="1721" type="e125"/' | sdp -fh -o "$DERIVED_FILES_DIR" --basename "$INPUT_FILE_BASE" --bundleid defaults read "$INPUT_FILE_PATH/Contents/Info" CFBundleIdentifier


