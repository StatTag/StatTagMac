//
//  STMSWord2011TextRange+StatTagExtensions.h
//  StatTag
//
//  Created by Eric Whitley on 7/13/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

/*
 
 Leaving this in here for reference so you know we tried this...
 
 Thought "oh, so with the absence of range duplication, maybe we can just copy the range and then write a category to have 'Duplicate' available to us?"
 
 Yes - that would work - but not with scripting bridge. At least not reliably in any way that's worth it.
 
 Since the objects don't really exist (properly as types) the way you think they would, you can't extend a "range" object - you have to extend the _scripting bridge_ object.  And, in practice, that's problematic since it's not only doesn't work all that well, but it's sort of a dangerous thing to do.
 
 */
//#import <StatTag/StatTagFramework.h>
//#import <ScriptingBridge/ScriptingBridge.h>
//
//@interface SBObject (StatTagExtensions)
//
//-(STMSWord2011TextRange*)Duplicate;
//-(STMSWord2011TextRange*)DuplicateForDoc:(STMSWord2011Document*)doc;
//
//@end
