//
//  StatTagRParserTests.m
//  StatTag
//
//  Created by Rasmussen, Luke on 8/23/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"
#import "MockIFileHandler.h"
#import <OCMock/OCMock.h>

@interface StatTagRMarkdownParserTests : XCTestCase

@end

@implementation StatTagRMarkdownParserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void) testPreProcessFile_NullAutomation
{
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"---",
                               nil];
  mock.lines = lines;
  mock.exists = TRUE;

  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages RMarkdown];
  codeFile.FilePath = @"Test.Rmd";
  STRMarkdownParser* parser = [[STRMarkdownParser alloc] init];
  XCTAssertThrows([parser PreProcessFile:codeFile automation:NULL]);
}

-(void) testPreProcessFile_NotRmd
{
  MockIFileHandler* mock = [[MockIFileHandler alloc] init];
  NSArray<NSString*>* lines = [NSArray<NSString*> arrayWithObjects:
                               @"---",
                               nil];
  mock.lines = lines;
  mock.exists = TRUE;
  
  STCodeFile* codeFile = [[STCodeFile alloc] init:mock];
  codeFile.StatisticalPackage = [STConstantsStatisticalPackages RMarkdown];
  codeFile.FilePath = @"Test.R";
  STRMarkdownParser* parser = [[STRMarkdownParser alloc] init];
  XCTAssertThrows([parser PreProcessFile:codeFile automation:NULL]);
}

-(void) testReplaceKntirCommands_NullEmpty
{
  STRMarkdownParser* parser = [[STRMarkdownParser alloc] init];
  XCTAssertNil([parser ReplaceKnitrCommands:nil]);
  NSArray<NSString*>* emptyArray = [[NSArray<NSString*> alloc] init];
  XCTAssertEqual(0, [[parser ReplaceKnitrCommands:emptyArray] count]);
}

-(void) testReplaceKntirCommands_NoKnitrCommands
{
  STRMarkdownParser* parser = [[STRMarkdownParser alloc] init];
  XCTAssertNil([parser ReplaceKnitrCommands:nil]);
  NSArray<NSString*>* commands = [[NSArray<NSString*> alloc] initWithObjects:
                                  @"x <- 15", @"print(x)", nil];
  XCTAssertEqualObjects(@"x <- 15\r\nprint(x)", [[parser ReplaceKnitrCommands:commands] componentsJoinedByString:@"\r\n"]);
  
  commands = [[NSArray<NSString*> alloc] initWithObjects:
              @"x <- 15", @"table(x)", nil];
  XCTAssertEqualObjects(@"x <- 15\r\ntable(x)", [[parser ReplaceKnitrCommands:commands] componentsJoinedByString:@"\r\n"]);
}

-(void) testReplaceKntirCommands_KnitrCommands
{
  STRMarkdownParser* parser = [[STRMarkdownParser alloc] init];
  XCTAssertNil([parser ReplaceKnitrCommands:nil]);
  NSArray<NSString*>* commands = [[NSArray<NSString*> alloc] initWithObjects:
                                  @"PrettyTable <- print(TableOne, printToggle = FALSE, noSpaces = TRUE)", @"knitr::kable(PrettyTable)", nil];
  XCTAssertEqualObjects(@"PrettyTable <- print(TableOne, printToggle = FALSE, noSpaces = TRUE)\r\nprint(PrettyTable)", [[parser ReplaceKnitrCommands:commands] componentsJoinedByString:@"\r\n"]);
  
  commands = [[NSArray<NSString*> alloc] initWithObjects:
              @"PrettyTable <- print(TableOne, printToggle = FALSE, noSpaces = TRUE)", @"kable(PrettyTable)", nil];
  XCTAssertEqualObjects(@"PrettyTable <- print(TableOne, printToggle = FALSE, noSpaces = TRUE)\r\nprint(PrettyTable)", [[parser ReplaceKnitrCommands:commands] componentsJoinedByString:@"\r\n"]);
}



// TODO - These tests rely heavily on mocking, and I need to learn how to do this better in Obj-C
//[TestMethod]
//[ExpectedException(typeof(StatTagUserException))]
//public void PreProcessFile_RFileExists()
//{
//  var codeFileHandlerMock = new Mock<IFileHandler>();
//  codeFileHandlerMock.Setup(file => file.ReadAllLines(It.IsAny<string>())).Returns(new[]
//                                                                                   {
//                                                                                     "---",
//                                                                                   });
//  codeFileHandlerMock.Setup(file => file.Exists(It.IsAny<string>())).Returns(true);
//  
//  var parserFileHandlerMock = new Mock<IFileHandler>();
//  parserFileHandlerMock.Setup(file => file.Exists(It.IsRegex("Test\\.R"))).Returns(true);  // Trigger an error condition by making it think the R file exists
//  
//  var automationMock = new Mock<IStatAutomation>();
//  
//  var codeFile = new CodeFile(codeFileHandlerMock.Object) { StatisticalPackage = Constants.StatisticalPackages.RMarkdown, FilePath = "Test.Rmd" };
//  
//  var parser = new RMarkdownParser(parserFileHandlerMock.Object);
//  parser.PreProcessFile(codeFile, automationMock.Object);
//}
//
//[TestMethod]
//public void PreProcessFile_Processed()
//{
//  // This test is not entirely perfect.  We do a lot of mocking, but are verifying the path through
//  // PreProcessFile that it will return appropriately when done.  We don't even have any assertions
//  // at the end, and instead are expecting this to finish without throwing exceptions as done in the
//  // earlier tests.
//  var codeFileHandlerMock = new Mock<IFileHandler>();
//  codeFileHandlerMock.Setup(file => file.ReadAllLines(It.IsAny<string>())).Returns(new[]
//                                                                                   {
//                                                                                     "---",
//                                                                                     "title: \"Test\"",
//                                                                                     "author: \"Test\"",
//                                                                                     "date: \"November 28, 2018\"",
//                                                                                     "output: html_document",
//                                                                                     "---",
//                                                                                     "",
//                                                                                     "```{r cars}",
//                                                                                     "##>>>ST:Table(Label=\"Summary\", Frequency=\"On Demand\", Type=\"Default\")",
//                                                                                     "summary(cars)",
//                                                                                     "##<<<",
//                                                                                     "```"
//                                                                                   });
//  codeFileHandlerMock.Setup(file => file.Exists(It.IsAny<string>())).Returns(true);
//  
//  var parserFileHandlerMock = new Mock<IFileHandler>();
//  parserFileHandlerMock.Setup(file => file.Exists(It.IsRegex("Test\\.R"))).Returns(false);  // We don't want the R file to exist
//  
//  var automationMock = new Mock<IStatAutomation>();
//  automationMock.Setup(aut => aut.RunCommands(It.IsAny<string[]>(), It.IsAny<Tag>())).Returns(new CommandResult[] { });
//  
//  var codeFile = new CodeFile(codeFileHandlerMock.Object) { StatisticalPackage = Constants.StatisticalPackages.RMarkdown, FilePath = "Test.Rmd" };
//  
//  var parser = new RMarkdownParser(parserFileHandlerMock.Object);
//  parser.PreProcessFile(codeFile, automationMock.Object);
//  
//  // Why no assertions?  We could go through all of the hassle of mocking up the results, but since it's all
//  // mocked up data, what's the point?
//}

@end
