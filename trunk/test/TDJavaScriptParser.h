//
//  TDJavaScriptParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 3/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@interface TDJavaScriptParser : TDRepetition {
    TDCollectionParser *assignmentOpParser;
    TDCollectionParser *relationalOpParser;
    TDCollectionParser *equalityOpParser;
    TDCollectionParser *shiftOpParser;
    TDCollectionParser *incrementOpParser;
    TDCollectionParser *unaryOpParser;
    TDCollectionParser *multiplicativeOpParser;
    
    TDCollectionParser *programParser;
    TDCollectionParser *elementParser;
    TDCollectionParser *funcParser;
    TDCollectionParser *paramListOptParser;
    TDCollectionParser *paramListParser;
    TDCollectionParser *commaIdentifierParser;
    TDCollectionParser *compoundStmtParser;
    TDCollectionParser *stmtsParser;
    TDCollectionParser *stmtParser;
    TDCollectionParser *ifStmtParser;
    TDCollectionParser *ifElseStmtParser;
    TDCollectionParser *whileStmtParser;
    TDCollectionParser *forParenStmtParser;
    TDCollectionParser *forBeginStmtParser;
    TDCollectionParser *forInStmtParser;
    TDCollectionParser *breakStmtParser;
    TDCollectionParser *continueStmtParser;
    TDCollectionParser *withStmtParser;
    TDCollectionParser *returnStmtParser;
    TDCollectionParser *variablesOrExprStmtParser;
    TDCollectionParser *conditionParser;
    TDCollectionParser *forParenParser;
    TDCollectionParser *forBeginParser;
    TDCollectionParser *variablesOrExprParser;
    TDCollectionParser *varVariablesParser;
    TDCollectionParser *variablesParser;
    TDCollectionParser *commaVariableParser;
    TDCollectionParser *variableParser;
    TDCollectionParser *assignmentParser;
    TDCollectionParser *exprOptParser;
    TDCollectionParser *exprParser;
    TDCollectionParser *commaAssignmentExprParser;
    TDCollectionParser *assignmentExprParser;
    TDCollectionParser *assignmentOpConditionalExprParser;
    TDCollectionParser *conditionalExprParser;
    TDCollectionParser *ternaryExprParser;
    TDCollectionParser *orExprParser;
    TDCollectionParser *orAndExprParser;
    TDCollectionParser *andExprParser;
    TDCollectionParser *andBitwiseOrExprParser;
    TDCollectionParser *bitwiseOrExprParser;
    TDCollectionParser *pipeBitwiseXorExprParser;
    TDCollectionParser *bitwiseXorExprParser;
    TDCollectionParser *caretBitwiseAndExprParser;
    TDCollectionParser *bitwiseAndExprParser;
    TDCollectionParser *ampEqualityExprParser;
    TDCollectionParser *equalityExprParser;
    TDCollectionParser *equalityOpRelationalExprParser;
    TDCollectionParser *relationalExprParser;
    TDCollectionParser *relationalExprRHSParser;
    TDCollectionParser *shiftExprParser;
    TDCollectionParser *shiftOpShiftExprParser;
    TDCollectionParser *additiveExprParser;
    TDCollectionParser *plusOrMinusExprParser;
    TDCollectionParser *plusExprParser;
    TDCollectionParser *minusExprParser;
    TDCollectionParser *multiplicativeExprParser;
    TDCollectionParser *multiplicativeOpUnaryExprParser;
    TDCollectionParser *unaryExprParser;
    TDCollectionParser *unaryExpr1Parser;
    TDCollectionParser *unaryExpr2Parser;
    TDCollectionParser *unaryExpr3Parser;
    TDCollectionParser *unaryExpr4Parser;
    TDCollectionParser *unaryExpr5Parser;
    TDCollectionParser *unaryExpr6Parser;
    TDCollectionParser *constructorParser;
    TDCollectionParser *constructorCallParser;
    TDCollectionParser *parenArgListParenParser;
    TDCollectionParser *memberExprParser;
    TDCollectionParser *dotBracketOrParenExprParser;
    TDCollectionParser *dotMemberExprParser;
    TDCollectionParser *bracketMemberExprParser;
    TDCollectionParser *parenMemberExprParser;
    TDCollectionParser *argListOptParser;
    TDCollectionParser *argListParser;
    TDCollectionParser *primaryExprParser;
    TDCollectionParser *parenExprParenParser;

    TDParser *identifierParser;    
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
@property (nonatomic, retain) TDCollectionParser *assignmentOpParser;
@property (nonatomic, retain) TDCollectionParser *relationalOpParser;
@property (nonatomic, retain) TDCollectionParser *equalityOpParser;
@property (nonatomic, retain) TDCollectionParser *shiftOpParser;
@property (nonatomic, retain) TDCollectionParser *incrementOpParser;
@property (nonatomic, retain) TDCollectionParser *unaryOpParser;
@property (nonatomic, retain) TDCollectionParser *multiplicativeOpParser;

@property (nonatomic, retain) TDCollectionParser *programParser;
@property (nonatomic, retain) TDCollectionParser *elementParser;
@property (nonatomic, retain) TDCollectionParser *funcParser;
@property (nonatomic, retain) TDCollectionParser *paramListOptParser;
@property (nonatomic, retain) TDCollectionParser *paramListParser;
@property (nonatomic, retain) TDCollectionParser *commaIdentifierParser;
@property (nonatomic, retain) TDCollectionParser *compoundStmtParser;
@property (nonatomic, retain) TDCollectionParser *stmtsParser;
@property (nonatomic, retain) TDCollectionParser *stmtParser;
@property (nonatomic, retain) TDCollectionParser *ifStmtParser;
@property (nonatomic, retain) TDCollectionParser *ifElseStmtParser;
@property (nonatomic, retain) TDCollectionParser *whileStmtParser;
@property (nonatomic, retain) TDCollectionParser *forParenStmtParser;
@property (nonatomic, retain) TDCollectionParser *forBeginStmtParser;
@property (nonatomic, retain) TDCollectionParser *forInStmtParser;
@property (nonatomic, retain) TDCollectionParser *breakStmtParser;
@property (nonatomic, retain) TDCollectionParser *continueStmtParser;
@property (nonatomic, retain) TDCollectionParser *withStmtParser;
@property (nonatomic, retain) TDCollectionParser *returnStmtParser;
@property (nonatomic, retain) TDCollectionParser *variablesOrExprStmtParser;
@property (nonatomic, retain) TDCollectionParser *conditionParser;
@property (nonatomic, retain) TDCollectionParser *forParenParser;
@property (nonatomic, retain) TDCollectionParser *forBeginParser;
@property (nonatomic, retain) TDCollectionParser *variablesOrExprParser;
@property (nonatomic, retain) TDCollectionParser *varVariablesParser;
@property (nonatomic, retain) TDCollectionParser *variablesParser;
@property (nonatomic, retain) TDCollectionParser *commaVariableParser;
@property (nonatomic, retain) TDCollectionParser *variableParser;
@property (nonatomic, retain) TDCollectionParser *assignmentParser;
@property (nonatomic, retain) TDCollectionParser *exprOptParser;
@property (nonatomic, retain) TDCollectionParser *exprParser;
@property (nonatomic, retain) TDCollectionParser *commaAssignmentExprParser;
@property (nonatomic, retain) TDCollectionParser *assignmentExprParser;
@property (nonatomic, retain) TDCollectionParser *assignmentOpConditionalExprParser;
@property (nonatomic, retain) TDCollectionParser *conditionalExprParser;
@property (nonatomic, retain) TDCollectionParser *ternaryExprParser;
@property (nonatomic, retain) TDCollectionParser *orExprParser;
@property (nonatomic, retain) TDCollectionParser *orAndExprParser;
@property (nonatomic, retain) TDCollectionParser *andExprParser;
@property (nonatomic, retain) TDCollectionParser *andBitwiseOrExprParser;
@property (nonatomic, retain) TDCollectionParser *bitwiseOrExprParser;
@property (nonatomic, retain) TDCollectionParser *pipeBitwiseXorExprParser;
@property (nonatomic, retain) TDCollectionParser *bitwiseXorExprParser;
@property (nonatomic, retain) TDCollectionParser *caretBitwiseAndExprParser;
@property (nonatomic, retain) TDCollectionParser *bitwiseAndExprParser;
@property (nonatomic, retain) TDCollectionParser *ampEqualityExprParser;
@property (nonatomic, retain) TDCollectionParser *equalityExprParser;
@property (nonatomic, retain) TDCollectionParser *equalityOpRelationalExprParser;
@property (nonatomic, retain) TDCollectionParser *relationalExprParser;
@property (nonatomic, retain) TDCollectionParser *relationalExprRHSParser;
@property (nonatomic, retain) TDCollectionParser *shiftExprParser;
@property (nonatomic, retain) TDCollectionParser *shiftOpShiftExprParser;
@property (nonatomic, retain) TDCollectionParser *additiveExprParser;
@property (nonatomic, retain) TDCollectionParser *plusOrMinusExprParser;
@property (nonatomic, retain) TDCollectionParser *plusExprParser;
@property (nonatomic, retain) TDCollectionParser *minusExprParser;
@property (nonatomic, retain) TDCollectionParser *multiplicativeExprParser;
@property (nonatomic, retain) TDCollectionParser *multiplicativeOpUnaryExprParser;
@property (nonatomic, retain) TDCollectionParser *unaryExprParser;
@property (nonatomic, retain) TDCollectionParser *unaryExpr1Parser;
@property (nonatomic, retain) TDCollectionParser *unaryExpr2Parser;
@property (nonatomic, retain) TDCollectionParser *unaryExpr3Parser;
@property (nonatomic, retain) TDCollectionParser *unaryExpr4Parser;
@property (nonatomic, retain) TDCollectionParser *unaryExpr5Parser;
@property (nonatomic, retain) TDCollectionParser *unaryExpr6Parser;
@property (nonatomic, retain) TDCollectionParser *constructorParser;
@property (nonatomic, retain) TDCollectionParser *constructorCallParser;
@property (nonatomic, retain) TDCollectionParser *parenArgListParenParser;
@property (nonatomic, retain) TDCollectionParser *memberExprParser;
@property (nonatomic, retain) TDCollectionParser *dotBracketOrParenExprParser;
@property (nonatomic, retain) TDCollectionParser *dotMemberExprParser;
@property (nonatomic, retain) TDCollectionParser *bracketMemberExprParser;
@property (nonatomic, retain) TDCollectionParser *parenMemberExprParser;
@property (nonatomic, retain) TDCollectionParser *argListOptParser;
@property (nonatomic, retain) TDCollectionParser *argListParser;
@property (nonatomic, retain) TDCollectionParser *primaryExprParser;
@property (nonatomic, retain) TDCollectionParser *parenExprParenParser;

@property (nonatomic, retain) TDParser *identifierParser;
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