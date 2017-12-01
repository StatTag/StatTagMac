//
//  StatTagWordDocumentUnlinkedTagValidator.m
//  StatTag
//
//  Created by Eric Whitley on 10/26/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "StatTagWordDocumentUnlinkedTagValidator.h"

#import "StatTagWordDocument.h"
//#import "StatTagWordDocumentFieldTag.h"

//#import "StatTagFramework.h"


//http://www.knowstack.com/concurrency-nsoperationqueue-grand-central-dispatch/
//https://www.raywenderlich.com/76341/use-nsoperation-nsoperationqueue-swift


@implementation StatTagWordDocumentUnlinkedTagValidator

@synthesize statTagWordDoc = _statTagWordDoc;

-(instancetype)initWithStatTagWordDocument:(StatTagWordDocument*)doc
{
  self = [super init];
  if(self)
  {
    _statTagWordDoc = doc;
    executing = NO;
    finished = NO;
  }
  return self;
}

//-(void)main
//{
//
//}


-(void)start
{
  if ([self isCancelled])
  {
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    return;
  }
  // If the operation is not canceled, begin executing the task.
  [self willChangeValueForKey:@"isExecuting"];
  [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
  executing = YES;
  [self didChangeValueForKey:@"isExecuting"];
}

-(void)main
{
  //This is the method that will do the work
  @try {
    [[self statTagWordDoc] validateUnlinkedTags];

    [self willChangeValueForKey:@"isExecuting"];
    executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    
  }
  @catch (NSException *exception) {
    NSLog(@"Exception: StatTagWordDocumentUnlinkedTagValidator: %@",[exception description]);
  }
  @finally {
//    NSLog(@"Custom Operation - Main Method - Finally block");
  }
}

-(BOOL)isExecuting{
  return executing;
}

-(BOOL)isFinished{
  return finished;
}

@end
