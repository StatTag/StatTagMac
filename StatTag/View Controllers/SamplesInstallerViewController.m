//
//  SamplesInstallerViewController.m
//  StatTag
//
//  Created by Eric Whitley on 5/26/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "SamplesInstallerViewController.h"
#import <StatTagFramework/STCocoaUtil.h>
#import "NSURL+FileAccess.h"

@interface SamplesInstallerViewController ()

@end

@implementation SamplesInstallerViewController

static NSString* StatTagSampleDefaultUserPathKey = @"StatTag Samples Location";
  
//MARK: storyboard / nib setup
- (NSString *)nibName
{
  return @"SamplesInstallerViewController";
}
  
-(id)init {
  self = [super init];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  [self setup];
  return self;
}
  
-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self topLevelObjects:nil];
  }
  [self setup];
  return self;
}

-(void)setup
{
  if([self fileSourceURI] == nil)
  {
    [self setFileSourceURI:[[NSURL alloc] initWithString:@"https://github.com/StatTag/Simple-Code-Examples/archive/master.zip"]];
  }

  self.downloadProgressViewController = [[SamplesDownloadProgressViewController alloc] init];
  [[self downloadProgressViewController] setDelegate:self];
  
  // leaving the info here on how to get access to the custom "downloads" folder icon
  // leaving this in here as an example in case we want to change this later - wasn't easy to find
  // originally had a dropdown with the default "downloads" directory - then "other..." as an option
  // changed this for the time being

  //apple restricted icons located at
  // /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources
  // you can't really use these
  // to get a handle on the folder icon, you need to pull it from the workspace

  //  NSMenuItem* item = [[[self downloadPathPopUp] menu] itemWithTag:1];
  //  //fix our download folder icon
  //  NSImage* icon = [[NSWorkspace sharedWorkspace] iconForFileType:NSFileTypeForHFSTypeCode(kToolbarDownloadsFolderIcon)];
  //  [item setImage:icon];
  
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewDidAppear
{
}

- (IBAction)changeFilePath:(id)sender
{
  
  NSOpenPanel* openPanel = [NSOpenPanel openPanel];
  [openPanel setCanChooseFiles:NO];
  [openPanel setCanChooseDirectories:YES];
  [openPanel setCanCreateDirectories:YES];
  [openPanel setCanSelectHiddenExtension:NO];
  [openPanel setPrompt:@"Select a folder"];
  [openPanel setAllowsMultipleSelection:NO];
  
  
  //BOOL isDir;
  //NSFileManager* fileManager = [NSFileManager defaultManager];
  
  if ( [openPanel runModal] == NSModalResponseOK )
  {
    NSArray<NSURL*>* files = [openPanel URLs];
    NSURL* folderPath = [files firstObject];
    [self setDefaultDownloadFolderURI:folderPath];
  }
  
}



- (IBAction)startDownload:(id)sender {
  
  //https://developer.apple.com/library/content/documentation/UserExperience/Conceptual/OSXHIGuidelines/SystemProvided.html
  
  if([[self defaultDownloadFolderURI] canWriteToFileAtPath])
  {
    [[self downloadProgressViewController] setDownloadSourceFileURL:[self fileSourceURI]];
    [[self downloadProgressViewController] setDownloadTargetDirectoryURL:[self defaultDownloadFolderURI]];
    [self presentViewControllerAsSheet:[self downloadProgressViewController]];
  } else {
    //selected path can't be written to - notify user

    NSString* alertText = [NSString stringWithFormat:@"The requested installation path cannot be used. You do not have permissions to write to this directory (%@). Please choose another directory.", [self defaultDownloadFolderURI]];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Cannot write to requested directory"];
    [alert setInformativeText:alertText];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];
    
  }
  
}

-(NSString*)defaultDownloadFolderPath
{
  return [[self defaultDownloadFolderURI] path];
}

-(NSURL*)defaultDownloadFolderURI
{

  NSDictionary* prefsDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]];
  
  //let's see if we have a setting from previous installations
  NSString *urlString = [prefsDict objectForKey:StatTagSampleDefaultUserPathKey];

  if(urlString != nil)
  {
    NSURL *targetPathURI = [NSURL fileURLWithPath:urlString];
    if(targetPathURI != nil && [targetPathURI canWriteToFileAtPath])
    {
      //now let's see if that path is accessible
      return targetPathURI;
    }
  }
  
  NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
  return [[NSURL alloc] initWithString:[dirs firstObject]];
}

-(void)setDefaultDownloadFolderURI:(NSURL*)defaultDownloadFolderURI
{
  
  [self willChangeValueForKey:@"defaultDownloadFolderPath"];
  
  NSMutableDictionary* prefs = [[NSMutableDictionary alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] persistentDomainForName:[STCocoaUtil currentBundleIdentifier]]];
  [prefs setValue:[defaultDownloadFolderURI path] forKey:StatTagSampleDefaultUserPathKey];
  [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefs forName:[STCocoaUtil currentBundleIdentifier]];
  
  [[NSUserDefaults standardUserDefaults] synchronize];

  [self didChangeValueForKey:@"defaultDownloadFolderPath"];

  
}


//MARK: process view delegate
-(void)dismissSamplesDownloadProgressViewController:(SamplesDownloadProgressViewController *)controller withReturnCode:(StatTagResponseState)returnCode andMessage:(NSString *)message andError:(NSError *)error
{
  [self dismissViewController:controller];

  NSAlert *alert = [[NSAlert alloc] init];
  [alert addButtonWithTitle:@"Ok"];

  NSString* alertText = [NSString stringWithFormat:@"Samples have been downloaded to\n\n %@", [[self defaultDownloadFolderURI] path]];
  [alert setMessageText:@""];
  [alert setAlertStyle:NSInformationalAlertStyle];

  
  if(returnCode == Error)
  {
    alertText = @"Unable to download samples";
    if(error != nil)
    {
      [alert setMessageText:[error localizedDescription]];
    } else {
      [alert setMessageText:@"There was a problem downloading the samples. Please ensure you have an active Internet connection."];
    }
    [alert setAlertStyle:NSWarningAlertStyle];
  }
  
  [alert setInformativeText:alertText];
  [alert runModal];
  
  if(returnCode == OK)
  {
    [[NSWorkspace sharedWorkspace] selectFile:[[self defaultDownloadFolderURI] path] inFileViewerRootedAtPath:[[self defaultDownloadFolderURI] path]];
    [[[self view] window] close];
  }

}

@end
