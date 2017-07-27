//
//  STAppleScript_LoadSettings.m
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import "STAppleScript_LoadSettings.h"
#import "StatTagFramework.h"
#import "AppDelegate.h"
#import "MainTabViewController.h"
#import "StatTagShared.h"
#import "UpdateOutputViewController.h"

//http://stackoverflow.com/questions/17214464/how-do-i-set-initial-view-in-an-nstabview
//http://devcry.heiho.net/html/2012/20120102-nstabview-tutorial.html
//http://stackoverflow.com/questions/38155344/accessing-property-in-cocoa-appdelegate-nsapplicationdelegate-from-applescript
//http://www.cocoawithlove.com/2008/11/singletons-appdelegates-and-top-level.html
//https://www.brandpending.com/2014/12/03/accessing-custom-appdelegate-properties-from-a-viewcontroller-using-ios-and-swift/
//http://mirror.informatimago.com/next/developer.apple.com/cocoa/applescriptforapps.html


//read this
//http://stackoverflow.com/questions/37194835/making-cocoa-application-scriptable-swift
//then open the main storyboard
// you'll find the tab controller - inside of it, each tab can be assigned an identifier - that's what you're looking for
//
//@implementation STAppleScript_OpenSettings
//
//-(id)performDefaultImplementation {
//
//  StatTagShared* shared = [StatTagShared sharedInstance];
////  [[[shared mainVC] tabView] selectTabViewItemAtIndex:(StatTagTabIndexes)ManageCodeFiles];
//
//  [[[shared mainVC] tabView] selectTabViewItemWithIdentifier:@"Settings"];
//  
//  //https://forums.developer.apple.com/thread/9991
//  
//  return nil;
//}
//@end
//
//
//@implementation STAppleScript_OpenManageCodeFiles
//
//-(id)performDefaultImplementation {
//  
//  StatTagShared* shared = [StatTagShared sharedInstance];
//  //  [[[shared mainVC] tabView] selectTabViewItemAtIndex:(StatTagTabIndexes)ManageCodeFiles];
//  
//  [[[shared mainVC] tabView] selectTabViewItemWithIdentifier:@"ManageCodeFiles"];
//  
//  //https://forums.developer.apple.com/thread/9991
//  
//  return nil;
//}
//@end
//
//
//@implementation STAppleScript_UpdateFields
//
//-(id)performDefaultImplementation {
//  StatTagShared* shared = [StatTagShared sharedInstance];
//  [[[shared mainVC] tabView] selectTabViewItemWithIdentifier:@"UpdateOutput"];
//  
//  //if a tag argument was sent in...
//  //let's now see if we can find the tag by name/id and open it
//  NSDictionary<NSString*, id>* args = [self evaluatedArguments];
//  //NSLog(@"UpdateOutput: num args -> %ld", [args count]);
//  NSString* keys = [[args allKeys] componentsJoinedByString:@","];
//  //NSLog(@"UpdateOutput: keys ->%@", keys);
//  ////NSLog(@"UpdateOutput: keys ->%@", [args allKeys]);
//  
//  //1) detect the tags in the current document
//  //2) match the tag (if possible)
//  //3) if the tag is matched, select it in the table
//  //4) open the UI for the tag editor
//  NSString* tagName = [[self evaluatedArguments] valueForKey:@"TagName"];
//  STTag* tag = [[[StatTagShared sharedInstance] tagsViewController] selectTagWithName:tagName];
//  //NSLog(@"tag name : %@", [tag Name]);
//  if(tag != nil)
//  {
//    [[[StatTagShared sharedInstance] tagsViewController] editTag:nil];
//  }
//  
//  //NSLog(@"%@", args);
//  
//  return nil;
//}
//@end


@implementation STAppleScript_OpenSettings

-(id)performDefaultImplementation {

  AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
  [appDelegate openPreferences];
  
  return nil;
}
@end

@implementation STAppleScript_OpenAbout

-(id)performDefaultImplementation {
  
  AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
  [appDelegate openAboutWindow];
  
  return nil;
}
@end

@implementation STAppleScript_OpenHelp

-(id)performDefaultImplementation {
  
//  AppDelegate* appDelegate = (AppDelegate*)[[NSApplication sharedApplication] delegate];
  
  NSURL * helpFile = [[NSBundle mainBundle] URLForResource:@"StatTagHelp" withExtension:@"help"];
  [[NSWorkspace sharedWorkspace] openURL:helpFile];
  
//  [appDelegate showHelp];
  //[appDelegate openAboutWindow];
  
  return nil;
}
@end


@implementation STAppleScript_OpenManageCodeFiles

-(id)performDefaultImplementation {

  //set the active document to the current document on screen
  //we don't need to do anything past that because the code file list will display in the code file panel
  [[NSNotificationCenter defaultCenter] postNotificationName:@"activeDocumentDidChange" object:self userInfo:nil];
  
  return nil;
}
@end

@implementation STAppleScript_OpenManageTags

-(id)performDefaultImplementation {
  //activate the document
  //select "all tags"
  
  //we choose "all tags" by default when we load the content
  [[NSNotificationCenter defaultCenter] postNotificationName:@"activeDocumentDidChange" object:self userInfo:nil];

  return nil;
}
@end

@implementation STAppleScript_UpdateFields

-(id)performDefaultImplementation {
  //if a tag argument was sent in...
  //let's now see if we can find the tag by name/id and open it
  //NSDictionary<NSString*, id>* args = [self evaluatedArguments];
  //NSString* keys = [[args allKeys] componentsJoinedByString:@","];
  
  //1) detect the tags in the current document
  //2) match the tag (if possible)
  //3) if the tag is matched, select it in the table
  //4) open the UI for the tag editor
  //NSString* tagName = [[self evaluatedArguments] valueForKey:@"TagName"];
  //NSString* tagID = [[self evaluatedArguments] valueForKey:@"TagID"];
  
  //Change in plan. We're now just sending the index of the field
  // we're doing this because it's easier for us to reconstitute the required elements to properly identify a complete tag - the tag name and the code file path
  NSString* tagFieldIDString = [[self evaluatedArguments] valueForKey:@"TagFieldID"];
  if(tagFieldIDString != nil)
  {
    NSNumber* fieldID = [NSNumber numberWithInteger:[[[self evaluatedArguments] valueForKey:@"TagFieldID"] integerValue]];
    
    //NSDictionary* userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:tagName, @"TagName", tagID, @"TagID", fieldID, @"TagFieldID", nil];
    NSDictionary* userInfo = [[NSDictionary alloc] initWithObjectsAndKeys: fieldID, @"TagFieldID", nil];
    
    //if(tagName != nil)
    //{
      [[NSNotificationCenter defaultCenter] postNotificationName:@"activeTagDidChange" object:self userInfo:userInfo];
    //}
  }
  
  return nil;
}
@end
