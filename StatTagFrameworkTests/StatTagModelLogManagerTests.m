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
//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.OpenWrite(It.IsAny<string>())).Throws(new Exception("Invalid"));
//  var manager = new LogManager(mock.Object);
//  Assert.IsFalse(manager.IsValidLogPath("Test.log"));
//  Assert.IsFalse(manager.IsValidLogPath(""));
  XCTAssert(false);
}


-(void) testIsValidLogPath_Valid
{
//  var mock = new Mock<IFileHandler>();
//  FileStream nullStream = null;
//  mock.Setup(file => file.OpenWrite(It.IsAny<string>())).Returns(nullStream);
//  var manager = new LogManager(mock.Object);
//  Assert.IsTrue(manager.IsValidLogPath("Test.log"));
  XCTAssert(false);
}


-(void) testUpdateSettings
{
//  var manager = new LogManager();
//  Assert.IsFalse(manager.Enabled);
//  Assert.IsNull(manager.LogFilePath);
//  
//  var properties = new Properties() {EnableLogging = true, LogLocation = "Test.log"};
//  manager.UpdateSettings(properties);
//  Assert.IsTrue(manager.Enabled);
//  Assert.AreEqual("Test.log", manager.LogFilePath);
  XCTAssert(false);
}


-(void) testWriteMessage_Disabled
{
//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.AppendAllText(It.IsAny<string>(), It.IsAny<string>()));
//  var manager = new LogManager(mock.Object);
//  manager.UpdateSettings(false, null);
//  manager.WriteMessage("Test");
//  // Never called if disabled
//  mock.Verify(m => m.AppendAllText(It.IsAny<string>(), It.IsAny<string>()), Times.Never);
  XCTAssert(false);
}


-(void) testWriteMessage_Enabled
{
//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.AppendAllText(It.IsAny<string>(), It.IsAny<string>()));
//  var manager = new LogManager(mock.Object);
//  manager.UpdateSettings(true, "Test.log");
//  manager.WriteMessage("Test");
//  mock.Verify(m => m.AppendAllText(It.IsAny<string>(), It.IsAny<string>()), Times.Once);
  XCTAssert(false);
}


-(void) testWriteException
{
//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.AppendAllText(It.IsAny<string>(), It.IsAny<string>()));
//  var manager = new LogManager(mock.Object);
//  manager.UpdateSettings(true, "Test.log");
//  manager.WriteException(new Exception("Test exception"));;
//  mock.Verify(m => m.AppendAllText(It.IsAny<string>(), It.IsAny<string>()), Times.Once);
  XCTAssert(false);
}


-(void) testWriteException_Nested
{
//  var mock = new Mock<IFileHandler>();
//  mock.Setup(file => file.AppendAllText(It.IsAny<string>(), It.IsAny<string>()));
//  var manager = new LogManager(mock.Object);
//  manager.UpdateSettings(true, "Test.log");
//  manager.WriteException(new Exception("Test exception", new Exception("Inner")));
//  mock.Verify(m => m.AppendAllText(It.IsAny<string>(), It.IsAny<string>()), Times.Exactly(2));
  XCTAssert(false);

}

@end
