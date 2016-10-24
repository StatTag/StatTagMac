//
//  SettingsViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

/*
 For word wrapping on the file path, go to the size inspector and set "first runtime layout width" under "preferred width"
 */

#import "SettingsViewController.h"
#import "StatTag.h"
#import "StatTagShared.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize buttonChooseFile;
//@synthesize buttonCancelSave;
//@synthesize buttonSave;
@synthesize checkboxLogging;
@synthesize labelFilePath;
@synthesize boxView;
@synthesize boxGeneral;


@synthesize properties = _properties;
@synthesize propertiesManager = _propertiesManager;
@synthesize logManager = _logManager;

//we don't need this one...
//NSString* const ExecutableFileFilter = @"Application Executable|*.exe";
//NSString* const LogFileFilter = @"Log File|*.log";
NSString* const allowedExtensions_Log = @"txt/TXT/log/LOG";
NSString* const defaultLogFileName = @"StatTag.log";


- (void)viewWillLayout {
  [[self boxGeneral] setBoxType:NSBoxCustom];
  [[self boxGeneral] setBorderType:NSLineBorder];
  [[self boxGeneral] setFillColor:[NSColor whiteColor]];
}

//-(void)viewDidLayout {
//  [super viewDidLayout];
////  [[self labelFilePath] setPreferredMaxLayoutWidth:[[self labelFilePath] frame].size.width];
////  [[self view] layoutSubtreeIfNeeded];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
  NSLog(@"SettingsViewController loaded");
  //  [[settingsVC propertiesManager] Load];


}

-(void)viewWillAppear {
  [[self propertiesManager] Load];
  self.properties = [[self propertiesManager] Properties]; //just for setup
  [self setup];
}

//https://www.youtube.com/watch?v=Q5bLEwewO7M
//https://www.youtube.com/watch?v=TS4H3WvIwpY
//https://www.youtube.com/watch?v=i021PhLS54E

- (void)awakeFromNib {
}

- (NSString *)nibName
{
  return @"SettingsViewController";
}

//restoring at runtime with storyboards
-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"SettingsViewController" owner:self topLevelObjects:nil];
  }
  return self;
}


-(void)setDefaultPath {
  NSFileManager* fileManager = [NSFileManager defaultManager];
  //NSString* homeDirectory = NSHomeDirectory();
  NSString* documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
  
  [[self labelFilePath] setStringValue: [documentsDirectory stringByAppendingPathComponent:defaultLogFileName]];
}

-(void)setup {
  
  [[self checkboxLogging] setState: [[self properties] EnableLogging] ? NSOnState : NSOffState];
  if([[self properties] LogLocation] != nil && [[[self properties] LogLocation] length] > 0 && ![[[self properties] LogLocation] isEqualToString:@"Log Path Not Set"] && [STLogManager IsValidLogPath: [[self properties] LogLocation]]) {
    [[self labelFilePath] setStringValue: [[self properties] LogLocation]];
  } else {
    [self setDefaultPath];
  }
  
  [self UpdateLoggingControls];
  
  //lblVersion.Text = UIUtility.GetVersionLabel();
  //lblCopyright.Text = UIUtility.GetCopyright();
  
}

- (IBAction)checkboxLoggingChanged:(id)sender {
  [self UpdateLoggingControls];
  [self saveSettings];
}

- (IBAction)labelFilePathClicked:(id)sender {
}

- (IBAction)chooseFile:(id)sender {
  
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
    {
      NSURL* url = [files objectAtIndex:i];
      if ([fileManager fileExistsAtPath:[url path] isDirectory:&isDir] && isDir) {
        url = [url URLByAppendingPathComponent:defaultLogFileName];
      }
      
      [[self labelFilePath] setStringValue:[url path]];
    }
    
    [self saveSettings];
    
  }
  
  
}

/*
- (IBAction)saveSettings:(id)sender {
  [[self Properties] setEnableLogging:[[self checkboxLogging] state ] == NSOnState ? YES : NO ];
  [[self Properties] setLogLocation:[labelFilePath stringValue]];
  
//  NSLog(@"[[self Properties] EnableLogging] = %hhd", [[self Properties] EnableLogging]);
//  NSLog(@"[[self Properties] LogLocation] = %@", [[self Properties] LogLocation]);
//  NSLog(@"[STLogManager IsValidLogPath: [[self Properties] LogLocation]] = %hhd", [STLogManager IsValidLogPath: [[self Properties] LogLocation]]);
  
  if ([[self Properties] EnableLogging] && ![STLogManager IsValidLogPath: [[self Properties] LogLocation]])
  {
    [STUIUtility WarningMessageBox:@"The debug file you have selected appears to be invalid, or you do not have rights to access it.\r\nPlease select a valid path for the debug file, or disable debugging." logger:nil];
    //DialogResult = DialogResult.None;
  } else {
    [[self PropertiesManager] setProperties:[self Properties]];
    [[self PropertiesManager] Save];
    [[self LogManager] UpdateSettings:[self Properties]];
  }
//  [[self window] close];
}
*/

//- (IBAction)cancelSave:(id)sender {
//  //unclear if this exists in 10.7... I'd expect a compiler warning
//  //[self.window.sheetParent endSheet:self.window];
//  [[self window] close];
//}


-(void)saveSettings {
  [[self properties] setEnableLogging:[[self checkboxLogging] state ] == NSOnState ? YES : NO ];
  [[self properties] setLogLocation:[labelFilePath stringValue]];
  
  if ([[self properties] EnableLogging] && ![STLogManager IsValidLogPath: [[self properties] LogLocation]])
  {
    [STUIUtility WarningMessageBox:@"The debug file you have selected appears to be invalid, or you do not have rights to access it.\r\nPlease select a valid path for the debug file, or disable debugging." logger:nil];
  } else {
    [[self propertiesManager] setProperties:[self properties]];
    [[self propertiesManager] Save];
    [[self logManager] UpdateSettings:[self properties]];
//    [[self logPathControl] setURL:[NSURL URLWithString:[[[self properties] LogLocation] stringByExpandingTildeInPath]]];
  }
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
