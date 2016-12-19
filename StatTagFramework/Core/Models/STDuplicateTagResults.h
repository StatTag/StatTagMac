//
//  STDuplicateTagResults.h
//  StatTag
//
//  Created by Eric Whitley on 7/11/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#ifndef STDuplicateTagResults_h
#define STDuplicateTagResults_h


#endif /* STDuplicateTagResults_h */

@class STTag;

typedef NSMutableDictionary<STTag*, NSArray<STTag*>*> STDuplicateTagResults;

/*
NOTE: this is different from the C#
 
 StatTag.Core.Models.DuplicateTagResults -> is a class

 We're using a typedef (which is how we had it originally - prior to the December, 2016 code update)
 
 [Serializable]
 public class DuplicateTagResults : Dictionary<CodeFile, Dictionary<Tag, List<Tag>>>
 {
 }
*/
