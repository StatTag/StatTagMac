//
//  StatTagModelJSONTests.m
//  StatTag
//
//  Created by Eric Whitley on 6/23/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTag.h"

@interface StatTagModelJSONTests : XCTestCase {
  NSDate* d1;
  NSDate* d2;
  STCodeFile* cf;
  STCodeFile* cf2;
  
  STCommandResult* cr1;
  STCommandResult* cr2;
  
  STCodeFileAction* a1;
  STCodeFileAction* a2;
  
  STTable* t1;
  STTable* t2;
  
  STTag* tg1;
  STTag* tg2;
  
  STFigureFormat* ff1;
  STFigureFormat* ff2;
  
  STValueFormat *vf1;
  STValueFormat *vf2;
  
  STTableFormat* tf1;
  STTableFormat* tf2;
}

@end

@implementation StatTagModelJSONTests




- (void)setUp {
  [super setUp];


  //-----------------
  //Dates
  //-----------------
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *components = [[NSDateComponents alloc] init];
  [components setCalendar:calendar];
  [components setYear:2016];
  [components setMonth:01];
  [components setDay:01];
  [components setHour:1];
  [components setMinute:2];
  [components setSecond:3];
  
  d1 = [calendar dateFromComponents:components];
  
  [components setYear:2015];
  [components setMonth:06];
  [components setSecond:46];
  d2 = [calendar dateFromComponents:components];
  
  //-----------------
  //Code Files
  //-----------------
  cf = [[STCodeFile alloc] init];
  cf.StatisticalPackage = @"ABC";
  cf.FilePath = [[NSURL alloc] initWithString:@"myfile.txt"];
  cf.LastCached = d1;
  
  cf2 = [[STCodeFile alloc] init];
  cf2.StatisticalPackage = @"DEF";
  cf2.FilePath = [[NSURL alloc] initWithString:@"secondfile.txt"];
  cf2.LastCached = d2;
 
  
  //-----------------
  //Code File Action
  //-----------------
  a1 = [[STCodeFileAction alloc] init];
  a1.Label = @"a1 label";
  a1.Action = 1;
  a1.Parameter = @"a1 parameter";
  
  a2 = [[STCodeFileAction alloc] init];
  a2.Label = @"a2 label";
  a2.Action = 2;
  a2.Parameter = @"a2 parameter";

  //-----------------
  //Table
  //-----------------
  t1 = [[STTable alloc] init];
  t1.RowNames = [NSMutableArray arrayWithArray:@[@"1_row1", @"1_row2"]];
  t1.ColumnNames = [NSMutableArray arrayWithArray:@[@"1_col1", @"1_col2"]];
  t1.Data = [NSMutableArray arrayWithArray:@[@1, @2, @3, @4]];
  t1.RowSize = 2;
  t1.ColumnSize = 2;

  //tableresult
  t2 = [[STTable alloc] init];
  t2.RowNames = [NSMutableArray arrayWithArray:@[@"2_row1", @"2_row2"]];
  t2.ColumnNames = [NSMutableArray arrayWithArray:@[@"2_col1", @"2_col2"]];
  t2.Data = [NSMutableArray arrayWithArray:@[@10, @20, @30, @40]];
  t2.RowSize = 2;
  t2.ColumnSize = 2;

  
  //-----------------
  //Command Result
  //-----------------
  cr1 = [[STCommandResult alloc] init];
  cr1.ValueResult = @"1_value_result";
  cr1.FigureResult = @"1_value_result";
  cr1.TableResult = t1;

  cr2 = [[STCommandResult alloc] init];
  cr2.ValueResult = @"2_value_result";
  cr2.FigureResult = @"2_value_result";
  cr2.TableResult = t2;

  //-----------------
  //Value Format
  //-----------------
  vf1 = [[STValueFormat alloc] init];
  vf1.FormatType = @"1_format_type";
  vf1.DecimalPlaces = 1;
  vf1.UseThousands = true;
  vf1.DateFormat = @"1_date_format";
  vf1.TimeFormat = @"1_time_format";
  vf1.AllowInvalidTypes = true;
  
  vf2 = [[STValueFormat alloc] init];
  vf2.FormatType = @"2_format_type";
  vf2.DecimalPlaces = 2;
  vf2.UseThousands = false;
  vf2.DateFormat = @"2_date_format";
  vf2.TimeFormat = @"2_time_format";
  vf2.AllowInvalidTypes = false;

  //-----------------
  //Figure Format
  //-----------------
  ff1 = [[STFigureFormat alloc] init];
  ff2 = [[STFigureFormat alloc] init];

  //-----------------
  //Table Format
  //-----------------
  tf1 = [[STTableFormat alloc] init];
  tf1.IncludeRowNames = true;
  tf1.IncludeColumnNames = false;
  
  tf2 = [[STTableFormat alloc] init];
  tf2.IncludeRowNames = false;
  tf2.IncludeColumnNames = true;

  
  //-----------------
  //Tag
  //-----------------
  tg1 = [[STTag alloc] init];
  tg1.Type = @"1_type";
  tg1.Name = @"1_name";
  tg1.RunFrequency = @"1_run_frequency";
  tg1.ValueFormat = vf1;
  tg1.FigureFormat = ff1;
  tg1.TableFormat = tf1;
  tg1.CachedResult = [NSMutableArray arrayWithObjects:cr1,cr2, nil];
  tg1.LineStart = @10;
  tg1.LineEnd = @15;
  
  tg2 = [[STTag alloc] init];
  tg2.Type = @"2_type";
  tg2.Name = @"2_name";
  tg2.RunFrequency = @"2_run_frequency";
  tg2.ValueFormat = vf2;
  tg2.FigureFormat = ff2;
  tg2.TableFormat = tf2;
  tg2.CachedResult = [NSMutableArray arrayWithObjects:cr1,cr2, nil];
  tg2.LineStart = @20;
  tg2.LineEnd = @25;

  
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testCodeFile {
  //build the array and serialize it to json
  NSArray<STCodeFile*>* ar1 = [NSArray arrayWithObjects:cf, cf2, nil];
  NSString* json = [STCodeFile SerializeList:ar1 error:nil];
  
  //now from json back to objects -> array
  NSArray* ar = [STCodeFile DeserializeList:json error:nil];

  //validate
  XCTAssert([[ar[0] StatisticalPackage] isEqualToString:@"ABC"]);
  XCTAssert([[[ar[0] FilePath] path] isEqualToString:@"myfile.txt"]);
  XCTAssert([[ar[0] LastCached] isEqualToDate:d1]);

  XCTAssert([[ar[1] StatisticalPackage] isEqualToString:@"DEF"]);
  XCTAssert([[[ar[1] FilePath] path] isEqualToString:@"secondfile.txt"]);
  XCTAssert([[ar[1] LastCached] isEqualToDate:d2]);
}



- (void)testCodeFileAction {
  //build the array and serialize it to json
  NSArray<STCodeFileAction*>* ar1 = [NSArray arrayWithObjects:a1, a2, nil];
  NSString* json = [STCodeFileAction SerializeList:ar1 error:nil];
  
  //now from json back to objects -> array
  NSArray* ar2 = [STCodeFileAction DeserializeList:json error:nil];
  
  //validate
  XCTAssert([[ar2[0] Label] isEqualToString:@"a1 label"]);
  XCTAssertEqual(1, [ar2[0] Action]);
  XCTAssert([[ar2[0] Parameter] isEqualToString:@"a1 parameter"]);
  
  XCTAssert([[ar2[1] Label] isEqualToString:@"a2 label"]);
  XCTAssertEqual(2, [ar2[1] Action]);
  XCTAssert([[ar2[1] Parameter] isEqualToString:@"a2 parameter"]);
}

- (void)testCommandResult {
//  //tableresult
  
  //build the array and serialize it to json
  NSArray<STCommandResult*>* ar1 = [NSArray arrayWithObjects:cr1, cr2, nil];
  NSString* json = [STCommandResult SerializeList:ar1 error:nil];
  NSLog(@"json : %@", json);
  
  //now from json back to objects -> array
  NSArray* ar2 = [STCommandResult DeserializeList:json error:nil];

  //validate
  XCTAssert([[ar2[0] ValueResult] isEqualToString:[cr1 ValueResult]]);
  XCTAssert([[ar2[0] FigureResult] isEqualToString:[cr1 FigureResult]]);
  XCTAssert([[[ar2[0] TableResult] RowNames] isEqualToArray:t1.RowNames]);
  XCTAssert([[[ar2[0] TableResult] ColumnNames] isEqualToArray:t1.ColumnNames]);
  XCTAssert([[[ar2[0] TableResult] Data] isEqualToArray:t1.Data]);
  XCTAssertEqual(t1.RowSize, [[ar2[0] TableResult] RowSize]);
  XCTAssertEqual(t1.ColumnSize, [[ar2[0] TableResult] ColumnSize]);

  //validate
  XCTAssert([[ar2[1] ValueResult] isEqualToString:[cr2 ValueResult]]);
  XCTAssert([[ar2[1] FigureResult] isEqualToString:[cr2 FigureResult]]);
  XCTAssert([[[ar2[1] TableResult] RowNames] isEqualToArray:t2.RowNames]);
  XCTAssert([[[ar2[1] TableResult] ColumnNames] isEqualToArray:t2.ColumnNames]);
  XCTAssert([[[ar2[1] TableResult] Data] isEqualToArray:t2.Data]);
  XCTAssertEqual(t2.RowSize, [[ar2[1] TableResult] RowSize]);
  XCTAssertEqual(t2.ColumnSize, [[ar2[1] TableResult] ColumnSize]);

  
  
  NSLog(@"json : %@", json);
}

- (void)testExecutionStep {
  /*
   public int Type { get; set; }
   public List<string> Code { get; set; }
   public List<string> Result { get; set; }
   public Tag Tag { get; set; }
   
   */
  
  STExecutionStep* es1 = [[STExecutionStep alloc] init];
  es1.Type = 1;
  es1.Code = [NSMutableArray arrayWithArray:@[@"1_code_1", @"1_code_2"]];
  es1.Result = [NSMutableArray arrayWithArray:@[@"1_result_1", @"1_result_2"]];
  //es1.Tag = ...

  STExecutionStep* es2 = [[STExecutionStep alloc] init];
  es2.Type = 2;
  es2.Code = [NSMutableArray arrayWithArray:@[@"2_code_1", @"2_code_2"]];
  es2.Result = [NSMutableArray arrayWithArray:@[@"2_result_1", @"2_result_2"]];
  //es.Tag = ...

  
  XCTAssert(false);
  
  
}

- (void)testFieldTag {
  XCTAssert(false);
}

- (void)testFigureFormat {
  //nothing to encode or decode here...(yet)
}


- (void)testTable {

  //build the array and serialize it to json
  NSArray<STTable*>* ar1 = [NSArray arrayWithObjects:t1, t2, nil];
  NSString* json = [STTable SerializeList:ar1 error:nil];

  //NSLog(@"json : %@", json);

  //now from json back to objects -> array
  NSArray* ar2 = [STTable DeserializeList:json error:nil];

  //validate
  XCTAssert([[ar2[0] RowNames] isEqualToArray:t1.RowNames]);
  XCTAssert([[ar2[0] ColumnNames] isEqualToArray:t1.ColumnNames]);
  XCTAssert([[ar2[0] Data] isEqualToArray:t1.Data]);
  XCTAssertEqual(t1.RowSize, [ar2[0] RowSize]);
  XCTAssertEqual(t1.ColumnSize, [ar2[0] ColumnSize]);

  XCTAssert([[ar2[1] RowNames] isEqualToArray:t2.RowNames]);
  XCTAssert([[ar2[1] ColumnNames] isEqualToArray:t2.ColumnNames]);
  XCTAssert([[ar2[1] Data] isEqualToArray:t2.Data]);
  XCTAssertEqual(t1.RowSize, [ar2[1] RowSize]);
  XCTAssertEqual(t2.ColumnSize, [ar2[1] ColumnSize]);
  
}

- (void)testTag {

  NSArray<STTag*>* ar1 = [NSArray arrayWithObjects:tg1, tg2, nil];
  NSString* json = [STTag SerializeList:ar1 error:nil];
  
  //NSLog(@"json : %@", json);
  
  //now from json back to objects -> array
  NSArray* ar2 = [STTag DeserializeList:json error:nil];

  //STOPPED HERE
  
  XCTAssert(false);
}



- (void)testTableFormat {
  
  //build the array and serialize it to json
  NSArray<STTableFormat*>* ar1 = [NSArray arrayWithObjects:tf1, tf2, nil];
  NSString* json = [STTableFormat SerializeList:ar1 error:nil];
  
  //NSLog(@"json : %@", json);
  
  //now from json back to objects -> array
  NSArray* ar2 = [STTableFormat DeserializeList:json error:nil];
  
  //validate
  XCTAssert([ar2[0] IncludeRowNames] == tf1.IncludeRowNames);
  XCTAssert([ar2[0] IncludeColumnNames] == tf1.IncludeColumnNames);
  XCTAssert([ar2[1] IncludeRowNames] == tf2.IncludeRowNames);
  XCTAssert([ar2[1] IncludeColumnNames] == tf2.IncludeColumnNames);

}

-(void)testValueFormat {
  

  //build the array and serialize it to json
  NSArray<STValueFormat*>* ar1 = [NSArray arrayWithObjects:vf1, vf2, nil];
  NSString* json = [STValueFormat SerializeList:ar1 error:nil];
  
  NSLog(@"json : %@", json);
  
  //now from json back to objects -> array
  NSArray* ar2 = [STValueFormat DeserializeList:json error:nil];

  XCTAssert([[ar2[0] FormatType] isEqualToString: [vf1 FormatType]]);
  XCTAssert([ar2[0] DecimalPlaces] == vf1.DecimalPlaces);
  XCTAssert([ar2[0] UseThousands] == vf1.UseThousands);
  XCTAssert([[ar2[0] DateFormat] isEqualToString: [vf1 DateFormat]]);
  XCTAssert([[ar2[0] TimeFormat] isEqualToString: [vf1 TimeFormat]]);
  XCTAssert([ar2[0] AllowInvalidTypes] == vf1.AllowInvalidTypes);
  
  XCTAssert([[ar2[1] FormatType] isEqualToString: [vf2 FormatType]]);
  XCTAssert([ar2[1] DecimalPlaces] == vf2.DecimalPlaces);
  XCTAssert([ar2[1] UseThousands] == vf2.UseThousands);
  XCTAssert([[ar2[1] DateFormat] isEqualToString: [vf2 DateFormat]]);
  XCTAssert([[ar2[1] TimeFormat] isEqualToString: [vf2 TimeFormat]]);
  XCTAssert([ar2[1] AllowInvalidTypes] == vf2.AllowInvalidTypes);

  
}

@end
