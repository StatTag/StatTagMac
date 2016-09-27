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
#import "StatTagShared.h"

@interface TagEditorViewController ()

@end

@implementation TagEditorViewController

@synthesize tag = _tag;
@synthesize documentManager = _documentManager;
@synthesize codeFileList = _codeFileList;
@synthesize tagFrequency = _tagFrequency;

BOOL changedCodeFile = false;
STCodeFile* codeFile;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
  if(_documentManager != nil) {
    [_tagFrequency removeObjects:[_tagFrequency arrangedObjects]];
    [_tagFrequency addObjects: [STConstantsRunFrequency GetList]];
  }
  [_sourceView setDelegate:self];
  [_sourceView setTheme:ACEThemeXcode];
  [_sourceView setKeyboardHandler:ACEKeyboardHandlerAce];
  [_sourceView setShowPrintMargin:NO];
  [_sourceView setShowInvisibles:YES];
  [_sourceView setBasicAutoCompletion:YES];
  [_sourceView setLiveAutocompletion:YES];
  [_sourceView setSnippets:YES];
  [_sourceView setEmmet: YES];

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
    [self setCodeFile:nil];
    
  }
}


-(void)loadSourceViewFromCodeFile:(STCodeFile*)codeFile {
  [_sourceView setString:[[codeFile Content] componentsJoinedByString:@"\r\n" ] ];
  
  //yeah - I know - it's not smart to do this with hardcoded comparisons
  //  - but I'm just working through it for now
  if([[codeFile StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages Stata]]) {
    [_sourceView setMode:ACEModeStata];
  } else if([[codeFile StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages R]]) {
    [_sourceView setMode:ACEModeR];
  } else if([[codeFile StatisticalPackage] isEqualToString: [STConstantsStatisticalPackages SAS]]) {
    //[_sourceView setMode:ACEModeSAS]; //don't have SAS yet
    [_sourceView setMode:ACEModeHTML];
  } else {
    [_sourceView setMode:ACEModeHTML];
  }
  

  
}

- (IBAction)setCodeFile:(id)sender {
  if([[[self listCodeFile] selectedItem] representedObject] != nil) {
    STCodeFile* aCodeFile = (STCodeFile*)[[[self listCodeFile] selectedItem] representedObject];
    codeFile = aCodeFile;
    [self loadSourceViewFromCodeFile:codeFile];
    changedCodeFile = false; //we just reset the code file so set this back
  }
}

- (IBAction)setFrequency:(id)sender {
}

- (IBAction)setTagName:(id)sender {
}


- (void) textDidChange:(NSNotification *)notification {
  // Handle text changes
  changedCodeFile = true;
  NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (IBAction)cancel:(id)sender {
  [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)Cancel];
}


- (IBAction)save:(id)sender {
  //NOTE: we're not saving yet
  
  NSError* saveError;

  if(changedCodeFile) {
    codeFile.Content = [NSMutableArray arrayWithArray:[[_sourceView string] componentsSeparatedByString: @"\r\n"]];
    [codeFile Save:&saveError];
  }

  if(! [[_tag Name] isEqualToString: [_textBoxTagName stringValue]]  ) {
    //the name has been changed - so update it
    //first see if we have a duplicate tag name

    //tag names must be unique within a code file
    // it's allowed (but not ideal) for them to be duplicated between code files
    
    for(STTag* aTag in [codeFile Tags]) {
      if ([[aTag Name] isEqualToString:[_textBoxTagName stringValue]] && ![aTag isEqual:_tag]){
        //is the tag name reused (other than this tag)?
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:[NSString stringWithFormat:@"The tag name %@ is already used in code file %@", [aTag Name], [codeFile FileName]] forKey:NSLocalizedDescriptionKey];
        saveError = [NSError errorWithDomain:@"com.stattag.StatTag" code:100 userInfo:errorDetail];
      }
    }
  }

  if(saveError != nil) {
    //oops! something bad happened - tell the user
    [NSApp presentError:saveError];
    
  } else {
    [_delegate dismissTagEditorController:self withReturnCode:(StatTagResponseState)OK];
  }
  
}




@end
