//
//  STDocumentManager+CodeFileManagement.h
//  StatTag
//
//  Created by Eric Whitley on 8/11/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <StatTagFramework/StatTagFramework.h>

@interface STDocumentManager (CodeFileManagement)
-(NSArray<STCodeFile*>*)unlinkedCodeFiles;
@end
