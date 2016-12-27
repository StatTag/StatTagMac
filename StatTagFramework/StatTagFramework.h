//
//  StatTagFramework.h
//  StatTag
//
//  Created by Eric Whitley on 6/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppleScriptObjC/AppleScriptObjC.h>

//! Project version number for StatTag.
FOUNDATION_EXPORT double StatTagVersionNumber;

//! Project version string for StatTag.
FOUNDATION_EXPORT const unsigned char StatTagVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <StatTag/PublicHeader.h>


//NOTE: make sure you tag this as "public" in the framework target membership



//======================================
// StatTag
//======================================

//--Categories
#import <StatTagFramework/NSMutableArray+Stack.h>
#import <StatTagFramework/WordHelpers.h>
//#import <StatTagFramework/SBObject+StatTagExtensions.h>
#import <StatTagFramework/WordASOC.h>
//#import <StatTagFramework/WordFindProtocol.h>


//--Classes
#import <StatTagFramework/STGlobals.h>
#import <StatTagFramework/STThisAddIn.h>

//--Models
#import <StatTagFramework/STBaseManager.h>
#import <StatTagFramework/STDocumentManager.h>
#import <StatTagFramework/STDuplicateTagResults.h>
#import <StatTagFramework/STFieldGenerator.h>
#import <StatTagFramework/STGridDataItem.h>
#import <StatTagFramework/STProperties.h>
#import <StatTagFramework/STPropertiesManager.h>
#import <StatTagFramework/STMSWord2011.h>
#import <StatTagFramework/STStatsManager.h>
#import <StatTagFramework/STTagManager.h>
#import <StatTagFramework/STLogManager.h>
#import <StatTagFramework/STCSVToTable.h>
#import <StatTagFramework/STFilterFormat.h>
#import <StatTagFramework/STLogManager.h>

#import <StatTagFramework/STUIUtility.h>
#import <StatTagFramework/STTableData.h>





//======================================
// CORE
//======================================

//--Stata
#import <StatTagFramework/STStata.h>
#import <StatTagFramework/STStataAutomation.h>
#import <StatTagFramework/STStataCommands.h>

//--SAS
#import <StatTagFramework/STSASAutomation.h>
#import <StatTagFramework/STSASCommands.h>

//--R
#import <StatTagFramework/STRAutomation.h>
#import <StatTagFramework/STRCommands.h>

//--Generators
#import <StatTagFramework/STBaseGenerator.h>
#import <StatTagFramework/STBaseParameterGenerator.h>
#import <StatTagFramework/STFigureGenerator.h>
#import <StatTagFramework/STIGenerator.h>
#import <StatTagFramework/STStataBaseGenerator.h>
#import <StatTagFramework/STTableParameterGenerator.h>
#import <StatTagFramework/STValueParameterGenerator.h>

//--Interfaces
#import <StatTagFramework/STJSONAble.h>
#import <StatTagFramework/STIFileHandler.h>
#import <StatTagFramework/STIResultCommandFormatter.h>
#import <StatTagFramework/STIResultCommandList.h>
#import <StatTagFramework/STICodeFileParser.h>
#import <StatTagFramework/STIStatAutomation.h>


//--Models
#import <StatTagFramework/STCodeFile.h>
#import <StatTagFramework/STCodeFileAction.h>
#import <StatTagFramework/STCommandResult.h>
#import <StatTagFramework/STConstants.h>
#import <StatTagFramework/STExecutionStep.h>
#import <StatTagFramework/STFieldTag.h>
#import <StatTagFramework/STFigureFormat.h>
#import <StatTagFramework/STFileHandler.h>
#import <StatTagFramework/STTable.h>
#import <StatTagFramework/STTableFormat.h>
#import <StatTagFramework/STTag.h>
#import <StatTagFramework/STUpdatePair.h>
#import <StatTagFramework/STValueFormat.h>

//--Parser
#import <StatTagFramework/STBaseParameterParser.h>
#import <StatTagFramework/STBaseParser.h>
#import <StatTagFramework/STStataParser.h>
#import <StatTagFramework/STSASParser.h>
#import <StatTagFramework/STFigureParameterParser.h>
#import <StatTagFramework/STICodeFileParser.h>
#import <StatTagFramework/STTableParameterParser.h>
#import <StatTagFramework/STValueParameterParser.h>

//--Utility
#import <StatTagFramework/STCocoaUtil.h>
#import <StatTagFramework/STJSONUtility.h>
#import <StatTagFramework/STTagUtil.h>
#import <StatTagFramework/STGeneralUtil.h>
#import <StatTagFramework/STTableUtil.h>


//--ValueFormatter
#import <StatTagFramework/STBaseValueFormatter.h>
#import <StatTagFramework/STIValueFormatter.h>
#import <StatTagFramework/STStataBaseValueFormatter.h>

//--Factories
#import <StatTagFramework/STFactories.h>


