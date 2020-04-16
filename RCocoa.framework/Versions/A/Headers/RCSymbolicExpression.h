//
//  RCSymbolicExpression.h
//  RCocoa
//
//  Created by Luke Rasmussen on 4/13/17.
//  Copyright © 2017 Northwestern University. All rights reserved.
//

#ifndef RCSymbolicExpression_h
#define RCSymbolicExpression_h

#include <Rinternals.h>

/*
 Note on memory management
 Some of the methods have a ns_returns_retained attribute as part of their definition (https://clang.llvm.org/docs/AutomaticReferenceCounting.html#retained-return-values).  This tells an app calling this framework that it is responsible for cleaning up the returned value.  Per the Apple documentation, this should let ARC know (assuming the framework is called from an ARC-enabled application) that it is responsible for releasing and cleaning the object it receives.
 */

@class RCEngine;
@class RCCharacterMatrix;
@class RCLogicalMatrix;
@class RCIntegerMatrix;
@class RCRealMatrix;
@class RCDataFrame;
@class RCVector;
@class RCFunction;
@class RCClosure;
@class RCBuiltinFunction;
@class RCSpecialFunction;

@interface RCSymbolicExpression : NSObject
{
    id _expression;
    RCEngine* _engine;
    bool isProtected;
}

+(RCFunction*) _getAsListFunction;

-(id) initWithEngineAndExpression: (RCEngine*)eng expression: (id)sexp;

// Gets the symbolic expression type
-(int) Type;

// Gets the length of the expression
-(int) Length;

// Gets the RCEngine to which this expression belongs
-(RCEngine*) Engine;

// Is the handle of this SEXP invalid (zero, i.e. null pointer)
-(BOOL) IsInvalid;

// Get all attribute value names
-(NSArray<NSString*>*) GetAttributeNames __attribute((ns_returns_retained));

// Get a specific attribute
-(RCSymbolicExpression*) GetAttribute: (NSString*)name __attribute((ns_returns_retained));

// Set an attribute
-(void) SetAttribute: (RCSymbolicExpression*) symbol value:(RCSymbolicExpression*) value;

// Get the underlying SEXP pointer
-(id) GetHandle;

// Type detection methods
-(BOOL) IsVector;
-(BOOL) IsFactor;
-(BOOL) IsMatrix;
-(BOOL) IsDataFrame;
-(BOOL) IsList;
//-(BOOL) IsS4;
//-(BOOL) IsEnvironment;
//-(BOOL) IsExpression;
//-(BOOL) IsSymbol;
//-(BOOL) IsLanguage;
-(BOOL) IsFunction;
//-(BOOL) IsFactor;

// Vector conversion methods methods
-(NSArray*) AsInteger __attribute((ns_returns_retained));
-(NSArray*) AsReal __attribute((ns_returns_retained));
-(NSArray*) AsLogical __attribute((ns_returns_retained));
-(NSArray*) AsCharacter __attribute((ns_returns_retained));
//(NSArray*) AsNumeric;
//(NSArray*) AsComplex;

// Other conversion methods
-(RCVector*) AsList;
-(RCDataFrame*) AsDataFrame;
//(NSArray*) AsS4;
//(NSArray*) AsVector;
//(NSArray*) AsRaw;
//(NSArray*) AsEnvironment;
//(NSArray*) AsExpression;
//(NSArray*) AsSymbol;
//(NSArray*) AsLanguage;
-(RCFunction*) AsFunction;
//(NSArray*) AsFactor;

// Matrix conversion methods
-(RCIntegerMatrix*) AsIntegerMatrix __attribute((ns_returns_retained));
-(RCRealMatrix*) AsRealMatrix __attribute((ns_returns_retained));
-(RCCharacterMatrix*) AsCharacterMatrix __attribute((ns_returns_retained));
-(RCLogicalMatrix*) AsLogicalMatrix __attribute((ns_returns_retained));
//(NSArray*) AsNumericMatrix;
//(NSArray*) AsComplexMatrix;
//(NSArray*) AsRawMatrix;

@end

#endif /* RCSymbolicExpression_h */
