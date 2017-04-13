BROKEN:
==================
1) -(void)UpdateInlineShapes:(STMSWord2011Document*)document
   we can't seem to update inline shapes - at all
  http://stackoverflow.com/questions/38621644/word-applescript-update-link-format-working-with-inline-shapes



TO DO:
==================
-1) In VBA - before calling out to refresh all fields - disable screen updating.  Screen updating toggle does NOT work for Word via AppleScript
1) Fix date parsing - still odd issues with times w/o dates pulling incorrect timezone
2) Change all inner members to _variable notation and fix property mappings
3) Fix all error handlers - currently returning nils
4) Set all atomic/retain/etc. options for each property (readonly) (nonatomic) (strong) (copy) etc.
   - (copy) string
   - (strong, nonatomic) array, date
   _ (strong, nonatomic) any other child model item
   - assign
   - readonly
   - int/bool/double?
5) in Tag, should the equality comparison be case insensitive?

    //FIXME: should these be case insensitive comparisons?
    if(![_Name isEqualToString:[tag Name]]) {
      return false;
    }
6) in Tag, check to see about "current culture" comparison
    //return Type != null && Type.Equals(Constants.TagType.Table, StringComparison.CurrentCulture);
7) Update STFieldTag to fix new properties in object copy
8) Specifically test STBaseParameterGenerator -> CleanResult (put in a trailing comma)
9) STableGenerator -
    //FIXME: is this going to emit "YES" or "true" or "1"?
    -(NSString*)CreateTableParameters:(STTag*) tag
   ***** NOTE: this is in several places - so may have to scan for all BOOLs used in strings
    in c#, it's "false" or "true" (but the json doesn't string encode the value)
10) What's the "parameter" object in STCodeFileAction?
   
11) isEqualTo vs isEqual - should we do both?
12) Think through the use of NSURL for all of these paths - apparently NSURL preprends certain file paths if we pass just a filename - should we be storing a string instead?
13) Move regex helper functionality out of the StataBaseParser class
    +(BOOL)regexIsMatch:(NSRegularExpression*)regex inString:(NSString*)string {
    (etc.)
14) see if we need to make our own faux wrapping class for approximation of the c# regex. Problem is we may not have the original string everywhere, so passing this back up _may_ be useful
    m.success (did it work) nil/non-nill
    m.index (starting point)
    m.length (length)
    m.value (match result) {from range}
15) Issue: no support for if/then/else conditional regex
private static readonly Regex ValueRegex = new Regex(string.Format("^\\s*{0}((\\s*\\()|(\\s+))(.*)(?(2)\\))", ValueCommand));

http://www.rexegg.com/regex-conditionals.html
http://stackoverflow.com/questions/8072756/does-java-support-if-then-else-regexp-constructsperl-constructs

    Change the GetValueName implementation later - 

    Pseudocode:
    - do basic regex
    - get group
    - trim all whitespace
    - if starts with “(“ and ends with “)”
      - remove single prefix “(“ and single suffix “)”

     Evaluate: https://github.com/bendytree/Objective-C-RegEx-Categories


16A) read up on Office 2016 AppleScript 

http://www.rondebruin.nl/mac/applescripttask.htm

16) read up more on scripting bridge

    https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ScriptingBridgeConcepts/UsingScriptingBridge/UsingScriptingBridge.html

To generate a scripting bridge header:

sdef [path to app] | sdp -fh --basename [your class prefix]
sdef /Applications/R.app | sdp -fh --basename STR

16b) 
  applescript variable example - https://github.com/henriquebastos/autoword/blob/master/autoword.applescript
  dictionary literal constructor - http://stackoverflow.com/questions/12535855/should-i-prefer-to-use-literal-syntax-or-constructors-for-creating-dictionaries
  how to pass word variable between AS and VBA - https://forum.keyboardmaestro.com/t/how-to-pass-km-variable-into-a-word-mac-2011-macro-as-a-variable/2582/4
  how to pass word variable between AS and VBA - http://answers.microsoft.com/en-us/mac/forum/macoffice2011-macword/can-i-pass-parameters-to-a-word-2011-macro-from/bfd3fe1d-317e-4d96-85f3-1758638e2653?auth=1

16c) go back and review the way we're handling bridging to Word document variables.  Try to see if we can fix the way we're creating variables. Had issues following the example:  http://robnapier.net/scripting-bridge

    MailOutgoingMessage *mailMessage =
      [[[[mail classForScriptingClass:@"outgoing message"] alloc]
        initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
          @"Test outgoing", @"subject",
          @"Test body\n\n", @"content",
          nil]] autorelease];
    [[mail outgoingMessages] addObject:mailMessage];


17) DocumentManager -> AddCodeFile - we're not setting this in the origin array - this is a copy. Ask Luke about this'


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


FIXED:
==================


10) TagUtil - this method is probably wrong on the obj-c side
+(BOOL)IsDuplicateLabelInSameFile:(STTag*)tag result:(NSDictionary<STCodeFile*, NSArray<NSNumber*>*>*)result
FIXED: - now checking integerValue instead of just > (value)


NOTES: OCMock
===================

OCMock - this is a 64bit library.
If you update it, you'll need to do what I did - get it to be 32-bit compatible.

To be able to compile OCMock for 32bit, you'll need to adjust one area of code so it's compatible.

File: /OCMock/Core Mocks/Recorder/OCMVerifier.h
Add the instance variable declaration

@interface OCMVerifier : OCMRecorder {
OCMLocation *_location;
}


File: /OCMock/Core Mocks/Recorder/OCMVerifier.m
Synthesize the property:

@synthesize location = _location;

Then - to incorporate it into your tests, do the following (from here: http://stackoverflow.com/questions/14760435/adding-ocmock-causes-test-to-launch-main-app-instead-of-running-tests)

  1) Go to your project file
  2) Go to your test target
  3) Click on "Build Phases"
  4) Add a build phase for Copy Files"'
  5) Set Destination to "Prodcts Directory"
  6) Add OCMock.framework (32 bit version) to the list of files"





NOTES:
==============
NSRegularExpressionAnchorsMatchLines on using $
http://stackoverflow.com/questions/16665870/nsregularexpression-find-pattern-with-optional-part



#import <objc/runtime.h>

- (NSArray*) attributesOfProp:(NSString*)propName ofObj:(id)obj{
//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
objc_property_t prop = class_getProperty([obj class], propName.UTF8String);
if (!prop) {
// doesn't exist for object
return nil;
}
const char * propAttr = property_getAttributes(prop);
NSString *propString = [NSString stringWithUTF8String:propAttr];
NSArray *attrArray = [propString componentsSeparatedByString:@","];
return attrArray;
}


//NSLog(@"%@", [self attributesOfProp:key ofObj:self]);



//  // if you are expecting  the JSON string to be in form of array else use NSDictionary instead
//  id object = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:error];
//  
//  if ([object isKindOfClass:[NSDictionary class]] && error == nil)
//  {
//    NSArray *array;
//    if ([[object objectForKey:@"results"] isKindOfClass:[NSArray class]])
//    {
//      array = [object objectForKey:@"results"];
//      return array;
//    }
//  }
//  return nil;



//Loop method
//      for (NSString* key in JSONDictionary) {
//        [self setValue:[JSONDictionary valueForKey:key] forKey:key];
//      }
//[self setValuesForKeysWithDictionary:JSONDictionary]; //we have a URL, so we can't do this
