//
//  StatTagShared.h
//  StatTag
//
//  Created by Eric Whitley on 9/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@class MainTabViewController;
@class STMSWord2011Application;
@class STMSWord2011Document;
@class STDocumentManager;
@class ManageCodeFilesViewController;
@class STPropertiesManager;
@class STLogManager;
@class StatTagNeedsWordViewController;

@interface StatTagShared : NSObject {
  MainTabViewController* _mainVC;
  STMSWord2011Application* _app;
  STMSWord2011Document* _doc;
  STDocumentManager* _docManager;
  STPropertiesManager* _propertiesManager;
  STLogManager* _pogManager;
  //  NSWindow* _mainWindow;
}

+ (id)sharedInstance;

//StatTag objects
@property (strong, nonatomic) STMSWord2011Application* app;
@property (strong, nonatomic) STMSWord2011Document* doc;
@property (strong, nonatomic) STDocumentManager* docManager;
@property (strong, nonatomic) STPropertiesManager* propertiesManager;
@property (strong, nonatomic) STLogManager* logManager;
@property (strong, nonatomic) StatTagNeedsWordViewController* needsWordController;
@property (strong, nonatomic) ManageCodeFilesViewController* codeFilesViewController;

@property (strong, nonnull) NSString* wordAppStatusMessage;
@property BOOL wordAccessible;

//view controller accessors
@property (strong, nonatomic) MainTabViewController* mainVC; //weak?

+ (NSColor*)colorFromRGBRed:(CGFloat)r  green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a;

@property (weak, nonatomic) NSWindow* window;

-(void)initializeWordViews;

@property NSRect archivedWindowFrame;

typedef enum {
  ManageCodeFiles = 0,
  Settings = 1,
  UpdateOutput = 2
} StatTagTabIndexes;

typedef enum {
  OK = 0,
  Error = 1,
  Cancel = 2
} StatTagResponseState;


extern NSString* const kStatTagErrorDomain = @"STErrorDomain";

@end
