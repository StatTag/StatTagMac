//
//  STTagManager.m
//  StatTag
//
//  Created by Eric Whitley on 7/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STTagManager.h"
#import "STDocumentManager.h"
#import "STTag.h"
#import "STTagUtil.h"
#import "STCodeFile.h"
#import "STMSWord2011.h"
#import "STConstants.h"
#import "STFieldTag.h"
#import "STDuplicateTagResults.h"
#import "STOverlappingTagResults.h"
#import "STGlobals.h"
#import "STThisAddIn.h"
#import "STCodeFileAction.h"
#import "WordHelpers.h"
#import "STFactories.h"
#import "STTagCollisionResult.h"
#import "STICodeFileParser.h"

#import <objc/message.h>

/**
 
The TagManager is responsible for finding, editing, and otherwise managing specific tags.
This has some overlap (conceptually) with the DocumentManager class.  Functionality split out here is
meant to relieve the DocumentManager of needing to accomplish everything.

At times, this class needs to reference the DocumentManager to perform an action.  For example - an
action for an unlinked tag is to re-link the code file, which is handled by the DocumentManager.
A reference is included back to the DocumentManager class to allow this.

The relationship is that an TagManager only exists in the context of a DocumentManager.  An instance
of this class should not exist outside of the DocumentManager.  These methods should only be accessed by
the DocumentManager instance that contains it.
*/

@implementation STTagManager

@synthesize DocumentManager = _DocumentManager;

-(instancetype)init:(STDocumentManager*)manager {
  self = [super init];
  if(self) {
    self.DocumentManager = manager;
  }
  return self;
}

/**
 
 */
-(STTag*)FindTag:(id)arg {
  if([arg isKindOfClass:[NSString class]]) {
    return [self FindTagByID:arg];
  } else if ([arg isKindOfClass:[STTag class]]) {
    return [self FindTagByTag:arg];
  }
  return nil;
}

/**
  Find the master reference of an tag, which is contained in the code files
  associated with the current document
  @param tag: The tag to find
*/
-(STTag*)FindTagByTag:(STTag*)tag {
  return [self FindTagByID:[tag Id]];
}

/**
  Find the master reference of an tag, which is contained in the code files
  associated with the current document
  @param tagID: The tag identifier to search for
 
  @remark: In the original c#, the method name is "FindTag" (NOT FindTagByID). The dynamic nature of Obj-C makes using identical method names impossible.
*/
-(STTag*)FindTagByID:(NSString*)tagID {
  
  //NSLog(@"Executing FindTagByID:%@", tagID);
  
  NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];

  if(files == nil) {
    //NSLog(@"Unable to find a tag because the files collection is null");
    return nil;
  } else {
    //NSLog(@"FindTagByID - found (%lu) files", (unsigned long)[files count]);
  }
  
  //return files.SelectMany(file => file.Tags).FirstOrDefault(tag => tag.Id.Equals(id));
  //just easier to loop instead of using array predicate here - and since the size is small, performance shouldn't be a huge issue. We really need functional map/reduce/filter...
  //could probably do an array filter by testing if the key/value pair match the criteria
  for(STCodeFile* file in files) {
    for(STTag* tag in [file Tags]) {
      if([tagID isEqualToString:[tag Id]]) {
        return tag;
      }
    }
  }
  
  return nil;
}

/**
 For all of the code files associated with the current document, get all of the
 tags as a single list.
 */
-(NSArray<STTag*>*)GetTags {
  NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];
  NSMutableArray<STTag*>* tags = [[NSMutableArray<STTag*> alloc] init];
  for(STCodeFile* file in files) {
    [tags addObjectsFromArray:[file Tags]];
  }
  return tags;
}



/**
 Given a Word field, determine if it is our specialized StatTag field type given
 its composition.
*/
+(BOOL)IsStatTagField:(STMSWord2011Field*) field {
  return(field != nil
         //fieldType is a STMSWord2011E183 enum, so we are looking for value "STMSWord2011E183FieldMacroButton" (which is "51" in the Windows version)
         //NOTE: the scripting bridge doesn't successfully import this macro field value name, so you need to supply it yourself - see the readme in the StatTag base project directory
         && [field fieldType] == STMSWord2011E183FieldMacroButton
         && [[[field fieldCode] fields] count] > 0
         && [field fieldCode] != nil && [[[[field fieldCode] formattedText] content] containsString:[STConstantsFieldDetails MacroButtonName]]
         );
}


/**
 Determine if a field is a linked field.  While linked fields can take on various forms, we
 use them in StatTag to represent images.
*/
-(BOOL)IsLinkedField:(STMSWord2011Field*) field {
  return (field != nil
          && [field fieldType] == STMSWord2011E183FieldLink
  );
}


/**
  Deserialize a field to extract the FieldTag data
*/
-(STFieldTag*)DeserializeFieldTag:(STMSWord2011Field*) field {
  @autoreleasepool {

    [STGlobals activateDocument];
    
    NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];

    //NSLog(@"DeserializeFieldTag -> files : %@", files);
    //FIXME: we should fix his to be a hard crash - debugging...

    STMSWord2011TextRange* code = [field fieldCode];
    //NSLog(@"DeserializeFieldTag -> code : (%ld,%ld)", [code startOfContent], [code endOfContent]);
    STMSWord2011Field* nestedField = [[code fields] firstObject];//[code fields][1];
    if (nestedField == nil || [nestedField fieldText] == nil) {
      return nil;
    }
    
    //[STGlobals activateDocument];
    NSString* nestedFieldText = [NSString stringWithString:[nestedField fieldText]];//[[nestedField fieldText] copy];
    //[STGlobals activateDocument];
    
    //NSLog(@"DeserializeFieldTag -> nestedField : %@", nestedField);
    //NSLog(@"DeserializeFieldTag -> nestedField field type: %d", [nestedField fieldType]);
    //NSLog(@"DeserializeFieldTag -> nestedField field entry_index: %ld", [nestedField entry_index]);
    
    //NSLog(@"DeserializeFieldTag -> nestedField fieldText : %@", nestedFieldText);
    //FIXME: very, very unsure of this.. original c# used "Data" and we're using fieldText - which seems to be the closest approximation...
    //  var fieldTag = FieldTag.Deserialize(nestedField.Data.ToString(CultureInfo.InvariantCulture),
    //                                      files);
    //FIXME: check this - something unhappy
//    STFieldTag* fieldTag = [STFieldTag Deserialize:nestedFieldText withFiles:files error:nil];
    STFieldTag* fieldTag = [STFieldTag Deserialize:nestedFieldText error:nil];
    return fieldTag;
  }
}


/**
 Given a Word document Field, extracts the embedded StatTag tag
 associated with it.
 @param field: The Word field object to investigate
*/
-(STFieldTag*)GetFieldTag:(STMSWord2011Field*) field {
  @autoreleasepool {

    //FIXME: added some checks we should remove here - hard crash is preferred for now
    
    [STGlobals activateDocument];
    
    STFieldTag* fieldTag = [self DeserializeFieldTag:field];
    if (fieldTag == nil) {
      return nil;
    }
    //NSLog(@"GetFieldTag -> fieldTag : %@", [fieldTag description]);
    STTag* tag = [self FindTagByTag:fieldTag];
    //NSLog(@"GetFieldTag -> tag : %@", [tag description]);
    
    //NSLog(@"");
    //NSLog(@"GetFieldTag");
    //NSLog(@"================");
    //NSLog(@"fieldTag is nil : %d", fieldTag == nil);
    //NSLog(@"FormattedResult : %@", [fieldTag FormattedResult]);
    //NSLog(@"Type : %@", [fieldTag Type]);
    //NSLog(@"CachedResult : %@", [fieldTag CachedResult]);
    
    //NSLog(@"tag is nil : %d", tag == nil);
    //NSLog(@"FormattedResult : %@", [tag FormattedResult]);
    //NSLog(@"Type : %@", [tag Type]);
    //NSLog(@"CachedResult : %@", [tag CachedResult]);
    //NSLog(@"--------------");
    
    // The result of FindTag is going to be a document-level tag, not a
    // cell specific one that exists as a field.  We need to re-set the cell index
    // from the tag we found, to ensure it's available for later use.
    return [[STFieldTag alloc] initWithTag:tag andFieldTag:fieldTag];
  }
}

-(STDuplicateTagResults*)FindAllDuplicateTags {
  NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];
  STDuplicateTagResults* duplicateTags = [[STDuplicateTagResults alloc] init];
  for(STCodeFile* file in files) {
    STDuplicateTagResults* result = [[STDuplicateTagResults alloc] initWithDictionary:[file FindDuplicateTags]];
    if(result != nil && [result count] > 0) {
      [duplicateTags addEntriesFromDictionary:result];
      //FIXME: go back and review this.  The original did something like...
      //  duplicateTags.Add(file, result);
      // so that may behave slightly differently
      // from the docs it looks like it should be the "same" ?
      // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSMutableDictionary_Class/index.html#//apple_ref/occ/instm/NSMutableDictionary/addEntriesFromDictionary:
    }
  }
  return duplicateTags;
}

-(STOverlappingTagResults*)FindAllOverlappingTags
{
  NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];
  STOverlappingTagResults* results = [[STOverlappingTagResults alloc] init];
  for (STCodeFile* file in files) {
    NSObject<STICodeFileParser>* parser = [STFactories GetParser:file];
    if (parser == nil) {
      continue;
    }

    NSArray<STTag*>* tags = [parser ParseIncludingInvalidTags:file];

    // If there are 0 or 1 tags, there's no way any of them can overlap.  Just continue
    if (tags == nil || [tags count] < 2) {
      continue;
    }

    for (int index = 0; index < ([tags count] - 1); index++) {
      STTag* tag1 = [tags objectAtIndex:index];
      STTag* tag2 = [tags objectAtIndex:(index + 1)];
      STTagCollisionResult* result = [STTagUtil DetectTagCollision:tag1 tag2:tag2];
      if (result != nil && [result Collision] != NoOverlap && [result CollidingTag] != nil) {
        NSMutableArray<NSMutableArray<STTag*>*>* collection = [results objectForKey:file];
        if (collection == nil) {
          collection = [[NSMutableArray<NSMutableArray<STTag*>*> alloc] init];
          [results setObject:collection forKey:file];
        }

        // Our code file entry is established, now we need to figure out if these colliding tags are
        // in a collision group already.  If so, we'll add the tags that are missing from the group.
        // If not, we will create a new group.
        NSMutableArray<STTag*>* foundTagGroup1 = nil;
        NSMutableArray<STTag*>* foundTagGroup2 = nil;
        for (int outerIndex = 0; outerIndex < [collection count]; outerIndex++) {
          NSMutableArray<STTag*>* array = [collection objectAtIndex:outerIndex];
          for (int innerIndex = 0; innerIndex < [array count]; innerIndex++) {
            if ([[array objectAtIndex:innerIndex] EqualsWithPosition:tag1]) {
              foundTagGroup1 = array;
            }
            if ([[array objectAtIndex:innerIndex] EqualsWithPosition:tag2]) {
              foundTagGroup2 = array;
            }

            if (foundTagGroup1 != nil && foundTagGroup2 != nil) {
              break;
            }
          }

          if (foundTagGroup1 != nil && foundTagGroup2 != nil) {
            break;
          }
        }

        if (foundTagGroup1 == nil && foundTagGroup2 == nil) {
          // Creating a new tag collision group
          NSMutableArray<STTag*>* group = [[NSMutableArray<STTag*> alloc] init];
          [group addObject:tag1];
          [group addObject:tag2];
          [collection addObject:group];
        }
        else if (foundTagGroup1 == nil) {
          // Adding to tag2 collision group
          [foundTagGroup2 addObject:tag1];
        }
        else if (foundTagGroup2 == nil) {
          // Adding to tag1 collision group
          [foundTagGroup1 addObject:tag2];
        }
      }
    }
  }
  return results;
}

/**
 Search the active Word document and find all inserted tags.  Determine if the tag's
 code file is linked to this document, and report those that are not.

 We have two scenarios we're looking for
 1) (Code file missing) Tag exists in document, but referenced code file does not
 2) (Tag no longer in code file) Tag exists in document, referenced code file exists, but tag no longer in code file
 */
-(NSDictionary<NSString*, NSArray<STTag*>*>*) FindAllUnlinkedTagsOriginal {
  //NSLog(@"FindAllUnlinkedTags - Started");
  NSMutableDictionary<NSString*, NSMutableArray<STTag*>*>* results = [[NSMutableDictionary<NSString*, NSMutableArray<STTag*>*> alloc] init];
  @autoreleasepool {

    STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
    STMSWord2011Document* document = [application activeDocument];

    
    // Fields is a 1-based index
    // -- EWW -> above is from the original c# - will be interesting to see if this is the case for the Mac version
    //FIXME: check later to see if Fields is 1-based index
    NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];
    //NSLog(@"Preparing to process %ld fields", fieldsCount);
    
    NSArray<STTag*>* allTags = [self GetTags];

    //==========================================================
    // FIELDS
    //==========================================================
    NSMutableArray<STMSWord2011Field*>* fields = [WordHelpers getAllFieldsInDocument:document];
    NSInteger fieldsCount = [fields count];
    
    //counting backwards
    for (NSInteger index = fieldsCount - 1; index >= 0; index--) {
      
        STMSWord2011Field* field = fields[index];
        if(field == nil) {
          //NSLog(@"Null field detected at index %ld", index);
          continue;
        }

        if(![[self class] IsStatTagField:field]) {
          continue;
        }
      
        //NSLog(@"Processing StatTag field");
        STFieldTag* tag = [self GetFieldTag:field];
        if(tag == nil) {
          //NSLog(@"The field tag is null or could not be found");
          continue;
        }

        BOOL hasFilePath = false;
        for(STCodeFile* cf in files) {
          if([[cf FilePath] isEqualToString:[tag CodeFilePath]]) {
            hasFilePath = true;
          }
        }
        if(!hasFilePath || ![allTags containsObject:tag]) {
          //!hasFilePath => this tag refers to an invalid code file path
          //![allTags containsObject:tag] => we have a file path that's valid, but now let's check to see if the tag we're looking at is actually found in the code file(s)
          if([results objectForKey:[tag CodeFilePath]] == nil) {
            [results setObject:[[NSMutableArray<STTag*> alloc] init] forKey:[tag CodeFilePath]];
          }
          [[results objectForKey:[tag CodeFilePath]] addObject:tag];
        }
    }
    
    
    //==========================================================
    // SHAPES
    //==========================================================
    // we have to approach this one a bit differently
    
    
    //if the shape type is "image"...
    // we have a figure tag

    NSMutableArray* allShapes = [[NSMutableArray alloc] init];

    
    //[allShapes addObjectsFromArray:[document inlineShapes]]; //no reason to use these - they're not real tags
    [allShapes addObjectsFromArray:[document shapes]];
    
    NSInteger shapesCount = [allShapes count];
    
    
    for (NSInteger index = shapesCount - 1; index >= 0; index--) {
      //STMSWord2011Shape* shape = allShapes[index];
      STMSWord2011Shape* shape = allShapes[index];

      if(shape == nil) {
        //NSLog(@"Null field detected at index %ld", index);
        continue;
      }
      
      //go through all the tags
      // if we find one which matches then we can ignore
      // if we don't, then we have an issue
      
      //STTag* tag = [self FindTagByID:[shape name]];
      STTag* tag = [self restoreUnlinkedTagFromShape:shape];
      if(tag != nil)
      {
        BOOL hasFilePath = false;
        for(STCodeFile* cf in files) {
          if([[cf FilePath] isEqualToString:[[tag CodeFile] FilePath]]) {
            hasFilePath = true;
          }
        }
        if(!hasFilePath || ![allTags containsObject:tag]) {
          //!hasFilePath => this tag refers to an invalid code file path
          //![allTags containsObject:tag] => we have a file path that's valid, but now let's check to see if the tag we're looking at is actually found in the code file(s)
          if([results objectForKey:[[tag CodeFile] FilePath]] == nil) {
            [results setObject:[[NSMutableArray<STTag*> alloc] init] forKey:[[tag CodeFile] FilePath]];
          }
          [[results objectForKey:[[tag CodeFile] FilePath]] addObject:tag];
        }
      }
        
      
    }
    
    //NSLog(@"FindAllUnlinkedTags - Finished");
    return results;
  }
}

//moving this out so we can reuse in the main app UI
-(NSMutableDictionary<NSString*, STMSWord2011Field*>*)GetUniqueFields
{
  STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* document = [application activeDocument];

  NSMutableArray<STMSWord2011Field*>* fields = [WordHelpers getAllFieldsInDocument:document];
  NSInteger fieldsCount = [fields count];

  __block NSMutableDictionary<NSString*, STMSWord2011Field*>* unique_fields_dict = [[NSMutableDictionary<NSString*, STMSWord2011Field*> alloc] init];

  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
  dispatch_apply(fieldsCount, queue, ^(size_t index) {
    
    STMSWord2011Field* field = fields[index];
    if(field != nil) {
      if([[self class] IsStatTagField:field]) {
        STMSWord2011TextRange* code = [field fieldCode];
        //NSLog(@"parent fieldCode = [%@]", [code content]);
        //NSLog(@"parent fieldText = [%@]", [field fieldText]);
        STMSWord2011Field* nestedField = [code fields][0];
        //NSLog(@"nestedField = [%@]", nestedField);
        //NSLog(@"nestedField description = [%@]", [nestedField description]);
        //NSLog(@"nestedField fieldCode = [%@]", [[nestedField fieldCode] content]);
        //NSLog(@"nestedField fieldText = [%@]", [nestedField fieldText]);
        [unique_fields_dict setObject:field forKey:[nestedField fieldText]];
      }
    }
  });
  
  return unique_fields_dict;
}

-(NSDictionary<NSString*, NSArray<STTag*>*>*) FindAllUnlinkedTags {

  __block NSMutableDictionary<NSString*, NSMutableArray<STTag*>*>* results = [[NSMutableDictionary<NSString*, NSMutableArray<STTag*>*> alloc] init];
  __block NSMutableDictionary<NSString*, STMSWord2011Field*>* unique_fields_dict = [[NSMutableDictionary<NSString*, STMSWord2011Field*> alloc] init];

  @autoreleasepool {
    
    STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
    STMSWord2011Document* document = [application activeDocument];
    
    
    // Fields is a 1-based index
    // -- EWW -> above is from the original c# - will be interesting to see if this is the case for the Mac version
    //FIXME: check later to see if Fields is 1-based index
    NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];
    //NSLog(@"Preparing to process %ld fields", fieldsCount);
    
    NSArray<STTag*>* allTags = [self GetTags];
//    NSArray<STTag*>* allTagNames = [allTags valueForKey:@"Name"];
//    NSArray<STTag*>* allTagPaths = [allTags valueForKey:@"FilePath"];

    //==========================================================
    // FIELDS
    //==========================================================
    NSMutableArray<STMSWord2011Field*>* fields = [WordHelpers getAllFieldsInDocument:document];
    NSInteger fieldsCount = [fields count];
    
    //FIXME: performance fixes
    // change this a bit...
    // if the tag NAME is NOT found at all - we know it's unlinked
    // then, for the remainder of the ones with names... try by path
    // ANYTHING to help us skip accessing the fieldText -> hit - 300ms (minimum)
    // this is going to be risky - we're likely to have to use the "name" element (field code) to de-duplicate initially instead of the id (which contains path)
    /*
     There are two scenarios where we'll have unlinked tags
     1) tag name exists in Word field, but not in tag list
     2) tag path in Word field does not exist in code file list
     
     Yes - you're right - in an ideal world, we'd just reconstitute all tags from fields and be done with it.
     BUT - accessing the fieldText property seems to have a fixed cost of around 300ms. That's a huge performance hit.
     
     We're going to see if we can slim down that cost by first asking if the tag name exists at all. If not, definitely unlinked - go to next tag.
     
     The problem is going to be that a tag name is NOT unique enough. People could be using duplicate tag names across code files.
     
     HIGH RISK ->
     We're also going to have to cheat a bit here - and not in a good way.

     We're going to use the field tag name as the unique key instead of the path on the first go so we can condense the set. The impact here will be that our performance should (ideally) be marginally better - at the cost of accuracy. We will not know for sure if the tag is really missing or not because we're not validating each unique file path.
     
     SAMPLES:
     
     [ MacroButton StatTag 15.4 ADDIN Average Speed ]
     [ MacroButton StatTag 15.40 ADDIN r test with Leah ]
     [ MacroButton StatTag 50 ADDIN Num Obs ]
     [ MacroButton StatTag 334 ADDIN test_of_new_tag ]

     according to BBEdit, there are control characters in the following positions...
     using "?" to show presence of character
     
     [ MacroButton StatTag 334? ADDIN test_of_new_tag ?]

     1) Get all tags from code files
     2) Get a list of duplicate tags? Can we do that quickly?
     3) Get list of "distinct" fields by add-in label. This will NOT be truly distinct. If there are duplicate tags then we WILL have issues.
       OPTIONS:
        - Could we cross-check this against the duplicate tag list and expand it if necessary?
     4) If the field title - aka tag name - does not exist in our tag list, add it to the list of unlinked tags - skip checking the file path
     
     */
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    /*
    dispatch_apply(fieldsCount, queue, ^(size_t index) {
      
      STMSWord2011Field* field = fields[index];
      if(field != nil) {
        if([[self class] IsStatTagField:field]) {
          STMSWord2011TextRange* code = [field fieldCode];
          //NSLog(@"parent fieldCode = [%@]", [code content]);
          //NSLog(@"parent fieldText = [%@]", [field fieldText]);
          STMSWord2011Field* nestedField = [code fields][0];
          //NSLog(@"nestedField = [%@]", nestedField);
          //NSLog(@"nestedField description = [%@]", [nestedField description]);
          //NSLog(@"nestedField fieldCode = [%@]", [[nestedField fieldCode] content]);
          //NSLog(@"nestedField fieldText = [%@]", [nestedField fieldText]);
          [unique_fields_dict setObject:field forKey:[nestedField fieldText]];
        }
      }
    });
     */
    unique_fields_dict = [self GetUniqueFields];
     
    //NSLog(@"unique_fields_dict : %@", unique_fields_dict);
    
    __block NSArray<NSString*>* codeFilePaths = [files valueForKey:@"FilePath"];
    __block NSArray<STMSWord2011Field*>* unique_fields = [unique_fields_dict allValues];
    fieldsCount = [unique_fields count];
    
    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_apply(fieldsCount, queue, ^(size_t index) {
      STMSWord2011Field* field = [unique_fields objectAtIndex:index];
      STFieldTag* tag = [self GetFieldTag:field];
      if(tag != nil) {
        if(![codeFilePaths containsObject:[tag CodeFilePath]] || ![allTags containsObject:tag]) {
          if([results objectForKey:[tag CodeFilePath]] == nil) {
            [results setObject:[[NSMutableArray<STTag*> alloc] init] forKey:[tag CodeFilePath]];
          }
          [[results objectForKey:[tag CodeFilePath]] addObject:tag];
        }
      }
    });

    //NSLog(@"results : %@", results);

    
    //==========================================================
    // SHAPES
    //==========================================================
    // we have to approach this one a bit differently
    
    
    //if the shape type is "image"...
    // we have a figure tag
    
    NSMutableArray* allShapes = [[NSMutableArray alloc] init];
    
    
    //[allShapes addObjectsFromArray:[document inlineShapes]]; //no reason to use these - they're not real tags
    [allShapes addObjectsFromArray:[document shapes]];
    
    NSInteger shapesCount = [allShapes count];
    
    
    for (NSInteger index = shapesCount - 1; index >= 0; index--) {
      STMSWord2011Shape* shape = allShapes[index];
      
      if(shape == nil) {
        continue;
      }
      
      //go through all the tags
      // if we find one which matches then we can ignore
      // if we don't, then we have an issue
      
      STTag* tag = [self restoreUnlinkedTagFromShape:shape];
      if(tag != nil)
      {
        BOOL hasFilePath = false;
        for(STCodeFile* cf in files) {
          if([[cf FilePath] isEqualToString:[[tag CodeFile] FilePath]]) {
            hasFilePath = true;
          }
        }
        if(!hasFilePath || ![allTags containsObject:tag]) {
          //!hasFilePath => this tag refers to an invalid code file path
          //![allTags containsObject:tag] => we have a file path that's valid, but now let's check to see if the tag we're looking at is actually found in the code file(s)
          if([results objectForKey:[[tag CodeFile] FilePath]] == nil) {
            [results setObject:[[NSMutableArray<STTag*> alloc] init] forKey:[[tag CodeFile] FilePath]];
          }
          //only add the tag if we don't already have it in the tag array for this code file
          if(![[results objectForKey:[[tag CodeFile] FilePath]] containsObject:tag])
          {
            [[results objectForKey:[[tag CodeFile] FilePath]] addObject:tag];
          }
        }
      }
    }
    
    return results;
  }
}








/**
 A generic method that will iterate over the fields in the active document, and apply a function to
 each StatTag field.

 @param function: The function to apply to each relevant field. Original argument from C# was "Action<Field, FieldTag, object>". We're going to use a typedef to represent it for simplicity.
 @param configuration: A set of configuration information specific to the function
 
 It looks like the "configuration" object could be any number of things depending on the function argument that's sent in. EX: could be a tag. Could be a dictionary of code files and tags. Totally depends on the function.
 */
-(void)ProcessStatTagFields:(CodeFileActionType)aFunction configuration:(id)configuration {
//-(void)ProcessStatTagFields:(SEL)aFunction configuration:(id)configuration {
  //NSLog(@"ProcessStatTagFields - Started");
 
  @autoreleasepool {

    STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
    STMSWord2011Document* document = [application activeDocument];

    NSMutableArray<STMSWord2011Field*>* fields = [WordHelpers getAllFieldsInDocument:document];
    NSInteger fieldsCount = [fields count];

    // Fields is a 1-based index
    //NSLog(@"Preparing to process %ld fields", fieldsCount);
    for (NSInteger index = fieldsCount - 1; index >= 0; index--) {
      
      STMSWord2011Field* field = fields[index];
      if(field == nil) {
        //NSLog(@"Null field detected at index %ld", index);
        continue;
      }
      if(![[self class] IsStatTagField:field]) {
        //Marshal.ReleaseComObject(field);
        continue;
      }
      //NSLog(@"Processing StatTag field");
      STFieldTag* tag = [self GetFieldTag:field];
      if(tag == nil) {
        //NSLog(@"The field tag is null or could not be found");
        continue;
      }

      aFunction(field, tag, configuration);
    }
  }
}


/**
  Update the tag data in a field.

  @remark Assumes that the field parameter is known to be an tag field
 
  @param field: The field to update.  This is the outermost layer of the tag field.
  @param tag: The tag to be updated.
*/
-(void)UpdateTagFieldData:(STMSWord2011Field*)field tag:(STFieldTag*)tag {
  @autoreleasepool {
    STMSWord2011TextRange* code = [field fieldCode];
    STMSWord2011Field* nestedField = [code fields][0];
    nestedField.fieldText = [tag Serialize:nil];
  }
}


/**
  Given a field and its tag, update it to link to a new code file

  @param field: The document Field that contains the tag
  @param tag: The tag that will be updated
  @param configuration: A collection of the actions to apply (of type Dictionary<string, CodeFileAction>)
 */
//-(void) UpdateUnlinkedTagsByCodeFile:(STMSWord2011Field*)field tag:(STFieldTag*)tag configuration:(id)configuration {
//EWW changed field types to handle shapes for verbatim
-(void) UpdateUnlinkedTagsByCodeFile:(id)field tag:(STTag*)tag configuration:(id)configuration {

  //we can handle one of two items:
  //MicrosoftWordField
  //MicrosoftWordShape
  NSString* fieldClass = NSStringFromClass([field class]);
  if(![fieldClass isEqualToString:@"MicrosoftWordField"] && ![fieldClass isEqualToString:@"MicrosoftWordShape"])
  {
    return;
  }
  
  NSDictionary<NSString*, STCodeFileAction*>* actions = (NSDictionary<NSString*, STCodeFileAction*>*)configuration;
  if(actions == nil && [actions isKindOfClass:[NSDictionary class]]) {
    //NSLog(@"The list of actions to perform is null or of the wrong type");
    return;
  }
  
  // If there is no action specified for this field, we will exit.  This should happen when we have fields that
  // are still linked in a document.
  if([actions objectForKey:[tag CodeFilePath]] == nil) {
    //NSLog(@"No action is needed for tag in file %@", [tag CodeFilePath]);
    return;
  }
  
  // Make sure that the action is actually defined.  If no action was specified by the user, we can't continue
  // with doing anything.
  STCodeFileAction* action = [actions objectForKey:[tag CodeFilePath]];
  if(action == nil) {
    //NSLog(@"No action was specified - exiting");
    return;
  }

  // Apply the appropriate action to this field, based on what the user specified.
  STCodeFile* codeFile = (STCodeFile*)[action Parameter];
  if(codeFile != nil && [codeFile isKindOfClass:[STCodeFile class]]) {
    if([action Action] == [STConstantsCodeFileActionTask ChangeFile]) {
      //NSLog(@"Changing tag %@ from %@ to %@", [tag Name], [tag CodeFilePath], [codeFile FilePath]);
      tag.CodeFile = codeFile;
      [_DocumentManager AddCodeFile:[tag CodeFilePath]];
      if([fieldClass isEqualToString:@"MicrosoftWordField"])
      {
        [self UpdateTagFieldData:field tag:(STFieldTag*)tag];
      } else if([fieldClass isEqualToString:@"MicrosoftWordShape"])
      {
        [self UpdateTagShapeData:field tag:tag];
      }
    } else if ([action Action] == [STConstantsCodeFileActionTask RemoveTags]) {
      //NSLog(@"Removing %@", [tag Name]);
      if([fieldClass isEqualToString:@"MicrosoftWordField"])
      {
        [self replaceAndHighlightField:field replaceWithString:[STConstantsPlaceholders RemovedField] andHighlight:STMSWord2011E110Yellow];
      } else if([fieldClass isEqualToString:@"MicrosoftWordShape"])
      {
        [self replaceAndHighlightShape:field replaceWithString:[STConstantsPlaceholders RemovedField] andHighlight:STMSWord2011E110Yellow];
      }
    } else if ([action Action] == [STConstantsCodeFileActionTask ReAddFile]) {
      //NSLog(@"Linking code file %@", [tag CodeFilePath]);
      [_DocumentManager AddCodeFile:[tag CodeFilePath]];
    } else {
      //NSLog(@"The action task of %ld is not known and will be skipped", (long)[action Action]);
    }
  }
  
}

/**
 Given a field and its tag, update it to link to a new code file
 @param field: The document Field that contains the tag
 @param tag: The tag that will be updated
 @param configuration: A collection of the actions to apply (of type Dictionary<string, CodeFileAction>)
 */
//-(void) UpdateUnlinkedTagsByTag:(STMSWord2011Field*)field tag:(STFieldTag*)tag configuration:(id)configuration {
-(void) UpdateUnlinkedTagsByTag:(id)field tag:(STTag*)tag configuration:(id)configuration {
  @autoreleasepool {
    
    //we can handle one of two items:
    //MicrosoftWordField
    //MicrosoftWordShape
    NSString* fieldClass = NSStringFromClass([field class]);
    if(![fieldClass isEqualToString:@"MicrosoftWordField"] && ![fieldClass isEqualToString:@"MicrosoftWordShape"])
    {
      return;
    }

    
    NSDictionary<NSString*, STCodeFileAction*>* actions = (NSDictionary<NSString*, STCodeFileAction*>*)configuration;
    if(actions == nil && [actions isKindOfClass:[NSDictionary class]]) {
      //NSLog(@"The list of actions to perform is null or of the wrong type");
      return;
    }
    
    // If there is no action specified for this field, we will exit.  This should happen when we have fields that
    // are still linked in a document.
    if([actions objectForKey:[tag Id]] == nil) {
      //NSLog(@"No action is needed for tag in file %@", [tag Id]);
      return;
    }

    // Make sure that the action is actually defined.  If no action was specified by the user, we can't continue
    // with doing anything.
    STCodeFileAction* action = [actions objectForKey:[tag Id]];
    if(action == nil) {
      //NSLog(@"No action was specified - exiting");
      return;
    }

    // Apply the appropriate action to this field, based on what the user specified.
    STCodeFile* codeFile = (STCodeFile*)[action Parameter];
    if(codeFile != nil && [codeFile isKindOfClass:[STCodeFile class]]) {
      if([action Action] == [STConstantsCodeFileActionTask ChangeFile]) {
        //NSLog(@"Changing tag %@ from %@ to %@", [tag Name], [tag CodeFilePath], [codeFile FilePath]);
        tag.CodeFile = codeFile;
        [_DocumentManager AddCodeFile:[tag CodeFilePath]];
        
        if([fieldClass isEqualToString:@"MicrosoftWordField"])
        {
          [self UpdateTagFieldData:field tag:(STFieldTag*)tag];
        } else if([fieldClass isEqualToString:@"MicrosoftWordShape"])
        {
          [self UpdateTagShapeData:field tag:tag];
        }
      } else if ([action Action] == [STConstantsCodeFileActionTask RemoveTags]) {
        //NSLog(@"Removing %@", [tag Name]);
        //[field select];
        if([fieldClass isEqualToString:@"MicrosoftWordField"])
        {
          [self replaceAndHighlightField:field replaceWithString:[STConstantsPlaceholders RemovedField] andHighlight:STMSWord2011E110Yellow];
        } else if([fieldClass isEqualToString:@"MicrosoftWordShape"])
        {
          [self replaceAndHighlightShape:field replaceWithString:[STConstantsPlaceholders RemovedField] andHighlight:STMSWord2011E110Yellow];
        }
      } else if ([action Action] == [STConstantsCodeFileActionTask ReAddFile]) {
        //NSLog(@"Linking code file %@", [tag CodeFilePath]);
        [_DocumentManager AddCodeFile:[tag CodeFilePath]];
      } else {
        //NSLog(@"The action task of %ld is not known and will be skipped", [action Action]);
      }
    }
  }
}

-(void)replaceAndHighlightField:(STMSWord2011Field*)field replaceWithString:(NSString*)replacement andHighlight:(STMSWord2011E110)highlight
{
  if(field != nil && replacement != nil)
  {
    [WordHelpers select:field];
    STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
    //NOTE: Unlike Windows, when we change the content we BREAK the selection we're going to need to go back and create a new selection so we can include the text we just inserted
    NSInteger start = [[[application selection] textObject] startOfContent];
    NSInteger end = start + [replacement length];
    [[application selection] textObject].content = [STConstantsPlaceholders RemovedField];
    [WordHelpers selectTextAtRangeStart:start andEnd:end];
    [[[application selection] textObject] setHighlightColorIndex: highlight];
  }
}

-(void)replaceAndHighlightShape:(STMSWord2011Shape*)shape replaceWithString:(NSString*)replacement andHighlight:(STMSWord2011E110)highlight
{
  //on the mac we can't select shapes... so we can't delete them...
  // instead, we're going to leave the shape in place
  // replace the text
  // remove the shape name
  if(shape != nil && replacement != nil)
  {
    [[[shape textFrame] textRange] setContent:replacement];
    [shape setName:@""];
    [[[shape textFrame] textRange] setHighlightColorIndex:highlight];
  }
}


/// <summary>
/// Is this possibly a StatTag shape?  This is somewhat of a weak check as we are just
/// able to look for the presence of a name field, but if it can reduce overhead in
/// processing shapes we'll take it.
/// </summary>
/// <param name="shape"></param>
/// <returns></returns>
+(bool)IsStatTagShape:(STMSWord2011Shape*)shape
{
  
  NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
  return (shape != nil
          && !([[[shape name] stringByTrimmingCharactersInSet:ws] length] == 0)
          && [[shape name] containsString:TagIdentifierDelimiter]);
}




//MARK: EWW -> added extra stattag shape handlers for unlinked tags

-(STTag*)restoreUnlinkedTagFromShape:(id)aShape
{
  
  
  STTag* tag;
  NSString* shapeClass = NSStringFromClass([aShape class]);

  //MicrosoftWordInlineShape
  if ([shapeClass isEqualToString:@"MicrosoftWordShape"])
  {
    STMSWord2011Shape* shape = (STMSWord2011Shape*)aShape;
    if(shape != nil)
    {
      tag = [self FindTag:[shape name]];
      if(tag != nil)
      {
        return tag;
      }

      NSRange r = [[shape name] rangeOfString:@"--"];
      if (r.location != NSNotFound)
      {
        NSString* originShapeName;
        NSInteger shapeType = -1;
        tag = [[STTag alloc] init];
        
        //because of the scripting bridge we can't use isKindOfClass, so we have to use...
        
        //  [tag setType:[STConstantsTagType Figure]];
        originShapeName = [shape name];
        shapeType = [shape shapeType];
        //if the shape type is textbox...
        //we have a verbatim tag
        if(shapeType == STMSWord2011MShpShapeTypeTextBox)
        {
          //NSLog(@"found a text box");
          [tag setType:[STConstantsTagType Verbatim]];
        }
        
        NSString* shapeName = [originShapeName substringToIndex:r.location];
        NSString* shapeFilePath = [originShapeName substringFromIndex:r.location + r.length];
        
        //NSLog(@"shapeName = '%@'", shapeName);
        //NSLog(@"shapeFilePath = '%@'", shapeFilePath);
        //NSLog(@"shapeType = '%ld'", shapeType);
        
        [tag setName:shapeName];
        STCodeFile* cf = [[STCodeFile alloc] init];
        [cf setFilePath:shapeFilePath];
        [tag setCodeFile:cf];
        
      }

    }

  }
  

  
  return tag;
  
}



-(void)ProcessStatTagShapes:(CodeFileActionTypeShape)aFunction configuration:(id)configuration {
  //-(void)ProcessStatTagFields:(SEL)aFunction configuration:(id)configuration {
  //NSLog(@"ProcessStatTagFields - Started");
  
  @autoreleasepool {
    
    STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
    STMSWord2011Document* document = [application activeDocument];
    
    NSArray<STMSWord2011Shape*>* shapes = [document shapes];
    NSInteger shapesCount = [shapes count];
    
    // Fields is a 1-based index
    //NSLog(@"Preparing to process %ld fields", fieldsCount);
    for (NSInteger index = shapesCount - 1; index >= 0; index--) {
      
      STMSWord2011Shape* shape = shapes[index];
      if(shape == nil) {
        //NSLog(@"Null field detected at index %ld", index);
        continue;
      }
      if(![STTagManager IsStatTagShape:shape]) {
        //Marshal.ReleaseComObject(field);
        continue;
      }
      //NSLog(@"Processing StatTag field");
      STTag* tag = [self restoreUnlinkedTagFromShape:shape];
      if(tag == nil) {
        //NSLog(@"The field tag is null or could not be found");
        continue;
      }
      
      aFunction(shape, tag, configuration);
    }
  }
}

/**
 Update the tag data in a field.
 
 @remark Assumes that the field parameter is known to be an tag field
 
 @param field: The field to update.  This is the outermost layer of the tag field.
 @param tag: The tag to be updated.
 */
-(void)UpdateTagShapeData:(STMSWord2011Shape*)shape tag:(STTag*)tag {
  @autoreleasepool {
    [shape setName:[tag Id]];
  }
}

@end
