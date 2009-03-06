//
//  XPathParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "XPathParser.h"
//#import "TDNCName.h"

#import "TDNCNameState.h"
#import "XPathAssembler.h"

@interface XPathParser ()
@property (retain) XPathAssembler *xpathAssembler;
@end

@implementation XPathParser

- (id)init {
    self = [super init];
    if (self) {
        self.xpathAssembler = [[[XPathAssembler alloc] init] autorelease];
        [self add:self.locationPath];
    }
    return self;
}


- (void)dealloc {
    self.xpathAssembler = nil;
    self.locationPath = nil;
    self.absoluteLocationPath = nil;
    self.relativeLocationPath = nil;
    self.step = nil;
    self.axisSpecifier = nil;
    self.axisName = nil;
    self.nodeTest = nil;
    self.predicate = nil;
    self.predicateExpr = nil;
    self.abbreviatedAbsoluteLocationPath = nil;
    self.abbreviatedRelativeLocationPath = nil;
    self.abbreviatedStep = nil;
    self.abbreviatedAxisSpecifier = nil;
    self.expr = nil;
    self.primaryExpr = nil;
    self.functionCall = nil;
    self.argument = nil;
    self.unionExpr = nil;
    self.pathExpr = nil;
    self.filterExpr = nil;
    self.orExpr = nil;
    self.andExpr = nil;
    self.equalityExpr = nil;
    self.relationalExpr = nil;
    self.additiveExpr = nil;
    self.multiplicativeExpr = nil;
    self.unaryExpr = nil;
    self.exprToken = nil;
    self.literal = nil;
    self.number = nil;
    self.operator = nil;
    self.operatorName = nil;
    self.multiplyOperator = nil;
    self.functionName = nil;
    self.variableReference = nil;
    self.nameTest = nil;
    self.nodeType = nil;
    self.QName = nil;
    [super dealloc];
}


- (TDAssembly *)assemblyWithString:(NSString *)s {
    TDTokenizer *t = [[[TDTokenizer alloc] initWithString:s] autorelease];
    [t.symbolState add:@"::"];
    [t.symbolState add:@"!="];
    [t.symbolState add:@"<="];
    [t.symbolState add:@">="];
    [t.symbolState add:@".."];
    [t.symbolState add:@"//"];
    [t setTokenizerState:t.wordState from: '_' to: '_'];
//    [t setTokenizerState:NCNameState from: 'a' to: 'z'];
//    [t setTokenizerState:NCNameState from: 'A' to: 'Z'];
//    [t setTokenizerState:NCNameState from:0xc0 to:0xff];
    
    TDTokenAssembly *a = [TDTokenAssembly assemblyWithTokenizer:t];
//    TDNCNameState *NCNameState = [[[TDNCNameState alloc] init] autorelease];
    
    return a;
}


- (id)parse:(NSString *)s {
    [xpathAssembler reset];
    TDAssembly *a = [self assemblyWithString:s];
    id result = [self completeMatchFor:a];
    return result;
}


// [1]        LocationPath                        ::=       RelativeLocationPath | AbsoluteLocationPath    
- (TDCollectionParser *)locationPath {
    //NSLog(@"%s", _cmd);
    if (!locationPath) {
        self.locationPath = [TDAlternation alternation];
        locationPath.name = @"locationPath";
        
        [locationPath add:self.relativeLocationPath];
        [locationPath add:self.absoluteLocationPath];
    }
    return locationPath;
}


//[2]        AbsoluteLocationPath                ::=       '/' RelativeLocationPath? | AbbreviatedAbsoluteLocationPath    
- (TDCollectionParser *)absoluteLocationPath {
    //NSLog(@"%s", _cmd);
    if (!absoluteLocationPath) {
        self.absoluteLocationPath = [TDAlternation alternation];
        absoluteLocationPath.name = @"absoluteLocationPath";

        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.relativeLocationPath];
        
        TDSequence *s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"/"]];
        [s add:a];
        
        [absoluteLocationPath add:s];
        [absoluteLocationPath add:self.abbreviatedAbsoluteLocationPath];
    }
    return absoluteLocationPath;
}

#pragma mark -
#pragma mark left recursion

//[3] RelativeLocationPath ::= Step    | RelativeLocationPath '/' Step    | AbbreviatedRelativeLocationPath

// avoiding left recursion by changing to this
//[3] RelativeLocationPath ::= Step SlashStep*    | AbbreviatedRelativeLocationPath

- (TDCollectionParser *)relativeLocationPath {
    //NSLog(@"%s", _cmd);
    if (!relativeLocationPath) {
        self.relativeLocationPath = [TDAlternation alternation];
        relativeLocationPath.name = @"relativeLocationPath";

        TDSequence *s = [TDSequence sequence];
        [s add:self.step];

        TDSequence *slashStep = [TDSequence sequence];
        [slashStep add:[TDSymbol symbolWithString:@"/"]];
        [slashStep add:self.step];
        [s add:[TDRepetition repetitionWithSubparser:slashStep]];

        [relativeLocationPath add:s];
        // TODO this is causing and infinite loop!
//        [relativeLocationPath add:self.abbreviatedRelativeLocationPath];
    }
    return relativeLocationPath;
}


// [4] Step ::=       AxisSpecifier NodeTest Predicate* | AbbreviatedStep    
- (TDCollectionParser *)step {
    NSLog(@"%s", _cmd);
    if (!step) {
        self.step = [TDAlternation alternation];
        step.name = @"step";
        
        TDSequence *s = [TDSequence sequence];
        [s add:self.axisSpecifier];
        [s add:self.nodeTest];
        [s add:[TDRepetition repetitionWithSubparser:self.predicate]];
        
        [step add:s];
        [step add:self.abbreviatedStep];
        
        [step setAssembler:xpathAssembler selector:@selector(workOnStepAssembly:)];
    }
    return step;
}


// [5]    AxisSpecifier ::= AxisName '::' | AbbreviatedAxisSpecifier
- (TDCollectionParser *)axisSpecifier {
    //NSLog(@"%s", _cmd);
    if (!axisSpecifier) {
        self.axisSpecifier = [TDAlternation alternation];
        axisSpecifier.name = @"axisSpecifier";
        
        TDSequence *s = [TDSequence sequence];
        [s add:self.axisName];
        [s add:[TDSymbol symbolWithString:@"::"]];
        
        [axisSpecifier add:s];
        [axisSpecifier add:self.abbreviatedAxisSpecifier];
        [axisSpecifier setAssembler:xpathAssembler selector:@selector(workOnAxisSpecifierAssembly:)];
    }
    return axisSpecifier;
}


// [6] AxisName ::= 'ancestor' | 'ancestor-or-self' | 'attribute' | 'child' | 'descendant' | 'descendant-or-self'
//            | 'following' | 'following-sibling' | 'namespace' | 'parent' | 'preceding' | 'preceding-sibling' | 'self'
- (TDCollectionParser *)axisName {
    //NSLog(@"%s", _cmd);
    if (!axisName) {
        self.axisName = [TDAlternation alternation];
        axisName.name = @"axisName";
        [axisName add:[TDLiteral literalWithString:@"ancestor"]];
        [axisName add:[TDLiteral literalWithString:@"ancestor-or-self"]];
        [axisName add:[TDLiteral literalWithString:@"attribute"]];
        [axisName add:[TDLiteral literalWithString:@"child"]];
        [axisName add:[TDLiteral literalWithString:@"descendant"]];
        [axisName add:[TDLiteral literalWithString:@"descendant-or-self"]];
        [axisName add:[TDLiteral literalWithString:@"following"]];
        [axisName add:[TDLiteral literalWithString:@"following-sibling"]];
        [axisName add:[TDLiteral literalWithString:@"preceeding"]];
        [axisName add:[TDLiteral literalWithString:@"preceeding-sibling"]];
        [axisName add:[TDLiteral literalWithString:@"namespace"]];
        [axisName add:[TDLiteral literalWithString:@"parent"]];
        [axisName add:[TDLiteral literalWithString:@"self"]];
    }
    return axisName;
}


// [7]  NodeTest ::= NameTest | NodeType '(' ')' | 'processing-instruction' '(' Literal ')'
- (TDCollectionParser *)nodeTest {
    //NSLog(@"%s", _cmd);
    if (!nodeTest) {
        self.nodeTest = [TDAlternation alternation];
        nodeTest.name = @"nodeTest";
        [nodeTest add:self.nameTest];
        
        TDSequence *s = [TDSequence sequence];
        [s add:self.nodeType];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:[TDSymbol symbolWithString:@")"]];
        [nodeTest add:s];
        
        s = [TDSequence sequence];
        [s add:[TDLiteral literalWithString:@"processing-instruction"]];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:self.literal];
        [s add:[TDSymbol symbolWithString:@")"]];
        [nodeTest add:s];    
    }
    return nodeTest;
}


// [8]  Predicate ::=  '[' PredicateExpr ']'    
- (TDCollectionParser *)predicate {
    //NSLog(@"%s", _cmd);
    if (!predicate) {
        self.predicate = [TDSequence sequence];
        predicate.name = @"predicate";
        [predicate add:[TDSymbol symbolWithString:@"["]];
        [predicate add:self.predicateExpr];
        [predicate add:[TDSymbol symbolWithString:@"]"]];
    }
    return predicate;
}


// [9]  PredicateExpr    ::=       Expr
- (TDCollectionParser *)predicateExpr {
    //NSLog(@"%s", _cmd);
    if (!predicateExpr) {
        self.predicateExpr = self.expr;
        predicateExpr.name = @"predicateExpr";
    }
    return predicateExpr;
}


// [10]  AbbreviatedAbsoluteLocationPath ::= '//' RelativeLocationPath    
- (TDCollectionParser *)abbreviatedAbsoluteLocationPath {
    //NSLog(@"%s", _cmd);
    if (!abbreviatedAbsoluteLocationPath) {
        self.abbreviatedAbsoluteLocationPath = [TDSequence sequence];
        abbreviatedAbsoluteLocationPath.name = @"abbreviatedAbsoluteLocationPath";
        [abbreviatedAbsoluteLocationPath add:[TDSymbol symbolWithString:@"//"]];
        [abbreviatedAbsoluteLocationPath add:self.relativeLocationPath];
    }
    return abbreviatedAbsoluteLocationPath;
}


// [11] AbbreviatedRelativeLocationPath ::= RelativeLocationPath '//' Step    
- (TDCollectionParser *)abbreviatedRelativeLocationPath {
    //NSLog(@"%s", _cmd);
    if (!abbreviatedRelativeLocationPath) {
        self.abbreviatedRelativeLocationPath = [TDSequence sequence];
        abbreviatedRelativeLocationPath.name = @"abbreviatedRelativeLocationPath";
        [abbreviatedRelativeLocationPath add:self.relativeLocationPath];
        [abbreviatedRelativeLocationPath add:[TDSymbol symbolWithString:@"//"]];
        [abbreviatedRelativeLocationPath add:self.step];
    }
    return abbreviatedRelativeLocationPath;
}


// [12] AbbreviatedStep    ::=       '.'    | '..'
- (TDCollectionParser *)abbreviatedStep {
    //NSLog(@"%s", _cmd);
    if (!abbreviatedStep) {
        self.abbreviatedStep = [TDAlternation alternation];
        abbreviatedStep.name = @"abbreviatedStep";
        [abbreviatedStep add:[TDSymbol symbolWithString:@"."]];
        [abbreviatedStep add:[TDSymbol symbolWithString:@".."]];
    }
    return abbreviatedStep;
}


// [13] AbbreviatedAxisSpecifier ::=       '@'?
- (TDCollectionParser *)abbreviatedAxisSpecifier {
    //NSLog(@"%s", _cmd);
    if (!abbreviatedAxisSpecifier) {
        self.abbreviatedAxisSpecifier = [TDAlternation alternation];
        abbreviatedAxisSpecifier.name = @"abbreviatedAxisSpecifier";
        [abbreviatedAxisSpecifier add:[TDEmpty empty]];
        [abbreviatedAxisSpecifier add:[TDSymbol symbolWithString:@"@"]];
    }
    return abbreviatedAxisSpecifier;
}


// [14]       Expr ::=       OrExpr    
- (TDCollectionParser *)expr {
    //NSLog(@"%s", _cmd);
    if (!expr) {
        self.expr = self.orExpr;
        expr.name = @"expr";
    }
    return expr;
}


// [15] PrimaryExpr    ::=  VariableReference    
//                    | '(' Expr ')'    
//                    | Literal    
//                    | Number    
//                    | FunctionCall
- (TDCollectionParser *)primaryExpr {
    //NSLog(@"%s", _cmd);
    if (!primaryExpr) {
        self.primaryExpr = [TDAlternation alternation];
        primaryExpr.name = @"primaryExpr";
        [primaryExpr add:self.variableReference];
        
        TDSequence *s = [TDSequence sequence];
        [s add:[TDSymbol symbolWithString:@"("]];
        [s add:self.expr];
        [s add:[TDSymbol symbolWithString:@")"]];
        [primaryExpr add:s];
        
        [primaryExpr add:self.literal];
        [primaryExpr add:self.number];
        [primaryExpr add:self.functionCall];
    }
    return primaryExpr;
}


// [16] FunctionCall ::= FunctionName '(' ( Argument ( ',' Argument )* )? ')'    

// commaArg ::= ',' Argument
// [16] FunctionCall ::= FunctionName '(' ( Argument commaArg* )? ')'    
- (TDCollectionParser *)functionCall {
    //NSLog(@"%s", _cmd);
    if (!functionCall) {
        self.functionCall = [TDSequence sequence];
        functionCall.name = @"functionCall";
        [functionCall add:self.functionName];
        [functionCall add:[TDSymbol symbolWithString:@"("]];
        
        TDSequence *commaArg = [TDSequence sequence];
        [commaArg add:[TDSymbol symbolWithString:@","]];
        [commaArg add:self.argument];
        
        TDSequence *args = [TDSequence sequence];
        [args add:self.argument];
        [args add:[TDRepetition repetitionWithSubparser:commaArg]];
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:args];
        
        [functionCall add:a];
        [functionCall add:[TDSymbol symbolWithString:@")"]];
    }
    return functionCall;
}


// [17] Argument ::=       Expr
- (TDCollectionParser *)argument {
    //NSLog(@"%s", _cmd);
    if (!argument) {
        self.argument = self.expr;
        argument.name = @"argument";
    }
    return argument;
}


#pragma mark -
#pragma mark Left Recursion

// [18]  UnionExpr ::=       PathExpr | UnionExpr '|' PathExpr    

// pipePathExpr :: = | PathExpr
// [18]  UnionExpr ::=       PathExpr PipePathExpr*
- (TDCollectionParser *)unionExpr {
    //NSLog(@"%s", _cmd);
    if (!unionExpr) {
        self.unionExpr = [TDSequence sequence];
        unionExpr.name = @"unionExpr";

        TDSequence *pipePathExpr = [TDSequence sequence];
        [pipePathExpr add:[TDSymbol symbolWithString:@"|"]];
        [pipePathExpr add:self.pathExpr];
        
        [unionExpr add:self.pathExpr];
        [unionExpr add:[TDRepetition repetitionWithSubparser:pipePathExpr]];
    }
    return unionExpr;
}


//[19]       PathExpr ::= LocationPath    
//                    | FilterExpr    
//                    | FilterExpr '/' RelativeLocationPath    
//                    | FilterExpr '//' RelativeLocationPath    
- (TDCollectionParser *)pathExpr {
    //NSLog(@"%s", _cmd);
    if (!pathExpr) {
        self.pathExpr = [TDAlternation alternation];
        pathExpr.name = @"pathExpr";
        [pathExpr add:self.locationPath];
        [pathExpr add:self.filterExpr];
        
        TDSequence *s = [TDSequence sequence];
        [s add:self.filterExpr];
        [s add:[TDSymbol symbolWithString:@"/"]];
        [s add:self.relativeLocationPath];
        [pathExpr add:s];
        
        s = [TDSequence sequence];
        [s add:self.filterExpr];
        [s add:[TDSymbol symbolWithString:@"//"]];
        [s add:self.relativeLocationPath];
        [pathExpr add:s];
    }
    return pathExpr;
}


#pragma mark -
#pragma mark Left Recursion????????????

// [20]  FilterExpr     ::=       PrimaryExpr    | FilterExpr Predicate


// [20]  FilterExpr     ::=       PrimaryExpr Predicate?
- (TDCollectionParser *)filterExpr {
    //NSLog(@"%s", _cmd);
    if (!filterExpr) {
        self.filterExpr = [TDSequence sequence];
        filterExpr.name = @"filterExpr";
        [filterExpr add:self.primaryExpr];
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:self.predicate];
        [filterExpr add:a];
    }
    return filterExpr;
}


#pragma mark -
#pragma mark Left Recursion
// [21] OrExpr ::= AndExpr    | OrExpr 'or' AndExpr    

// orAndExpr ::= 'or' AndExpr
// me: AndExpr orAndExpr*
- (TDCollectionParser *)orExpr {
    //NSLog(@"%s", _cmd);
    if (!orExpr) {
        self.orExpr = [TDSequence sequence];
        orExpr.name = @"orExpr";
        
        [orExpr add:self.andExpr];
        
        TDSequence *orAndExpr = [TDSequence sequence];
        [orAndExpr add:[TDLiteral literalWithString:@"or"]];
        [orAndExpr add:self.andExpr];
        
        [orExpr add:[TDRepetition repetitionWithSubparser:orAndExpr]];
    }
    return orExpr;
}


#pragma mark -
#pragma mark Left Recursion

// [22] AndExpr ::= EqualityExpr | AndExpr 'and' EqualityExpr    


// andEqualityExpr
// EqualityExpr andEqualityExpr

- (TDCollectionParser *)andExpr {
    //NSLog(@"%s", _cmd);
    if (!andExpr) {
        self.andExpr = [TDSequence sequence];
        andExpr.name = @"andExpr";
        [andExpr add:self.equalityExpr];

        TDSequence *andEqualityExpr = [TDSequence sequence];
        [andEqualityExpr add:[TDLiteral literalWithString:@"and"]];
        [andEqualityExpr add:self.equalityExpr];
        
        [andExpr add:[TDRepetition repetitionWithSubparser:andEqualityExpr]];
    }
    return andExpr;
}


#pragma mark -
#pragma mark Left Recursion

// [23] EqualityExpr ::= RelationalExpr    
//            | EqualityExpr '=' RelationalExpr
//            | EqualityExpr '!=' RelationalExpr    

// RelationalExpr (equalsRelationalExpr | notEqualsRelationalExpr)?

- (TDCollectionParser *)equalityExpr {
    //NSLog(@"%s", _cmd);
    if (!equalityExpr) {
        self.equalityExpr = [TDSequence sequence];
        equalityExpr.name = @"equalityExpr";
        [equalityExpr add:self.relationalExpr];
        
        TDSequence *equalsRelationalExpr = [TDSequence sequence];
        [equalsRelationalExpr add:[TDSymbol symbolWithString:@"="]];
        [equalsRelationalExpr add:self.relationalExpr];
        
        TDSequence *notEqualsRelationalExpr = [TDSequence sequence];
        [notEqualsRelationalExpr add:[TDSymbol symbolWithString:@"!="]];
        [notEqualsRelationalExpr add:self.relationalExpr];
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:equalsRelationalExpr];
        [a add:notEqualsRelationalExpr];
        
        TDAlternation *a1 = [TDAlternation alternation];
        [a1 add:[TDEmpty empty]];
        [a1 add:a];
        
        [equalityExpr add:a1];
    }
    return equalityExpr;
}


#pragma mark -
#pragma mark Left Recursion

// [24] RelationalExpr ::= AdditiveExpr
//                        | RelationalExpr '<' AdditiveExpr    
//                        | RelationalExpr '>' AdditiveExpr    
//                        | RelationalExpr '<=' AdditiveExpr    
//                        | RelationalExpr '>=' AdditiveExpr

// RelationalExpr = AdditiveExpr (ltAdditiveExpr | gtAdditiveExpr | lteAdditiveExpr | gteAdditiveExpr)?
- (TDCollectionParser *)relationalExpr {
    //NSLog(@"%s", _cmd);
    if (!relationalExpr) {
        
        self.relationalExpr = [TDSequence sequence];
        relationalExpr.name = @"relationalExpr";
        [relationalExpr add:self.additiveExpr];
        
        TDAlternation *a = [TDAlternation alternation];
        
        TDSequence *ltAdditiveExpr = [TDSequence sequence];
        [ltAdditiveExpr add:[TDSymbol symbolWithString:@"<"]];
        [a add:ltAdditiveExpr];

        TDSequence *gtAdditiveExpr = [TDSequence sequence];
        [gtAdditiveExpr add:[TDSymbol symbolWithString:@">"]];
        [a add:gtAdditiveExpr];

        TDSequence *lteAdditiveExpr = [TDSequence sequence];
        [lteAdditiveExpr add:[TDSymbol symbolWithString:@"<="]];
        [a add:lteAdditiveExpr];

        TDSequence *gteAdditiveExpr = [TDSequence sequence];
        [gteAdditiveExpr add:[TDSymbol symbolWithString:@">="]];
        [a add:gteAdditiveExpr];
        
        TDAlternation *a1 = [TDAlternation alternation];
        [a1 add:[TDEmpty empty]];
        [a1 add:a];
        
        [relationalExpr add:a1];
    }
    return relationalExpr;
}


#pragma mark -
#pragma mark Left Recursion

// [25] AdditiveExpr ::= MultiplicativeExpr    
//                        | AdditiveExpr '+' MultiplicativeExpr    
//                        | AdditiveExpr '-' MultiplicativeExpr    

// AdditiveExpr ::= MultiplicativeExpr (plusMultiplicativeExpr | minusMultiplicativeExpr)?
- (TDCollectionParser *)additiveExpr {
    //NSLog(@"%s", _cmd);
    if (!additiveExpr) {
        self.additiveExpr = [TDSequence sequence];
        additiveExpr.name = @"additiveExpr";
        [additiveExpr add:self.multiplicativeExpr];
        
        TDAlternation *a = [TDAlternation alternation];

        TDSequence *plusMultiplicativeExpr = [TDSequence sequence];
        [plusMultiplicativeExpr add:[TDSymbol symbolWithString:@"+"]];
        [plusMultiplicativeExpr add:self.multiplicativeExpr];
        [a add:plusMultiplicativeExpr];
        
        TDSequence *minusMultiplicativeExpr = [TDSequence sequence];
        [minusMultiplicativeExpr add:[TDSymbol symbolWithString:@"-"]];
        [minusMultiplicativeExpr add:self.multiplicativeExpr];
        [a add:minusMultiplicativeExpr];
        
        TDAlternation *a1 = [TDAlternation alternation];
        [a1 add:[TDEmpty empty]];
        [a1 add:a];
        
        [additiveExpr add:a1];
    }
    return additiveExpr;
}


#pragma mark -
#pragma mark Left Recursion

// [26] MultiplicativeExpr ::= UnaryExpr    
//                            | MultiplicativeExpr MultiplyOperator UnaryExpr    
//                            | MultiplicativeExpr 'div' UnaryExpr    
//                            | MultiplicativeExpr 'mod' UnaryExpr

// MultiplicativeExpr :: = UnaryExpr (multiplyUnaryExpr | divUnaryExpr | modUnaryExpr)? 
- (TDCollectionParser *)multiplicativeExpr {
    //NSLog(@"%s", _cmd);
    if (!multiplicativeExpr) {
        self.multiplicativeExpr = [TDSequence sequence];
        multiplicativeExpr.name = @"multiplicativeExpr";
        [multiplicativeExpr add:self.unaryExpr];
        
        TDAlternation *a = [TDAlternation alternation];
        
        TDSequence *multiplyUnaryExpr = [TDSequence sequence];
        [multiplyUnaryExpr add:self.multiplyOperator];
        [multiplyUnaryExpr add:self.unaryExpr];
        [a add:multiplyUnaryExpr];
        
        TDSequence *divUnaryExpr = [TDSequence sequence];
        [divUnaryExpr add:[TDLiteral literalWithString:@"div"]];
        [divUnaryExpr add:self.unaryExpr];
        [a add:divUnaryExpr];
        
        TDSequence *modUnaryExpr = [TDSequence sequence];
        [modUnaryExpr add:[TDLiteral literalWithString:@"mod"]];
        [modUnaryExpr add:self.unaryExpr];
        [a add:modUnaryExpr];
        
        TDAlternation *a1 = [TDAlternation alternation];
        [a1 add:[TDEmpty empty]];
        [a1 add:a];
        
        [multiplicativeExpr add:a1];
    }
    return multiplicativeExpr;
}


#pragma mark -
#pragma mark Left Recursion

// [27] UnaryExpr ::= UnionExpr | '-' UnaryExpr

// UnaryExpr ::= '-'? UnionExpr
- (TDCollectionParser *)unaryExpr {
    //NSLog(@"%s", _cmd);
    if (!unaryExpr) {
        self.unaryExpr = [TDSequence sequence];
        unaryExpr.name = @"unaryExpr";
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDEmpty empty]];
        [a add:[TDSymbol symbolWithString:@"-"]];
        
        [unaryExpr add:a];
        [unaryExpr add:self.unionExpr];
        
        //        self.unaryExpr = [TDAlternation alternation];
//        [unaryExpr add:self.unionExpr];
//        
//        TDSequence *s = [TDSequence sequence];
//        [s add:[TDSymbol symbolWithString:@"-"]];
//        [s add:unaryExpr];
//        [unionExpr add:s];
    }
    return unaryExpr;
}


// [28] ExprToken ::= '(' | ')' | '[' | ']' | '.' | '..' | '@' | ',' | '::'
//                    | NameTest    
//                    | NodeType    
//                    | Operator    
//                    | FunctionName    
//                    | AxisName    
//                    | Literal    
//                    | Number    
//                    | VariableReference    
- (TDCollectionParser *)exprToken {
    //NSLog(@"%s", _cmd);
    if (!exprToken) {
        self.exprToken = [TDAlternation alternation];
        exprToken.name = @"exprToken";
        
        TDAlternation *a = [TDAlternation alternation];
        [a add:[TDSymbol symbolWithString:@"("]];
        [a add:[TDSymbol symbolWithString:@")"]];
        [a add:[TDSymbol symbolWithString:@"["]];
        [a add:[TDSymbol symbolWithString:@"]"]];
        [a add:[TDSymbol symbolWithString:@"."]];
        [a add:[TDSymbol symbolWithString:@".."]];
        [a add:[TDSymbol symbolWithString:@"@"]];
        [a add:[TDSymbol symbolWithString:@","]];
        [a add:[TDSymbol symbolWithString:@"::"]];
        [exprToken add:a];
        
        [exprToken add:self.nameTest];
        [exprToken add:self.nodeType];
        [exprToken add:self.operator];
        [exprToken add:self.functionName];
        [exprToken add:self.axisName];
        [exprToken add:self.literal];
        [exprToken add:self.number];
        [exprToken add:self.variableReference];
    }
    return exprToken;
}


- (TDParser *)literal {
    //NSLog(@"%s", _cmd);
    if (!literal) {
        self.literal = [TDQuotedString quotedString];
        literal.name = @"literal";
    }
    return literal;
}


- (TDParser *)number {
    //NSLog(@"%s", _cmd);
    if (!number) {
        self.number = [TDNum num];
        number.name = @"number";
    }
    return number;
}


// [32] Operator ::= OperatorName    
//                    | MultiplyOperator    
//                    | '/' | '//' | '|' | '+' | '-' | '=' | '!=' | '<' | '<=' | '>' | '>='    
- (TDCollectionParser *)operator {
    //NSLog(@"%s", _cmd);
    if (!operator) {
        self.operator = [TDAlternation alternation];
        operator.name = @"operator";
        [operator add:self.operatorName];
        [operator add:self.multiplyOperator];
        [operator add:[TDSymbol symbolWithString: @"/"]];
        [operator add:[TDSymbol symbolWithString:@"//"]];
        [operator add:[TDSymbol symbolWithString: @"|"]];
        [operator add:[TDSymbol symbolWithString: @"+"]];
        [operator add:[TDSymbol symbolWithString: @"-"]];
        [operator add:[TDSymbol symbolWithString: @"="]];
        [operator add:[TDSymbol symbolWithString:@"!="]];
        [operator add:[TDSymbol symbolWithString: @"<"]];
        [operator add:[TDSymbol symbolWithString:@"<="]];
        [operator add:[TDSymbol symbolWithString: @">"]];
        [operator add:[TDSymbol symbolWithString:@">="]];
    }
    return operator;
}


// [33] OperatorName ::=       'and' | 'or' | 'mod' | 'div'    
- (TDCollectionParser *)operatorName {
    //NSLog(@"%s", _cmd);
    if (!operatorName) {
        self.operatorName = [TDAlternation alternation];
        operatorName.name = @"operatorName";
        [operatorName add:[TDLiteral literalWithString:@"and"]];
        [operatorName add:[TDLiteral literalWithString: @"or"]];
        [operatorName add:[TDLiteral literalWithString:@"mod"]];
        [operatorName add:[TDLiteral literalWithString:@"div"]];
    }
    return operatorName;
}


// [34]       MultiplyOperator                    ::=       '*'    
- (TDParser *)multiplyOperator {
    //NSLog(@"%s", _cmd);
    if (!multiplyOperator) {
        self.multiplyOperator = [TDSymbol symbolWithString:@"*"];
        multiplyOperator.name = @"multiplyOperator";
    }
    return multiplyOperator;
}


//[7]       QName       ::=   PrefixedName| UnprefixedName
//[8]       PrefixedName ::=        Prefix ':' LocalPart
//[9]       UnprefixedName     ::=        LocalPart
//[10]       Prefix       ::=       NCName
//[11]       LocalPart       ::=       NCName
- (TDCollectionParser *)QName {
    //NSLog(@"%s", _cmd);
    if (!QName) {
        self.QName = [TDAlternation alternation];
        QName.name = @"QName";

        TDParser *prefix = [TDWord word];
        TDParser *localPart = [TDWord word];
        TDParser *unprefixedName = localPart;
        
        TDSequence *prefixedName = [TDSequence sequence];
        [prefixedName add:prefix];
        [prefixedName add:[TDSymbol symbolWithString:@":"]];
        [prefixedName add:localPart];
        
        [QName add:prefixedName];
        [QName add:unprefixedName];
    }
    return QName;
}


// [35] FunctionName ::= QName - NodeType    
- (TDParser *)functionName {
    //NSLog(@"%s", _cmd);
    if (!functionName) {
        self.functionName = self.QName; // TODO QName - NodeType
        functionName.name = @"functionName";
    }
    return functionName;
}


// [36]  VariableReference ::=       '$' QName    
- (TDCollectionParser *)variableReference {
    //NSLog(@"%s", _cmd);
    if (!variableReference) {
        self.variableReference = [TDSequence sequence];
        variableReference.name = @"variableReference";
        [variableReference add:[TDSymbol symbolWithString:@"$"]];
        [variableReference add:self.QName];
    }
    return variableReference;
}


// [37] NameTest ::= '*' | NCName ':' '*' | QName    
- (TDCollectionParser *)nameTest {
    //NSLog(@"%s", _cmd);
    if (!nameTest) {
        self.nameTest = [TDAlternation alternation];
        nameTest.name = @"nameTest";
        [nameTest add:[TDSymbol symbolWithString:@"*"]];

        TDSequence *s = [TDSequence sequence];
        [s add:[TDWord word]];
        [s add:[TDSymbol symbolWithString:@":"]];
        [s add:[TDSymbol symbolWithString:@"*"]];
        [nameTest add:s];
        
        [nameTest add:self.QName];
    }
    return nameTest;
}


// [38] NodeType ::= 'comment'    
//                    | 'text'    
//                    | 'processing-instruction'    
//                    | 'node'
- (TDCollectionParser *)nodeType {
    //NSLog(@"%s", _cmd);
    if (!nodeType) {
        self.nodeType = [TDAlternation alternation];
        nodeType.name = @"nodeType";
        [nodeType add:[TDLiteral literalWithString:@"comment"]];
        [nodeType add:[TDLiteral literalWithString:@"text"]];
        [nodeType add:[TDLiteral literalWithString:@"processing-instruction"]];
        [nodeType add:[TDLiteral literalWithString:@"node"]];
    }
    return nodeType;
}

@synthesize xpathAssembler;
@synthesize locationPath;
@synthesize absoluteLocationPath;
@synthesize relativeLocationPath;
@synthesize step;
@synthesize axisSpecifier;
@synthesize axisName;
@synthesize nodeTest;
@synthesize predicate;
@synthesize predicateExpr;
@synthesize abbreviatedAbsoluteLocationPath;
@synthesize abbreviatedRelativeLocationPath;
@synthesize abbreviatedStep;
@synthesize abbreviatedAxisSpecifier;
@synthesize expr;
@synthesize primaryExpr;
@synthesize functionCall;
@synthesize argument;
@synthesize unionExpr;
@synthesize pathExpr;
@synthesize filterExpr;
@synthesize orExpr;
@synthesize andExpr;
@synthesize equalityExpr;
@synthesize relationalExpr;
@synthesize additiveExpr;
@synthesize multiplicativeExpr;
@synthesize unaryExpr;
@synthesize exprToken;
@synthesize literal;
@synthesize number;
@synthesize operator;
@synthesize operatorName;
@synthesize multiplyOperator;
@synthesize functionName;
@synthesize variableReference;
@synthesize nameTest;
@synthesize nodeType;
@synthesize QName;
@end
