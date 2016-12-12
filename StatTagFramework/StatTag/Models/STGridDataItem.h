//
//  STGridDataItem.h
//  StatTag
//
//  Created by Eric Whitley on 8/1/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STCodeFileAction;

@interface STGridDataItem : NSObject {
  NSString* _Display;
  STCodeFileAction* _Data;
}


@property (copy, nonatomic) NSString* Display;
@property (copy, nonatomic) STCodeFileAction* Data;


/**
 Utility method to create an action item for our combo box column
 
 @remarks: We're wrapping this up to facilitate the DataGridView and how it works.  The GridDataItem lets us have a display and value property, and the value (the CodeFileAction) can then be picked up and shared when it is selected.
 @param @display: What to display in the combo box</param>
 @param @action: The resulting action to perform
 @param @parameter: Optional - parameter to use with the specified action.
 @returns: The created GridDataItem that wraps and contains a CodeFileAction
 */
+(STGridDataItem*)CreateActionItem:(NSString*)display action:(NSInteger)action parameter:(id)parameter;


@end
