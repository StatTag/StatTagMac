//
//  STSettingsController.m
//  StatTag
//
//  Created by Eric Whitley on 8/3/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STSettingsController.h"
#import "StatTag.h"

@interface STSettingsController ()

@end




@implementation STSettingsController
@synthesize buttonChooseFile;
@synthesize buttonCancelSave;
@synthesize buttonSave;
@synthesize checkboxLogging;
@synthesize labelFilePath;
@synthesize boxView;
@synthesize boxGeneral;


@synthesize Properties = _Properties;
@synthesize PropertiesManager = _PropertiesManager;
@synthesize LogManager = _LogManager;

//we don't need this one...
//NSString* const ExecutableFileFilter = @"Application Executable|*.exe";
//NSString* const LogFileFilter = @"Log File|*.log";
NSString* const allowedExtensions_Log = @"txt/TXT/log/LOG";
NSString* const defaultLogFileName = @"StatTag.log";

- (void)windowDidLoad {
  [super windowDidLoad];
  [self setup];
  //var dialog = new Settings(PropertiesManager.Properties);
//  self.boxView.fillC
  
  //self.boxView.setF
  [[self boxGeneral] setBoxType:NSBoxCustom];
  [[self boxGeneral] setBorderType:NSLineBorder];
  [[self boxGeneral] setFillColor:[NSColor whiteColor]];
  
  //[[self boxView] setWantsLayer:YES];
  //[[[self boxView] layer] setBackgroundColor:[[NSColor whiteColor] CGColor]];
}

- (void)windowWillClose:(NSNotification *)notification {
  [[NSApplication sharedApplication] stopModal];
  //also -> stopModalWithCode: someInteger;
}

- (void)windowDidBecomeKey:(NSNotification*)notification
{
//  ++timesShown;
//  NSString* newTitle= [NSString stringWithFormat:@"Shown %d Times", timesShown];
//  [[self window] setTitle:newTitle];
}


//we're not likely to use this...
//-(instancetype)initWithProperties:(STProperties*)properties {
//  self = [super init];
//  if(self) {
//    self.Properties = properties;
//    //UIUtility.SetDialogTitle(this);
//  }
//  return self;
//}

-(void)setDefaultPath {
  NSFileManager* fileManager = [NSFileManager defaultManager];
  //NSString* homeDirectory = NSHomeDirectory();
  NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

  [[self labelFilePath] setStringValue: [documentsDirectory stringByAppendingPathComponent:defaultLogFileName]];
}

-(void)setup {
  
  [[self checkboxLogging] setState: [[self Properties] EnableLogging] ? NSOnState : NSOffState];
  if([[self Properties] LogLocation] != nil && [[[self Properties] LogLocation] length] > 0 && ![[[self Properties] LogLocation] isEqualToString:@"Log Path Not Set"] && [STLogManager IsValidLogPath: [[self Properties] LogLocation]]) {
    [[self labelFilePath] setStringValue: [[self Properties] LogLocation]];
  } else {
    [self setDefaultPath];
  }
  
  [self UpdateLoggingControls];
  
  //lblVersion.Text = UIUtility.GetVersionLabel();
  //lblCopyright.Text = UIUtility.GetCopyright();
  
}

- (IBAction)checkboxLoggingChanged:(id)sender {
  [self UpdateLoggingControls];
}

- (IBAction)labelFilePathClicked:(id)sender {
}

- (IBAction)chooseFile:(id)sender {
  
//  var logPath = UIUtility.GetFileName(LogFileFilter, false);
//  if (!string.IsNullOrWhiteSpace(logPath))
//  {
//    txtLogLocation.Text = logPath;
//  }

  NSOpenPanel* openPanel = [NSOpenPanel openPanel];
  [openPanel setCanChooseFiles:YES];
  [openPanel setCanChooseDirectories:YES];
  [openPanel setCanSelectHiddenExtension:NO];
  [openPanel setPrompt:@"Select a File"];
  [openPanel setAllowsMultipleSelection:NO];
  
  
  NSArray<NSString*>* types = [allowedExtensions_Log pathComponents];
  [openPanel setAllowedFileTypes:types];


  BOOL isDir;
  NSFileManager* fileManager = [NSFileManager defaultManager];
  
  if ( [openPanel runModal] == NSOKButton )
  {
    NSArray<NSURL*>* files = [openPanel URLs];

    for( int i = 0; i < [files count]; i++ )
    //for(NSURL* url in files)
    {
      NSURL* url = [files objectAtIndex:i];
      if ([fileManager fileExistsAtPath:[url path] isDirectory:&isDir] && isDir) {
        url = [url URLByAppendingPathComponent:defaultLogFileName];
      }
      
      [[self labelFilePath] setStringValue:[url path]];
    }
  }
  
  
}

- (IBAction)saveSettings:(id)sender {
  [[self Properties] setEnableLogging:[[self checkboxLogging] state ] == NSOnState ? YES : NO ];
  [[self Properties] setLogLocation:[labelFilePath stringValue]];
  
  NSLog(@"[[self Properties] EnableLogging] = %hhd", [[self Properties] EnableLogging]);
  NSLog(@"[[self Properties] LogLocation] = %@", [[self Properties] LogLocation]);
  NSLog(@"[STLogManager IsValidLogPath: [[self Properties] LogLocation]] = %hhd", [STLogManager IsValidLogPath: [[self Properties] LogLocation]]);
  
  if ([[self Properties] EnableLogging] && ![STLogManager IsValidLogPath: [[self Properties] LogLocation]])
  {
    [STUIUtility WarningMessageBox:@"The debug file you have selected appears to be invalid, or you do not have rights to access it.\r\nPlease select a valid path for the debug file, or disable debugging." logger:nil];
    //DialogResult = DialogResult.None;
  } else {
    [[self PropertiesManager] setProperties:[self Properties]];
    [[self PropertiesManager] Save];
    [[self LogManager] UpdateSettings:[self Properties]];
  }
  [[self window] close];
}

- (IBAction)cancelSave:(id)sender {
  //unclear if this exists in 10.7... I'd expect a compiler warning
  //[self.window.sheetParent endSheet:self.window];
  [[self window] close];
}


-(void) UpdateLoggingControls
{
  BOOL enabled = [[self checkboxLogging] state]  == NSOnState ? YES : NO ;
  if (enabled == NO) {
    [[self labelFilePath] setTextColor:[NSColor grayColor]];
  } else {
    [[self labelFilePath] setTextColor:[NSColor controlTextColor]];
  }
}



@end
