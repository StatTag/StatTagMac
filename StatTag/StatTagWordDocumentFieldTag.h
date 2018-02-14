//
//  StatTagWordDocumentFieldTag.h
//  StatTag
//
//  Created by Eric Whitley on 10/24/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STMSWord2011Field;
@class STTag;
@class STFieldTag;
@class STMSWord2011Shape;

@interface StatTagWordDocumentFieldTag : NSObject

@property STMSWord2011Field* field;
@property STMSWord2011Shape* shape;

@property STTag* tag;
@property STFieldTag* fieldTag;

@property BOOL unlinked;

-(NSString*) fieldType;

-(instancetype)initWithWordField:(STMSWord2011Field*)field andFieldTag:(STFieldTag*)fieldTag andTag:(STTag*)tag;
-(instancetype)initWithWordShape:(STMSWord2011Shape*)shape andTag:(STTag*)tag;

-(void)updateWithTag:(STTag*)tag;
-(void)removeTag;

@end
