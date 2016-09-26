//
//  OfficeMacVBAPublic.c
//  StatTag
//
//  Created by Eric Whitley on 8/3/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#include "OfficeMacVBAPublic.h"
#import <Cocoa/Cocoa.h>

#import "STWindowLauncher.h"
#import "StatTag.h"

void StatTagOpenSettings()
{
  [STWindowLauncher openSettings];
}

void StatTagOpenUpdateOutput()
{
  [STWindowLauncher openUpdateOutput];
}

void StatTagUpdateWordFields()
{
  STDocumentManager* manager = [[STDocumentManager alloc] init];
  [manager UpdateFields];
}

void StatTagTestGettingFields()
{
  [STWindowLauncher testGettingFields];
}

void StatTagManageCodeFields()
{
  [STWindowLauncher openManageCodeFiles];
}


int TestCInterface()
{
  return 123;
}


