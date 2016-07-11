//
//  STDocumentManager.h
//  StatTag
//
//  Created by Eric Whitley on 7/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STStatsManager;
@class STTagManager;
@class STCodeFile;
@class STTag;
@class STMSWord2011Document;

@interface STDocumentManager : NSObject {
  NSMutableDictionary<NSString*, NSMutableArray<STCodeFile*>*>* DocumentCodeFiles;
  STTagManager* _TagManager;
  STStatsManager* _StatsManager;
}

@property (strong, nonatomic) STTagManager* TagManager;
@property (strong, nonatomic) STStatsManager* StatsManager;


-(STTag*)FindTag:(NSString*)tagID;

-(void)LoadCodeFileListFromDocument:(STMSWord2011Document*)document;

-(void)AddCodeFile:(NSString*)fileName;
-(void)AddCodeFile:(NSString*)fileName document:(STMSWord2011Document*)document;

-(NSMutableArray<STCodeFile*>*)GetCodeFileList;
-(NSMutableArray<STCodeFile*>*)GetCodeFileList:(STMSWord2011Document*)document;
-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files;
-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files document:(STMSWord2011Document*)document;

@end
