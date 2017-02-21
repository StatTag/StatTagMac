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

@implementation STAppleScript_OpenSettings

-(id)performDefaultImplementation {

  StatTagShared* shared = [StatTagShared sharedInstance];
//  [[[shared mainVC] tabView] selectTabViewItemAtIndex:(StatTagTabIndexes)ManageCodeFiles];

  [[[shared mainVC] tabView] selectTabViewItemWithIdentifier:@"Settings"];
  
  //https://forums.developer.apple.com/thread/9991
  
  return nil;
}
@end


@implementation STAppleScript_OpenManageCodeFiles

-(id)performDefaultImplementation {
  
  StatTagShared* shared = [StatTagShared sharedInstance];
  //  [[[shared mainVC] tabView] selectTabViewItemAtIndex:(StatTagTabIndexes)ManageCodeFiles];
  
  [[[shared mainVC] tabView] selectTabViewItemWithIdentifier:@"ManageCodeFiles"];
  
  //https://forums.developer.apple.com/thread/9991
  
  return nil;
}
@end


@implementation STAppleScript_UpdateFields

-(id)performDefaultImplementation {
  StatTagShared* shared = [StatTagShared sharedInstance];
  [[[shared mainVC] tabView] selectTabViewItemWithIdentifier:@"UpdateOutput"];
  
  //if a tag argument was sent in...
  //let's now see if we can find the tag by name/id and open it
  NSDictionary<NSString*, id>* args = [self evaluatedArguments];
  NSLog(@"UpdateOutput: num args -> %ld", [args count]);
  NSString* keys = [[args allKeys] componentsJoinedByString:@","];
  NSLog(@"UpdateOutput: keys ->%@", keys);
  //NSLog(@"UpdateOutput: keys ->%@", [args allKeys]);
  
  //1) detect the tags in the current document
  //2) match the tag (if possible)
  //3) if the tag is matched, select it in the table
  //4) open the UI for the tag editor
  NSString* tagName = [[self evaluatedArguments] valueForKey:@"TagName"];
  STTag* tag = [[[StatTagShared sharedInstance] tagsViewController] selectTagWithName:tagName];
  NSLog(@"tag name : %@", [tag Name]);
  if(tag != nil)
  {
    [[[StatTagShared sharedInstance] tagsViewController] editTag:nil];
  }
  
  NSLog(@"%@", args);
  
  return nil;
}
@end

