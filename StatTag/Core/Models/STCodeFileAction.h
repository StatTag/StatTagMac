//
//  STCodeFileAction.h
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STJSONable.h"

/**
 @brief Used to specify an action to take when a code file is unlinked from a document, and there
        are tags referenced in the document that it depends on.
 */
@interface STCodeFileAction : NSObject <STJSONAble> {
  NSString* _Label;
  int _Action;
  id _Parameter;
}

/**
 @brief The description of the action (for the UI)
 */
@property (copy, nonatomic) NSString *Label;
/**
 @brief The action that should be performed, from Constants.CodeFileActionTask
 */
@property int Action;
/**
 @brief An optional parameter associated with an action.  For example, linking to a new file will
        specify the file to link to as the parameter.
 */
@property (strong, nonatomic) id Parameter;

-(NSString *)ToString;

@end
