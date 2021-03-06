//
//  WordHelpers.h
//  StatTag
//
//  Created by Eric Whitley on 7/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STMSWord2011TextRange;
@class STMSWord2011Document;
@class STMSWord2011LinkFormat;
@class STMSWord2011Table;
@class STMSWord2011BaseObject;
@class STMSWord2011Field;

@interface WordHelpers : NSObject

+ (instancetype)sharedInstance;

+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range;
+(STMSWord2011TextRange*)DuplicateRange:(STMSWord2011TextRange*)range forDoc:(STMSWord2011Document*)doc;
+(BOOL)FindText:(NSString*)text inRange:(STMSWord2011TextRange*)range;

/**
 Unlike the C# version of Range, we can't just update content - this simply _appends_ content to the range. And - we can't directly update the content and shift the positions cleanly - the "update position" methods all return a new instance of the text range.  (I know, right?)
 
 So instead we need to return a new object, but... not. So we're going to create a new one in the method and then point to that object using the original object reference.
 
 Kludgy.
 */
+(void)updateContent:(NSString*)text inRange:(STMSWord2011TextRange**)range;
//+(STMSWord2011TextRange*)setRangeStart:(NSInteger)start end:(NSInteger)end;
+(void)setRange:(STMSWord2011TextRange**)range start:(NSInteger)start end:(NSInteger)end;
+(void)setRange:(STMSWord2011TextRange**)range start:(NSInteger)start end:(NSInteger)end withDoc:(STMSWord2011Document*)doc;

+(void)createOrUpdateDocumentVariableWithName:(NSString*)variableName andValue:(NSString*)variableValue;

+(void)UpdateLinkFormat:(STMSWord2011LinkFormat*)linkFormat;
+(BOOL)imageExistsAtPath:(NSString*)filePath;
+(BOOL)insertImageAtPath:(NSString*)filePath;
+(void)UpdateAllImageLinks;
//+(void)disableScreenUpdates;
//+(void)enableScreenUpdates;
+(void)toggleAllFieldCodes;
+(void)toggleFieldCodesInRange:(STMSWord2011TextRange*)range;

+(STMSWord2011Table*)createTableAtRange:(STMSWord2011TextRange*)range withRows:(NSInteger)rows andCols:(NSInteger)cols;
+(BOOL)insertParagraphAtRange:(STMSWord2011TextRange*)range;


+(BOOL)updateAllFields;

+(void)select:(STMSWord2011BaseObject*)wordObject;

+(void)selectTextAtRangeStart:(NSInteger)rangeStart andEnd:(NSInteger)rangeEnd;
+(void)selectTextInRange:(STMSWord2011TextRange*)textRange;

+(NSMutableArray<STMSWord2011Field*>*) getAllFieldsInDocument:(STMSWord2011Document*)document;

+(void)setActiveDocumentByDocName:(NSString*)theName;
+(NSString*)getActiveDocumentName;


+(void)insertTextboxAtRangeStart:(NSInteger)theRangeStart andRangeEnd:(NSInteger)theRangeEnd forShapeName:(NSString*)shapeName withShapetext:(NSString*)shapeText andFontSize:(double)fontSize andFontFace:(NSString*)fontFace withMultiplier:(double)multiplier;

+(void)updateShapeHeightToFitTextContentsForShapeNamed:(NSString*)shapeName andFontSize:(double)fontSize andFontFace:(NSString*)fontFace withMultiplier:(double)multiplier;

+(void)insertFieldAtRangeStart:(NSInteger)theRangeStart andRangeEnd:(NSInteger)theRangeEnd forFieldType:(NSInteger)fieldType withText:(NSString*)fieldText  ;

@end
