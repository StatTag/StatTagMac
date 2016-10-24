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
#import "STCodeFile.h"
#import "STMSWord2011.h"
#import "STConstants.h"
#import "STFieldTag.h"
#import "STDuplicateTagResults.h"
#import "STGlobals.h"
#import "STThisAddIn.h"
#import "STCodeFileAction.h"
#import "WordHelpers.h"

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
  
  NSLog(@"Executing FindTagByID:%@", tagID);
  
  NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];

  if(files == nil) {
    NSLog(@"Unable to find a tag because the files collection is null");
    return nil;
  } else {
    NSLog(@"FindTagByID - found (%lu) files", (unsigned long)[files count]);
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
-(BOOL)IsStatTagField:(STMSWord2011Field*) field {
  return(field != nil
         //fieldType is a STMSWord2011E183 enum, so we are looking for value "STMSWord2011E183FieldMacroButton" (which is "51" in the Windows version)
         //NOTE: the scripting bridge doesn't successfully import this macro field value name, so you need to supply it yourself - see the readme in the StatTag base project directory
         && [field fieldType] == STMSWord2011E183FieldMacroButton
         && [field fieldCode] != nil && [[[[field fieldCode] formattedText] content] containsString:[STConstantsFieldDetails MacroButtonName]]
         && [[[field fieldCode] fields] count] > 0
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
  
  [STGlobals activateDocument];
  
  NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];

  NSLog(@"DeserializeFieldTag -> files : %@", files);
  //FIXME: we should fix his to be a hard crash - debugging...

  STMSWord2011TextRange* code = [field fieldCode];
  NSLog(@"DeserializeFieldTag -> code : (%d,%d)", [code startOfContent], [code endOfContent]);
  STMSWord2011Field* nestedField = [[code fields] firstObject];//[code fields][1];
  
  [STGlobals activateDocument];
  NSString* nestedFieldText = [NSString stringWithString:[nestedField fieldText]];//[[nestedField fieldText] copy];
  [STGlobals activateDocument];
  
  NSLog(@"DeserializeFieldTag -> nestedField : %@", nestedField);
  NSLog(@"DeserializeFieldTag -> nestedField field type: %d", [nestedField fieldType]);
  NSLog(@"DeserializeFieldTag -> nestedField field entry_index: %d", [nestedField entry_index]);
  
  NSLog(@"DeserializeFieldTag -> nestedField fieldText : %@", nestedFieldText);
  //FIXME: very, very unsure of this.. original c# used "Data" and we're using fieldText - which seems to be the closest approximation...
  //  var fieldTag = FieldTag.Deserialize(nestedField.Data.ToString(CultureInfo.InvariantCulture),
  //                                      files);
  STFieldTag* fieldTag = [STFieldTag Deserialize:nestedFieldText withFiles:files error:nil];
  return fieldTag;
}


/**
 Given a Word document Field, extracts the embedded StatTag tag
 associated with it.
 @param field: The Word field object to investigate
*/
-(STFieldTag*)GetFieldTag:(STMSWord2011Field*) field {
  
  //FIXME: added some checks we should remove here - hard crash is preferred for now
  
  [STGlobals activateDocument];
  
  STFieldTag* fieldTag = [self DeserializeFieldTag:field];
  NSLog(@"GetFieldTag -> fieldTag : %@", [fieldTag description]);
  STTag* tag = [self FindTagByTag:fieldTag];
  NSLog(@"GetFieldTag -> tag : %@", [tag description]);
  
  NSLog(@"");
  NSLog(@"GetFieldTag");
  NSLog(@"================");
  NSLog(@"fieldTag is nil : %d", fieldTag == nil);
  NSLog(@"FormattedResult : %@", [fieldTag FormattedResult]);
  NSLog(@"Type : %@", [fieldTag Type]);
  NSLog(@"CachedResult : %@", [fieldTag CachedResult]);
  
  NSLog(@"tag is nil : %d", tag == nil);
  NSLog(@"FormattedResult : %@", [tag FormattedResult]);
  NSLog(@"Type : %@", [tag Type]);
  NSLog(@"CachedResult : %@", [tag CachedResult]);
  NSLog(@"--------------");
  
    // The result of FindTag is going to be a document-level tag, not a
    // cell specific one that exists as a field.  We need to re-set the cell index
    // from the tag we found, to ensure it's available for later use.
    return [[STFieldTag alloc] initWithTag:tag andFieldTag:fieldTag];
    
}

-(STDuplicateTagResults*)FindAllDuplicateTags {
  NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];
  STDuplicateTagResults* duplicateTags = [[STDuplicateTagResults alloc] init];
  for(STCodeFile* file in files) {
    STDuplicateTagResults* result = [[STDuplicateTagResults alloc] initWithDictionary:[file FindDuplicateTags]];
    if(result != nil && [result count] > 0) {
      [duplicateTags addEntriesFromDictionary:result];
      //FIXME: go back and reivew this.  The original did something like...
      //  duplicateTags.Add(file, result);
      // so that may behave slightly differently
      // from the docs it looks like it should be the "same" ?
      // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSMutableDictionary_Class/index.html#//apple_ref/occ/instm/NSMutableDictionary/addEntriesFromDictionary:
    }
  }
  return duplicateTags;
}

/** 
 Search the active Word document and find all inserted tags.  Determine if the tag's
 code file is linked to this document, and report those that are not.
 */
-(NSDictionary<NSString*, NSArray<STTag*>*>*) FindAllUnlinkedTags {
  NSLog(@"FindAllUnlinkedTags - Started");
  NSMutableDictionary<NSString*, NSMutableArray<STTag*>*>* results = [[NSMutableDictionary<NSString*, NSMutableArray<STTag*>*> alloc] init];
  
  STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* document = [application activeDocument];
  
  NSArray<STMSWord2011Field*>* fields = [document fields];
  int fieldsCount = [fields count];

  // Fields is a 1-based index
  // -- EWW -> above is from the original c# - will be interesting to see if this is the case for the Mac version
  //FIXME: check later to see if Fields is 1-based index
  NSArray<STCodeFile*>* files = [_DocumentManager GetCodeFileList];
  NSLog(@"Preparing to process %d fields", fieldsCount);
  for (int index = fieldsCount; index >= 1; index--) {
    STMSWord2011Field* field = fields[index];
    if(field == nil) {
      NSLog(@"Null field detected at index %d", index);
      continue;
    }

    if(![self IsStatTagField:field]) {
      continue;
    }

    NSLog(@"Processing StatTag field");
    STFieldTag* tag = [self GetFieldTag:field];
    if(tag == nil) {
      NSLog(@"The field tag is null or could not be found");
      continue;
    }

    BOOL hasFilePath = false;
    for(STCodeFile* cf in files) {
      if([[cf FilePath] isEqualToString:[tag CodeFilePath]]) {
        hasFilePath = true;
      }
    }
    if(!hasFilePath) {
      if([results objectForKey:[tag CodeFilePath]] == nil) {
        [results setObject:[[NSMutableArray<STTag*> alloc] init] forKey:[tag CodeFilePath]];
      }
      //FIXME: does this return a copy or the reference?
      [[results objectForKey:[tag CodeFilePath]] addObject:tag];
    }
  }
  
  NSLog(@"FindAllUnlinkedTags - Finished");
  return results;
}

/**
 A generic method that will iterate over the fields in the active document, and apply a function to
 each StatTag field.

 @param function: The function to apply to each relevant field
 @param configuration: A set of configuration information specific to the function
 */
-(void)ProcessStatTagFields:(NSString*)aFunction configuration:(id)configuration {
  NSLog(@"ProcessStatTagFields - Started");
 
  STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* document = [application activeDocument];

  NSArray<STMSWord2011Field*>* fields = [document fields];
  int fieldsCount = [fields count];

  // Fields is a 1-based index
  NSLog(@"Preparing to process %d fields", fieldsCount);
  for (int index = fieldsCount; index >= 1; index--) {
    
    STMSWord2011Field* field = fields[index];
    if(field == nil) {
      NSLog(@"Null field detected at index %d", index);
      continue;
    }
    if(![self IsStatTagField:field]) {
      //Marshal.ReleaseComObject(field);
      continue;
    }
    NSLog(@"Processing StatTag field");
    STFieldTag* tag = [self GetFieldTag:field];
    if(tag == nil) {
      NSLog(@"The field tag is null or could not be found");
      //Marshal.ReleaseComObject(field);
      continue;
    }

    //http://stackoverflow.com/questions/313400/nsinvocation-for-dummies
    //http://www.enigmaticape.com/blog/objc-invoking-a-selector-with-multiple-parameters
    //http://cocoasamurai.blogspot.com/2010/01/understanding-objective-c-runtime.html
    
    //option 1 - verbose
//    NSMethodSignature* method = [self methodSignatureForSelector: aFunction];
//    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature: method];
//    [invocation setSelector:aFunction];
//    [invocation setTarget:self];
//    [invocation setArgument: &field  atIndex: 2];
//    [invocation setArgument: &tag  atIndex: 3];
//    [invocation setArgument: &configuration  atIndex: 4];
//    [invocation invoke];
    //we have no return value

    //option 2 - succinct, but we hae trouble with our arguments list
//    IMP methodImpl = [STTagManager instanceMethodForSelector:aFunction];
    SEL selector = NSSelectorFromString(aFunction);
    IMP method = [self methodForSelector: selector];    
    ((void (*) (id, SEL, STMSWord2011Field*, STFieldTag*, id))method)(self,selector,field,tag,configuration);
//    id result = methodImpl( self,
//                     aFunction,
//                     field,
//                     tag,
//                     configuration );
    
    //can't do this since we have more than 2 parameters
    //    [self performSelector:aFunction
    //               withObject:@"Cake"
    //               withObject:@"More Cake"
    //               //waitUntilDone:YES
    //     ];
    //aFunction(field, tag, configuration);
    //Marshal.ReleaseComObject(field);
  }
  
  //Marshal.ReleaseComObject(document);
  NSLog(@"ProcessStatTagFields - Finished");
}



/**
  Update the tag data in a field.

  @remark Assumes that the field parameter is known to be an tag field
 
  @param field: The field to update.  This is the outermost layer of the tag field.
  @param tag: The tag to be updated.
*/
-(void)UpdateTagFieldData:(STMSWord2011Field*)field tag:(STFieldTag*)tag {
  STMSWord2011TextRange* code = [field fieldCode];
  STMSWord2011Field* nestedField = [code fields][1];
  nestedField.fieldText = [tag Serialize:nil];
}


/**
  Given a field and its tag, update it to link to a new code file

  @param field: The document Field that contains the tag
  @param tag: The tag that will be updated
  @param configuration: A collection of the actions to apply (of type Dictionary<string, CodeFileAction>)
 */
-(void) UpdateUnlinkedTagsByCodeFile:(STMSWord2011Field*)field tag:(STFieldTag*)tag configuration:(id)configuration {
  
  NSDictionary<NSString*, STCodeFileAction*>* actions = (NSDictionary<NSString*, STCodeFileAction*>*)configuration;
  if(actions == nil && [actions isKindOfClass:[NSDictionary class]]) {
    NSLog(@"The list of actions to perform is null or of the wrong type");
    return;
  }
  
  // If there is no action specified for this field, we will exit.  This should happen when we have fields that
  // are still linked in a document.
  if([actions objectForKey:[tag CodeFilePath]] == nil) {
    NSLog(@"No action is needed for tag in file %@", [tag CodeFilePath]);
    return;
  }
  
  // Make sure that the action is actually defined.  If no action was specified by the user, we can't continue
  // with doing anything.
  STCodeFileAction* action = [actions objectForKey:[tag CodeFilePath]];
  if(action == nil) {
    NSLog(@"No action was specified - exiting");
    return;
  }

  // Apply the appropriate action to this field, based on what the user specified.
  STCodeFile* codeFile = (STCodeFile*)[action Parameter];
  if(codeFile != nil && [codeFile isKindOfClass:[STCodeFile class]]) {
    if([action Action] == [STConstantsCodeFileActionTask ChangeFile]) {
      NSLog(@"Changing tag %@ from %@ to %@", [tag Name], [tag CodeFilePath], [codeFile FilePath]);
      tag.CodeFile = codeFile;
      [_DocumentManager AddCodeFile:[tag CodeFilePath]];
      [self UpdateTagFieldData:field tag:tag];
    } else if ([action Action] == [STConstantsCodeFileActionTask RemoveTags]) {
      NSLog(@"Removing %@", [tag Name]);
      [WordHelpers select:field];

      STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
      [[application selection] textObject].content = [STConstantsPlaceholders RemovedField];
      [[application selection] textObject].highlightColorIndex = STMSWord2011E110Yellow;
      // original c# - should be the same enum
      // application.Selection.Range.HighlightColorIndex = WdColorIndex.wdYellow;
    } else if ([action Action] == [STConstantsCodeFileActionTask ReAddFile]) {
      NSLog(@"Linking code file %@", [tag CodeFilePath]);
      [_DocumentManager AddCodeFile:[tag CodeFilePath]];
    } else {
      NSLog(@"The action task of %d is not known and will be skipped", [action Action]);
    }
  }
  
}

/**
 Given a field and its tag, update it to link to a new code file
 @param field: The document Field that contains the tag
 @param tag: The tag that will be updated
 @param configuration: A collection of the actions to apply (of type Dictionary<string, CodeFileAction>)
 */
-(void) UpdateUnlinkedTagsByTag:(STMSWord2011Field*)field tag:(STFieldTag*)tag configuration:(id)configuration {
 
  NSDictionary<NSString*, STCodeFileAction*>* actions = (NSDictionary<NSString*, STCodeFileAction*>*)configuration;
  if(actions == nil && [actions isKindOfClass:[NSDictionary class]]) {
    NSLog(@"The list of actions to perform is null or of the wrong type");
    return;
  }
  
  // If there is no action specified for this field, we will exit.  This should happen when we have fields that
  // are still linked in a document.
  if([actions objectForKey:[tag Id]] == nil) {
    NSLog(@"No action is needed for tag in file %@", [tag Id]);
    return;
  }

  // Make sure that the action is actually defined.  If no action was specified by the user, we can't continue
  // with doing anything.
  STCodeFileAction* action = [actions objectForKey:[tag Id]];
  if(action == nil) {
    NSLog(@"No action was specified - exiting");
    return;
  }

  // Apply the appropriate action to this field, based on what the user specified.
  STCodeFile* codeFile = (STCodeFile*)[action Parameter];
  if(codeFile != nil && [codeFile isKindOfClass:[STCodeFile class]]) {
    if([action Action] == [STConstantsCodeFileActionTask ChangeFile]) {
      NSLog(@"Changing tag %@ from %@ to %@", [tag Name], [tag CodeFilePath], [codeFile FilePath]);
      tag.CodeFile = codeFile;
      [_DocumentManager AddCodeFile:[tag CodeFilePath]];
      [self UpdateTagFieldData:field tag:tag];
    } else if ([action Action] == [STConstantsCodeFileActionTask RemoveTags]) {
      NSLog(@"Removing %@", [tag Name]);
      //[field select];
      [WordHelpers select:field];

      STMSWord2011Application* application = [[[STGlobals sharedInstance] ThisAddIn] Application];
      [[application selection] textObject].content = [STConstantsPlaceholders RemovedField];
      [[application selection] textObject].highlightColorIndex = STMSWord2011E110Yellow;
      // original c# - should be the same enum
      // application.Selection.Range.HighlightColorIndex = WdColorIndex.wdYellow;
    } else if ([action Action] == [STConstantsCodeFileActionTask ReAddFile]) {
      NSLog(@"Linking code file %@", [tag CodeFilePath]);
      [_DocumentManager AddCodeFile:[tag CodeFilePath]];
    } else {
      NSLog(@"The action task of %d is not known and will be skipped", [action Action]);
    }
  }
  
}

@end
