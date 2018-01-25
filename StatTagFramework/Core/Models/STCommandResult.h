//
//  STCommandResult.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STBase.h"


@class STTable;

@interface STCommandResult : STBase {
  NSString* _ValueResult;
  NSString* _FigureResult;
  STTable* _TableResult;
  NSString* _TableResultPromise;
}

@property (copy, nonatomic) NSString* ValueResult;
@property (copy, nonatomic) NSString* FigureResult;
@property (strong, nonatomic) STTable* TableResult;
@property (strong, nonatomic) NSString* VerbatimResult;


/**
Although not strictly enforced, the TableResult or TableResultPromise should be set at one time, but not both.  The presence of the TableResultPromise member will be used as a flag to indicate that the TableResult needs to be set. Once the table is set, we clear the promise since it has been fulfilled.

 @remark Indicates that a promise is made to deliver table data, but that the data may not be ready to be pulled yet.  The information stored in this property will be sufficient for each statistical package processor to create a populated instance of TableResult.
*/
@property (copy, nonatomic) NSString* TableResultPromise;

-(BOOL)IsEmpty;
-(NSString*)ToString;


//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
+(NSString*)SerializeList:(NSArray<STCommandResult*>*)list error:(NSError**)error;
+(NSArray<STCommandResult*>*)DeserializeList:(id)List error:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;

@end
