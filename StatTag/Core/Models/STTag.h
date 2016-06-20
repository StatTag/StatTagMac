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
  STCodeFile* _CodeFile;
  NSString* _Type;
  NSString* _Name;
  NSString* _RunFrequency;
  //STValueFormat *ValueFormat;
  //STTableFormat *TableFormat;
  NSMutableArray<STCommandResult*>* _CachedResult;
  NSNumber* _LineStart;
  NSNumber* _LineEnd;
}


@property (strong, nonatomic) STCodeFile *CodeFile;
@property (copy, nonatomic) NSString *Type;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *RunFrequency;
//@property STValueFormat *ValueFormat;
//@property STTableFormat *TableFormat;
@property (strong, nonatomic) NSMutableArray<STCommandResult*> *CachedResult;

/**
 @brief The starting line is the 0-based line index where the opening tag tag exists.
 */
@property (copy, nonatomic) NSNumber *LineStart; //nil-able int

/**
 @brief The ending line is the 0-based line index where the closing tag tag exists.
 */
@property (copy, nonatomic) NSNumber *LineEnd; //nil-able int


@end
