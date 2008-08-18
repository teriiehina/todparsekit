//
//  XPathParser.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "XPathParser.h"
//#import "TODNCName.h"
#import <TODParseKit/TODParseKit.h>
#import "TODNCNameState.h"
#import "XPathAssembler.h"

@interface XPathParser ()
@property (retain) XPathAssembler *xpathAssembler;
@end

@implementation XPathParser

- (id)init {
	self = [super init];
	if (self != nil) {
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
	[super dealloc];
}


- (TODAssembly *)assemblyWithString:(NSString *)s {
	TODTokenAssembly *a = [TODTokenAssembly assemblyWithString:s];
	TODTokenizer *t = a.tokenizer;
	
	[t.symbolState add:@"::"];
	[t.symbolState add:@"!="];
	[t.symbolState add:@"<="];
	[t.symbolState add:@">="];
	[t.symbolState add:@".."];
	[t.symbolState add:@"//"];
	
//	TODNCNameState *NCNameState = [[[TODNCNameState alloc] init] autorelease];
	
	[t setCharacterState:t.wordState from: '_' to: '_'];
//	[t setCharacterState:NCNameState from: 'a' to: 'z'];
//	[t setCharacterState:NCNameState from: 'A' to: 'Z'];
//	[t setCharacterState:NCNameState from:0xc0 to:0xff];
	return a;	
}


- (id)parse:(NSString *)s {
	[xpathAssembler reset];
	TODAssembly *a = [self assemblyWithString:s];
	id result = [self completeMatchFor:a];
	return result;
}


// [1]		LocationPath						::=   	RelativeLocationPath | AbsoluteLocationPath	
- (TODCollectionParser *)locationPath {
	//NSLog(@"%s", _cmd);
	if (!locationPath) {
		self.locationPath = [TODAlternation alternation];
		locationPath.name = @"locationPath";
		
		[locationPath add:self.relativeLocationPath];
		[locationPath add:self.absoluteLocationPath];
	}
	return locationPath;
}


//[2]		AbsoluteLocationPath				::=   	'/' RelativeLocationPath? | AbbreviatedAbsoluteLocationPath	
- (TODCollectionParser *)absoluteLocationPath {
	//NSLog(@"%s", _cmd);
	if (!absoluteLocationPath) {
		self.absoluteLocationPath = [TODAlternation alternation];
		absoluteLocationPath.name = @"absoluteLocationPath";

		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:self.relativeLocationPath];
		
		TODSequence *s = [TODSequence sequence];
		[s add:[TODSymbol symbolWithString:@"/"]];
		[s add:a];
		
		[absoluteLocationPath add:s];
		[absoluteLocationPath add:self.abbreviatedAbsoluteLocationPath];
	}
	return absoluteLocationPath;
}

#pragma mark -
#pragma mark left recursion

//[3] RelativeLocationPath ::= Step	| RelativeLocationPath '/' Step	| AbbreviatedRelativeLocationPath

// avoiding left recursion by changing to this
//[3] RelativeLocationPath ::= Step SlashStep*	| AbbreviatedRelativeLocationPath

- (TODCollectionParser *)relativeLocationPath {
	//NSLog(@"%s", _cmd);
	if (!relativeLocationPath) {
//		self.relativeLocationPath = [TODAlternation alternation];
//		[relativeLocationPath add:self.step];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:self.relativeLocationPath];
//		[s add:[TODSymbol symbolWithString:@"/"]];
//		[s add:self.step];
//		[relativeLocationPath add:s];
//		
//		[relativeLocationPath add:self.abbreviatedRelativeLocationPath];
		

		//[3] RelativeLocationPath ::= Step SlashStep*	| AbbreviatedRelativeLocationPath
		self.relativeLocationPath = [TODAlternation alternation];
		relativeLocationPath.name = @"relativeLocationPath";

		TODSequence *s = [TODSequence sequence];
		[s add:self.step];

		TODSequence *slashStep = [TODSequence sequence];
		[slashStep add:[TODSymbol symbolWithString:@"/"]];
		[slashStep add:self.step];
		[s add:[TODRepetition repetitionWithSubparser:slashStep]];

		[relativeLocationPath add:s];

//		[relativeLocationPath add:self.abbreviatedRelativeLocationPath];
	}
	return relativeLocationPath;
}


// [4] Step ::=   	AxisSpecifier NodeTest Predicate* | AbbreviatedStep	
- (TODCollectionParser *)step {
	NSLog(@"%s", _cmd);
	if (!step) {
		self.step = [TODAlternation alternation];
		step.name = @"step";
		
		TODSequence *s = [TODSequence sequence];
		[s add:self.axisSpecifier];
		[s add:self.nodeTest];
		[s add:[TODRepetition repetitionWithSubparser:self.predicate]];
		
		[step add:s];
		[step add:self.abbreviatedStep];
		
		[step setAssembler:xpathAssembler selector:@selector(workOnStepAssembly:)];
	}
	return step;
}


// [5]	AxisSpecifier ::= AxisName '::' | AbbreviatedAxisSpecifier
- (TODCollectionParser *)axisSpecifier {
	//NSLog(@"%s", _cmd);
	if (!axisSpecifier) {
		self.axisSpecifier = [TODAlternation alternation];
		axisSpecifier.name = @"axisSpecifier";
		
		TODSequence *s = [TODSequence sequence];
		[s add:self.axisName];
		[s add:[TODSymbol symbolWithString:@"::"]];
		
		[axisSpecifier add:s];
		[axisSpecifier add:self.abbreviatedAxisSpecifier];
		[axisSpecifier setAssembler:xpathAssembler selector:@selector(workOnAxisSpecifierAssembly:)];
	}
	return axisSpecifier;
}


// [6] AxisName ::= 'ancestor' | 'ancestor-or-self' | 'attribute' | 'child' | 'descendant' | 'descendant-or-self'
//			| 'following' | 'following-sibling' | 'namespace' | 'parent' | 'preceding' | 'preceding-sibling' | 'self'
- (TODCollectionParser *)axisName {
	//NSLog(@"%s", _cmd);
	if (!axisName) {
		self.axisName = [TODAlternation alternation];
		axisName.name = @"axisName";
		[axisName add:[TODLiteral literalWithString:@"ancestor"]];
		[axisName add:[TODLiteral literalWithString:@"ancestor-or-self"]];
		[axisName add:[TODLiteral literalWithString:@"attribute"]];
		[axisName add:[TODLiteral literalWithString:@"child"]];
		[axisName add:[TODLiteral literalWithString:@"descendant"]];
		[axisName add:[TODLiteral literalWithString:@"descendant-or-self"]];
		[axisName add:[TODLiteral literalWithString:@"following"]];
		[axisName add:[TODLiteral literalWithString:@"following-sibling"]];
		[axisName add:[TODLiteral literalWithString:@"preceeding"]];
		[axisName add:[TODLiteral literalWithString:@"preceeding-sibling"]];
		[axisName add:[TODLiteral literalWithString:@"namespace"]];
		[axisName add:[TODLiteral literalWithString:@"parent"]];
		[axisName add:[TODLiteral literalWithString:@"self"]];
	}
	return axisName;
}


// [7]  NodeTest ::= NameTest | NodeType '(' ')' | 'processing-instruction' '(' Literal ')'
- (TODCollectionParser *)nodeTest {
	//NSLog(@"%s", _cmd);
	if (!nodeTest) {
		self.nodeTest = [TODAlternation alternation];
		nodeTest.name = @"nodeTest";
		[nodeTest add:self.nameTest];
		
		TODSequence *s = [TODSequence sequence];
		[s add:self.nodeType];
		[s add:[TODSymbol symbolWithString:@"("]];
		[s add:[TODSymbol symbolWithString:@")"]];
		[nodeTest add:s];
		
		s = [TODSequence sequence];
		[s add:[TODLiteral literalWithString:@"processing-instruction"]];
		[s add:[TODSymbol symbolWithString:@"("]];
		[s add:self.literal];
		[s add:[TODSymbol symbolWithString:@")"]];
		[nodeTest add:s];		
	}
	return nodeTest;
}


// [8]  Predicate ::=  '[' PredicateExpr ']'	
- (TODCollectionParser *)predicate {
	//NSLog(@"%s", _cmd);
	if (!predicate) {
		self.predicate = [TODSequence sequence];
		predicate.name = @"predicate";
		[predicate add:[TODSymbol symbolWithString:@"["]];
		[predicate add:self.predicateExpr];
		[predicate add:[TODSymbol symbolWithString:@"]"]];
	}
	return predicate;
}


// [9]  PredicateExpr	::=   	Expr
- (TODCollectionParser *)predicateExpr {
	//NSLog(@"%s", _cmd);
	if (!predicateExpr) {
		// TODO
		self.predicateExpr = self.expr;
		predicateExpr.name = @"predicateExpr";
	}
	return predicateExpr;
}


// [10]  AbbreviatedAbsoluteLocationPath ::= '//' RelativeLocationPath	
- (TODCollectionParser *)abbreviatedAbsoluteLocationPath {
	//NSLog(@"%s", _cmd);
	if (!abbreviatedAbsoluteLocationPath) {
		self.abbreviatedAbsoluteLocationPath = [TODSequence sequence];
		abbreviatedAbsoluteLocationPath.name = @"abbreviatedAbsoluteLocationPath";
		[abbreviatedAbsoluteLocationPath add:[TODSymbol symbolWithString:@"//"]];
		[abbreviatedAbsoluteLocationPath add:self.relativeLocationPath];
	}
	return abbreviatedAbsoluteLocationPath;
}


// [11] AbbreviatedRelativeLocationPath ::= RelativeLocationPath '//' Step	
- (TODCollectionParser *)abbreviatedRelativeLocationPath {
	//NSLog(@"%s", _cmd);
	if (!abbreviatedRelativeLocationPath) {
		self.abbreviatedRelativeLocationPath = [TODSequence sequence];
		abbreviatedRelativeLocationPath.name = @"abbreviatedRelativeLocationPath";
		[abbreviatedRelativeLocationPath add:self.relativeLocationPath];
		[abbreviatedRelativeLocationPath add:[TODSymbol symbolWithString:@"//"]];
		[abbreviatedRelativeLocationPath add:self.step];
	}
	return abbreviatedRelativeLocationPath;
}


// [12] AbbreviatedStep	::=   	'.'	| '..'
- (TODCollectionParser *)abbreviatedStep {
	//NSLog(@"%s", _cmd);
	if (!abbreviatedStep) {
		self.abbreviatedStep = [TODAlternation alternation];
		abbreviatedStep.name = @"abbreviatedStep";
		[abbreviatedStep add:[TODSymbol symbolWithString:@"."]];
		[abbreviatedStep add:[TODSymbol symbolWithString:@".."]];
	}
	return abbreviatedStep;
}


// [13] AbbreviatedAxisSpecifier ::=   	'@'?
- (TODCollectionParser *)abbreviatedAxisSpecifier {
	//NSLog(@"%s", _cmd);
	if (!abbreviatedAxisSpecifier) {
		self.abbreviatedAxisSpecifier = [TODAlternation alternation];
		abbreviatedAxisSpecifier.name = @"abbreviatedAxisSpecifier";
		[abbreviatedAxisSpecifier add:[TODEmpty empty]];
		[abbreviatedAxisSpecifier add:[TODSymbol symbolWithString:@"@"]];
	}
	return abbreviatedAxisSpecifier;
}


// [14]   	Expr ::=   	OrExpr	
- (TODCollectionParser *)expr {
	//NSLog(@"%s", _cmd);
	if (!expr) {
		// TODO
		self.expr = self.orExpr;
		expr.name = @"expr";
	}
	return expr;
}


// [15] PrimaryExpr	::=  VariableReference	
//					| '(' Expr ')'	
//					| Literal	
//					| Number	
//					| FunctionCall
- (TODCollectionParser *)primaryExpr {
	//NSLog(@"%s", _cmd);
	if (!primaryExpr) {
		self.primaryExpr = [TODAlternation alternation];
		primaryExpr.name = @"primaryExpr";
		[primaryExpr add:self.variableReference];
		
		TODSequence *s = [TODSequence sequence];
		[s add:[TODSymbol symbolWithString:@"("]];
		[s add:self.expr];
		[s add:[TODSymbol symbolWithString:@")"]];
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
- (TODCollectionParser *)functionCall {
	//NSLog(@"%s", _cmd);
	if (!functionCall) {
		self.functionCall = [TODSequence sequence];
		functionCall.name = @"functionCall";
		[functionCall add:self.functionName];
		[functionCall add:[TODSymbol symbolWithString:@"("]];
		
		TODSequence *commaArg = [TODSequence sequence];
		[commaArg add:[TODSymbol symbolWithString:@","]];
		[commaArg add:self.argument];
		
		TODSequence *args = [TODSequence sequence];
		[args add:self.argument];
		[args add:[TODRepetition repetitionWithSubparser:commaArg]];
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:args];
		
		[functionCall add:a];
		[functionCall add:[TODSymbol symbolWithString:@")"]];
	}
	return functionCall;
}


// [17] Argument ::=   	Expr
- (TODCollectionParser *)argument {
	//NSLog(@"%s", _cmd);
	if (!argument) {
		// TODO
		self.argument = self.expr;
		argument.name = @"argument";
	}
	return argument;
}


#pragma mark -
#pragma mark Left Recursion

// [18]  UnionExpr ::=   	PathExpr | UnionExpr '|' PathExpr	

// pipePathExpr :: = | PathExpr
// [18]  UnionExpr ::=   	PathExpr PipePathExpr*
- (TODCollectionParser *)unionExpr {
	//NSLog(@"%s", _cmd);
	if (!unionExpr) {
//		self.unionExpr = [TODAlternation alternation];
//		[unionExpr add:self.pathExpr];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:unionExpr];
//		[s add:[TODSymbol symbolWithString:@"|"]];
//		[s add:self.pathExpr];
		
		self.unionExpr = [TODSequence sequence];
		unionExpr.name = @"unionExpr";

		TODSequence *pipePathExpr = [TODSequence sequence];
		[pipePathExpr add:[TODSymbol symbolWithString:@"|"]];
		[pipePathExpr add:self.pathExpr];
		
		[unionExpr add:self.pathExpr];
		[unionExpr add:[TODRepetition repetitionWithSubparser:pipePathExpr]];
	}
	return unionExpr;
}


//[19]   	PathExpr ::= LocationPath	
//					| FilterExpr	
//					| FilterExpr '/' RelativeLocationPath	
//					| FilterExpr '//' RelativeLocationPath	
- (TODCollectionParser *)pathExpr {
	//NSLog(@"%s", _cmd);
	if (!pathExpr) {
		self.pathExpr = [TODAlternation alternation];
		pathExpr.name = @"pathExpr";
		[pathExpr add:self.locationPath];
		[pathExpr add:self.filterExpr];
		
		TODSequence *s = [TODSequence sequence];
		[s add:self.filterExpr];
		[s add:[TODSymbol symbolWithString:@"/"]];
		[s add:self.relativeLocationPath];
		[pathExpr add:s];
		
		s = [TODSequence sequence];
		[s add:self.filterExpr];
		[s add:[TODSymbol symbolWithString:@"//"]];
		[s add:self.relativeLocationPath];
		[pathExpr add:s];
	}
	return pathExpr;
}


#pragma mark -
#pragma mark Left Recursion????????????

// [20]  FilterExpr	 ::=   	PrimaryExpr	| FilterExpr Predicate


// [20]  FilterExpr	 ::=   	PrimaryExpr Predicate?
- (TODCollectionParser *)filterExpr {
	//NSLog(@"%s", _cmd);
	if (!filterExpr) {
//		self.filterExpr = [TODAlternation alternation];
//		[filterExpr add:self.primaryExpr];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:filterExpr];
//		[s add:self.predicate];
//		
//		[filterExpr add:s];
		
		self.filterExpr = [TODSequence sequence];
		filterExpr.name = @"filterExpr";
		[filterExpr add:self.primaryExpr];
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:self.predicate];
		[filterExpr add:a];
	}
	return filterExpr;
}


#pragma mark -
#pragma mark Left Recursion
// [21] OrExpr ::= AndExpr	| OrExpr 'or' AndExpr	

// orAndExpr ::= 'or' AndExpr
// me: AndExpr orAndExpr*
- (TODCollectionParser *)orExpr {
	//NSLog(@"%s", _cmd);
	if (!orExpr) {
//		self.orExpr = [TODAlternation alternation];
//		[orExpr add:self.andExpr];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:orExpr];
//		[s add:[TODLiteral literalWithString:@"or"]];
//		[s add:self.andExpr];
//		[orExpr add:s];
		
		self.orExpr = [TODSequence sequence];
		orExpr.name = @"orExpr";
		
		[orExpr add:self.andExpr];
		
		TODSequence *orAndExpr = [TODSequence sequence];
		[orAndExpr add:[TODLiteral literalWithString:@"or"]];
		[orAndExpr add:self.andExpr];
		
		[orExpr add:[TODRepetition repetitionWithSubparser:orAndExpr]];
	}
	return orExpr;
}


#pragma mark -
#pragma mark Left Recursion

// [22] AndExpr ::= EqualityExpr | AndExpr 'and' EqualityExpr	


// andEqualityExpr
// EqualityExpr andEqualityExpr

- (TODCollectionParser *)andExpr {
	//NSLog(@"%s", _cmd);
	if (!andExpr) {
//		self.andExpr = [TODAlternation alternation];
//		[andExpr add:self.equalityExpr];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:andExpr];
//		[s add:[TODLiteral literalWithString:@"and"]];
//		[s add:self.equalityExpr];
//		[andExpr add:s];
		
		self.andExpr = [TODSequence sequence];
		andExpr.name = @"andExpr";
		[andExpr add:self.equalityExpr];

		TODSequence *andEqualityExpr = [TODSequence sequence];
		[andEqualityExpr add:[TODLiteral literalWithString:@"and"]];
		[andEqualityExpr add:self.equalityExpr];
		
		[andExpr add:[TODRepetition repetitionWithSubparser:andEqualityExpr]];
	}
	return andExpr;
}


#pragma mark -
#pragma mark Left Recursion?????????????????

// [23] EqualityExpr ::= RelationalExpr	
//			| EqualityExpr '=' RelationalExpr
//			| EqualityExpr '!=' RelationalExpr	

// RelationalExpr (equalsRelationalExpr | notEqualsRelationalExpr)?

- (TODCollectionParser *)equalityExpr {
	//NSLog(@"%s", _cmd);
	if (!equalityExpr) {
//		self.equalityExpr = [TODAlternation alternation];
//		[equalityExpr add:self.relationalExpr];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:equalityExpr];
//		[s add:[TODSymbol symbolWithString:@"="]];
//		[s add:self.relationalExpr];
//		[equalityExpr add:s];
//	
//		s = [TODSequence sequence];
//		[s add:equalityExpr];
//		[s add:[TODSymbol symbolWithString:@"!="]];
//		[s add:self.relationalExpr];
//		[equalityExpr add:s];
		
		self.equalityExpr = [TODSequence sequence];
		equalityExpr.name = @"equalityExpr";
		[equalityExpr add:self.relationalExpr];
		
		TODSequence *equalsRelationalExpr = [TODSequence sequence];
		[equalsRelationalExpr add:[TODSymbol symbolWithString:@"="]];
		[equalsRelationalExpr add:self.relationalExpr];
		
		TODSequence *notEqualsRelationalExpr = [TODSequence sequence];
		[notEqualsRelationalExpr add:[TODSymbol symbolWithString:@"!="]];
		[notEqualsRelationalExpr add:self.relationalExpr];
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:equalsRelationalExpr];
		[a add:notEqualsRelationalExpr];
		
		TODAlternation *a1 = [TODAlternation alternation];
		[a1 add:[TODEmpty empty]];
		[a1 add:a];
		
		[equalityExpr add:a1];
	}
	return equalityExpr;
}


#pragma mark -
#pragma mark Left Recursion?????????????????

// [24] RelationalExpr ::= AdditiveExpr
//						| RelationalExpr '<' AdditiveExpr	
//						| RelationalExpr '>' AdditiveExpr	
//						| RelationalExpr '<=' AdditiveExpr	
//						| RelationalExpr '>=' AdditiveExpr

// RelationalExpr = AdditiveExpr (ltAdditiveExpr | gtAdditiveExpr | lteAdditiveExpr | gteAdditiveExpr)?
- (TODCollectionParser *)relationalExpr {
	//NSLog(@"%s", _cmd);
	if (!relationalExpr) {
		
		self.relationalExpr = [TODSequence sequence];
		relationalExpr.name = @"relationalExpr";
		[relationalExpr add:self.additiveExpr];
		
		TODAlternation *a = [TODAlternation alternation];
		
		TODSequence *ltAdditiveExpr = [TODSequence sequence];
		[ltAdditiveExpr add:[TODSymbol symbolWithString:@"<"]];
		[a add:ltAdditiveExpr];

		TODSequence *gtAdditiveExpr = [TODSequence sequence];
		[gtAdditiveExpr add:[TODSymbol symbolWithString:@">"]];
		[a add:gtAdditiveExpr];

		TODSequence *lteAdditiveExpr = [TODSequence sequence];
		[lteAdditiveExpr add:[TODSymbol symbolWithString:@"<="]];
		[a add:lteAdditiveExpr];

		TODSequence *gteAdditiveExpr = [TODSequence sequence];
		[gteAdditiveExpr add:[TODSymbol symbolWithString:@">="]];
		[a add:gteAdditiveExpr];
		
		TODAlternation *a1 = [TODAlternation alternation];
		[a1 add:[TODEmpty empty]];
		[a1 add:a];
		
		[relationalExpr add:a1];
		
//		self.relationalExpr = [TODAlternation alternation];
//		[relationalExpr add:self.additiveExpr];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:relationalExpr];
//		[s add:[TODSymbol symbolWithString:@"<"]];
//		[s add:self.additiveExpr];
//		[relationalExpr add:s];
//		
//		s = [TODSequence sequence];
//		[s add:relationalExpr];
//		[s add:[TODSymbol symbolWithString:@">"]];
//		[s add:self.additiveExpr];
//		[relationalExpr add:s];
//
//		s = [TODSequence sequence];
//		[s add:relationalExpr];
//		[s add:[TODSymbol symbolWithString:@"<="]];
//		[s add:self.additiveExpr];
//		[relationalExpr add:s];
//
//		s = [TODSequence sequence];
//		[s add:relationalExpr];
//		[s add:[TODSymbol symbolWithString:@">="]];
//		[s add:self.additiveExpr];
//		[relationalExpr add:s];
	}
	return relationalExpr;
}


#pragma mark -
#pragma mark Left Recursion?????????????????

// [25] AdditiveExpr ::= MultiplicativeExpr	
//						| AdditiveExpr '+' MultiplicativeExpr	
//						| AdditiveExpr '-' MultiplicativeExpr	

// AdditiveExpr ::= MultiplicativeExpr (plusMultiplicativeExpr | minusMultiplicativeExpr)?
- (TODCollectionParser *)additiveExpr {
	//NSLog(@"%s", _cmd);
	if (!additiveExpr) {
		self.additiveExpr = [TODSequence sequence];
		additiveExpr.name = @"additiveExpr";
		[additiveExpr add:self.multiplicativeExpr];
		
		TODAlternation *a = [TODAlternation alternation];

		TODSequence *plusMultiplicativeExpr = [TODSequence sequence];
		[plusMultiplicativeExpr add:[TODSymbol symbolWithString:@"+"]];
		[plusMultiplicativeExpr add:self.multiplicativeExpr];
		[a add:plusMultiplicativeExpr];
		
		TODSequence *minusMultiplicativeExpr = [TODSequence sequence];
		[minusMultiplicativeExpr add:[TODSymbol symbolWithString:@"-"]];
		[minusMultiplicativeExpr add:self.multiplicativeExpr];
		[a add:minusMultiplicativeExpr];
		
		TODAlternation *a1 = [TODAlternation alternation];
		[a1 add:[TODEmpty empty]];
		[a1 add:a];
		
		[additiveExpr add:a1];
		
		//		self.additiveExpr = [TODAlternation alternation];
//		[additiveExpr add:self.multiplicativeExpr];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:additiveExpr];
//		[s add:[TODSymbol symbolWithString:@"+"]];
//		[s add:self.multiplicativeExpr];
//		[additiveExpr add:s];
//		
//		s = [TODSequence sequence];
//		[s add:additiveExpr];
//		[s add:[TODSymbol symbolWithString:@"+"]];
//		[s add:self.multiplicativeExpr];
//		[additiveExpr add:s];
	}
	return additiveExpr;
}


#pragma mark -
#pragma mark Left Recursion?????????????????

// [26] MultiplicativeExpr ::= UnaryExpr	
//							| MultiplicativeExpr MultiplyOperator UnaryExpr	
//							| MultiplicativeExpr 'div' UnaryExpr	
//							| MultiplicativeExpr 'mod' UnaryExpr

// MultiplicativeExpr :: = UnaryExpr (multiplyUnaryExpr | divUnaryExpr | modUnaryExpr)? 
- (TODCollectionParser *)multiplicativeExpr {
	//NSLog(@"%s", _cmd);
	if (!multiplicativeExpr) {
		self.multiplicativeExpr = [TODSequence sequence];
		multiplicativeExpr.name = @"multiplicativeExpr";
		[multiplicativeExpr add:self.unaryExpr];
		
		TODAlternation *a = [TODAlternation alternation];
		
		TODSequence *multiplyUnaryExpr = [TODSequence sequence];
		[multiplyUnaryExpr add:self.multiplyOperator];
		[multiplyUnaryExpr add:self.unaryExpr];
		[a add:multiplyUnaryExpr];
		
		TODSequence *divUnaryExpr = [TODSequence sequence];
		[divUnaryExpr add:[TODLiteral literalWithString:@"div"]];
		[divUnaryExpr add:self.unaryExpr];
		[a add:divUnaryExpr];
		
		TODSequence *modUnaryExpr = [TODSequence sequence];
		[modUnaryExpr add:[TODLiteral literalWithString:@"mod"]];
		[modUnaryExpr add:self.unaryExpr];
		[a add:modUnaryExpr];
		
		TODAlternation *a1 = [TODAlternation alternation];
		[a1 add:[TODEmpty empty]];
		[a1 add:a];
		
		[multiplicativeExpr add:a1];
		
//		self.multiplicativeExpr = [TODAlternation alternation];
//		[additiveExpr add:self.unaryExpr];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:multiplicativeExpr];
//		[s add:self.multiplyOperator];
//		[s add:self.unaryExpr];
//		[multiplicativeExpr add:s];
//		
//		s = [TODSequence sequence];
//		[s add:multiplicativeExpr];
//		[s add:[TODLiteral literalWithString:@"div"]];
//		[s add:self.unaryExpr];
//		[multiplicativeExpr add:s];
//		
//		s = [TODSequence sequence];
//		[s add:multiplicativeExpr];
//		[s add:[TODLiteral literalWithString:@"mod"]];
//		[s add:self.unaryExpr];
//		[multiplicativeExpr add:s];
	}
	return multiplicativeExpr;
}


#pragma mark -
#pragma mark Left Recursion?????????????????

// [27] UnaryExpr ::= UnionExpr | '-' UnaryExpr

// UnaryExpr ::= '-'? UnionExpr
- (TODCollectionParser *)unaryExpr {
	//NSLog(@"%s", _cmd);
	if (!unaryExpr) {
		self.unaryExpr = [TODSequence sequence];
		unaryExpr.name = @"unaryExpr";
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODEmpty empty]];
		[a add:[TODSymbol symbolWithString:@"-"]];
		
		[unaryExpr add:a];
		[unaryExpr add:self.unionExpr];
		
		//		self.unaryExpr = [TODAlternation alternation];
//		[unaryExpr add:self.unionExpr];
//		
//		TODSequence *s = [TODSequence sequence];
//		[s add:[TODSymbol symbolWithString:@"-"]];
//		[s add:unaryExpr];
//		[unionExpr add:s];
	}
	return unaryExpr;
}


// [28] ExprToken ::= '(' | ')' | '[' | ']' | '.' | '..' | '@' | ',' | '::'
//					| NameTest	
//					| NodeType	
//					| Operator	
//					| FunctionName	
//					| AxisName	
//					| Literal	
//					| Number	
//					| VariableReference	
- (TODCollectionParser *)exprToken {
	//NSLog(@"%s", _cmd);
	if (!exprToken) {
		self.exprToken = [TODAlternation alternation];
		exprToken.name = @"exprToken";
		
		TODAlternation *a = [TODAlternation alternation];
		[a add:[TODSymbol symbolWithString:@"("]];
		[a add:[TODSymbol symbolWithString:@")"]];
		[a add:[TODSymbol symbolWithString:@"["]];
		[a add:[TODSymbol symbolWithString:@"]"]];
		[a add:[TODSymbol symbolWithString:@"."]];
		[a add:[TODSymbol symbolWithString:@".."]];
		[a add:[TODSymbol symbolWithString:@"@"]];
		[a add:[TODSymbol symbolWithString:@","]];
		[a add:[TODSymbol symbolWithString:@"::"]];
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


- (TODParser *)literal {
	//NSLog(@"%s", _cmd);
	if (!literal) {
		self.literal = [TODQuotedString quotedString];
		literal.name = @"literal";
	}
	return literal;
}


- (TODParser *)number {
	//NSLog(@"%s", _cmd);
	if (!number) {
		self.number = [TODNum num];
		number.name = @"number";
	}
	return number;
}


// [32] Operator ::= OperatorName	
//					| MultiplyOperator	
//					| '/' | '//' | '|' | '+' | '-' | '=' | '!=' | '<' | '<=' | '>' | '>='	
- (TODCollectionParser *)operator {
	//NSLog(@"%s", _cmd);
	if (!operator) {
		self.operator = [TODAlternation alternation];
		operator.name = @"operator";
		[operator add:self.operatorName];
		[operator add:self.multiplyOperator];
		[operator add:[TODSymbol symbolWithString: @"/"]];
		[operator add:[TODSymbol symbolWithString:@"//"]];
		[operator add:[TODSymbol symbolWithString: @"|"]];
		[operator add:[TODSymbol symbolWithString: @"+"]];
		[operator add:[TODSymbol symbolWithString: @"-"]];
		[operator add:[TODSymbol symbolWithString: @"="]];
		[operator add:[TODSymbol symbolWithString:@"!="]];
		[operator add:[TODSymbol symbolWithString: @"<"]];
		[operator add:[TODSymbol symbolWithString:@"<="]];
		[operator add:[TODSymbol symbolWithString: @">"]];
		[operator add:[TODSymbol symbolWithString:@">="]];
	}
	return operator;
}


// [33] OperatorName ::=   	'and' | 'or' | 'mod' | 'div'	
- (TODCollectionParser *)operatorName {
	//NSLog(@"%s", _cmd);
	if (!operatorName) {
		self.operatorName = [TODAlternation alternation];
		operatorName.name = @"operatorName";
		[operatorName add:[TODLiteral literalWithString:@"and"]];
		[operatorName add:[TODLiteral literalWithString: @"or"]];
		[operatorName add:[TODLiteral literalWithString:@"mod"]];
		[operatorName add:[TODLiteral literalWithString:@"div"]];
	}
	return operatorName;
}


// [34]   	MultiplyOperator					::=   	'*'	
- (TODParser *)multiplyOperator {
	//NSLog(@"%s", _cmd);
	if (!multiplyOperator) {
		self.multiplyOperator = [TODSymbol symbolWithString:@"*"];
		multiplyOperator.name = @"multiplyOperator";
	}
	return multiplyOperator;
}


//[7]   	QName	   ::=   PrefixedName| UnprefixedName
//[8]   	PrefixedName ::=   	 Prefix ':' LocalPart
//[9]   	UnprefixedName	 ::=   	 LocalPart
//[10]   	Prefix	   ::=   	NCName
//[11]   	LocalPart	   ::=   	NCName
- (TODCollectionParser *)QName {
	//NSLog(@"%s", _cmd);
	if (!QName) {
		self.QName = [TODAlternation alternation];
		QName.name = @"QName";

		TODParser *prefix = [TODWord word];
		TODParser *localPart = [TODWord word];
		TODParser *unprefixedName = localPart;
		
		TODSequence *prefixedName = [TODSequence sequence];
		[prefixedName add:prefix];
		[prefixedName add:[TODSymbol symbolWithString:@":"]];
		[prefixedName add:localPart];
		
		[QName add:prefixedName];
		[QName add:unprefixedName];
	}
	return QName;
}


// [35] FunctionName ::= QName - NodeType	
- (TODParser *)functionName {
	//NSLog(@"%s", _cmd);
	if (!functionName) {
		self.functionName = self.QName; // TODO QName - NodeType
		functionName.name = @"functionName";
	}
	return functionName;
}


// [36]  VariableReference ::=   	'$' QName	
- (TODCollectionParser *)variableReference {
	//NSLog(@"%s", _cmd);
	if (!variableReference) {
		self.variableReference = [TODSequence sequence];
		variableReference.name = @"variableReference";
		[variableReference add:[TODSymbol symbolWithString:@"$"]];
		[variableReference add:self.QName];
	}
	return variableReference;
}


// [37] NameTest ::= '*' | NCName ':' '*' | QName	
- (TODCollectionParser *)nameTest {
	//NSLog(@"%s", _cmd);
	if (!nameTest) {
		self.nameTest = [TODAlternation alternation];
		nameTest.name = @"nameTest";
		[nameTest add:[TODSymbol symbolWithString:@"*"]];

		TODSequence *s = [TODSequence sequence];
		[s add:[TODWord word]];
		[s add:[TODSymbol symbolWithString:@":"]];
		[s add:[TODSymbol symbolWithString:@"*"]];
		[nameTest add:s];
		
		[nameTest add:self.QName];
	}
	return nameTest;
}


// [38] NodeType ::= 'comment'	
//					| 'text'	
//					| 'processing-instruction'	
//					| 'node'
- (TODCollectionParser *)nodeType {
	//NSLog(@"%s", _cmd);
	if (!nodeType) {
		self.nodeType = [TODAlternation alternation];
		nodeType.name = @"nodeType";
		[nodeType add:[TODLiteral literalWithString:@"comment"]];
		[nodeType add:[TODLiteral literalWithString:@"text"]];
		[nodeType add:[TODLiteral literalWithString:@"processing-instruction"]];
		[nodeType add:[TODLiteral literalWithString:@"node"]];
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
