//
//  StatTagWordDocument.h
//  StatTag
//
//  Created by Eric Whitley on 10/24/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STMSWord2011Application;
@class STMSWord2011Document;
@class STMSWord2011Field;
@class STTag;
@class STCodeFile;
@class StatTagWordDocumentFieldTag;


//FIXME: add a delegate protocol for the unlinked tags did change notification

@interface StatTagWordDocument : NSObject
{
//  NSMutableArray<STCodeFile*>* _codeFiles;
//  NSMutableArray<STTag*>* _tags;
//  NSMutableArray<STTag*>* _duplicateTags;
//  NSMutableArray<STTag*>* _unlinkedTags;
}

@property STMSWord2011Document* document;

@property BOOL validatingDocument;
@property NSMutableDictionary<NSString*, NSMutableArray<STTag*>*>* unlinkedTags;

@property BOOL processingDuplicateTags;
@property NSMutableArray<STTag*>* duplicateTags;

@property NSMutableArray<STTag*>* tags;

@property NSMutableArray<STCodeFile*>* codeFiles;
@property NSMutableArray<NSString*>* codeFilePaths;

//@property NSMutableDictionary<STMSWord2011Field*, STTag*>* fieldCache;
//@property NSMutableDictionary<STMSWord2011Field*, STTag*>* priorFieldCache;
@property NSMutableDictionary<NSString*, StatTagWordDocumentFieldTag*>* priorFieldList;
-(NSInteger)numUniqueFields;

@property NSInteger threadLimit;

//-(NSArray<STTag*>*)duplicateTags;
//-(NSArray<STTag*>*)unlinkedTags;

-(instancetype)init;
-(instancetype)initWithDocument:(STMSWord2011Document*)doc;


-(void)validateDocument;
-(void)validateUnlinkedTags;
-(void)loadDocument;
-(void)cachesDidChangeForTags:(NSArray<STTag*>*)tags orCodeFilePath:(NSString*)codeFilePath;

-(NSString*)description;

@end
