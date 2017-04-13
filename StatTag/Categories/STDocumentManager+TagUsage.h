//
//  STDocumentManager+TagUsage.h
//  StatTag
//
//  Created by Eric Whitley on 4/12/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <StatTagFramework/StatTagFramework.h>

@interface STDocumentManager (TagUsage)
-(NSArray<STFieldTag*>*)fieldTagsForTag:(STTag*)tag inDocument:(STMSWord2011Document*) doc;
@end
