//
//  STCodeFileAction.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCodeFileAction.h"
#import "STConstants.h"

@implementation STCodeFileAction

@synthesize Label = _Label;
@synthesize Action = _Action;
@synthesize Parameter = _Parameter;

//FIXME: just blindly copying for now - this should probably be "description"
-(NSString*)ToString {
  return _Label;
}
-(NSString*)description {
  return [self ToString];
}








//MARK: JSON
//NOTE: go back later and figure out if/how the bulk of this can be centralized in some sort of generic or category (if possible)
-(NSDictionary *)toDictionary {
  NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
  [dict setValue:[self Label] forKey:@"Label"];
  [dict setValue:[NSNumber numberWithInteger:[self Action]] forKey:@"Action"];
  [dict setValue:[self Parameter] forKey:@"Parameter"]; //this might be a problem
  return dict;
}

-(void)setWithDictionary:(NSDictionary*)dict {
  for (NSString* key in dict) {
    if([key isEqualToString:@"Parameter"]) {
      //explicitly calling this out because it's currently unclear how we should handle reconstructing this one
      //ex: is this a model object? is this a primitive type?
      [self setValue:[dict valueForKey:key] forKey:key];
    } else {
      [self setValue:[dict valueForKey:key] forKey:key];
    }
  }
}

-(NSString*)Serialize:(NSError**)outError
{
  return [STJSONUtility SerializeObject:self error:nil];
}

+(NSString*)SerializeList:(NSArray<NSObject<STJSONAble>*>*)list error:(NSError**)outError {
  return [STJSONUtility SerializeList:list error:nil];
}

+(NSArray<STCodeFileAction*>*)DeserializeList:(id)List error:(NSError**)outError
{
  NSMutableArray<STCodeFileAction*>* ar = [[NSMutableArray<STCodeFileAction*> alloc] init];
  for(id x in [STJSONUtility DeserializeList:List forClass:[self class] error:nil]) {
    if([x isKindOfClass:[self class]])
    {
      [ar addObject:x];
    }
  }
  return ar;
}

-(instancetype)initWithDictionary:(NSDictionary*)dict
{
  self = [super init];
  if (self) {
    [self setWithDictionary:dict];
  }
  return self;
}

-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)outError
{
  self = [super init];
  if (self) {
    
    NSError *error = nil;
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    
    if (!error && JSONDictionary) {
      [self setWithDictionary:JSONDictionary];
    } else {
      if (outError) {
        *outError = [NSError errorWithDomain:STStatTagErrorDomain
                                        code:[error code]
                                    userInfo:@{NSUnderlyingErrorKey: error}];
      }
    }
  }
  return self;
}



@end
