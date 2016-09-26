//
//  TagEditorViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/26/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TagEditorViewController.h"
#import "StatTag.h"
#import "ACEView/ACEView.h"
#import "ACEView/ACEModeNames.h"
#import "ACEView/ACEThemeNames.h"
#import "ACEView/ACEKeyboardHandlerNames.h"

@interface TagEditorViewController ()

@end

@implementation TagEditorViewController

@synthesize tag = _tag;
@synthesize documentManager = _documentManager;
@synthesize codeFileList = _codeFileList;
@synthesize tagFrequency = _tagFrequency;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
  if(_documentManager != nil) {
    [_tagFrequency removeObjects:[_tagFrequency arrangedObjects]];
    [_tagFrequency addObjects: [STConstantsRunFrequency GetList]];
  }
}

-(void)viewDidAppear {
  if(_documentManager != nil) {

    //every time this view appears we need to completely refresh all code files
    [_codeFileList removeObjects:[_codeFileList arrangedObjects]];
    [_codeFileList addObjects: [_documentManager GetCodeFileList]];
    
    
    //existing tag?
    if(_tag != nil) {
      self.textBoxTagName.stringValue = [_tag Name];
      
    } else {
      //probably a new tag
      
    }
    
    //in either case - we're going to default to the top-most object in the code file list
    if([[[self listCodeFile] selectedItem] representedObject] != nil) {
      STCodeFile* aCodeFile = (STCodeFile*)[[[self listCodeFile] selectedItem] representedObject];
      [self loadSourceViewFromCodeFile:aCodeFile];
    }
    
  }
}


-(void)loadSourceViewFromCodeFile:(STCodeFile*)codeFile {
  [_sourceView setString:[[codeFile Content] componentsJoinedByString:@"\r\n" ] ];
}

- (IBAction)setCodeFile:(id)sender {
  if([[[self listCodeFile] selectedItem] representedObject] != nil) {
    STCodeFile* aCodeFile = (STCodeFile*)[[[self listCodeFile] selectedItem] representedObject];
    [self loadSourceViewFromCodeFile:aCodeFile];
  }
}

- (IBAction)setFrequency:(id)sender {
}

- (IBAction)setTagName:(id)sender {
}


- (IBAction)save:(id)sender {
  //NOTE: we're not saving yet
  [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)OK];
}




@end
