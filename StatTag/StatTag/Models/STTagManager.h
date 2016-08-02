//
//  STTagManager.h
//  StatTag
//
//  Created by Eric Whitley on 7/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STDuplicateTagResults.h"
@class STDocumentManager;
@class STTag;
@class STMSWord2011Field;
@class STFieldTag;

@interface STTagManager : NSObject {
  STDocumentManager* _DocumentManager;
}

@property (strong, nonatomic) STDocumentManager* DocumentManager;

-(instancetype)init:(STDocumentManager*)manager;

-(STTag*)FindTag:(id)arg;
-(STTag*)FindTagByTag:(STTag*)tag;
-(STTag*)FindTagByID:(NSString*)tagID;

-(NSArray<STTag*>*)GetTags;

-(BOOL)IsStatTagField:(STMSWord2011Field*) field;
-(BOOL)IsLinkedField:(STMSWord2011Field*) field;
-(STFieldTag*)DeserializeFieldTag:(STMSWord2011Field*) field;
-(STFieldTag*)GetFieldTag:(STMSWord2011Field*) field;
-(STDuplicateTagResults*)FindAllDuplicateTags;
-(NSDictionary<NSString*, NSArray<STTag*>*>*) FindAllUnlinkedTags;

-(void)ProcessStatTagFields:(NSString*)aFunction configuration:(id)configuration;
//-(void)ProcessStatTagFields:(void (^)(STMSWord2011Field*, STFieldTag*, id))aFunction configuration:(id)configuration;
-(void)UpdateTagFieldData:(STMSWord2011Field*)field tag:(STFieldTag*)tag;
-(void) UpdateUnlinkedTagsByCodeFile:(STMSWord2011Field*)field tag:(STFieldTag*)tag configuration:(id)configuration;
-(void) UpdateUnlinkedTagsByTag:(STMSWord2011Field*)field tag:(STFieldTag*)tag configuration:(id)configuration;

@end
