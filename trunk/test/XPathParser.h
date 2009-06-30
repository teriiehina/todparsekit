//
//  XPathParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/ParseKit.h>

@class XPathAssembler;
@class PKAssembly;

@interface XPathParser : TDSequence {
    XPathAssembler *xpathAssembler;
    TDCollectionParser *locationPath;
    TDCollectionParser *absoluteLocationPath;
    TDCollectionParser *relativeLocationPath;
    TDCollectionParser *step;
    TDCollectionParser *axisSpecifier;
    TDCollectionParser *axisName;
    TDCollectionParser *nodeTest;
    TDCollectionParser *predicate;
    TDCollectionParser *predicateExpr;
    TDCollectionParser *abbreviatedAbsoluteLocationPath;
    TDCollectionParser *abbreviatedRelativeLocationPath;
    TDCollectionParser *abbreviatedStep;
    TDCollectionParser *abbreviatedAxisSpecifier;
    TDCollectionParser *expr;
    TDCollectionParser *primaryExpr;
    TDCollectionParser *functionCall;
    TDCollectionParser *argument;
    TDCollectionParser *unionExpr;
    TDCollectionParser *pathExpr;
    TDCollectionParser *filterExpr;
    TDCollectionParser *orExpr;
    TDCollectionParser *andExpr;
    TDCollectionParser *equalityExpr;
    TDCollectionParser *relationalExpr;
    TDCollectionParser *additiveExpr;
    TDCollectionParser *multiplicativeExpr;
    TDCollectionParser *unaryExpr;
    TDCollectionParser *exprToken;
    PKParser *literal;
    PKParser *number;
    TDCollectionParser *operator;
    TDCollectionParser *operatorName;
    PKParser *multiplyOperator;
    PKParser *functionName;
    TDCollectionParser *variableReference;
    TDCollectionParser *nameTest;
    TDCollectionParser *nodeType;
    TDCollectionParser *QName;
}
- (id)parse:(NSString *)s;
- (PKAssembly *)assemblyWithString:(NSString *)s;

@property (retain) TDCollectionParser *locationPath;
@property (retain) TDCollectionParser *absoluteLocationPath;
@property (retain) TDCollectionParser *relativeLocationPath;
@property (retain) TDCollectionParser *step;
@property (retain) TDCollectionParser *axisSpecifier;
@property (retain) TDCollectionParser *axisName;
@property (retain) TDCollectionParser *nodeTest;
@property (retain) TDCollectionParser *predicate;
@property (retain) TDCollectionParser *predicateExpr;
@property (retain) TDCollectionParser *abbreviatedAbsoluteLocationPath;
@property (retain) TDCollectionParser *abbreviatedRelativeLocationPath;
@property (retain) TDCollectionParser *abbreviatedStep;
@property (retain) TDCollectionParser *abbreviatedAxisSpecifier;
@property (retain) TDCollectionParser *expr;
@property (retain) TDCollectionParser *primaryExpr;
@property (retain) TDCollectionParser *functionCall;
@property (retain) TDCollectionParser *argument;
@property (retain) TDCollectionParser *unionExpr;
@property (retain) TDCollectionParser *pathExpr;
@property (retain) TDCollectionParser *filterExpr;
@property (retain) TDCollectionParser *orExpr;
@property (retain) TDCollectionParser *andExpr;
@property (retain) TDCollectionParser *equalityExpr;
@property (retain) TDCollectionParser *relationalExpr;
@property (retain) TDCollectionParser *additiveExpr;
@property (retain) TDCollectionParser *multiplicativeExpr;
@property (retain) TDCollectionParser *unaryExpr;
@property (retain) TDCollectionParser *exprToken;
@property (retain) PKParser *literal;
@property (retain) PKParser *number;
@property (retain) TDCollectionParser *operator;
@property (retain) TDCollectionParser *operatorName;
@property (retain) PKParser *multiplyOperator;
@property (retain) PKParser *functionName;
@property (retain) TDCollectionParser *variableReference;
@property (retain) TDCollectionParser *nameTest;
@property (retain) TDCollectionParser *nodeType;
@property (retain) TDCollectionParser *QName;
@end
