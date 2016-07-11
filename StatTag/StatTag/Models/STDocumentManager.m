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

@implementation STDocumentManager

@synthesize TagManager = _TagManager;
@synthesize StatsManager = _StatsManager;

NSString* const ConfigurationAttribute = @"StatTag Configuration";

-(instancetype) init {
  self = [super init];
  if(self){
    DocumentCodeFiles = [[NSMutableDictionary<NSString*, NSMutableArray<STCodeFile*>*> alloc] init];
    _TagManager = [[STTagManager alloc] init:self];
    _StatsManager = [[STStatsManager alloc] init:self];
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



//MARK: Wrappers around TagManager calls
-(STTag*)FindTag:(NSString*)tagID {
  return [[self TagManager] FindTagByID:tagID];
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
