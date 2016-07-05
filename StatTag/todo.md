TO DO:
==================
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


16) read up more on scripting bridge

    https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ScriptingBridgeConcepts/UsingScriptingBridge/UsingScriptingBridge.html

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


NSLog(@"%@", [self attributesOfProp:key ofObj:self]);



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
