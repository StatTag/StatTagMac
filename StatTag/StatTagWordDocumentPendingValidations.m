//
//  StatTagWordDocumentPendingValidations.m
//  StatTag
//
//  Created by Eric Whitley on 10/26/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "StatTagWordDocumentPendingValidations.h"

@implementation StatTagWordDocumentPendingValidations

//@property NSMutableDictionary<NSIndexPath*, NSOperation*>* validationsInProgress;
//@property NSOperationQueue* validationQueue;

@synthesize validationsInProgress = _validationsInProgress;
@synthesize validationQueue = _validationQueue;

-(instancetype)init
{
  self = [super init];
  if(self)
  {
    _validationsInProgress = [[NSMutableDictionary<NSString*, NSOperation*> alloc] init];
    _validationQueue = [[NSOperationQueue alloc] init];
    [[self validationQueue] setName:@"StatTag Document Validation Queue"];
    [[self validationQueue] setMaxConcurrentOperationCount:1]; //only one at a time
  }
  return self;
}

@end
