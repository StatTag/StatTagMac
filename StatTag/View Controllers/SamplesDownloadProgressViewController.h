//
//  SamplesDownloadProgressViewController.h
//  StatTag
//
//  Created by Eric Whitley on 5/28/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SamplesDownloadProgressViewController;
@protocol SamplesDownloadProgressDelegate <NSObject>
- (void)dismissSamplesDownloadProgressViewController:(SamplesDownloadProgressViewController*)controller withReturnCode:(StatTagResponseState)returnCode andMessage:(NSString*)message andError:(NSError*)error;
@end


@interface SamplesDownloadProgressViewController : NSViewController <NSURLDownloadDelegate> {
  NSURL* finalDownloadFilePath;
  NSURL* finalDownloadExtractPath;
  NSError* processError;
}


@property (weak) IBOutlet NSTextField *instructionalTextField;
@property (weak) IBOutlet NSTextField *progressTextField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@property (strong, nonatomic) NSString* instructionalText;
@property (strong, nonatomic) NSString* progressText;
@property NSInteger progressPercent;
@property NSInteger bytesReceived;
@property (strong, nonatomic) NSURLResponse *downloadResponse;

@property (strong, nonatomic) NSURL* downloadSourceFileURL;
@property (strong, nonatomic) NSURL* downloadTargetDirectoryURL;

@property (nonatomic, weak) id<SamplesDownloadProgressDelegate> delegate;


@end
