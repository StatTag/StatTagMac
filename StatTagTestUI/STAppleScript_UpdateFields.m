//
//  STAppleScript_UpdateFields.m
//  StatTag
//
//  Created by Eric Whitley on 8/16/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STAppleScript_UpdateFields.h"
#import "StatTag.h"

@implementation STAppleScript_UpdateFields


-(id)performDefaultImplementation {
  
  // get the arguments
//  NSDictionary *args = [self evaluatedArguments];
//  NSString *stringToSearch = @"";
  
//  if(args.count) {
//    stringToSearch = [args valueForKey:@""];    // get the direct argument
//  } else {
//    // raise error
//    [self setScriptErrorNumber:-50];
//    [self setScriptErrorString:@"Parameter Error: A Parameter is expected for the verb 'lookup' (You have to specify _what_ you want to lookup!)."];
//  }
//  // Implement your code logic (in this example, I'm just posting an internal notification)
//  [[NSNotificationCenter defaultCenter] postNotificationName:@"AppShouldLookupStringNotification" object:stringToSearch];
  
  STDocumentManager* manager = [[STDocumentManager alloc] init];

  STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
  STMSWord2011Document* doc = [app activeDocument];
  
  manager = [[STDocumentManager alloc] init];
  [manager LoadCodeFileListFromDocument:doc];
  //DocumentManager.LoadCodeFileListFromDocument(doc);
  
  //NSLog(@"GetCodeFileList : %@", [manager GetCodeFileList]);
  for(STCodeFile* file in [manager GetCodeFileList]) {
    [file LoadTagsFromContent];
  }
  
  
  STStatsManager* stats = [[STStatsManager alloc] init:manager];
  for(STCodeFile* cf in [manager GetCodeFileList]) {
    //NSLog(@"found codefile %@", [cf FilePath]);
    
    STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
                                                         filterMode:[STConstantsParserFilterMode TagList]
                                                          tagsToRun:nil//_tagsToProcess
                                           ];
    
  }
  
  
  NSLog(@"Starting to update fields from NSScriptCommand");
  [manager UpdateFields];
  NSLog(@"Finished updating fields NSScriptCommand");
  return [NSNumber numberWithBool:YES];
  
  //return nil;
}


@end
