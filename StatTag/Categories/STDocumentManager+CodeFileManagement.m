//
//  STDocumentManager+CodeFileManagement.m
//  StatTag
//
//  Created by Eric Whitley on 8/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "STDocumentManager+CodeFileManagement.h"
#import "NSURL+FileAccess.h"


@implementation STDocumentManager (CodeFileManagement)

//find all unlinked (aka not found) code files - based on URL path
-(NSArray<STCodeFile*>*)unlinkedCodeFiles
{
  NSMutableArray<STCodeFile*>* unlinkedCodeFiles = [[NSMutableArray<STCodeFile*> alloc] init];
  for(STCodeFile* cf in [self GetCodeFileList])
  {
    if(![[cf FilePathURL] fileExistsAtPath])
    {
      [unlinkedCodeFiles addObject:cf];
    }
  }
  
  return unlinkedCodeFiles;
}


@end
