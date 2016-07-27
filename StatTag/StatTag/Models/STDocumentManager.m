//
//  STDocumentManager.m
//  StatTag
//
//  Created by Eric Whitley on 7/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STDocumentManager.h"
#import "StatTag.h"

#import "STStatsManager.h"
#import "STTagManager.h"
#import "STCodeFile.h"
#import "STMSWord2011.h"
#import "STGlobals.h"
#import "STThisAddIn.h"
#import "STCodeFile.h"
#import "STFieldCreator.h"

@implementation STDocumentManager

@synthesize TagManager = _TagManager;
@synthesize StatsManager = _StatsManager;
@synthesize FieldManager = _FieldManager;

NSString* const ConfigurationAttribute = @"StatTag Configuration";

-(instancetype) init {
  self = [super init];
  if(self){
    DocumentCodeFiles = [[NSMutableDictionary<NSString*, NSMutableArray<STCodeFile*>*> alloc] init];
    _TagManager = [[STTagManager alloc] init:self];
    _StatsManager = [[STStatsManager alloc] init:self];
    _FieldManager = [[STFieldCreator alloc] init];
  }
  return self;
}


/**
  Provider a wrapper to check if a variable exists in the document.
  @remarks: Needed because Word interop doesn't provide a nice check mechanism, and uses exceptions instead.
  @param variable: The variable to check
  @returns : True if a variable exists and has a value, false otherwise
*/
-(BOOL)DocumentVariableExists:(STMSWord2011Variable*)variable {
  
  @try {
    NSString* value = [variable variableValue];
    NSLog(@"DocumentVariableExists: variable: %@ has value: %@", [variable name], value);
    return true;
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
  @finally {
  }
  
  return false;
}

/**
 Save the referenced code files to the current Word document.
 @param document: The Word document of interest
*/
-(void) SaveCodeFileListToDocument:(STMSWord2011Document*) document {
  
  NSLog(@"SaveCodeFileListToDocument - Started");
  SBElementArray<STMSWord2011Variable*>* variables = [document variables];
  STMSWord2011Variable* variable = [variables objectWithName:ConfigurationAttribute];

  @try {
    NSMutableArray<STCodeFile*>* files = [self GetCodeFileList:document];
    BOOL hasCodeFiles = (files != nil && [files count] > 0);
    NSString* attribute = [STCodeFile SerializeList:files error:nil];
    if(![self DocumentVariableExists:variable]) {
      if (hasCodeFiles)
      {
        NSLog(@"%@", [NSString stringWithFormat:@"Document variable does not exist.  Adding attribute value of %@", attribute]);
        [WordHelpers createOrUpdateDocumentVariableWithName:ConfigurationAttribute andValue:attribute];
      }
      else
      {
        NSLog(@"There are no code files to add.");
      }
    } else {
      if (hasCodeFiles)
      {
        NSLog(@"%@", [NSString stringWithFormat:@"Document variable already exists.  Updating attribute value to %@", attribute]);
        variable.variableValue = attribute;
      }
      else {
        NSLog(@"There are no code files - removing existing variable");
        [variables removeObject:variable]; //can we do this?
      }
    }
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
  @finally {
    
  }
  NSLog(@"SaveCodeFileListToDocument - Finished");
}



/**
  Load the list of associated Code Files from a Word document.
  @param document: The Word document of interest
*/
-(void)LoadCodeFileListFromDocument:(STMSWord2011Document*)document {
  NSLog(@"LoadCodeFileListFromDocument - Started for doc at path %@", [document fullName]);

  NSLog(@"variables : count: %lu", (unsigned long)[[document variables] count]);
  
  NSArray<STMSWord2011Variable*>* variables = [document variables];
  STMSWord2011Variable* variable;
  for(STMSWord2011Variable* var in variables) {
    NSLog(@"variable name: %@ with value : %@", [var name], [var variableValue]);
    if([[var name] isEqualToString:ConfigurationAttribute]) {
      variable = var;
    }
  }
  
  @try {
    if([self DocumentVariableExists:variable]) {
      NSLog(@"variable : %@ has value : %@", [variable name], [variable variableValue]);
      NSMutableArray<STCodeFile*>* list = [[NSMutableArray<STCodeFile*> alloc] initWithArray:[STCodeFile DeserializeList:[variable variableValue] error:nil]];
      [DocumentCodeFiles setObject:list forKey:[document fullName]];
      NSLog(@"Document variable existed, loaded %lu code files", (unsigned long)[list count]);
    } else {
      [DocumentCodeFiles setObject:[[NSMutableArray<STCodeFile*> alloc] init] forKey:[document fullName]];
      NSLog(@"Document variable does not exist, no code files loaded");
    }
    NSString* value = [variable variableValue];
    NSLog(@"DocumentVariableExists: variable: %@ has value: %@", [variable name], value);
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
  @finally {
    //Marshal.ReleaseComObject(variable);
    //Marshal.ReleaseComObject(variables);
  }

  NSLog(@"LoadCodeFileListFromDocument - Finished");
}


/**
 Insert an image (given a definition from an tag) into the current Word document at the current cursor location.
 */
-(void) InsertImage:(STTag*) tag {
  [NSException raise:@"InsertImage not implemented" format:@"InsertImage not implemented"];
}






/**
 Insert a table tag into the current selection.

 @remark: This assumes that the tag is known to be a table result.</remarks>
*/
-(void) InsertTable:(STMSWord2011SelectionObject*)selection tag:(STTag*) tag {
  [NSException raise:@"InsertTable not implemented" format:@"InsertTable not implemented"];
}




//MARK: Wrappers around TagManager calls

-(NSDictionary<NSString*, NSArray<STTag*>*>*)FindAllUnlinkedTags {
  return [_TagManager FindAllUnlinkedTags];
}

-(NSArray<STTag*>*)GetTags {
  return [_TagManager GetTags];
}

-(STTag*)FindTag:(NSString*)tagID {
  return [[self TagManager] FindTagByID:tagID];
}


//MARK: add / update

/**
 Given an tag, insert the result into the document at the current cursor position.
 
 @remark This method assumes the tag result is already refreshed.  It does not attempt to refresh or recalculate it.
 */
-(void) InsertField:(id)tag {
  NSLog(@"InsertField for Tag");
  if([tag isKindOfClass:[STFieldTag class]]) {
    [self InsertFieldWithFieldTag:tag];
  } else if ([tag isKindOfClass:[STTag class]]) {
    [self InsertFieldWithFieldTag:[[STFieldTag alloc] initWithTag:tag]];
  }
}


/**
 Given an tag, insert the result into the document at the current cursor position.

 @remark This method assumes the tag result is already refreshed.  It does not attempt to refresh or recalculate it.
 */
-(void) InsertFieldWithFieldTag:(STFieldTag*)tag {
  NSLog(@"InsertField - Started");

  if(tag == nil) {
    NSLog(@"The tag is null");
    return;
  }
  
  if([[tag Type] isEqualToString:[STConstantsTagType Figure]]) {
    NSLog(@"Detected a Figure tag");
    [self InsertImage:tag];
    return;
  }
  
  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];

  @try {
    STMSWord2011SelectionObject* selection = [app selection];
    if(selection == nil) {
      NSLog(@"There is no active selection");
      return;
    }

    // If the tag is a table, and the cell index is not set, it means we are inserting the entire
    // table into the document.  Otherwise, we are able to just insert a single table cell.
    if([tag IsTableTag] && [tag TableCellIndex] != nil) {
      // if (tag.IsTableTag() && !tag.TableCellIndex.HasValue)
      NSLog(@"Inserting a new table tag");
      [self InsertTable:selection tag:tag];
    } else {
      NSLog(@"Inserting a single tag field");
      //FIXME: unclear if we should use textObject or formattedText
      STMSWord2011TextRange* range = [selection textObject];
      [self CreateTagField:range tagIdentifier:[tag Name] displayValue:[tag FormattedResult] tag:tag];
      //Marshal.ReleaseComObject(range);
    }
    //Marshal.ReleaseComObject(selection);
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception.reason);
  }
  @finally {
    //Marshal.ReleaseComObject(document);
  }

  NSLog(@"InsertField - Finished");

}


/**
Insert an StatTag field at the currently specified document range.

@param range: The range to insert the field at
@param tagIdentifier: The visible identifier of the tag (does not need to be globablly unique)
@param displayValue: The value that should display when the field is shown.
@param tag: The tag to be inserted
 */
-(void)CreateTagField:(STMSWord2011TextRange*)range tagIdentifier:(NSString*)tagIdentifier displayValue:(NSString*)displayValue tag:(STTag*)tag {
  NSLog(@"CreateTagField - Started");

//  [app createNewFieldTextRange:range fieldType:type fieldText:text preserveFormatting:preserveFormatting];
//  return [[range fields] lastObject];
  
  //C# - XML - can't use it as we don't have support for InsertXML
  //  range.InsertXML(OpenXmlGenerator.GenerateField(tagIdentifier, displayValue, tag));
  
  //C# prior to XML - which we can't use
  //var fields = FieldManager.InsertField(range, string.Format("{3}MacroButton {0} {1}{3}ADDIN {2}{4}{4}",
  //    Constants.FieldDetails.MacroButtonName, displayValue, tagIdentifier, FieldCreator.FieldOpen, FieldCreator.FieldClose));
  //Log(string.Format("Inserted field with identifier {0} and display value {1}", tagIdentifier, displayValue));

  NSArray<STMSWord2011Field*>* fields = [_FieldManager InsertField:range theString:
                                         
                                         [NSString stringWithFormat:@"%@MacroButton %@ %@%@ADDIN %@%@%@",
                                          
                                          [STFieldCreator FieldOpen],
                                          [STConstantsFieldDetails MacroButtonName],
                                          displayValue,
                                          [STFieldCreator FieldOpen],
                                          tagIdentifier,
                                          [STFieldCreator FieldClose],
                                          [STFieldCreator FieldClose]
                                          
                                          //0    Constants.FieldDetails.MacroButtonName,
                                          //1    displayValue,
                                          //2    tagIdentifier,
                                          //3    FieldCreator.FieldOpen,
                                          //4    FieldCreator.FieldClose
                                          
                                          ]
                                         ];
  
//  NSArray<STMSWord2011Field*>* fields = [_FieldManager InsertField:range theString:@"<MacroButton test test>"];

//    NSArray<STMSWord2011Field*>* fields = [_FieldManager InsertField:range theString:@"< = 5 + < PAGE > >"];

  
//  NSLog(@"fields : %@", fields);
//  
//  NSLog(@"Inserted field with identifier %@ and display value %@", tagIdentifier, displayValue);
  
  STMSWord2011Field* dataField = [fields firstObject];
  //@property (copy) NSString *fieldText;  // Returns or sets data in an ADDIN field. The data is not visible in the field code or result. It is only accessible by returning the value of the data property. If the field isn't an ADDIN field, this property will cause an error.
  dataField.fieldText = [tag Serialize:nil];
  
  //var dataField = fields.First();
  //dataField.Data = tag.Serialize();
  
  NSLog(@"CreateTagField - Finished");
}




/**
 Add a code file reference to our master list of files in the document.  This should be used when
 discovering code files to link to the document.
*/
-(void)AddCodeFile:(NSString*)fileName document:(STMSWord2011Document*)document {

  //NSMutableArray<STCodeFile*>* files = [[NSMutableArray<STCodeFile*> alloc] initWithArray:[self GetCodeFileList:document]];
  NSMutableArray<STCodeFile*>* files = [self GetCodeFileList:document];

  //  if (files.Any(x => x.FilePath.Equals(fileName, StringComparison.CurrentCultureIgnoreCase)))
  //  {
  //    Log(string.Format("Code file {0} already exists and won't be added again", fileName));
  //    return;
  //  }

  NSString* package = [STCodeFile GuessStatisticalPackage:fileName];
  STCodeFile* file = [[STCodeFile alloc] init];
  file.FilePath = fileName;
  file.StatisticalPackage = package;
  [file LoadTagsFromContent];
  [file SaveBackup:nil];
  //FIXME: if this is a copy of the array, then this won't add anything...
  // which makes me wonder if this is supposed to return a pointer to the actual array instead...
  [files addObject:file];
  NSLog(@"Added code file %@", fileName);
  
}
-(void)AddCodeFile:(NSString*)fileName {
  [self AddCodeFile:fileName document:nil];
}



/**
  Helper accessor to get the list of code files associated with a document.  If the code file list
  hasn't been established yet for the document, it will be created and returned.
*/
-(NSMutableArray<STCodeFile*>*)GetCodeFileList {
  return [self GetCodeFileList:nil];
}

-(NSMutableArray<STCodeFile*>*)GetCodeFileList:(STMSWord2011Document*)document {
  if(document == nil) {
    NSLog(@"No document specified, so fetching code file list for active document.");
    document = [[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument];
  }
  if(document == nil) {
    NSLog(@"Attempted to access code files for a null document.  Returning empty collection.");
    return [[NSMutableArray<STCodeFile*> alloc] init];
  }

  NSString* fullName = [document fullName];
  if([DocumentCodeFiles objectForKey:fullName] == nil) {
    [DocumentCodeFiles setValue:[[NSMutableArray<STCodeFile*> alloc] init] forKey:fullName];
  }
  
  return DocumentCodeFiles[fullName];
}

/**
 Helper setter to update a document's list of associated code files.
*/
-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files {
  [self SetCodeFileList:files document:nil];
}

-(void)SetCodeFileList:(NSArray<STCodeFile*>*)files document:(STMSWord2011Document*)document {
  if(document == nil) {
    NSLog(@"No document specified, so getting a reference to the active document.");
    document = [[[STGlobals sharedInstance] ThisAddIn] SafeGetActiveDocument];
  }
  if(document == nil) {
    NSLog(@"Attempted to set the code files for a null document.  Throwing exception.");
    [NSException raise:@"The Word document must be specified." format:@"The Word document must be specified."];
  }
  [DocumentCodeFiles setValue:[[NSMutableArray<STCodeFile*> alloc] initWithArray: files ] forKey:[document fullName]];
}


@end
