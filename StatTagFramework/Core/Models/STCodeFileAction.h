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
  NSInteger _Action;
  id _Parameter;
}

/**
 @brief The description of the action (for the UI)
 */
@property (copy, nonatomic) NSString *Label;
/**
 @brief The action that should be performed, from Constants.CodeFileActionTask
 */
@property NSInteger Action;
/**
 @brief An optional parameter associated with an action.  For example, linking to a new file will
        specify the file to link to as the parameter.
 */
@property (strong, nonatomic) id Parameter;

-(NSString *)ToString;



//MARK: JSON
-(NSDictionary *)toDictionary;
-(NSString*)Serialize:(NSError**)error;
+(NSString*)SerializeList:(NSArray<STCodeFileAction*>*)list error:(NSError**)error;
+(NSArray<STCodeFileAction*>*)DeserializeList:(id)List error:(NSError**)error;
-(instancetype)initWithDictionary:(NSDictionary*)dict;
-(instancetype)initWithJSONString:(NSString*)JSONString error:(NSError**)error;


@end
