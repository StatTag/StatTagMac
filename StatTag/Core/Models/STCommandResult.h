//
//  STCommandResult.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STJSONable.h"
@class STTable;

@interface STCommandResult : NSObject<STJSONAble> {
  NSString* _ValueResult;
  NSString* _FigureResult;
  STTable* _TableResult;
}

@property (copy, nonatomic) NSString* ValueResult;
@property (copy, nonatomic) NSString* FigureResult;
@property (strong, nonatomic) STTable* TableResult;

-(BOOL)IsEmpty;
-(NSString*)ToString;


//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
+(NSString*)SerializeList:(NSArray<STCommandResult*>*)list error:(NSError**)error;
+(NSArray<STCommandResult*>*)DeserializeList:(NSString*)List error:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;

@end
