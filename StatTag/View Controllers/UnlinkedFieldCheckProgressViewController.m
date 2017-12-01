//
//  UnlinkedFieldCheckProgressViewController.m
//  StatTag
//
//  Created by Eric Whitley on 9/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "UnlinkedFieldCheckProgressViewController.h"
#import "StatTagFramework.h"
#import "StatTagWordDocument.h"

@interface UnlinkedFieldCheckProgressViewController ()

@end

@implementation UnlinkedFieldCheckProgressViewController

@synthesize progressIndicator;
@synthesize progressText;

@synthesize documentManager = _documentManager;
@synthesize tagsToProcess = _tagsToProcess;
@synthesize failedTags = _failedTags;
@synthesize failedTagErrors = _failedTagErrors;
@synthesize stWordDoc = _stWordDoc;

@synthesize insert = _insert;


-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"UnlinkedFieldCheckProgressViewController" owner:self topLevelObjects:nil];
    _insert = NO;
  }
  return self;
}
-(id) init {
  self = [super init];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"UnlinkedFieldCheckProgressViewController" owner:self topLevelObjects:nil];
    _insert = NO;
  }
  return self;
}


- (void)viewDidLoad {
  [super viewDidLoad];
    // Do view setup here.
}

-(void)viewDidAppear {

  [self setNumItemsCompleted:@0];
  [self setNumItemsToProcess:@0];
  _failedTags = [[NSMutableArray<STTag*> alloc] init];
  _failedTagErrors = [[NSMutableDictionary<STTag*, NSException*> alloc] init];

  [self setStWordDoc:[[StatTagShared sharedInstance] activeStatTagWordDocument]];
  
  [self subscribeToNotifications];
  [self checkUnlinkedTags];
}

-(void)subscribeToNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(unlinkedFieldCheckStart:)
                                               name:@"unlinkedFieldCheckStart"
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(unlinkedFieldCheckComplete:)
                                               name:@"unlinkedFieldCheckComplete"
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(allUnlinkedFieldChecksComplete:)
                                               name:@"allUnlinkedFieldChecksComplete"
                                             object:nil];
}

-(void)unsubscribeFromNotifications
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)checkUnlinkedTags {
  
  __block StatTagResponseState responseState;

  [self setNumItemsCompleted:@0];
  NSInteger numItemsToProcess = [[self stWordDoc] numUniqueFields];
  //NSInteger numItemsToProcess = [[self stWordDoc] numUniqueFields];
  
  if(numItemsToProcess == 0)
  {
    responseState = OK;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"allUnlinkedFieldChecksComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:responseState]}];
    return;
  }
  [self setNumItemsToProcess:[NSNumber numberWithLong:numItemsToProcess]];
  [[self progressIndicatorDeterminate] setMinValue:0];
  [[self progressIndicatorDeterminate] setMaxValue:numItemsToProcess];

  [progressIndicator setIndeterminate:YES];
  [progressIndicator startAnimation:nil];
  [progressText setStringValue:@"Checking unlinked fields..."];
  ////NSLog(@"%lu tags", (unsigned long)[_tagsToProcess count]);


  dispatch_async(dispatch_get_global_queue(0, 0), ^{

    @try {



        dispatch_async(dispatch_get_main_queue(), ^{
          [progressText setStringValue:@"Checking unlinked fields..."];
          [self setProgressCountText:[NSString stringWithFormat:@"%@/%ld", [self numItemsCompleted], [[self tagsToProcess] count]]];
          [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numItemsCompleted], [self numItemsToProcess]]];
        });

        [[self stWordDoc] validateUnlinkedTags];

//        for(STCodeFile* cf in [_documentManager GetCodeFileList]) {
//          STStatsManagerExecuteResult* result = [stats ExecuteStatPackage:cf
//                                                               filterMode:[STConstantsParserFilterMode TagList]
//                                                                tagsToRun:_tagsToProcess
//                                                 ];
//          [[allResults FailedTags] addObjectsFromArray:[result FailedTags]];
//          [[allResults UpdatedTags] addObjectsFromArray:[result UpdatedTags]];
//          [allResults setSuccess:([result Success] == true && [allResults Success] == true)];
//          #pragma unused (result)
//        }
        //});

        dispatch_async(dispatch_get_main_queue(), ^{

//          [progressText setStringValue:@"Checking Fields in Microsoft Word..."];

//          for(STTag* tag in _tagsToProcess)
//          {
//            STUpdatePair<STTag*>* pair = [[STUpdatePair alloc] init];
//            pair.Old = tag;
//            pair.New = tag;
//            [_documentManager UpdateFields:pair];
//          }

          
          [progressIndicator setIndeterminate:YES];
          [progressIndicator stopAnimation:nil];

          [progressText setStringValue:@"Check complete"];

          //responseState = [allResults Success] == true ? OK : Error;
          responseState = OK;
          [[NSNotificationCenter defaultCenter] postNotificationName:@"allUnlinkedFieldChecksComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:responseState]}];

        });

    }
    @catch (NSException* exc) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allUnlinkedFieldChecksComplete" object:self userInfo:@{@"responseState":[NSNumber numberWithInteger:Error]}];
    }
  });
}



- (IBAction)cancelOperation:(id)sender {
}


-(void)unlinkedFieldCheckStart:(NSNotification*)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{
//    NSString* tagName = [[notification userInfo] valueForKey:@"tagName"];
//    NSString* codeFileName = [[notification userInfo] valueForKey:@"codeFileName"];
//    NSString* type = [[notification userInfo] valueForKey:@"type"];
//    //NSLog(@"tagUpdateStart complete => tag: %@", tagName);
//
//    if([type isEqualToString:@"tag"])
//    {
//      [[self progressText] setStringValue:[NSString stringWithFormat:@"%@ %@ '%@' from code file'%@'", [self insert] ? @"Inserting" : @"Updating", type, tagName, codeFileName]];
//    }
//    if([type isEqualToString:@"field"])
//    {
//      [[self progressText] setStringValue:[NSString stringWithFormat:@"%@ %@ for tag '%@'", [self insert] ? @"Inserting" : @"Updating", type, tagName]];
//    }
//    ////NSLog(@"tag update start (%@/%@): %@", [self numTagsCompleted], [self numTagsToProcess], tagName);
//    [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numItemsCompleted], [self numItemsToProcess]]];
  });
}

-(void)unlinkedFieldCheckComplete:(NSNotification*)notification
{
  dispatch_async(dispatch_get_main_queue(), ^{
    
    [self setNumItemsCompleted:[NSNumber numberWithDouble:([[self numItemsCompleted] doubleValue] + 1.0)]];
    if([[self numItemsToProcess] doubleValue] > 0) {
      [[self progressIndicatorDeterminate] setDoubleValue:[[self numItemsCompleted] doubleValue]];
    }
    else {
      [[self progressIndicatorDeterminate] setDoubleValue:1.0];
    }
    [[self progressCountLabel] setStringValue:[NSString stringWithFormat:@"(%@/%@)", [self numItemsCompleted], [self numItemsToProcess]]];
  });
}

-(void)allUnlinkedFieldChecksComplete:(NSNotification*)notification
{
  [self unsubscribeFromNotifications];
  NSNumber* responseStateNum = [[notification userInfo] valueForKey:@"responseState"];
  StatTagResponseState responseState = (StatTagResponseState)[responseStateNum integerValue];
  
  dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"allUnlinkedFieldChecksComplete: %@", [[[StatTagShared sharedInstance] activeStatTagWordDocument] unlinkedTags]);
    if([[self delegate] respondsToSelector:@selector(dismissUnlinkedFieldCheckProgressViewController:withReturnCode:)]) {
      [_delegate dismissUnlinkedFieldCheckProgressViewController:self withReturnCode:(StatTagResponseState)responseState];
    }
  });
}



@end
