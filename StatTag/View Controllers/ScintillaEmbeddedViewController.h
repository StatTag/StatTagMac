//
//  ScintillaEmbeddedViewController.h
//  StatTag
//
//  Created by Eric Whitley on 4/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SCNotification;
@protocol ScintillaNotificationProtocol
- (void)notification: (SCNotification*)notification;
@end

@class ScintillaView;

@interface ScintillaEmbeddedViewController : NSViewController <ScintillaNotificationProtocol>
{
  ScintillaView* _sourceEditor;
  BOOL _usesInfoBar;
  BOOL _editable;
}

@property (strong, nonatomic) ScintillaView *sourceEditor;
@property (weak) IBOutlet NSView *sourceView;
@property BOOL usesInfoBar;
@property BOOL editable;

-(void)loadSource:(NSString*)source withPackageIdentifier:(NSString*)packageType;

-(NSArray<NSString*>*)GetSelectedText;
-(NSArray<NSNumber*>*)GetSelectedIndices;
-(void)EmptyUndoBuffer;

@end
