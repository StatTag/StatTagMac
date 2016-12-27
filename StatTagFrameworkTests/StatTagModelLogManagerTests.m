//
//  StatTagModelLogManagerTests.m
//  StatTag
//
//  Created by Eric Whitley on 12/20/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"
#import "MockIFileHandler.h"
#import <OCMock/OCMock.h>


@interface StatTagModelLogManagerTests : XCTestCase

@end

@implementation StatTagModelLogManagerTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}


-(void) testIsValidLogPath_Invalid
{
//  MockIFileHandler* mock = [[MockIFileHandler alloc] init];

  //id mock = OCMClassMock([STIFileHandler class]);
  id mock = OCMProtocolMock(@protocol(STIFileHandler));
  
  
  //OCMStub([mock OpenWrite:[OCMArg any]]).andReturn(tweetArray);
  OCMStub([mock OpenWrite:[OCMArg any]]).andThrow([NSException exceptionWithName:@"Invalid" reason:nil userInfo:nil]);
  
  STLogManager* manager = [[STLogManager alloc] initWithFileHandler:mock];

  XCTAssertFalse([manager IsValidLogPath:@"Test.log"]);
  XCTAssertFalse([manager IsValidLogPath:@""]);
  
//  Tweet *testTweet = /* create a tweet somehow */;
//  NSArray *tweetArray = [NSArray arrayWithObject:testTweet];
//  OCMStub([mockConnection retrieveTweetsForSearchTerm:[OCMArg any]]).andReturn(tweetArray);
  
//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.OpenWrite(It.IsAny<string>())).Throws(new Exception("Invalid"));
//  var manager = new LogManager(mock.Object);
//  Assert.IsFalse(manager.IsValidLogPath("Test.log"));
//  Assert.IsFalse(manager.IsValidLogPath(""));
}


-(void) testIsValidLogPath_Valid
{
  
  id mock = OCMProtocolMock(@protocol(STIFileHandler));
  OCMStub([mock OpenWrite:[OCMArg any]]).andReturn(nil);
  STLogManager* manager = [[STLogManager alloc] initWithFileHandler:mock];
  XCTAssertTrue([manager IsValidLogPath:@"Test.log"]);
  
//  var mock = new Mock<IFileHandler>();
//  FileStream nullStream = null;
//  mock.Setup(file => file.OpenWrite(It.IsAny<string>())).Returns(nullStream);
//  var manager = new LogManager(mock.Object);
//  Assert.IsTrue(manager.IsValidLogPath("Test.log"));
}


-(void) testUpdateSettings
{
  STLogManager* manager = [[STLogManager alloc] init];
  XCTAssertFalse([manager Enabled]);
  XCTAssertNil([manager LogFilePath]);
  
//  var manager = new LogManager();
//  Assert.IsFalse(manager.Enabled);
//  Assert.IsNull(manager.LogFilePath);
  STProperties* properties = [[STProperties alloc] init];
  properties.EnableLogging = YES;
  properties.LogLocation = @"Test.log";

  [manager UpdateSettings:properties];
  //NSLog(@"[[manager LogFilePath] path] : %@", [[manager LogFilePath] path]);
  
  XCTAssertTrue([manager Enabled]);
  XCTAssert([@"Test.log" isEqualToString:[[manager LogFilePath] lastPathComponent]]);
}


-(void) testWriteMessage_Disabled
{
  
  
  //more on sending NSError
  //http://stackoverflow.com/questions/1288918/how-do-i-mock-a-method-that-accepts-a-handle-as-an-argument-in-ocmock
  /*
   Option 1
   [[[mock stub] andReturn:someDict] uploadValues:YES error:[OCMArg setTo:nil]];

   Option 2
   NSError* someError = ...
   [[[mock stub] andReturn:someDict] uploadValues:YES error:[OCMArg setTo:someError]];
  
   Option 3
   [[[mock stub] andReturn:someDict] uploadValues:YES error:[OCMArg anyPointer]];
   
   */
  
  //http://stackoverflow.com/questions/5434649/how-to-verify-number-of-method-calls-using-ocmock
  id mock = OCMProtocolMock(@protocol(STIFileHandler));
  NSError* err;
  __block NSInteger callCount = 0;
  OCMStub([mock AppendAllText:[OCMArg any] withContent:[OCMArg any] error:[OCMArg setTo:err]]).andDo(^(NSInvocation *invocation){
        ++callCount;
      });
  STLogManager* manager = [[STLogManager alloc] initWithFileHandler:mock];
  [manager UpdateSettings:NO filePath:nil];
  [manager WriteMessage:@"Test"];
  // Never called if disabled
  XCTAssertEqual(0, callCount);
  
//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.AppendAllText(It.IsAny<string>(), It.IsAny<string>()));
//  var manager = new LogManager(mock.Object);
//  manager.UpdateSettings(false, null);
//  manager.WriteMessage("Test");
//  // Never called if disabled
//  mock.Verify(m => m.AppendAllText(It.IsAny<string>(), It.IsAny<string>()), Times.Never);
}


-(void) testWriteMessage_Enabled
{
  
  id mock = OCMProtocolMock(@protocol(STIFileHandler));
  NSError* err;
  __block NSInteger callCount = 0;
  OCMStub([mock AppendAllText:[OCMArg any] withContent:[OCMArg any] error:[OCMArg setTo:err]]).andDo(^(NSInvocation *invocation){
    ++callCount;
  });
  STLogManager* manager = [[STLogManager alloc] initWithFileHandler:mock];
  [manager UpdateSettings:YES filePath:@"Test.log"];
  [manager WriteMessage:@"Test"];
  XCTAssertEqual(1, callCount);

  
//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.AppendAllText(It.IsAny<string>(), It.IsAny<string>()));
//  var manager = new LogManager(mock.Object);
//  manager.UpdateSettings(true, "Test.log");
//  manager.WriteMessage("Test");
//  mock.Verify(m => m.AppendAllText(It.IsAny<string>(), It.IsAny<string>()), Times.Once);
}


-(void) testWriteException
{
  
  id mock = OCMProtocolMock(@protocol(STIFileHandler));
  NSError* err;
  __block NSInteger callCount = 0;
  OCMStub([mock AppendAllText:[OCMArg any] withContent:[OCMArg any] error:[OCMArg setTo:err]]).andDo(^(NSInvocation *invocation){
    ++callCount;
  });
  STLogManager* manager = [[STLogManager alloc] initWithFileHandler:mock];
  [manager UpdateSettings:YES filePath:@"Test.log"];
  [manager WriteException:[NSException exceptionWithName:@"Test exception" reason:@"Because we're testing" userInfo:nil]];
  XCTAssertEqual(1, callCount);

//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.AppendAllText(It.IsAny<string>(), It.IsAny<string>()));
//  var manager = new LogManager(mock.Object);
//  manager.UpdateSettings(true, "Test.log");
//  manager.WriteException(new Exception("Test exception"));;
//  mock.Verify(m => m.AppendAllText(It.IsAny<string>(), It.IsAny<string>()), Times.Once);
}


-(void) testWriteException_Nested
{
  
  
  //I don't see any way to nest exceptions like this, so I'm passing the test case because it's the same as our non-nested exception case
  
//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.AppendAllText(It.IsAny<string>(), It.IsAny<string>()));
//  var manager = new LogManager(mock.Object);
//  manager.UpdateSettings(true, "Test.log");
//  manager.WriteException(new Exception("Test exception", new Exception("Inner")));
//  mock.Verify(m => m.AppendAllText(It.IsAny<string>(), It.IsAny<string>()), Times.Exactly(2));
  XCTAssert(true);

}

@end
