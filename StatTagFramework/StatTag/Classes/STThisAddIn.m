//
//  STThisAddIn.m
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STThisAddIn.h"
#import "STMSWord2011.h"
#import "STCocoaUtil.h"
#import "STLogManager.h"
#import "STDocumentManager.h"
#import "STStatsManager.h"
#import "STPropertiesManager.h"
#import "STProperties.h"
#import "STUIUtility.h"
#import "STFileHandler.h"
#import "STCodeFile.h"


@implementation STThisAddIn

@synthesize AppBundleIdentifier = _AppBundleIdentifier;
@synthesize Application = _Application;
@synthesize LogManager = _LogManager;
@synthesize DocumentManager = _DocumentManager;
@synthesize StatsManager = _StatsManager;
@synthesize PropertiesManager = _PropertiesManager;
@synthesize applicationVersion = _applicationVersion;

+(NSArray<NSString*>*) ProcessNames {
  return [NSArray arrayWithObjects:
          @"com.microsoft.Word",
          nil];
}

+(NSString*)determineInstalledAppBundleIdentifier {
  for(NSString* bundleID in [[self class]ProcessNames]) {
    if ([STCocoaUtil appIsPresentForBundleID:bundleID]) {
      return bundleID;
    }
  }
  return nil;
}

-(instancetype)init {
  self = [super init];
  if(self) {
    _AppBundleIdentifier = [[self class] determineInstalledAppBundleIdentifier];
    if([[self class] IsAppInstalled]){
      _Application = [SBApplication applicationWithBundleIdentifier:_AppBundleIdentifier];
      _LogManager = [[STLogManager alloc] init];
      _DocumentManager = [[STDocumentManager alloc] init];
      
      _StatsManager = [[STStatsManager alloc] init:[self DocumentManager]];
      _PropertiesManager = [[STPropertiesManager alloc] init];

      [[self PropertiesManager] Load];
      [[self LogManager] UpdateSettings:[[[self PropertiesManager] Properties] EnableLogging]  filePath:[[[self PropertiesManager] Properties] LogLocation]];
      _DocumentManager.Logger = [self LogManager];
      
      NSArray* versionParts = [[_Application applicationVersion] componentsSeparatedByString:@"."];
      if(versionParts.count > 0) {
        _applicationVersion = [NSNumber numberWithInt:[[versionParts firstObject] intValue]];
      } else {
        _applicationVersion = [NSNumber numberWithInt:0];
      }
      
      
      //[self ThisAddIn_Startup];
    }
  }
  return self;
}

+(BOOL)IsAppInstalled {
  return [STCocoaUtil appIsPresentForBundleID:[[self class] determineInstalledAppBundleIdentifier]];
}

+(BOOL)IsAppRunning {
  STMSWord2011Application *s = [SBApplication applicationWithBundleIdentifier:[[self class] determineInstalledAppBundleIdentifier]];
  if([s isRunning]) {
    return true;
  }
  return false;
}

+(NSURL*)AppPath {
  return [STCocoaUtil appURLForBundleId:[[self class] determineInstalledAppBundleIdentifier]];
}

-(NSArray<NSRunningApplication*>*)getRunningApps {
  if(_AppBundleIdentifier != nil) {
    return [NSRunningApplication runningApplicationsWithBundleIdentifier:_AppBundleIdentifier];
  }
  return nil;
}



//FIXME: incomplete implementation - just stubbing this out to test Word

/**
 Perform a safe get of the active document.  There is no other way to safely
 check for the active document, since if it is not set it throws an exception.
*/
-(STMSWord2011Document*)SafeGetActiveDocument {
  @try {
    return [[self Application] activeDocument];
  }
  @catch (NSException* exception) {
    NSLog(@"%@", exception.reason);
    NSLog(@"method: %@, line : %d", NSStringFromSelector(_cmd), __LINE__);
    NSLog(@"%@", [NSThread callStackSymbols]);

    NSLog(@"Getting ActiveDocument threw an exception : %@", exception.reason);
  }
  @finally {
  }
  return nil;
}

/**
 Called when the add-in is started up.  This performs basic initialization and one-time setup for running in a Word session.
*/
-(void)ThisAddIn_Startup {
  _StatsManager = [[STStatsManager alloc] init:[self DocumentManager]];

  // We'll load at Startup but won't save on Shutdown.  We only save when the user makes
  // a change and then confirms it through the Settings dialog.
  [[self PropertiesManager] Load];
  [[self LogManager] UpdateSettings:[[[self PropertiesManager] Properties] EnableLogging]  filePath:[[[self PropertiesManager] Properties] LogLocation]];
  [[self LogManager] WriteMessage:@"Startup completed"];
  _DocumentManager.Logger = [self LogManager];
  //  AfterDoubleClickErrorCallback += OnAfterDoubleClickErrorCallback;

  @try {
    // When you double-click on a document to open it (and Word is closed), the DocumentOpen event isn't called.
    // We will process the DocumentOpen event when the add-in is initialized, if there is an active document
    STMSWord2011Document* document = [self SafeGetActiveDocument];
    if(document == nil) {
      [[self LogManager] WriteMessage:@"Active document not accessible"];
    } else {
      [[self LogManager] WriteMessage:[NSString stringWithFormat:@"Active document is %@", [document name]]];
      [self Application_DocumentOpen:document];
    }
  }
  @catch (NSException* exc) {
    [STUIUtility ReportException:exc userMessage:@"There was an unexpected error when trying to initialize StatTag.  Not all functionality may be available." logger:[self LogManager]];
  }
}

/**
 Perform some customization to document metadata before the document is actually saved.
*/
-(void)Application_DocumentBeforeSave:(STMSWord2011Document*)doc //, ref bool saveAsUI, ref bool cancel)
{
  [[self LogManager] WriteMessage:@"DocumentBeforeSave - preparing to save code files to document"];
  
  @try
  {
    [[self DocumentManager] SaveCodeFileListToDocument:doc];
  }
  @catch (NSException* exc)
  {
    [STUIUtility ReportException:exc userMessage:@"There was an error while trying to save the document.  Your StatTag data may not be saved." logger:[self LogManager]];
  }
  
  [[self LogManager] WriteMessage:@"DocumentBeforeSave - code files saved"];
}


/**
 Handle initailization when a document is opened.  This may be called multiple times in a single Word session.
*/
-(void)Application_DocumentOpen:(STMSWord2011Document*)doc {
  [[self LogManager] WriteMessage:@"DocumentOpen - Started"];
  [[self DocumentManager] LoadCodeFileListFromDocument:doc];
  NSArray<STCodeFile*>* files = [[self DocumentManager] GetCodeFileList:doc];

  [[self LogManager] WriteMessage:[NSString stringWithFormat:@"Loaded %d code files from document", [files count]]];

  NSMutableArray<STCodeFile*>* filesNotFound = [[NSMutableArray<STCodeFile*> alloc] init];
  for(STCodeFile* file in files) {
    NSError* err;
    if(![STFileHandler Exists:[file FilePathURL] error:&err]) {
      [filesNotFound addObject:file];
      [[self LogManager] WriteMessage:[NSString stringWithFormat:@"Code file: %@ not found", [file FilePath]]];
    }
    else
    {
      //NOTE: deviation from Windows version - we're setting the LoadTagsFromContent to TRUE (it was FALSE)
      [file LoadTagsFromContent:true];// Skip saving the cache, since this is the first load

      @try
      {
        [[self LogManager] WriteMessage:[NSString stringWithFormat:@"Code file: %@ found and %d tags loaded", [file FilePath], [files count]]];
        STStatsManagerExecuteResult* results = [[self StatsManager] ExecuteStatPackage:file];
        [[self LogManager] WriteMessage:[NSString stringWithFormat:@"Executed the statistical code for file, with success = %hhd", results.Success]];
      }
      @catch (NSException* exc) {
        NSLog(@"StatTag encountered an exception while attempting to load and execute tags from the codefile : %@", [file FilePath]);
      }
      @finally
      {
      }
    }
  
  }
  
  if([filesNotFound count] > 0 ) {
    
    NSString* alertText = [NSString stringWithFormat:@"The following source code files were referenced by this document, but could not be found on this device:\r\n\r\n%@", [[filesNotFound valueForKey:@"FilePath"] componentsJoinedByString:@"\r\n"]];
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"StatTag fan't find some code files"];
    [alert setInformativeText:alertText];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert addButtonWithTitle:@"Ok"];
    [alert runModal];

  } else {
    [[self LogManager] WriteMessage:@"Performing the document validation check"];
    [[self DocumentManager] PerformDocumentCheck:doc onlyShowDialogIfResultsFound:true];
  }

  [[self LogManager] WriteMessage:@"DocumentOpen - Completed"];
}


/// <summary>
/// Respond to an error after double-clicking on a field.
/// </summary>
/// <param name="sender"></param>
/// <param name="eventArgs"></param>
//private void OnAfterDoubleClickErrorCallback(object sender, EventArgs eventArgs)
//{
//  var exception = sender as Exception;
//  if (exception != null)
//  {
//    UIUtility.ReportException(exception,
//                              "There was an error attempting to load the details of this tag.  If this problem persists, you may want to remove and insert the tag again.",
//                              LogManager);
//  }
//}

/// <summary>
/// The official event handler for add-ins in response to double-click.
/// </summary>
/// <param name="selection"></param>
/// <param name="cancel"></param>
//void Application_BeforeDoubleClick(Word.Selection selection, ref bool cancel)
//{
//  // Workaround for Word add-in API - there is no AfterDoubleClick event, so we will set a new
//  // thread with a timer in it to process the double-click after the message is fully processed.
//  var thread = new System.Threading.Thread(Application_AfterDoubleClick) {IsBackground = true};
//  thread.SetApartmentState(ApartmentState.STA);
//  thread.Start();
//}

/// <summary>
/// Special handler called by us to allow the event queue to be processed before we try responding to
/// a double-click message.  This allows us to simulate an AfterDoubleClick event.
/// </summary>
//void Application_AfterDoubleClick()
//{
//  // There is a UI delay that is noticeable, but is required as a workaround to get the double-click to
//  // be processed after the actual selection has changed.
//  Thread.Sleep(100);
//  
//  var selection = Application.Selection;
//  var fields = selection.Fields;
//  
//  try
//  {
//    // We require more than one field, since our AM fields show up as 2 fields.
//    if (fields.Count > 1)
//    {
//      // If there are multiple items selected, we will grab the first field in the selection.
//      var field = selection.Fields[1];
//      if (field != null)
//      {
//        DocumentManager.EditTagField(field);
//        Marshal.ReleaseComObject(field);
//      }
//    }
//  }
//  catch (Exception exc)
//  {
//    // This may also seem kludgy to use a callback, but we want to display the dialog in
//    // the main UI thread.  So we use the callback to transition control back over there
//    // when an error is detected.
//    if (AfterDoubleClickErrorCallback != null)
//    {
//      AfterDoubleClickErrorCallback(exc, EventArgs.Empty);
//    }
//  }
//  finally
//  {
//    Marshal.ReleaseComObject(fields);
//    Marshal.ReleaseComObject(selection);
//  }
//}


@end
