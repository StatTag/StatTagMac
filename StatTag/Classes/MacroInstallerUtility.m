//
//  MacroInstallerUtility.m
//  StatTag
//
//  Created by Eric Whitley on 3/5/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "MacroInstallerUtility.h"
#import <Cocoa/Cocoa.h>
#import "AppKitCompatibilityDeclarations.h"
#import "AlertDisclosureTextView.h"

#import "StatTagShared.h"
#import "STLogManager.h"
#import "STThisAddIn.h"


@implementation MacroInstallerUtility


+(void)installMacros
{
  NSString* completionDetail = nil;
  if([STThisAddIn IsAppInstalled]) {
    if([STThisAddIn IsAppRunning]) {
      completionDetail = @"You will need to quit and restart Microsoft Word to fully enable StatTag integration";
    }
  }
  
  [[self class] runShellInstallScript:@"StatTagMacroInstallationScript" withActionButtonNamed:@"Install" andMessage:@"Would you like to install support for Microsoft Word?" andInformativeText:@"For improved integration, StatTag can install a toolbar in Microsoft Word. Would you like to install this functionality?" andRTFDetailFile:@"StatTagMacroInstallText" withCompletionMessage:@"StatTag Support Installed" andCompletionDetail:completionDetail] ;
  
}

+(void)removeMacros
{
  
  [[self class] runShellInstallScript:@"StatTagMacroRemovalScript" withActionButtonNamed:@"Remove" andMessage:@"Would you like to remove support for Microsoft Word?" andInformativeText:@"This action will remove Macro and AppleScript files that enable Microsoft Word to communicate with StatTag" andRTFDetailFile:nil withCompletionMessage:@"StatTag Support Removed" andCompletionDetail:nil];
}


+(void)runShellInstallScript:(NSString*)scriptName withActionButtonNamed:(NSString*)actionTitle andMessage:(NSString*)message andInformativeText:(NSString*)informativeText andRTFDetailFile:(NSString*)detailFileName withCompletionMessage:(NSString*)completionMessage andCompletionDetail:(NSString*)completionDetail
{
  
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSAlertStyleInformational];
  if(informativeText != nil)
  {
    [alert setInformativeText:informativeText];
  }
  [alert setMessageText:message];
  [alert addButtonWithTitle:actionTitle];
  [alert addButtonWithTitle:@"Cancel"];
  
  if(detailFileName != nil)
  {
    NSData *data;
    NSAttributedString *content;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:detailFileName ofType:@"rtf"];
    data = [NSData dataWithContentsOfFile:filePath];
    if (data)
    {
      AlertDisclosureTextView* d = [[AlertDisclosureTextView alloc] init];
      [alert setAccessoryView:[d view]];
      
      content = [[NSAttributedString alloc] initWithRTF:data documentAttributes:nil];
      [[[d textView] textStorage] setAttributedString: content];
    }
  }
  
  NSModalResponse returnCode = [alert runModal];
  
//  [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSModalResponse returnCode) {
    if (returnCode == NSAlertFirstButtonReturn) {
      
      NSTask *task = [[NSTask alloc] init];
      NSBundle *myBundle = [NSBundle bundleForClass:[self class]];
      [task setLaunchPath:[myBundle pathForResource:scriptName ofType:@"sh"]];
      
      //we're telling the shell script where the app is so we can pull the resources (macro files, etc.) out
      //this is just in case the app isn't installed in /Applications (which it really should be...)
      [task setArguments:@[ @"-a", [NSString stringWithFormat:@"%@%@", [myBundle bundlePath], @"/Contents/Resources/"]]];
      
      NSPipe* errorPipe = [NSPipe pipe];
      [task setStandardError:errorPipe];
      
      [task launch];
      [task waitUntilExit];
      
      //we're just going to do this in a simple, brute synchronous way
      NSData* error = [[errorPipe fileHandleForReading] readDataToEndOfFile];
      NSString* err_result = [[NSString alloc] initWithData:error encoding:NSUTF8StringEncoding];
      //NSLog(@"%@", err_result);
      
      if([task terminationStatus] != 0 || [err_result length] > 0)
      {
        //something didn't work - let's just log this and give the user some really ugly details
        [[[StatTagShared sharedInstance] logManager] WriteMessage:@"Could not install/remove StatTag Macros"];
        [[[StatTagShared sharedInstance] logManager] WriteMessage:err_result];
        [[self class] simpleOKWithMessage:@"StatTag Encountered a Problem" andInformativeText:err_result];
      } else {
        [[self class] simpleOKWithMessage:completionMessage andInformativeText:completionDetail];
      }
      
    } else if (returnCode == NSAlertSecondButtonReturn) {
    }
//  }];
  
}


+(void)simpleOKWithMessage:(NSString*)message andInformativeText:(NSString*)informativeText
{
  
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setAlertStyle:NSAlertStyleInformational];
  if(informativeText != nil && [informativeText length] > 0)
  {
    [alert setInformativeText:informativeText];
  }
  [alert setMessageText:message];
  [alert addButtonWithTitle:@"OK"];

  [alert runModal];
//  [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] completionHandler:^(NSModalResponse returnCode) {
//  }];
  
}


@end
