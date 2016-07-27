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
@class STFieldCreator;
@class STTag;
@class STFieldTag;
@class STMSWord2011SelectionObject;
@class STMSWord2011Variable;

@interface STDocumentManager : NSObject {
  NSMutableDictionary<NSString*, NSMutableArray<STCodeFile*>*>* DocumentCodeFiles;
  STTagManager* _TagManager;
  STStatsManager* _StatsManager;
  
  STFieldCreator* _FieldManager;
}

@property (strong, nonatomic) STTagManager* TagManager;
@property (strong, nonatomic) STStatsManager* StatsManager;
@property (strong, nonatomic) STFieldCreator* FieldManager;


-(NSArray<STTag*>*)GetTags;
-(NSDictionary<NSString*, NSArray<STTag*>*>*)FindAllUnlinkedTags;
-(STTag*)FindTag:(NSString*)tagID;


-(void)SaveCodeFileListToDocument:(STMSWord2011Document*)document;
-(void)LoadCodeFileListFromDocument:(STMSWord2011Document*)document;
-(void)UpdateInlineShapes:(STMSWord2011Document*)document; // this should be private - only making public for testing

-(void)AddCodeFile:(NSString*)fileName;
-(void)AddCodeFile:(NSString*)fileName document:(STMSWord2011Document*)document;

-(NSMutableArray<STCodeFile*>*)GetCodeFileList;
-(NSMutableArray<STCodeFile*>*)GetCodeFileList:(STMSWord2011Document*)document;
-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files;
-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files document:(STMSWord2011Document*)document;

-(void) InsertImage:(STTag*) tag;
-(void) InsertTable:(STMSWord2011SelectionObject*)selection tag:(STTag*) tag;

-(void) InsertField:(id)tag;

@end
