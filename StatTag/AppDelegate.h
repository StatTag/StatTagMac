//
//  AppDelegate.h
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//@class MainTabViewController;
//@class STMSWord2011Application;
//@class STMSWord2011Document;
//@class STDocumentManager;
//@class ManageCodeFilesViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
//  MainTabViewController* _mainVC;
//  STMSWord2011Application* _app;
//  STMSWord2011Document* _doc;
//  STDocumentManager* _manager;
}

//@property (strong, nonatomic) STMSWord2011Application* app;
//@property (strong, nonatomic) STMSWord2011Document* doc;
//@property (strong, nonatomic) STDocumentManager* manager;
//
//@property (strong, nonatomic) MainTabViewController* mainVC; //weak?


@property (weak) NSWindow* window;

//-(BOOL)enablePreferences;

@end

