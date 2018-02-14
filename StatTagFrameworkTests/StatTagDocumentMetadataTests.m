//
//  StatTagDocumentMetadataTests.m
//  StatTag
//
//  Created by Eric Whitley on 1/18/18.
//  Copyright © 2018 StatTag. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "StatTagFramework.h"


@interface StatTagDocumentMetadataTests : XCTestCase

@end

@implementation StatTagDocumentMetadataTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    [super tearDown];
}

- (void)testSerialize_Partial {

  STDocumentMetadata* metadata = [[STDocumentMetadata alloc] init];
  [metadata setStatTagVersion:@"3.1.0"];

  NSString* serialized = [metadata Serialize:nil];
  //NOTE: deviating from Windows test case because of differences in JSON handling
  XCTAssert([@"{\"StatTagVersion\":\"3.1.0\"}" isEqualToString:serialized]);

  metadata = [[STDocumentMetadata alloc] initWithJSONString:@"{\"MetadataFormatVersion\":null,\"StatTagVersion\":\"3.1.0\"}" error:nil];
  serialized = [metadata Serialize:nil];
  NSDictionary *objDict = [NSJSONSerialization JSONObjectWithData:[serialized dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
  
  NSString* jsonString = @"{\"StatTagVersion\":\"3.1.0\"}";
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
  XCTAssert([objDict isEqualToDictionary:jsonDict]);
}

- (void)testSerialize_Full {
  
  STDocumentMetadata* metadata = [[STDocumentMetadata alloc] init];
  [metadata setStatTagVersion:@"3.1.0"];
  [metadata setRepresentMissingValues:@"StatPackageDefault"];
  [metadata setCustomMissingValue:@"[X]"];
  [metadata setMetadataFormatVersion:@"1.0.0"];
  [metadata setTagFormatVersion:@"1.0.0"];
  
  NSString* serialized = [metadata Serialize:nil];
  NSDictionary *objDict = [NSJSONSerialization JSONObjectWithData:[serialized dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];

  NSString* jsonString = @"{\"MetadataFormatVersion\":\"1.0.0\",\"TagFormatVersion\":\"1.0.0\",\"StatTagVersion\":\"3.1.0\",\"RepresentMissingValues\":\"StatPackageDefault\",\"CustomMissingValue\":\"[X]\"}";
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
  
  XCTAssert([objDict isEqualToDictionary:jsonDict]);
}

- (void)testDeserialize_Partial {
  
  NSString* json = @"{\"StatTagVersion\":\"3.1.0\"}";
  STDocumentMetadata* metadata = [STDocumentMetadata Deserialize:json error:nil];
  
  XCTAssert([[metadata StatTagVersion] isEqualToString:@"3.1.0"]);
  XCTAssertNil([metadata RepresentMissingValues]);
  XCTAssertNil([metadata CustomMissingValue]);
  XCTAssertNil([metadata MetadataFormatVersion]);
  XCTAssertNil([metadata TagFormatVersion]);
}


- (void)testDeserialize_Full {
  
  NSString* json = @"{\"MetadataFormatVersion\":\"1.0.0\",\"TagFormatVersion\":\"1.0.0\",\"StatTagVersion\":\"StatTag v3.1.0\",\"RepresentMissingValues\":\"StatPackageDefault\",\"CustomMissingValue\":\"[X]\"}";
  STDocumentMetadata* metadata = [STDocumentMetadata Deserialize:json error:nil];
  
  XCTAssert([[metadata StatTagVersion] isEqualToString:@"StatTag v3.1.0"]);
  XCTAssert([[metadata RepresentMissingValues] isEqualToString:@"StatPackageDefault"]);
  XCTAssert([[metadata CustomMissingValue] isEqualToString:@"[X]"]);
  XCTAssert([[metadata MetadataFormatVersion] isEqualToString:@"1.0.0"]);
  XCTAssert([[metadata TagFormatVersion] isEqualToString:@"1.0.0"]);
}

- (void)testDeserialize_ExtraFields {
  // Ensure deserializing works with extra fields in there
  NSString* json = @"{\"Extra\":\"Data\", \"StatTagVersion\":\"3.1.0\"}";
  STDocumentMetadata* metadata = [STDocumentMetadata Deserialize:json error:nil];
  
  XCTAssert([[metadata StatTagVersion] isEqualToString:@"3.1.0"]);
  XCTAssert([[[metadata ExtraMetadata] objectForKey:@"Extra"] isEqualToString:@"Data"]);
}

- (void)testDeserialize_FullSerializeDeserializeExtraFields {
  // Ensure deserializing works with extra fields in there
  NSString* json = @"{\"Extra\":\"Data\", \"StatTagVersion\":\"3.1.0\"}";
  STDocumentMetadata* metadata = [STDocumentMetadata Deserialize:json error:nil];
  
  XCTAssert([[metadata StatTagVersion] isEqualToString:@"3.1.0"]);
  XCTAssert([[[metadata ExtraMetadata] objectForKey:@"Extra"] isEqualToString:@"Data"]);
  
  NSString* serialized = [metadata Serialize:nil];
  NSDictionary *serializedDict = [NSJSONSerialization JSONObjectWithData:[serialized dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
  
  //NOTE: deviating from test based on discussion w/ Luke. Comparing strings is a mess, so we're comparing dictionaries, BUT we are tossing out keys with missing / NULL values, so - we're omitting them in this string
  //origial: "{\"MetadataFormatVersion\":null,\"TagFormatVersion\":null,\"StatTagVersion\":\"3.1.0\",\"RepresentMissingValues\":null,\"CustomMissingValue\":null,\"Extra\":\"Data\"}"
  NSString* jsonString = @"{\"StatTagVersion\":\"3.1.0\",\"Extra\":\"Data\"}";
  NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];


  XCTAssert([serializedDict isEqualToDictionary:jsonDict]);
}


@end
