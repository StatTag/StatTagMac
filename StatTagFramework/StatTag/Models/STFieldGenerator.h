//
//  STFieldGenerator.h
//  StatTag
//
//  Created by Eric Whitley on 7/12/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMSWord2011.h"

@interface STFieldGenerator : NSObject {
}

+(NSString*)FieldOpen;
+(NSString*)FieldClose;


//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString fieldOpen:(NSString*)fieldOpen fieldClose:(NSString*)fieldClose withDoc:(STMSWord2011Document*)doc;
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString fieldOpen:(NSString*)fieldOpen fieldClose:(NSString*)fieldClose;
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range;
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString;
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString withDoc:(STMSWord2011Document*)doc;
//+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range theString:(NSString*)theString fieldOpen:(NSString*)fieldOpen;

+(NSArray<STMSWord2011Field*>*)InsertField:(STMSWord2011TextRange*)range displayValue:(NSString*)displayValue macroButtonName:(NSString*)macroButtonName tagIdentifier:(NSString*)tagIdentifier withDoc:(STMSWord2011Document*)doc;

+(NSString*)escapeMacroContent:(NSString*)content;

+(STMSWord2011Field*)AddFieldToRange:(STMSWord2011TextRange*)range type:(STMSWord2011E183)type preserveFormatting:(BOOL)preserveFormatting text:(NSString*)text;

@end
