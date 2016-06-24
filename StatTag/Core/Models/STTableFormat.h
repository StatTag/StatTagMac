//
//  STFigureFormat.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIValueFormatter.h"
#import "STJSONable.h"

@class STTable;
@class STBaseValueFormatter;

@interface STTableFormat : NSObject <NSCopying, STJSONAble> {
  BOOL _IncludeColumnNames;
  BOOL _IncludeRowNames;
}

@property BOOL IncludeColumnNames;
@property BOOL IncludeRowNames;

-(NSArray<NSString*>*)Format:(STTable*)tableData valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter;
-(NSArray<NSString*>*)Format:(STTable*)tableData;



//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
+(NSString*)SerializeList:(NSArray<STTableFormat*>*)list error:(NSError**)error;
+(NSArray<STTableFormat*>*)DeserializeList:(NSString*)List error:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;


@end
