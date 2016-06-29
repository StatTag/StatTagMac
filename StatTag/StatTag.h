//
//  StatTag.h
//  StatTag
//
//  Created by Eric Whitley on 6/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for StatTag.
FOUNDATION_EXPORT double StatTagVersionNumber;

//! Project version string for StatTag.
FOUNDATION_EXPORT const unsigned char StatTagVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <StatTag/PublicHeader.h>

//NOTE: make sure you tag this as "public" in the framework target membership

//--Generators
#import <StatTag/STBaseGenerator.h>
#import <StatTag/STBaseParameterGenerator.h>
#import <StatTag/STFigureGenerator.h>
#import <StatTag/STIGenerator.h>
#import <StatTag/STStataBaseGenerator.h>
#import <StatTag/STTableGenerator.h>
#import <StatTag/STValueGenerator.h>

//--Interfaces
#import <StatTag/STJSONAble.h>
#import <StatTag/STIFileHandler.h>
#import <StatTag/STIResultCommandFormatter.h>
#import <StatTag/STIResultCommandList.h>

//--Models
#import <StatTag/STCodeFile.h>
#import <StatTag/STCodeFileAction.h>
#import <StatTag/STCommandResult.h>
#import <StatTag/STConstants.h>
#import <StatTag/STExecutionStep.h>
#import <StatTag/STFieldTag.h>
#import <StatTag/STFigureFormat.h>
#import <StatTag/STFileHandler.h>
#import <StatTag/STTable.h>
#import <StatTag/STTableFormat.h>
#import <StatTag/STTag.h>
#import <StatTag/STUpdatePair.h>
#import <StatTag/STValueFormat.h>

//--Parser
#import <StatTag/STBaseParameterParser.h>
#import <StatTag/STBaseParser.h>
#import <StatTag/STBaseParserStata.h>
#import <StatTag/STFigureParameterParser.h>
#import <StatTag/STIParser.h>
#import <StatTag/STTableParameterParser.h>
#import <StatTag/STValueParameterParser.h>

//--Utility
#import <StatTag/STJSONUtility.h>
#import <StatTag/STTagUtil.h>
#import <StatTag/STGeneralUtil.h>

//--ValueFormatter
#import <StatTag/STBaseValueFormatter.h>
#import <StatTag/STIValueFormatter.h>
#import <StatTag/STStataBaseValueFormatter.h>

//--Factories
#import <StatTag/STFactories.h>


