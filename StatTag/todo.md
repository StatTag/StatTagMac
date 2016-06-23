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


FIXED:
==================


10) TagUtil - this method is probably wrong on the obj-c side
+(BOOL)IsDuplicateLabelInSameFile:(STTag*)tag result:(NSDictionary<STCodeFile*, NSArray<NSNumber*>*>*)result
FIXED: - now checking integerValue instead of just > (value)











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
