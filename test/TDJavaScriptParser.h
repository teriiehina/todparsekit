//
//  TDJavaScriptParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 3/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@interface TDJavaScriptParser : TDRepetition {
    TDCollectionParser *primaryExprParser;
    
    TDCollectionParser *argListOptParser;
    TDCollectionParser *argListParser;

    TDCollectionParser *exprParser;
    TDCollectionParser *identifierParser;
    TDCollectionParser *assignmentExprParser;
    TDCollectionParser *assignmentParser;
    
    TDParser *stringParser;
    TDParser *numberParser;
        
    // keywords
    TDParser *ifParser;
    TDParser *elseParser;
    TDParser *whileParser;
    TDParser *forParser;
    TDParser *inParser;
    TDParser *breakParser;
    TDParser *continueParser;
    TDParser *withParser;
    TDParser *returnParser;
    TDParser *varParser;
    TDParser *deleteParser;
    TDParser *newParser;
    TDParser *thisParser;
    TDParser *falseParser;
    TDParser *trueParser;
    TDParser *nullParser;
    TDParser *undefinedParser;
    TDParser *voidParser;
    TDParser *typeofParser;
    TDParser *instanceofParser;
    TDParser *functionParser;

    // multi-char symbols
    TDParser *orParser;
    TDParser *andParser;
    TDParser *neParser;
    TDParser *isNotParser;
    TDParser *eqParser;
    TDParser *isParser;
    TDParser *leParser;
    TDParser *geParser;
    TDParser *plusPlusParser;
    TDParser *minusMinusParser;
    TDParser *plusEqParser;
    TDParser *minusEqParser;
    TDParser *timesEqParser;
    TDParser *divEqParser;
    TDParser *modEqParser;
    TDParser *shiftLeftParser;
    TDParser *shiftRightParser;
    TDParser *shiftRightExtParser;
    TDParser *shiftLeftEqParser;
    TDParser *shiftRightEqParser;
    TDParser *shiftRightExtEqParser;
    TDParser *andEqParser;
    TDParser *xorEqParser;
    TDParser *orEqParser;
    
    // single char symbols
    TDParser *openCurlyParser;
    TDParser *closeCurlyParser;
    TDParser *openParenParser;
    TDParser *closeParenParser;
    TDParser *openBracketParser;
    TDParser *closeBracketParser;
    TDParser *commaParser;
    TDParser *dotParser;
    TDParser *semiParser;
    TDParser *colonParser;
    TDParser *equalsParser;
    TDParser *notParser;
    TDParser *ltParser;
    TDParser *gtParser;
    TDParser *ampParser;
    TDParser *pipeParser;
    TDParser *caretParser;
    TDParser *tildeParser;
    TDParser *questionParser;
    TDParser *plusParser;
    TDParser *minusParser;
    TDParser *timesParser;
    TDParser *divParser;
    TDParser *modParser;
    
    
}

@property (nonatomic, retain) TDCollectionParser *primaryExprParser;

@property (nonatomic, retain) TDCollectionParser *exprParser;
@property (nonatomic, retain) TDCollectionParser *identifierParser;
@property (nonatomic, retain) TDCollectionParser *assignmentExprParser;
@property (nonatomic, retain) TDCollectionParser *assignmentParser;

@property (nonatomic, retain) TDCollectionParser *argListOptParser;
@property (nonatomic, retain) TDCollectionParser *argListParser;

@property (nonatomic, retain) TDParser *stringParser;
@property (nonatomic, retain) TDParser *numberParser;

@property (nonatomic, retain) TDParser *ifParser;
@property (nonatomic, retain) TDParser *elseParser;
@property (nonatomic, retain) TDParser *whileParser;
@property (nonatomic, retain) TDParser *forParser;
@property (nonatomic, retain) TDParser *inParser;
@property (nonatomic, retain) TDParser *breakParser;
@property (nonatomic, retain) TDParser *continueParser;
@property (nonatomic, retain) TDParser *withParser;
@property (nonatomic, retain) TDParser *returnParser;
@property (nonatomic, retain) TDParser *varParser;
@property (nonatomic, retain) TDParser *deleteParser;
@property (nonatomic, retain) TDParser *newParser;
@property (nonatomic, retain) TDParser *thisParser;
@property (nonatomic, retain) TDParser *falseParser;
@property (nonatomic, retain) TDParser *trueParser;
@property (nonatomic, retain) TDParser *nullParser;
@property (nonatomic, retain) TDParser *undefinedParser;
@property (nonatomic, retain) TDParser *voidParser;
@property (nonatomic, retain) TDParser *typeofParser;
@property (nonatomic, retain) TDParser *instanceofParser;
@property (nonatomic, retain) TDParser *functionParser;

@property (nonatomic, retain) TDParser *orParser;
@property (nonatomic, retain) TDParser *andParser;
@property (nonatomic, retain) TDParser *neParser;
@property (nonatomic, retain) TDParser *isNotParser;
@property (nonatomic, retain) TDParser *eqParser;
@property (nonatomic, retain) TDParser *isParser;
@property (nonatomic, retain) TDParser *leParser;
@property (nonatomic, retain) TDParser *geParser;
@property (nonatomic, retain) TDParser *plusPlusParser;
@property (nonatomic, retain) TDParser *minusMinusParser;
@property (nonatomic, retain) TDParser *plusEqParser;
@property (nonatomic, retain) TDParser *minusEqParser;
@property (nonatomic, retain) TDParser *timesEqParser;
@property (nonatomic, retain) TDParser *divEqParser;
@property (nonatomic, retain) TDParser *modEqParser;
@property (nonatomic, retain) TDParser *shiftLeftParser;
@property (nonatomic, retain) TDParser *shiftRightParser;
@property (nonatomic, retain) TDParser *shiftRightExtParser;
@property (nonatomic, retain) TDParser *shiftLeftEqParser;
@property (nonatomic, retain) TDParser *shiftRightEqParser;
@property (nonatomic, retain) TDParser *shiftRightExtEqParser;
@property (nonatomic, retain) TDParser *andEqParser;
@property (nonatomic, retain) TDParser *xorEqParser;
@property (nonatomic, retain) TDParser *orEqParser;

@property (nonatomic, retain) TDParser *openCurlyParser;
@property (nonatomic, retain) TDParser *closeCurlyParser;
@property (nonatomic, retain) TDParser *openParenParser;
@property (nonatomic, retain) TDParser *closeParenParser;
@property (nonatomic, retain) TDParser *openBracketParser;
@property (nonatomic, retain) TDParser *closeBracketParser;
@property (nonatomic, retain) TDParser *commaParser;
@property (nonatomic, retain) TDParser *dotParser;
@property (nonatomic, retain) TDParser *semiParser;
@property (nonatomic, retain) TDParser *colonParser;
@property (nonatomic, retain) TDParser *equalsParser;
@property (nonatomic, retain) TDParser *notParser;
@property (nonatomic, retain) TDParser *ltParser;
@property (nonatomic, retain) TDParser *gtParser;
@property (nonatomic, retain) TDParser *ampParser;
@property (nonatomic, retain) TDParser *pipeParser;
@property (nonatomic, retain) TDParser *caretParser;
@property (nonatomic, retain) TDParser *tildeParser;
@property (nonatomic, retain) TDParser *questionParser;
@property (nonatomic, retain) TDParser *plusParser;
@property (nonatomic, retain) TDParser *minusParser;
@property (nonatomic, retain) TDParser *timesParser;
@property (nonatomic, retain) TDParser *divParser;
@property (nonatomic, retain) TDParser *modParser;
@end
