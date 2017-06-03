//
//  DuplicateTagRenameViewController.m
//  StatTag
//
//  Created by Eric Whitley on 6/1/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "DuplicateTagRenameViewController.h"
#import "StatTagFramework.h"
#import "STCodeFile+FileAttributes.h"

@interface DuplicateTagRenameViewController ()

@end


@implementation DuplicateTagRenameViewController

@synthesize canRename = _canRename;
@synthesize duplicateTag = _duplicateTag;
@synthesize documentManager = _documentManager;

STCodeFile* _codeFile;
STTag* _renamedTag;

//MARK: storyboard / nib setup
- (NSString *)nibName
{
  return @"DuplicateTagRenameViewController";
}

-(id)init {
  self = [super init];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}

-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  return self;
}

//MARK: standard view controller events

- (void)awakeFromNib {
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewDidAppear
{
  
  [[self replacementTagNameTextField] setStringValue:@""];
  
  //existing tag
  _renamedTag = [[STTag alloc] initWithTag:[self duplicateTag]];
  _codeFile = [_renamedTag CodeFile];
  
  [[self currentTagNameTextField] setStringValue:[[self duplicateTag] Name]];
  allTagNames = [[NSMutableArray<NSString*> alloc] init];
  
  for(STCodeFile* cf in [_documentManager GetCodeFileList])
  {
    if([cf fileAccessibleAtPath])
    {
      //[allTags addObjectsFromArray:[cf Tags]];
      [allTagNames addObjectsFromArray:[[cf Tags] valueForKey:@"Name"]];
    }
  }
  
  NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
  NSSet<NSString*>* allTagNamesSet = [NSSet setWithArray:allTagNames];
  allTagNames = [NSMutableArray arrayWithArray:[allTagNamesSet sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]]];

  
  [self setCanRename:NO];
}

-(void)validateReplacementTagName:(NSString*)replacementName
{
  //set canRename to something - use bindings to do the rest
  
  //let's do a case insenitive comparison of the names
  if ([replacementName length] <= 0 || [[allTagNames valueForKey:@"lowercaseString"] containsObject:[replacementName lowercaseString]])
  {
    //not valid, so show the warning labels and disable the submit button
    [self setCanRename:NO];
  } else {
    //valid, so disable the warnings and enable the submit button
    [self setCanRename:YES];
  }
}

-(void)dismissControllerWithReturnCode:(StatTagResponseState)returnCode
{
  if([[self delegate] respondsToSelector:@selector(dismissTagRenameController:withReturnCode:)]) {
    [[self delegate] dismissTagRenameController:self withReturnCode:returnCode];
  }
}


- (IBAction)cancelButtonClick:(id)sender {
  [self dismissControllerWithReturnCode:Cancel];
}
- (IBAction)renameButtonClick:(id)sender {
  
  //assumption: the tag name has been pre-validated as a part of our normal cocoa-binding validation on text entry
  
  [_renamedTag setName:[[self replacementTagNameTextField] stringValue]];
  
  STUpdatePair<STTag*>* pair = [[STUpdatePair alloc] init];
  pair.Old = [self duplicateTag];
  pair.New = _renamedTag;
  
  //FIXME: we should circle back on this and see how we're handling errors - this is fishy

  @try {
    [_documentManager UpdateRenamedTags:[[NSArray<STUpdatePair<STTag*>*> alloc] initWithObjects:pair, nil]];
    [self dismissControllerWithReturnCode:OK];
  }
  @catch (NSException* exc) {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Could not rename tag"];
    [alert setInformativeText:@"We're sorry, but we were unable to rename this tag."];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"OK"];
    [alert beginSheetModalForWindow:[[self view] window] completionHandler:^(NSModalResponse returnCode) {
      if (returnCode == NSAlertFirstButtonReturn) {
        //if we want to do something later
        //FIXME: add this to our debug log
      }
    }];
  }

}


//MARK: text delegates
//as we type, validate the proposed new tag name against the list of known tag names
- (void)controlTextDidChange:(NSNotification *)notification {
  NSTextField *textField = [notification object];
  NSLog(@"controlTextDidChange:%@", [textField stringValue]);
  [self validateReplacementTagName:[textField stringValue]];
}
//submit on return
- (void)controlTextDidEndEditing:(NSNotification *)notification {
  NSTextField *textField = [notification object];
  if([[[notification userInfo] objectForKey:@"NSTextMovement"] integerValue] == NSReturnTextMovement)
  {
    [self validateReplacementTagName:[textField stringValue]];
    if([self canRename])
    {
      [self renameButtonClick:[self renameButton]];
    }
  }
}


@end
