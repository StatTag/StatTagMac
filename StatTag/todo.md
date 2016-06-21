
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
10) TagUtil - this method is probably wrong on the obj-c side
    +(BOOL)IsDuplicateLabelInSameFile:(STTag*)tag result:(NSDictionary<STCodeFile*, NSArray<NSNumber*>*>*)result


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
