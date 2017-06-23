//
//  ASOC.h
//  TestASOC
//
//  Created by Eric Whitley on 7/14/16.
//  Copyright © 2016 Eric Whitley. All rights reserved.
//

#import <Foundation/Foundation.h>

//@protocol ASOC <NSObject>
//
//-(void)thinkdifferent;
//-(NSNumber *)square:(NSNumber *)aNumber;
//
//@end
@class STMSWord2011Document;
@class STMSWord2011LinkFormat;

@interface WordASOC : NSObject

// Note: C primitives are only automatically bridged when calling from AS into ObjC.
// AS methods with boolean/integer/real parameters/results must declare NSNumber*:

-(NSNumber*)findText:(NSString*)searchText atRangeStart:(NSNumber*)rangeStart andRangeEnd:(NSNumber*)rangeEnd;

-(void)createOrUpdateDocumentVariableWithName:(NSString*)variableName andValue:(NSString*)variableValue;

-(void)UpdateLinkFormat:(STMSWord2011LinkFormat*)linkFormat;
-(void)insertImageAtPath:(NSString*)filePath;
-(void)UpdateAllImageLinks;
-(NSNumber*)createTableAtRangeStart:(NSNumber*)rangeStart andRangeEnd:(NSNumber*)rangeEnd withRows:(NSNumber*)rows andCols:(NSNumber*)cols;
-(NSNumber*)insertParagraphAtRangeStart:(NSNumber*)rangeStart andRangeEnd:(NSNumber*)rangeEnd;
-(NSNumber*)updateAllFields;

-(void)setActiveDocumentByDocName:(NSString*)theName;

-(void)insertTextboxAtRangeStart:(NSNumber*)theRangeStart andRangeEnd:(NSNumber*)theRangeEnd forShapeName:(NSString*)shapeName withShapetext:(NSString*)shapeText andFontSize:(NSNumber*)fontSize andFontFace:(NSString*)fontFace;

//-(void)disableScreenUpdates;
//-(void)enableScreenUpdates;

@end
