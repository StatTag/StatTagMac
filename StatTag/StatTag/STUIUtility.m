//
//  STUIUtility.m
//  StatTag
//
//  Created by Eric Whitley on 7/29/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STUIUtility.h"
#import "StatTag.h"
#import <Cocoa/Cocoa.h>

@implementation STUIUtility

+(void)WarningMessageBox:(NSString*)text logger:(STLogManager*)logger {
  if(logger != nil) {
    [logger WriteMessage:text];
  }
  
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText:text];
  [alert setAlertStyle:NSWarningAlertStyle];
  [alert addButtonWithTitle:@"Ok"];
  [alert runModal];

  return;

  /*
  
  ////  MessageBox.Show(text, GetAddInName(), MessageBoxButtons.OK, MessageBoxIcon.Exclamation);

  //https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSAlert_Class/
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText:text];
  [alert setAlertStyle:NSCriticalAlertStyle];
  //[alert setInformativeText:@"Informative text."];
  //[alert addButtonWithTitle:@"OK"];
  [alert runModal];
  
  
  //I always forget how to do these...
  //http://www.knowstack.com/nsalert-cocoa-objective-c/
//  NSAlert *alert = [[NSAlert alloc] init];
//  [alert addButtonWithTitle:@"OK"];
//  [alert setMessageText:@"Alert"];
//  [alert setInformativeText:text];
//  [alert setAlertStyle:NSWarningAlertStyle];
//  [alert beginSheetModalForWindow:[[NSApplication sharedApplication] mainWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
   */
  
//  NSAlert *alert = [[NSAlert alloc] init];
//  [alert setMessageText:@"Message text."];
//  [alert setInformativeText:@"Informative text."];
//  [alert addButtonWithTitle:@"Cancel"];
//  [alert addButtonWithTitle:@"Ok"];
//  [alert runModal];

  
}

-(void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
}


+(void)ReportException:(NSException*)exc userMessage:(NSString*)userMessage logger:(STLogManager*)logger
{
  if (logger != nil)
  {
    [logger WriteException:exc];
  }
  
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText:@"StatTag encountered a problem"];
  [alert setInformativeText:userMessage];
  [alert setAlertStyle:NSCriticalAlertStyle];
  [alert addButtonWithTitle:@"Ok"];
  [alert runModal];

  
  NSLog(@"*** FIX ME *** Later on we should see an alert panel... when we have any sort of UI");
  //MessageBox.Show(userMessage, GetAddInName(), MessageBoxButtons.OK, MessageBoxIcon.Error);
}



@end
