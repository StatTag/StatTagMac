//
//  STCodeFile.h
//  StatTag
//
//  Created by Eric Whitley on 6/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>


/** 
@brief A sequence of instructions saved in a text file that can be executed
 in a statistical package (e.g. Stata, R, SAS), and will be used within
 a Word document to derive values that are placed into the document text.
*/
@interface STCodeFile : NSObject {
  NSMutableArray<NSString *> *ContentCache;
  NSString *StatisticalPackage;
  NSURL *FilePath;
  NSDate *LastCached;
  //FIXME: type for Tags should be suggested as Tag, not NSString
  NSMutableArray<NSString *> *Tags;
  
  NSMutableArray<NSString *> *_Content;

}

//NSMutableArray<NSString *> *onlyStrings

@property NSMutableArray<NSString *> *ContentCache;
@property (copy) NSString *StatisticalPackage;
@property (copy) NSURL *FilePath;
@property NSDate *LastCached;
//FIXME: type for Tags should be suggested as Tag, not NSString
@property NSMutableArray<NSString *> *Tags;

@property (nonatomic) NSMutableArray<NSString *> *Content;


- (NSMutableArray*) LoadFileContent;


@end
