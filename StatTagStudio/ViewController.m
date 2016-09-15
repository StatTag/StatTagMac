//
//  ViewController.m
//  StatTagStudio
//
//  Created by Eric Whitley on 8/22/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Do any additional setup after loading the view.
  
  //http://stackoverflow.com/questions/36367752/how-do-i-do-distributed-objects-on-osx-with-objective-c/36367753#36367753
  
  proxy = [NSConnection rootProxyForConnectionWithRegisteredName:@"org.stattag.StatTagWordHelpers" host:nil];
  if (proxy == nil ) {
    NSLog(@"no server running");
  }
  NSLog(@"calling test response thru proxy object");
  NSString *sResult = [proxy testResponse:@"sent"];
  NSLog(@"RESULT=%@",sResult);
  
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];

  // Update the view, if already loaded.
}

@end
