//
//  WordFieldTreeItem.m
//  StatTag
//
//  Created by Eric Whitley on 2/27/19.
//  Copyright © 2019 StatTag. All rights reserved.
//

#import "WordFieldTreeItem.h"

@implementation WordFieldTreeItem

@synthesize field;
@synthesize tag;
@synthesize fieldTag;

@synthesize parentFieldTreeItem;

@synthesize indexPath;
@synthesize entryIndex;
@synthesize nodeTitle;
@synthesize numChildren;

@synthesize childFields;
@synthesize isStatTagField;
@synthesize fieldData;

@synthesize document;

- (instancetype)init
{
  self = [super init];
  if (self != nil)
  {
    self.nodeTitle = @"";
    self.childFields = [[NSMutableArray alloc] init];
  }
  return self;
}

-(instancetype)initWithField:(STMSWord2011Field*)wordField andParentField:(WordFieldTreeItem*)parent forDocument:(StatTagWordDocument*)document
{
  self = [super init];
  if (self != nil)
  {
    self.nodeTitle = @"";
    self.childFields = [[NSMutableArray alloc] init];
    self.fieldData = @"";
    NSIndexPath* path;
    path = [[NSIndexPath alloc] initWithIndex:0];
    [self setIndexPath:path];
    [self setDocument:document];
    if(parent != nil)
    {
      [[parent childFields] addObject:self];
      [self setParentFieldTreeItem:parent];
    }
    
    [self setField:wordField];

    /*
    if(wordField != nil)
    {
      [self setField:wordField];
      
      NSInteger arrayIndex = [wordField entry_index] -1;
      [self setEntryIndex:[wordField entry_index]];
      [self setNodeTitle:[NSString stringWithFormat:@"%ld", (long)[self entryIndex]]];
      //[self setField:wordField];
      //path = [[NSIndexPath alloc] initWithIndex:arrayIndex];
      if([wordField fieldText] != nil)
      {
        fieldData = [wordField fieldText];
      }
      [self setField:wordField];
      if([self isStatTagField]) {
        [self setNodeTitle:[fieldTag Name]];
      }
      
      //[self setIndexPath:path];
    }
    */
  }
  return self;
}


-(void)setField:(STMSWord2011Field *)theField
{
  field = theField;
  tag = nil;
  
  if(field != nil) {
    
    //NSInteger arrayIndex = [field entry_index] -1;
    [self setEntryIndex:[field entry_index]];
    [self setNodeTitle:[NSString stringWithFormat:@"%ld", (long)[self entryIndex]]];
    //[self setField:wordField];
    //[self setIndexPath: [[NSIndexPath alloc] initWithIndex:arrayIndex]];
    if([field fieldText] != nil)
    {
      fieldData = [field fieldText];
    }
    
    if ([STTagManager IsStatTagField:field]) {
      fieldTag = [[[[StatTagShared sharedInstance] docManager] TagManager] GetFieldTag:field];
      [self setFieldTag:fieldTag];
      //STTag* t = [[[[StatTagShared sharedInstance] docManager] TagManager] tag
      //NSLog(@"fieldTag FormattedResult : %@", [fieldTag FormattedResult]);
      isStatTagField = YES;
      
      [self setNodeTitle:[fieldTag Name]];
      if(document != nil) {
        for(STTag* sttag in [[[[StatTagShared sharedInstance] docManager] TagManager] GetTags])
        {
          if([[fieldTag Id] isEqualToString: [sttag Id]])
          {
            [self setTag:sttag];
            //[self setFieldTag[[[[StatTagShared sharedInstance] docManager] TagManager] GetFieldTag:[currentField field]]];
          }
        }
      }
    } else {
      if([[self parentFieldTreeItem] tag] != nil)
      {
        [self setTag:[[self parentFieldTreeItem] tag]];
        [self setFieldTag:[[self parentFieldTreeItem] fieldTag]];
        [self setNodeTitle:[NSString stringWithFormat:@"%@ (*)", [[self parentFieldTreeItem] nodeTitle]]];

        [self setIsStatTagField:YES];
      } else {
        isStatTagField = NO;
      }
    }
  } else {
    isStatTagField = NO;
  }

}

-(STMSWord2011Field*)field {
  return field;
}

-(BOOL)isLeaf
{
  if([self numChildren] > 0)
  {
    return NO;
  }
  return YES;
  
}

-(NSInteger)numChildren
{
  return [[self childFields] count];
}

- (NSString*)description
{
  return [self nodeTitle];
}


@end
