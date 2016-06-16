//
//  STFigureFormat.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
//@protocol STIValueFormatter;
#import "STIValueFormatter.h"

@class STTable;
@class STBaseValueFormatter;

@interface STTableFormat : NSObject {
  BOOL IncludeColumnNames;
  BOOL IncludeRowNames;
}

@property BOOL IncludeColumnNames;
@property BOOL IncludeRowNames;

-(NSArray<NSString*>*)Format:(STTable*)tableData valueFormatter:(NSObject<STIValueFormatter>*)valueFormatter;
-(NSArray<NSString*>*)Format:(STTable*)tableData;


@end
