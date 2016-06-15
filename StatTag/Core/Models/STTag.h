//
//  STTag.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STCodeFile;
@class STCommandResult;

@interface STTag : NSObject {
  /*
   public CodeFile CodeFile { get; set; }
   public string Type { get; set; }
   public string Name { get; set; }
   public string RunFrequency { get; set; }
   public ValueFormat ValueFormat { get; set; }
   public FigureFormat FigureFormat { get; set; }
   public TableFormat TableFormat { get; set; }
   public List<CommandResult> CachedResult { get; set; }
   */
  STCodeFile *CodeFile;
  NSString *Type;
  NSString *Name;
  NSString *RunFrequency;
  //STValueFormat *ValueFormat;
  //STTableFormat *TableFormat;
  NSMutableArray<STCommandResult*> *CachedResult;
  NSNumber *LineStart;
  NSNumber *LineEnd;
}


@property STCodeFile *CodeFile;
@property NSString *Type;
@property NSString *Name;
@property NSString *RunFrequency;
//@property STValueFormat *ValueFormat;
//@property STTableFormat *TableFormat;
@property NSMutableArray<STCommandResult*> *CachedResult;

/**
 @brief The starting line is the 0-based line index where the opening tag tag exists.
 */
@property NSNumber *LineStart; //nil-able int

/**
 @brief The ending line is the 0-based line index where the closing tag tag exists.
 */
@property NSNumber *LineEnd; //nil-able int


@end
