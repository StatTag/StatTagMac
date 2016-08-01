//
//  STGridDataItem.m
//  StatTag
//
//  Created by Eric Whitley on 8/1/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STGridDataItem.h"

#import "STCodeFileAction.h"

@implementation STGridDataItem

@synthesize Display = _Display;
@synthesize Data = _Data;


/**
 Utility method to create an action item for our combo box column

 @remarks: We're wrapping this up to facilitate the DataGridView and how it works.  The GridDataItem lets us have a display and value property, and the value (the CodeFileAction) can then be picked up and shared when it is selected.
  @param @display: What to display in the combo box</param>
  @param @action: The resulting action to perform
  @param @parameter: Optional - parameter to use with the specified action.
  @returns: The created GridDataItem that wraps and contains a CodeFileAction
*/
+(STGridDataItem*)CreateActionItem:(NSString*)display action:(int)action parameter:(id)parameter
{
  STCodeFileAction* cf = [[STCodeFileAction alloc] init];
  cf.Label = display;
  cf.Action = action;
  cf.Parameter = parameter;

  STGridDataItem* grid = [[STGridDataItem alloc] init];
  grid.Display = display;
  grid.Data = cf;

  return grid;
}


@end
