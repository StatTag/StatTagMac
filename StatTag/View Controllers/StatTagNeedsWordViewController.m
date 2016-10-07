//
//  StatTagNeedsWordViewController.m
//  StatTag
//
//  Created by Eric Whitley on 10/7/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "StatTagNeedsWordViewController.h"
#import "StatTagShared.h"

@interface StatTagNeedsWordViewController ()

@end


@implementation StatTagNeedsWordViewController

static void *SharedContext = &SharedContext;

- (void)awakeFromNib {
}

- (NSString *)nibName
{
  return @"StatTagNeedsWordViewController";
}

//restoring at runtime with storyboards
-(id) initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if(self) {
    [[NSBundle mainBundle] loadNibNamed:@"StatTagNeedsWordViewController" owner:self topLevelObjects:nil];
    [self setup];
  }
  return self;
}

-(void)setup {
  _statusMessageText = [[NSString alloc] init];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _statTagShared = [StatTagShared sharedInstance];
  [self startObservingChanges];
}

-(void)viewDidAppear {
  NSLog(@"%@", [self statusMessageText]);
  NSLog(@"%@", [[self statusMessage] stringValue]);
}

-(void)dealloc {
  [self stopObservingChanges];
}

//self.statTagShared.wordAppStatusMessage

-(void) startObservingChanges {
  [self addObserver:self
         forKeyPath:@"statTagShared.wordAppStatusMessage"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:SharedContext];
}

-(void) stopObservingChanges {
  [self removeObserver:self
            forKeyPath:@"statTagShared.wordAppStatusMessage"
               context:SharedContext];
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  if (context == SharedContext) {
    [self setStatusMessageText:[[StatTagShared sharedInstance] wordAppStatusMessage]];
  } else {
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
  }
}



@end
