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

//    public class DuplicateTagResults : Dictionary<CodeFile, Dictionary<Tag, List<Tag>>>

//typalias DuplicateTagResults : NSDictionary<STTag*, NSArray<STTag*>*>
//typedef MyClass<MyProtocol> MyTypeAlias

typedef NSMutableDictionary<STTag*, NSArray<STTag*>*> STDuplicateTagResults;

