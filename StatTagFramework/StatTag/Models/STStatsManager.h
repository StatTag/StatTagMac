//
//  STStatsManager.h
//  StatTag
//
//  Created by Eric Whitley on 7/8/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STIStatAutomation.h"
#import "STICodeFileParser.h"


@class STTag;
@class STDocumentManager;
@class STCodeFile;
@class STTag;
@class STSettingsManager;

/**
 Used exclusively by ExecuteStatPackage as its return value type.
 */
@interface STStatsManagerExecuteResult : NSObject {
  BOOL _Success;
  NSMutableArray<NSException*>* GeneralErrors;
  NSMutableArray<STTag*>* UpdatedTags;
  NSMutableArray<STTag*>* FailedTags;
}

/**
 Did the call to ExecuteStatPackage complete without any errors
 */
@property BOOL Success;
/**
 A list of Tags that were detected as having changed values since they
 were originally inserted into the document
*/
@property (strong, nonatomic) NSMutableArray<STTag*>* UpdatedTags;
@property (strong, nonatomic) NSMutableArray<STTag*>* FailedTags;
/**
 A collection of exceptions caught while processing
 */
@property (strong, nonatomic) NSMutableArray<NSException*>* GeneralErrors;

@end


/**
 Manages the execution of code files in the correct statistical package.
 */
@interface STStatsManager : NSObject {
  STDocumentManager* _DocumentManager;
  STSettingsManager* _SettingsManager;
}

@property (strong, nonatomic) STDocumentManager* DocumentManager;
@property (strong, nonatomic) STSettingsManager* SettingsManager;

-(instancetype)initWithDocumentManager:(STDocumentManager*)documentManager andSettingsManager:(STSettingsManager*)settingsManager;

+(id<STIStatAutomation>)GetStatAutomation:(STCodeFile*) file;
+(id<STICodeFileParser>)GetCodeFileParser:(STCodeFile*) file;

-(STStatsManagerExecuteResult*) ExecuteStatPackage:(STCodeFile*)file filterMode:(NSInteger)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(STStatsManagerExecuteResult*) ExecuteStatPackage:(STCodeFile*)file filterMode:(NSInteger)filterMode;
-(STStatsManagerExecuteResult*) ExecuteStatPackage:(STCodeFile*)file;

@end
