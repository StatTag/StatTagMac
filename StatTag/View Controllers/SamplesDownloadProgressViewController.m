//
//  SamplesDownloadProgressViewController.m
//  StatTag
//
//  Created by Eric Whitley on 5/28/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

//EWW - This is a _really_ rudimentary serial setup and not "Cocoa-like"


#import "SamplesDownloadProgressViewController.h"

@interface SamplesDownloadProgressViewController ()

@end

@implementation SamplesDownloadProgressViewController

//MARK: initializers
- (NSString *)nibName
{
  return @"SamplesDownloadProgressViewController";
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

//MARK: standard view events
- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)viewDidAppear
{
  //#if __MAC_OS_X_VERSION_MAX_ALLOWED > 101100
  //
  //#endif
  [self setInstructionalText:@"Downloading file..."];
  [self downloadAndUnzipFile];
}

-(void)viewWillLayout
{
  //these are multiline labels
  // "preferred width automatic" was introduced in 10.11
  // since we're targeting 10.10, we need to calculate the max layout width ourselves
  // since we're using autolayout we can use the generated width from the frame and then pass it to max layout width for the text line wrapping
  // refer to: //http://www.brightec.co.uk/ideas/preferredmaxlayoutwidth
  [[self instructionalTextField] setPreferredMaxLayoutWidth:self.instructionalTextField.frame.size.width];
  [[self progressTextField] setPreferredMaxLayoutWidth:self.progressTextField.frame.size.width];
}


//MARK: main view methods
-(void)downloadAndUnzipFile
{
  [self downloadFileFromPath:[self downloadSourceFileURL] toFolder:[self downloadTargetDirectoryURL]];
}

-(void)dismissProgressController
{
  if([[self delegate] respondsToSelector:@selector(dismissSamplesDownloadProgressViewController:withReturnCode:andMessage:andError:)]) {
    
    StatTagResponseState state = (StatTagResponseState)OK;
    if(processError != nil)
    {
      state = (StatTagResponseState)Error;
    }
    
    [[self delegate] dismissSamplesDownloadProgressViewController:self withReturnCode:state andMessage:@"" andError:processError];
  }
}

-(void)downloadFileFromPath:(NSURL*)sourcePath toFolder:(NSURL*)targetFolder
{
  NSURLRequest *theRequest = [NSURLRequest
                                requestWithURL:sourcePath
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                timeoutInterval:5000.0];
  
  NSURLDownload  *theDownload = [[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
  if (!theDownload) {
    NSLog(@"The download failed");
  }
}


-(void)unzipFile:(NSURL*)zipFilePath toPath:(NSURL*)destinationPath
{
  //this is hokey
  //we may want to use https://github.com/ZipArchive/ZipArchive instead
  
  NSTask *unzip = [[NSTask alloc] init];
  [unzip setLaunchPath:@"/usr/bin/unzip"];
  [unzip setArguments:[NSArray arrayWithObjects:@"-u", @"-d", destinationPath, zipFilePath, nil]];
  
  NSPipe *aPipe = [[NSPipe alloc] init];
  [unzip setStandardOutput:aPipe];

  NSPipe* errorPipe = [[NSPipe alloc] init];
  [unzip setStandardError: errorPipe];

  [unzip launch];
  [unzip waitUntilExit];
  
  NSData *outputData = [[aPipe fileHandleForReading] readDataToEndOfFile];
  NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
  
  NSData *errorData = [[errorPipe fileHandleForReading] readDataToEndOfFile];
  NSString *errorString = [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding];
  
  if(errorString != nil && [errorString length] > 0)
  {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Error unzipping file.", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(errorString, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Please manually review the zip file", nil)
                               };
    processError = [NSError errorWithDomain:@"org.stattag.stattag"//kStatTagErrorDomain
                                         code:-57
                                     userInfo:userInfo];
  }
  
  NSLog(@"Zip File: %@", zipFilePath);
  NSLog(@"Destination: %@", destinationPath);
  NSLog(@"Pipe: %@", outputString);
  NSLog(@"Error: %@", errorString);
  NSLog(@"------------- Finish -----------");
  
}

//MARK: NSURLDownloadDelegate
// helpful example: http://www.knowstack.com/cocoa-file-download-using-nsurldownload-sample-code/
-(void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
  NSURL* targetPath = [NSURL fileURLWithPath:filename relativeToURL:[self downloadTargetDirectoryURL]];
  [download setDestination:[targetPath path] allowOverwrite:NO];
}


- (void)setDownloadResponse:(NSURLResponse *)downloadResponse
{
  _downloadResponse = downloadResponse;
}

- (void)download:(NSURLDownload *)download didReceiveResponse:(NSURLResponse *)response
{
  [self setProgressPercent:0];
  [self setBytesReceived:0];
  [self setDownloadResponse:response];
}

- (void)download:(NSURLDownload *)download didReceiveDataOfLength:(NSUInteger)length
{
  long long expectedLength = [[self downloadResponse] expectedContentLength];
  [self setBytesReceived: [self bytesReceived] + length];
  
  if (expectedLength != NSURLResponseUnknownLength) {
    //KNOWN target length - show % complete and set progess bar to show % to target
    [[self progressIndicator] setIndeterminate:NO];
    double percentComplete = (self.bytesReceived/(float)expectedLength)*100.0;
    [[self progressIndicator] setDoubleValue:percentComplete];
    [self setProgressText:[NSString stringWithFormat:@"%f%% complete", percentComplete]];
  }
  else {
    //unknown target length - show bytes received and change progess bar to indeterminate
    [[self progressIndicator] setIndeterminate:YES];
    [self setProgressText:[NSString stringWithFormat:@"%ld kb received", (long)([self bytesReceived]/1024)]];
  }
}

-(void)download:(NSURLDownload *)download didCreateDestination:(NSString *)path
{
  finalDownloadFilePath = [NSURL fileURLWithPath:path];
}

- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
//  NSLog(@"Download failed! Error - %@ %@",
//        [error localizedDescription],
//        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);

  processError = error;
  [self setInstructionalText:@"Error downloading samples"];
  [[self progressIndicator] stopAnimation:nil];

  [self setProgressText:[NSString stringWithFormat:@"Error: %@", [error localizedDescription]]];
  [self dismissProgressController];
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
  [self setProgressText:@"Download Complete"];
  
  if(finalDownloadFilePath != nil && [[[finalDownloadFilePath pathExtension] lowercaseString] isEqualToString:@"zip"])
  {
    [self setInstructionalText:@"Unzipping file..."];
    [[self progressIndicator] stopAnimation:nil];
    [[self progressIndicator] setIndeterminate:YES];
    [[self progressIndicator] startAnimation:nil];
    [self unzipFile:finalDownloadFilePath toPath:[self downloadTargetDirectoryURL]];
    [self setProgressText:@""];
    [[self progressIndicator] stopAnimation:nil];
  }
  [self dismissProgressController];
}

@end
