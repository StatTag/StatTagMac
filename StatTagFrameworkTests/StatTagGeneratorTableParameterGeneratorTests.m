//
//  StatTagGeneratorTableGeneratorTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/30/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"

@interface StatTagGeneratorTableParameterGeneratorTests : XCTestCase

@end

@implementation StatTagGeneratorTableParameterGeneratorTests

- (void)setUp {
  [super setUp];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testCreateParameters_NoLabel {
  STTableParameterGenerator* generator = [[STTableParameterGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  XCTAssert([@"" isEqualToString:[generator CreateParameters:tag]]);
}

- (void)testCreateParameters_Label {
  STTableParameterGenerator* generator = [[STTableParameterGenerator alloc] init];
  STTag* tag = [[STTag alloc] init];
  tag.Name = @"Test";
  XCTAssert([@"Label=\"Test\"" isEqualToString:[generator CreateParameters:tag]]);
}


-(void) testCreateParameters_FiltersDisabled
{
  STTableParameterGenerator* generator = [[STTableParameterGenerator alloc] init];
//  var generator = new TableParameterGenerator();
  
//  // Null table format
//  Assert.AreEqual("Label=\"Test\"", generator.CreateParameters(new Tag() { Name = "Test" }));
//  
//  // Row and column filters both disabled
//  Assert.AreEqual("Label=\"Test\"",
//                  generator.CreateParameters(new Tag()
//                                             {
//                                               Name = "Test",
//                                               TableFormat = new TableFormat()
//                                               {
//                                                 ColumnFilter = new FilterFormat("Column") {Enabled = false},
//                                                 RowFilter = new FilterFormat("Row") { Enabled = false }
//                                               }
//                                             }));
  XCTAssert(false);

}

-(void) testCreateParameters_RowFilter
{
//  var generator = new TableParameterGenerator();
//  Assert.AreEqual("Label=\"Test\", RowFilterEnabled=True, RowFilterType=\"Exclude\", RowFilterValue=\"1\"",
//                  generator.CreateParameters(new Tag()
//                                             {
//                                               Name = "Test",
//                                               TableFormat = new TableFormat()
//                                               {
//                                                 RowFilter = new FilterFormat("Row") { Enabled = true, Type = Constants.FilterType.Exclude, Value = "1" }
//                                               }
//                                             }));
  XCTAssert(false);

}

-(void) testCreateParameters_ColumnFilter
{
//  var generator = new TableParameterGenerator();
//  Assert.AreEqual("Label=\"Test\", ColumnFilterEnabled=True, ColumnFilterType=\"Exclude\", ColumnFilterValue=\"1\"",
//                  generator.CreateParameters(new Tag()
//                                             {
//                                               Name = "Test",
//                                               TableFormat = new TableFormat()
//                                               {
//                                                 ColumnFilter = new FilterFormat("Column") { Enabled = true, Type = Constants.FilterType.Exclude, Value = "1" }
//                                               }
//                                             }));
  XCTAssert(false);

}


@end
