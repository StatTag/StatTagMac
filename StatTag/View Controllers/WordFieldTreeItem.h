//
//  WordFieldTreeItem.h
//  StatTag
//
//  Created by Eric Whitley on 2/27/19.
//  Copyright © 2019 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMSWord2011.h"
#import "StatTagShared.h"
#import "StatTagWordDocument.h"

#import "STTagManager.h"
#import "STDocumentManager.h"
#import "STFieldTag.h"
#import "STTag.h"

@interface WordFieldTreeItem : NSObject

@property STMSWord2011Field* field;
@property STTag* tag;
@property (nonatomic) BOOL isStatTagField;
@property STFieldTag* fieldTag;

@property (strong) NSMutableArray *childFields;
@property (nonatomic) BOOL isLeaf;

@property NSString* nodeTitle;
@property NSInteger entryIndex;
@property (nonatomic) NSInteger numChildren;
@property NSIndexPath* indexPath;
@property NSString* fieldData;

@property StatTagWordDocument* document;


//Cannot perform operation because childrenKeyPath is nil

@property WordFieldTreeItem* parentFieldTreeItem;

-(instancetype)initWithField:(STMSWord2011Field*) field andParentField:(WordFieldTreeItem*)parent forDocument:(StatTagWordDocument*)document;

@end
