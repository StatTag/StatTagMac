//
//  StatTagWordDocument.m
//  StatTag
//
//  Created by Eric Whitley on 10/24/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "StatTagWordDocument.h"
#import "StatTagShared.h"
#import "StatTagFramework.h"
#import "StatTagWordDocumentFieldTag.h"
#import "StatTagWordDocumentPendingValidations.h"

@implementation StatTagWordDocument

@synthesize document = _document;
@synthesize validatingDocument = _validatingDocument;
@synthesize unlinkedTags = _unlinkedTags;
@synthesize processingDuplicateTags = _processingDuplicateTags;
@synthesize duplicateTags = _duplicateTags;
@synthesize tags = _tags;
@synthesize codeFiles = _codeFiles;
@synthesize codeFilePaths = _codeFilePaths;

@synthesize fieldCache  = _fieldCache;
@synthesize priorFieldCache = _priorFieldCache;
@synthesize priorFieldList =  _priorFieldList;
@synthesize threadLimit = _threadLimit;

-(instancetype)init {
  self = [super init];
  if(self)
  {
    [self configure];
  }
  return self;
}
-(instancetype)initWithDocument:(STMSWord2011Document*)document
{
  self = [super init];
  if(self)
  {
    [self configure];
    [self setDocument:document];
  }
  return self;
}
-(void)configure
{
  _validatingDocument = NO;
  _unlinkedTags = [[NSMutableDictionary<NSString*, NSMutableArray<STTag*>*> alloc] init];
  _processingDuplicateTags = NO;
  _duplicateTags = [[NSMutableArray<STTag*> alloc] init];
  _tags = [[NSMutableArray<STTag*> alloc] init];
  _codeFiles = [[NSMutableArray<STCodeFile*> alloc] init];
  _priorFieldList = [[NSMutableDictionary<NSString*, StatTagWordDocumentFieldTag*> alloc] init];
  _threadLimit = 2;
}

-(STMSWord2011Document*)document
{
  return _document;
}
-(void)setDocument:(STMSWord2011Document *)document
{
  _document = document;
  [self configure];//wipe out anything we might have had left over
  [self loadDocument];
}

-(void)loadDocument
{
  if(_document)
  {
    //can we parallelize some of this?
    [self setCodeFiles: [[[StatTagShared sharedInstance] docManager] GetCodeFileList]];
    [self setCodeFilePaths: [[self codeFiles] valueForKey:@"FilePath"]];

    [[[StatTagShared sharedInstance] docManager] LoadAllTagsFromCodeFiles];
    [self setTags:[NSMutableArray<STTag*> arrayWithArray:[[[StatTagShared sharedInstance] docManager] GetTags]]];
    
    //NSLog(@"loading document");
    //[self validateDocument]; we're not going to validate here - do it in the other list of docs
    //_priorFieldList = [self getStatTagWordFieldListGCD];
    //NSLog(@"validating unlinked tags");
  }
}

-(NSMutableDictionary<NSString*, StatTagWordDocumentFieldTag*>*)getStatTagWordFieldListGCD
{
  NSArray<STMSWord2011Field*>* fields = [[self document] fields];
  NSInteger fieldCount = [fields count];
  __block NSMutableDictionary<NSString*, StatTagWordDocumentFieldTag*>* statTagFields = [[NSMutableDictionary<NSString*, StatTagWordDocumentFieldTag*> alloc] init];

  //dispatch_semaphore_t fd_field = dispatch_semaphore_create(getdtablesize() / 2);
  
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
  dispatch_apply(fieldCount, queue, ^(size_t index) {
    //dispatch_semaphore_wait(fd_field, DISPATCH_TIME_FOREVER);
//  for(NSInteger index = 0; index < fieldCount; index++) {
    STMSWord2011Field* field = fields[index];
    //NSLog(@"field: %@", [[field fieldCode] content]);
    if(field != nil) {
      if([[[[[StatTagShared sharedInstance] docManager] TagManager] class] IsStatTagField:field]) {
        
        //do NOT restore the tag here - we JUST want the field data right now
//        [statTagFields setObject:[[StatTagWordDocumentFieldTag alloc] initWithWordField:field andFieldTag:nil andTag:nil] forKey:[NSNumber numberWithInteger:[field entry_index]]];
        [statTagFields setObject:[[StatTagWordDocumentFieldTag alloc] initWithWordField:field andFieldTag:nil andTag:nil] forKey:[NSString stringWithFormat:@"Field_%ld", [field entry_index]]];
        //[statTagFields setObject:field forKey:[NSNumber numberWithInteger:[field entry_index]]];
      }
    }
    //dispatch_semaphore_signal(fd_field);
//  }
  });

  //verbatim tags are "shapes"
  fieldCount = [[[self document] shapes] count];
  __block NSArray<STMSWord2011Shape*>* allShapes = [NSArray arrayWithArray:[[self document] shapes]];
  
  dispatch_apply(fieldCount, queue, ^(size_t index) {
    //  for(NSInteger index = 0; index < fieldCount; index++) {

    STMSWord2011Shape* shape = [allShapes objectAtIndex:index];

    //NSLog(@"field: %@", [[field fieldCode] content]);
    if(shape != nil) {
      STTag* tag = [[[[StatTagShared sharedInstance] docManager] TagManager] restoreUnlinkedTagFromShape:shape];
      if(tag != nil)
      {
        [statTagFields setObject:[[StatTagWordDocumentFieldTag alloc] initWithWordShape:shape andTag:tag] forKey:[NSString stringWithFormat:@"Shape_%@", [shape name]]];
      }
    }
    //  }
  });

  
  return statTagFields;
}



//-(NSMutableDictionary<STMSWord2011Field*, STTag*>*)getStatTagWordFieldDictionary
//{
//  NSArray<STMSWord2011Field*>* fields = [[self document] fields];
//  NSInteger fieldCount = [fields count];
//  __block NSMutableDictionary<STMSWord2011Field*, STTag*>* statTagFields = [[NSMutableDictionary<STMSWord2011Field*, STTag*> alloc] init];
//
//  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
//  dispatch_apply(fieldCount, queue, ^(size_t index) {
//    STMSWord2011Field* field = fields[index];
//    if(field != nil) {
//      if([[[[StatTagShared sharedInstance] docManager] TagManager] IsStatTagField:field]) {
//        [statTagFields setValue:nil forKey:[field copy]];
//      }
//    }
//  });
//  return statTagFields;
//}

-(void)validateDocument
{
  //NSLog(@"validateDocument - enter");
  [[StatTagShared sharedInstance] validateDocument:self];
}


/*
 This method does a few things
 1) if the field cache information is empty - it populates it
 2) it attempts to synchronize the field cache against the current Word field cache
   - if it matches - we're fine - no more processing
   - adds new
   - removes "missing" (this is fairly ugly because the position is a component of the field)
 
 FIXME: we need to change this so we can deal with queued operations
 ex: start validation - change doc - return and start new validation AFTER
 ex: start validation - close doc - cancell all operations for doc
 Since we do NOT want to block the UI we should consider doing more queues for long processes like this
 */
-(void)validateFieldCache
{
  //NOTE we cannot use NSSet effectively here. The Field object is not comparable
  // we'll need to compare by position and content (NOT the innert text - which is what we should really be using)
  // accessing inner text has a huge performance penalty
  //NOTE (2) - Reminder - we cannot currently deal with images as they are simply file path references
  
  
  //NSLog(@"validateFieldCache - enter");
  
  __block NSMutableDictionary<NSString*, StatTagWordDocumentFieldTag*>* currentFieldList = [self getStatTagWordFieldListGCD];
  __block NSMutableDictionary<NSString*, StatTagWordDocumentFieldTag*>* newFields = [[NSMutableDictionary<NSString*, StatTagWordDocumentFieldTag*> alloc] init];

  //NSLog(@"validateFieldCache - after GCD");
  
  //REMINDER - you CANNOT directly compare arrays

  //add in what we need
  __block NSArray *keys = [currentFieldList allKeys];
  NSInteger fieldsCount = [keys count];
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
  dispatch_apply(fieldsCount, queue, ^(size_t index) {
    NSString* n = [keys objectAtIndex:index];
    StatTagWordDocumentFieldTag* currentField = [currentFieldList objectForKey:n];
    StatTagWordDocumentFieldTag* priorField = [_priorFieldList objectForKey:n];

    //Word Field
    if([[currentField fieldType] isEqualToString:@"STMSWord2011Field"] && ([[priorField fieldType] isEqualToString:@"STMSWord2011Field"] || priorField == nil))
    {
      //if the fields aren't "the same" (index should already be consistent from the dictionary key)
      // then we want to restore the tag for the field
      if(![[[[currentField field] fieldCode] content] isEqualToString:[[[priorField field] fieldCode] content]])
      {
//        if(currentField != nil)
//        {
//          NSLog(@"restoring tag for field");
//          STFieldTag* tag = [[[[StatTagShared sharedInstance] docManager] TagManager] GetFieldTag:[currentField field]];
//          if(tag != nil)
//          {
//            [currentField setFieldTag:tag];
//          }
          [newFields setObject:currentField forKey:n];
//        }
      } else {
        [currentField setTag:[priorField tag]];
      }
    }
    //verbatim tags are "shapes"
    else if ([[currentField fieldType] isEqualToString:@"STMSWord2011Shape"] && ([[priorField fieldType] isEqualToString:@"STMSWord2011Shape"] || priorField == nil))
    {
      if(![[currentField tag] isEqual:[priorField tag]])
      {
        [newFields setObject:currentField forKey:n];
      } else {
        [currentField setTag:[priorField tag]];
      }
    }
    
  });
  
  if([newFields count] > 0)
  {
    //NSLog(@"validateFieldCache - new fields: %@", newFields);
  } else {
    //NSLog(@"validateFieldCache - no new fields");
  }

//    for(STMSWord2011Field* f in newFields)
//    {
//      //NSLog(@"validateFieldCache - new field: %@", [[f fieldCode] content]);
//    }
  
  [self setPriorFieldList:[currentFieldList copy]];
  //_priorFieldList = [currentFieldList copy];
  
}


-(BOOL)isUnlinkedTag:(STTag*)tag
{
  if(tag != nil) {
    if(![[self codeFilePaths] containsObject:[tag CodeFilePath]] || ![[self tags] containsObject:tag]) {
      return YES;
    }
  }
  return NO;
}
//check if unlinked tag
//check if figures are unlinked

-(void)validateUnlinkedTags
{
//  [self setValidatingDocument:YES];
//  [self unlinkedTagsDidBeginProcessing];

  //NSLog(@"TIMING: validateUnlinkedTags: validateFieldCache START");
  [self validateFieldCache];
  //NSLog(@"TIMING: validateUnlinkedTags: validateFieldCache END");
  //NSLog(@"TIMING: validateUnlinkedTags: [[self unlinkedTags] removeAllObjects] START");
  [[self unlinkedTags] removeAllObjects]; //clear the unlinked tag list
  //NSLog(@"TIMING: validateUnlinkedTags: [[self unlinkedTags] removeAllObjects] END");

  //NSLog(@"TIMING: validateUnlinkedTags: tag block START");

  //original unlinked tags call was:
  //_unlinkedTags = [[[StatTagShared sharedInstance] docManager] FindAllUnlinkedTags];
  //we do NOT want to do this. It's too expensive. We only want to rebuild the collection of items that have not yet been restored from fields
  // YES - that means we're going to have to manage our tag collection globally
  //we also need to be careful about directly interacting with the UI here - we do NOT want to do that
  //scenario: we start validating, user changes document, we finish validation - we potentially message the UI to display the wrong information
  __block NSArray *keys = [[self priorFieldList] allKeys];
  NSInteger fieldsCount = [keys count];
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
  dispatch_apply(fieldsCount, queue, ^(size_t index) {
    NSString* n = [keys objectAtIndex:index];
    StatTagWordDocumentFieldTag* currentField = [[self priorFieldList] objectForKey:n];
    if([[currentField fieldType] isEqualToString:@"STMSWord2011Field"] && [currentField tag] == nil)
    {
      //we need to restore the field tag - expensive
      [currentField setTag: [[[[StatTagShared sharedInstance] docManager] TagManager] GetFieldTag:[currentField field]]];
    }
    
    STTag* tag = [currentField tag];
    if(tag != nil) {
      //if(![[self codeFilePaths] containsObject:[tag CodeFilePath]] || ![[self tags] containsObject:tag]) {
      if([self isUnlinkedTag:tag])
      {
        if([[self unlinkedTags] objectForKey:[tag CodeFilePath]] == nil) {
          [[self unlinkedTags] setObject:[[NSMutableArray<STTag*> alloc] init] forKey:[tag CodeFilePath]];
        }
        [[[self unlinkedTags] objectForKey:[tag CodeFilePath]] addObject:tag];
      }
    }
  });
  
  //NSLog(@"TIMING: validateUnlinkedTags: tag block END");

  //@property NSDictionary<NSString*, NSArray<STTag*>*>* unlinkedTags;

  //(NSDictionary<NSString*, NSArray<STTag*>*>*)
  //  [self setUnlinkedTags:[StatTagShared sharedInstance]]
  
  //NSLog(@"unlinked tags");
  //NSLog(@"unlinked tags: %@", [self unlinkedTags]);

//  [self setValidatingDocument:NO];
//  [self unlinkedTagsDidFinishProcessing];
}

-(void)unlinkedTagsDidBeginProcessing
{
  //if delegate, etc.
}
-(void)unlinkedTagsDidFinishProcessing
{
  //if delegate, etc.
}

@end
