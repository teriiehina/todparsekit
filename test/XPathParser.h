//
//  XPathParser.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODSequence.h"

@class XPathAssembler;
@class TODAssembly;

@interface XPathParser : TODSequence {
	XPathAssembler *xpathAssembler;
	TODCollectionParser *locationPath;
	TODCollectionParser *absoluteLocationPath;
	TODCollectionParser *relativeLocationPath;
	TODCollectionParser *step;
	TODCollectionParser *axisSpecifier;
	TODCollectionParser *axisName;
	TODCollectionParser *nodeTest;
	TODCollectionParser *predicate;
	TODCollectionParser *predicateExpr;
	TODCollectionParser *abbreviatedAbsoluteLocationPath;
	TODCollectionParser *abbreviatedRelativeLocationPath;
	TODCollectionParser *abbreviatedStep;
	TODCollectionParser *abbreviatedAxisSpecifier;
	TODCollectionParser *expr;
	TODCollectionParser *primaryExpr;
	TODCollectionParser *functionCall;
	TODCollectionParser *argument;
	TODCollectionParser *unionExpr;
	TODCollectionParser *pathExpr;
	TODCollectionParser *filterExpr;
	TODCollectionParser *orExpr;
	TODCollectionParser *andExpr;
	TODCollectionParser *equalityExpr;
	TODCollectionParser *relationalExpr;
	TODCollectionParser *additiveExpr;
	TODCollectionParser *multiplicativeExpr;
	TODCollectionParser *unaryExpr;
	TODCollectionParser *exprToken;
	TODParser *literal;
	TODParser *number;
	TODCollectionParser *operator;
	TODCollectionParser *operatorName;
	TODParser *multiplyOperator;
	TODParser *functionName;
	TODCollectionParser *variableReference;
	TODCollectionParser *nameTest;
	TODCollectionParser *nodeType;
	TODCollectionParser *QName;
}
- (id)parse:(NSString *)s;
- (TODAssembly *)assemblyWithString:(NSString *)s;

@property (retain) TODCollectionParser *locationPath;
@property (retain) TODCollectionParser *absoluteLocationPath;
@property (retain) TODCollectionParser *relativeLocationPath;
@property (retain) TODCollectionParser *step;
@property (retain) TODCollectionParser *axisSpecifier;
@property (retain) TODCollectionParser *axisName;
@property (retain) TODCollectionParser *nodeTest;
@property (retain) TODCollectionParser *predicate;
@property (retain) TODCollectionParser *predicateExpr;
@property (retain) TODCollectionParser *abbreviatedAbsoluteLocationPath;
@property (retain) TODCollectionParser *abbreviatedRelativeLocationPath;
@property (retain) TODCollectionParser *abbreviatedStep;
@property (retain) TODCollectionParser *abbreviatedAxisSpecifier;
@property (retain) TODCollectionParser *expr;
@property (retain) TODCollectionParser *primaryExpr;
@property (retain) TODCollectionParser *functionCall;
@property (retain) TODCollectionParser *argument;
@property (retain) TODCollectionParser *unionExpr;
@property (retain) TODCollectionParser *pathExpr;
@property (retain) TODCollectionParser *filterExpr;
@property (retain) TODCollectionParser *orExpr;
@property (retain) TODCollectionParser *andExpr;
@property (retain) TODCollectionParser *equalityExpr;
@property (retain) TODCollectionParser *relationalExpr;
@property (retain) TODCollectionParser *additiveExpr;
@property (retain) TODCollectionParser *multiplicativeExpr;
@property (retain) TODCollectionParser *unaryExpr;
@property (retain) TODCollectionParser *exprToken;
@property (retain) TODParser *literal;
@property (retain) TODParser *number;
@property (retain) TODCollectionParser *operator;
@property (retain) TODCollectionParser *operatorName;
@property (retain) TODParser *multiplyOperator;
@property (retain) TODParser *functionName;
@property (retain) TODCollectionParser *variableReference;
@property (retain) TODCollectionParser *nameTest;
@property (retain) TODCollectionParser *nodeType;
@property (retain) TODCollectionParser *QName;
@end
