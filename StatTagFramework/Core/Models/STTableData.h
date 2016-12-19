//
//  STTableData.h
//  StatTag
//
//  Created by Eric Whitley on 12/5/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STJSONAble.h"

@interface STTableData : NSObject <NSCopying, STJSONAble> {
  NSMutableArray<NSMutableArray<NSString*>*>* _Data;
}
@property (strong, nonatomic) NSMutableArray<NSMutableArray<NSString*>*>* Data;
-(NSInteger)numRows;
-(NSInteger)numColumns;
-(NSInteger)numItems;

-(instancetype)init;
-(instancetype)initWithRows:(NSInteger)rows andCols:(NSInteger)cols;
-(instancetype)initWithRows:(NSInteger)rows andCols:(NSInteger)cols andData:(NSArray<NSArray<NSString*>*>*)data;
-(instancetype)initWithData:(NSArray<NSArray<NSString*>*>*)data;
-(void)replaceData:(NSArray<NSArray<NSString*>*>*)data;

-(void)addValue:(NSString*)value atRow:(NSInteger)row andColumn:(NSInteger)col;
-(NSString*)valueAtRow:(NSInteger)row andColumn:(NSInteger)col;
-(NSString*)GetDataAtIndex:(NSInteger)index;

-(NSString*) indexedDescription;

@end
