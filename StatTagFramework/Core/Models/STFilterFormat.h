//
//  STFilterFormat.h
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBase.h"


@interface STFilterFormat : STBase <NSCopying> {
  NSString* _Prefix;
  BOOL _Enabled;
  NSString* _Type;
  NSString* _Value;
}

@property (strong, nonatomic) NSString* Prefix;
@property BOOL Enabled;
@property (strong, nonatomic) NSString* Type;
@property (strong, nonatomic) NSString* Value;

-(NSInteger)GetValueFromString:(NSString*)value;
-(NSArray<NSNumber*>*)ExpandValue;


-(instancetype)init;
-(instancetype)initWithPrefix:(NSString*) prefix;


//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
//-(NSString*)SerializeObject:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;
-(void)setWithDictionary:(NSDictionary*)dict;

/**
 Create a new Tag object given a JSON string
 */
+(instancetype)Deserialize:(NSString*)json error:(NSError**)outError;
+(NSArray<STFilterFormat*>*)DeserializeList:(id)List error:(NSError**)outError;

@end
