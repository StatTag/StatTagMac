//
//  STStatsManager.h
//  StatTag
//
//  Created by Eric Whitley on 7/8/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STTag;
@class STDocumentManager;
@class STCodeFile;
@class STTag;

/**
 Used exclusively by ExecuteStatPackage as its return value type.
 */
@interface STStatsManagerExecuteResult : NSObject {
  BOOL _Success;
  NSMutableArray<STTag*>* UpdatedTags;
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


@end


/**
 Manages the execution of code files in the correct statistical package.
 */
@interface STStatsManager : NSObject {
  STDocumentManager* _Manager;
}

@property (strong, nonatomic) STDocumentManager* Manager;

-(instancetype)init:(STDocumentManager*)manager;

-(STStatsManagerExecuteResult*) ExecuteStatPackage:(STCodeFile*)file filterMode:(int)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun;
-(STStatsManagerExecuteResult*) ExecuteStatPackage:(STCodeFile*)file filterMode:(int)filterMode;
-(STStatsManagerExecuteResult*) ExecuteStatPackage:(STCodeFile*)file;

@end