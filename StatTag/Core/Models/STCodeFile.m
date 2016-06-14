//
//  STCodeFile.m
//  StatTag
//
//  Created by Eric Whitley on 6/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STCodeFile.h"

@implementation STCodeFile

@synthesize ContentCache = ContentCache;
@synthesize StatisticalPackage = StatisticalPackage;
@synthesize FilePath = FilePath;
@synthesize LastCached = LastCached;
@synthesize Tags = Tags;

@synthesize Content = _Content;
- (void) setContent:(NSMutableArray *)c {
  _Content = c;
}
- (NSMutableArray*) Content {
  // get { return ContentCache ?? (ContentCache = LoadFileContent()); }
  if(ContentCache == nil) {
    ContentCache = [self LoadFileContent];
  }
  return _Content;
}




/**
 @brief Return the contents of the CodeFile
*/
- (NSMutableArray*) LoadFileContent {
  [self RefreshContent];
  return ContentCache;
}

/**
 @brief Return the contents of the CodeFile
*/
- (void) RefreshContent {
  //ContentCache = new List<string>(FileHandler.ReadAllLines(FilePath));
  ContentCache = [[NSMutableArray alloc] init];
  
}



@end
