/*
 *  R.app : a Cocoa front end to: "R A Computer Language for Statistical Data Analysis"
 *  
 *  R.app Copyright notes:
 *                     Copyright (C) 2004-5  The R Foundation
 *                     written by Stefano M. Iacus and Simon Urbanek
 *
 *                  
 *  R Copyright notes:
 *                     Copyright (C) 1995-1996   Robert Gentleman and Ross Ihaka
 *                     Copyright (C) 1998-2001   The R Development Core Team
 *                     Copyright (C) 2002-2004   The R Foundation
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  A copy of the GNU General Public License is available via WWW at
 *  http://www.gnu.org/copyleft/gpl.html.  You can also obtain it by
 *  writing to the Free Software Foundation, Inc., 59 Temple Place,
 *  Suite 330, Boston, MA  02111-1307  USA.
 *
 *  Created by Simon Urbanek on Wed Dec 10 2003.
 *
 */

#ifndef RCEngine_h
#define RCEngine_h

#import <Cocoa/Cocoa.h>

#import <Foundation/Foundation.h>

/* 
 * When we use the RCocoa framework in other applications, we end up with a compilation conflict
 * because of FALSE and TRUE being defined, and the way in which the typedef is being declared
 * as an anonymous type.  To resolve this, we circumvent the Rext/Boolean.h definition entirely
 * (hence our use of #define R_EXT_BOOLEAN_H_), and define it in a way that won't cause compiler
 * complaints.
 */
#ifndef R_EXT_BOOLEAN_H_
#define R_EXT_BOOLEAN_H_
#undef FALSE
#undef TRUE
#ifdef  __cplusplus
extern "C" {
#endif
    typedef enum Rboolean { R_FALSE = 0, R_TRUE /*, MAYBE */ } Rboolean;
#ifdef  __cplusplus
}
#endif
#endif /* R_EXT_BOOLEAN_H_ */


#import <R/R.h>

#import "RSEXP.h"
#import "RCSymbolicExpression.h"
#import "RCCharacterDeviceAdapter.h"
#import "RCICharacterDevice.h"

/* since R 2.0 parse is mapped to Rf_parse which is deadly ... 
   therefore RCEngine.h must be included *after* R headers */
#ifdef parse
#undef parse
#endif

/* macros for translatable strings */
#define NLS(S) NSLocalizedString(S,@"")
#define NLSC(S,C) NSLocalizedString(S,C)

// Solution for dynamic casting taken from - https://stackoverflow.com/a/10557838/
# include <objc/runtime.h>
#define objc_dynamic_cast(obj, cls) \
([obj isKindOfClass:(Class)objc_getClass(#cls)] ? (cls *)obj : NULL)

extern BOOL preventReentrance;

@interface RCEngine : NSObject {
	/* set to NO if the engine is initialized but activate was not called yet - that is R was not really initialized yet */
	BOOL active;

	BOOL protectedMode;
	
	/* last error string */
	NSString* lastError;
	
	/* if >0 ProcessEvents doesn't call the event handler */
	int maskEvents;

  // Automatically print out results after evaluating
  BOOL autoPrint;

	/* initial arguments used by activate to initialize R */
	int  argc;
	char **argv;
	
	/* SaveAction (yes/no/ask - anything else is treated as ask) */
	NSString *saveAction;

    RCCharacterDeviceAdapter* adapter;
}

//+ (RCEngine*) mainEngine;
+ (void) shutdown;
+ (RCEngine*) GetInstance;
+ (RCEngine*) GetInstance:(RCICharacterDevice*) device;

- (id) init;
- (id) initWithArgs: (char**) args;
- (BOOL) activate:(RCICharacterDevice*) device;

- (BOOL) isActive;

- (NSString*) lastError;

- (BOOL) allowEvents;

- (BOOL) beginProtected;
- (void) endProtected;

// those must be called *before* activate and *after* init
- (void) setSaveAction: (NSString*) action; // yes/no/ask
- (NSString*) saveAction;
- (void) disableRSignalHandlers: (BOOL) disable;

// eval mode
- (NSMutableArray<RCSymbolicExpression*>*) Parse: (NSString*) str __attribute((ns_returns_retained));
- (RCSymbolicExpression*) Evaluate: (NSString*) str __attribute((ns_returns_retained));

// Methods used within parse/evaluation
- (NSMutableArray<NSString*>*) PreProcessStatement: (NSString*)statement;
- (NSArray<NSString*>*) ProcessLine: (NSString*)line;
- (BOOL) IsClosedString: (NSString*) string;

// From RController
- (void) initREnvironment;


// RDotNet functions
- (RCSymbolicExpression*) NilValue;
- (RCSymbolicExpression*) NaString;

@end

#endif
