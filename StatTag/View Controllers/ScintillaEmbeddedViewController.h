//
//  ScintillaEmbeddedViewController.h
//  StatTag
//
//  Created by Eric Whitley on 4/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//#import "Scintilla/Scintilla.h"
#import "Scintilla/ScintillaView.h"
//#import "Scintilla/InfoBar.h"


//@class SCNotification;
//@protocol ScintillaNotificationProtocol
//- (void)notification: (SCNotification*)notification;
//@end

@class ScintillaView;
@class SCLine;

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

-(void)SetLineMarker:(SCLine*)line andMark:(BOOL)mark;
-(NSArray<NSString*>*)GetSelectedText;
-(NSArray<NSNumber*>*)GetSelectedIndices;
-(void)EmptyUndoBuffer;
-(NSArray<SCLine*>*)GetSelectedLines;
-(NSString*)string;

-(void)setLineMarkerAtIndex:(NSInteger)index;
-(void)scrollToLine:(NSInteger)startIndex;

-(void)showLineNumbers;
-(void)hideLineNumbers;

-(void)showSelectionMargin;
-(void)hideSelectionMargin;



@end
