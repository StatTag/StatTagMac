//
//  STDocumentManager+TagUsage.m
//  StatTag
//
//  Created by Eric Whitley on 4/12/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import "STDocumentManager+TagUsage.h"

@implementation STDocumentManager (TagUsage)

-(NSArray<STFieldTag*>*)fieldTagsForTag:(STTag*)tag inDocument:(STMSWord2011Document*) doc
{
  NSMutableArray<STFieldTag*>* fieldTags = [[NSMutableArray<STFieldTag*> alloc] init];
  if(doc == nil)
  {
    STMSWord2011Application* app = [[[STGlobals sharedInstance] ThisAddIn] Application];
    doc = [app activeDocument];
  }
  if(doc == nil)
  {
    return fieldTags;
  }

  SBElementArray<STMSWord2011Field*>* fields = [doc fields];
  NSInteger fieldsCount = [fields count];

  for (NSInteger index = fieldsCount - 1; index >= 0; index--)
  {
    STMSWord2011Field* field = fields[index];
    if (field == nil)
    {
      continue;
    }
    if (![_TagManager IsStatTagField:field])
    {
      continue;
    }
    STFieldTag* fieldTag = [_TagManager GetFieldTag:field];
    if ([tag isEqual:fieldTag])
    {
      [fieldTags addObject:fieldTag];
    }
  }
  
  return fieldTags;
}

@end
