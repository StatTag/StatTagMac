//
//  TagBasicPropertiesController.h
//  StatTag
//
//  Created by Eric Whitley on 10/2/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DisclosureViewController.h"

//protocol for interacting with this control
@class TagBasicPropertiesController;
@protocol TagBasicPropertiesControllerDelegate <NSObject>
- (void)tagFrequencyDidChange:(TagBasicPropertiesController*)controller;
- (void)tagNameDidChange:(TagBasicPropertiesController*)controller;
- (void)tagNameDidFinishEditing:(TagBasicPropertiesController*)controller;
- (void)tagTypeDidChange:(TagBasicPropertiesController*)controller;
@end


@class STTag;

@interface TagBasicPropertiesController : NSViewController {
  
}

@property (strong) STTag* tag;

//tag name
@property (weak) IBOutlet NSTextField *tagNameLabel;
@property (weak) IBOutlet NSTextField *tagNameTextbox;

//tag refresh frequency
@property (weak) IBOutlet NSTextField *tagFrequencyLabel;
@property (weak) IBOutlet NSPopUpButton *tagFrequencyList;
@property (strong) IBOutlet NSArrayController *tagFrequencyArrayController;

@property (weak) IBOutlet NSTextField *tagTypeLabel;
@property (weak) IBOutlet NSPopUpButton *tagTypeList;
@property (strong) IBOutlet NSArrayController *tagTypeArrayController;


//delegate
@property (nonatomic, weak) id<TagBasicPropertiesControllerDelegate> delegate;

@end
