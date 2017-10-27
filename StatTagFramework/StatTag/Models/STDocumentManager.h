//
//  STDocumentManager.h
//  StatTag
//
//  Created by Eric Whitley on 7/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STBaseManager.h"
#import "STUpdatePair.h" //we have to pull this in for our generics to work

@class STStatsManager;
@class STTagManager;
@class STCodeFile;
@class STCodeFileAction;
@class STTag;
@class STMSWord2011Document;
@class STFieldGenerator;
@class STTag;
@class STFieldTag;
@class STMSWord2011SelectionObject;
@class STMSWord2011Variable;
@class STMSWord2011Document;
@class STStatsManagerExecuteResult;

@interface STDocumentManager : STBaseManager {
  NSMutableDictionary<NSString*, NSMutableArray<STCodeFile*>*>* DocumentCodeFiles;
  STTagManager* _TagManager;
  STStatsManager* _StatsManager;
  
  STFieldGenerator* _FieldManager;
  
  NSNumber* _wordFieldsTotal;
  NSNumber* _wordFieldsUpdated;
  NSString* _wordFieldUpdateStatus;
}

@property (strong, nonatomic) STTagManager* TagManager;
@property (strong, nonatomic) STStatsManager* StatsManager;
@property (strong, nonatomic) STFieldGenerator* FieldManager;

@property (copy, nonatomic) NSNumber* wordFieldsTotal;
@property (copy, nonatomic) NSNumber* wordFieldsUpdated;
@property (copy, nonatomic) NSString* wordFieldUpdateStatus;

-(NSArray<STTag*>*)GetTags;
-(NSDictionary<NSString*, NSArray<STTag*>*>*)FindAllUnlinkedTags;
-(STTag*)FindTag:(NSString*)tagID;


-(void)SaveCodeFileListToDocument:(STMSWord2011Document*)document;
-(void)LoadCodeFileListFromDocument:(STMSWord2011Document*)document;
-(void)UpdateInlineShapes:(STMSWord2011Document*)document; // this should be private - only making public for testing


/**
	If code files become unlinked in the document, this method is used to resolve those tags/fields
	already in the document that refer to the unlinked code file.  It applies a set of actions to ALL of
	the tags in the document for a code file.
 
	@remark: See <see cref="UpdateUnlinkedTagsByTag">UpdateUnlinkedTagsByTag</see>
	if you want to perform actions on individual tags.
 */
-(void)UpdateUnlinkedTagsByCodeFile:(NSDictionary<NSString*, STCodeFileAction*>*)actions;

/**
	When reviewing all of the tags/fields in a document for those that have unlinked code files, duplicate
	names, etc., this method is used to resolve the errors in those tags/fields.  It applies individual actions
	to each tag in the document.
 
	@remarks: Some of the actions may in fact affect multiple tags.  For example, re-linking the code file
	to the document for a single tag has the effect of re-linking it for all related tags.
 
	@remark: See <see cref="UpdateUnlinkedTagsByCodeFile">UpdateUnlinkedTagsByCodeFile</see>
	if you want to process all tags in a code file with a single action.
 */
-(void)UpdateUnlinkedTagsByTag:(NSDictionary<NSString*, STCodeFileAction*>*)actions;



-(void)AddCodeFile:(NSString*)fileName;
-(void)AddCodeFile:(NSString*)fileName document:(STMSWord2011Document*)document;

-(void)RemoveCodeFile:(NSString*)fileName document:(STMSWord2011Document*)document;
-(void)RemoveCodeFile:(NSString*)fileName;

-(void)LoadAllTagsFromCodeFiles;

-(void) UpdateRenamedTags:(NSArray<STUpdatePair<STTag*>*>*) updates;

-(NSMutableArray<STCodeFile*>*)GetCodeFileList;
-(NSMutableArray<STCodeFile*>*)GetCodeFileList:(STMSWord2011Document*)document;
-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files;
-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files document:(STMSWord2011Document*)document;

-(void) InsertImage:(STTag*) tag;
-(void) InsertTable:(STMSWord2011SelectionObject*)selection tag:(STTag*) tag;

-(void)InsertNewLineAndMoveDown:(STMSWord2011SelectionObject*) selection;

-(void) InsertField:(id)tag;

-(STStatsManagerExecuteResult*)InsertTagsInDocument:(NSArray<STTag*>*)tags;

-(BOOL)EditTag:(STTag*)tag existingTag:(STTag*)existingTag;

-(void)UpdateFields:(STUpdatePair<STTag*>*)tagUpdatePair matchOnPosition:(BOOL)matchOnPosition;
-(void)UpdateFields:(STUpdatePair<STTag*>*)tagUpdatePair;
-(void)UpdateFields;


/**
 Conduct an assessment of the active document to see if there are any inserted tags that do not have an associated code file in the document.
 
 @param document The Word document to analyze.
 @param onlyShowDialogIfResultsFound If true, the results dialog will only display if there is something to report
 */
-(void)PerformDocumentCheck:(STMSWord2011Document*)document onlyShowDialogIfResultsFound:(BOOL)onlyShowDialogIfResultsFound;
/**
 Conduct an assessment of the active document to see if there are any inserted tags that do not have an associated code file in the document.
 
 @param document The Word document to analyze.
 */
-(void)PerformDocumentCheck:(STMSWord2011Document*)document;


-(STMSWord2011Document*)activeDocument;


+(void)toggleWordFieldsForTags:(NSArray<STTag*>*)tags;
+(void)toggleWordFieldsForTag:(STTag*)tag;


@end
