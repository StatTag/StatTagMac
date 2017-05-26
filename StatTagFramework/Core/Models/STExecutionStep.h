//
//  STExecutionStep.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STJSONAble.h"

@class STTag;

@interface STExecutionStep : NSObject<STJSONAble> {
  NSInteger _Type;
  NSMutableArray<NSString*>* _Code;
  NSMutableArray<NSString*>* _Result;
  STTag* _Tag;
}

@property NSInteger Type;
@property (strong, nonatomic) NSMutableArray<NSString*>* Code;
@property (strong, nonatomic) NSMutableArray<NSString*>* Result;
@property (strong, nonatomic) STTag *Tag;


//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
+(NSString*)SerializeList:(NSArray<STExecutionStep*>*)list error:(NSError**)error;
+(NSArray<STExecutionStep*>*)DeserializeList:(NSString*)List error:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;

@end
