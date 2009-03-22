//
//  TDJavaScriptParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 3/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJavaScriptParser.h"

/*
 @symbols            = '||' '&&' '!=' '!==' '==' '===' '<=' '>=' '++' '--' '+=' '-=' '*=' '/=' '%=' '<<' '>>' '>>>' '<<=' '>>=' '>>>=' '&=' '^=' '|=';
 
 @reportsCommentTokens = YES;
 @commentState       = '/';
 @singleLineComments = '//';
 @multiLineComments  = '/*' '* /';
 
 @start              = program;
 
 if                  = 'if';
 else                = 'else';
 while               = 'while';
 for                 = 'for';
 in                  = 'in';
 break               = 'break';
 continue            = 'continue';
 with                = 'with';
 return              = 'return';
 var                 = 'var';
 delete              = 'delete';
 new                 = 'new';
 this                = 'this';
 false               = 'false';
 true                = 'true';
 null                = 'null';
 undefined           = 'undefined';
 void                = 'void';
 typeof              = 'typeof';
 instanceof          = 'instanceof';
 function            = 'function';
 
 openCurly           = '{';
 closeCurly          = '}';
 openParen           = '(';
 closeParen          = ')';
 openBracket         = '[';
 closeBracket        = ']';
 comma               = ',';
 dot                 = '.';
 semi                = ';';
 colon               = ':';
 equals              = '=';
 not                 = '!';
 lt                  = '<';
 gt                  = '>';
 amp                 = '&';
 pipe                = '|';
 caret               = '^';
 tilde               = '~';
 question            = '?';
 plus                = '+';
 minus               = '-';
 times               = '*';
 div                 = '/';
 mod                 = '%';
 
 or                  = '||';
 and                 = '&&';
 ne                  = '!=';
 isnot               = '!==';
 eq                  = '==';
 is                  = '===';
 le                  = '<=';
 ge                  = '>=';
 plusPlus            = '++';
 minusMinus          = '--';
 plusEq              = '+=';
 minusEq             = '-=';
 timesEq             = '*=';
 divEq               = '/=';
 modEq               = '%=';
 shiftLeft           = '<<';
 shiftRight          = '>>';
 shiftRightExt       = '>>>';
 shiftLeftEq         = '<<=';
 shiftRightEq        = '>>=';
 shiftRightExtEq     = '>>>=';
 andEq               = '&=';
 xorEq               = '^=';
 orEq                = '|=';
 */

@interface TDParser ()
- (void)setTokenizer:(TDTokenizer *)t;
@end

@interface TDJavaScriptParser ()
- (TDAlternation *)zeroOrOne:(TDParser *)p;
- (TDAlternation *)oneOrMore:(TDParser *)p;
@end

@implementation TDJavaScriptParser

- (id)init {
    if (self = [super init]) {
        self.tokenizer = [TDTokenizer tokenizer];
        
        tokenizer.commentState.reportsCommentTokens = YES;
        [tokenizer setTokenizerState:tokenizer.commentState from:'/' to:'/'];
        [tokenizer.commentState addSingleLineStartSymbol:@"//"];
        [tokenizer.commentState addMultiLineStartSymbol:@"/*" endSymbol:@"*/"];
        
        [tokenizer.symbolState add:@"||"];
        [tokenizer.symbolState add:@"&&"];
        [tokenizer.symbolState add:@"!="];
        [tokenizer.symbolState add:@"=="];
        [tokenizer.symbolState add:@"==="];
        [tokenizer.symbolState add:@"<="];
        [tokenizer.symbolState add:@">="];
        [tokenizer.symbolState add:@"++"];
        [tokenizer.symbolState add:@"--"];
        [tokenizer.symbolState add:@"+="];
        [tokenizer.symbolState add:@"-="];
        [tokenizer.symbolState add:@"*="];
        [tokenizer.symbolState add:@"/="];
        [tokenizer.symbolState add:@"%="];
        [tokenizer.symbolState add:@"<<"];
        [tokenizer.symbolState add:@">>"];
        [tokenizer.symbolState add:@">>>"];
        [tokenizer.symbolState add:@"<<="];
        [tokenizer.symbolState add:@">>="];
        [tokenizer.symbolState add:@">>>="];
        [tokenizer.symbolState add:@"&="];
        [tokenizer.symbolState add:@"^="];
        [tokenizer.symbolState add:@"|="];
    }
    return self;
}


- (void)dealloc {    
    self.assignmentOperatorParser = nil;
    self.relationalOperatorParser = nil;
    self.equalityOperatorParser = nil;
    self.shiftOperatorParser = nil;
    self.incrementOperatorParser = nil;
    self.unaryOperatorParser = nil;
    self.multiplicativeOperatorParser = nil;
    self.programParser = nil;
    self.elementParser = nil;
    self.funcParser = nil;
    self.paramListOptParser = nil;
    self.paramListParser = nil;
    self.commaIdentifierParser = nil;
    self.compoundStmtParser = nil;
    self.stmtsParser = nil;
    self.stmtParser = nil;
    self.ifStmtParser = nil;
    self.ifElseStmtParser = nil;
    self.whileStmtParser = nil;
    self.forParenStmtParser = nil;
    self.forBeginStmtParser = nil;
    self.forInStmtParser = nil;
    self.breakStmtParser = nil;
    self.continueStmtParser = nil;
    self.withStmtParser = nil;
    self.returnStmtParser = nil;
    self.variablesOrExprStmtParser = nil;
    self.conditionParser = nil;
    self.forParenParser = nil;
    self.forBeginParser = nil;
    self.variablesOrExprParser = nil;
    self.varVariablesParser = nil;
    self.variablesParser = nil;
    self.commaVariableParser = nil;
    self.variableParser = nil;
    self.assignmentParser = nil;
    self.exprOptParser = nil;
    self.exprParser = nil;
    self.commaExprParser = nil;
    self.assignmentExprParser = nil;
    self.extraAssignmentParser = nil;
    self.conditionalExprParser = nil;
    self.ternaryExprParser = nil;
    self.orExprParser = nil;
    self.orAndExprParser = nil;
    self.andExprParser = nil;
    self.andAndExprParser = nil;
    self.bitwiseOrExprParser = nil;
    self.pipeBitwiseOrExprParser = nil;
    self.bitwiseXorExprParser = nil;
    self.caretBitwiseXorExprParser = nil;
    self.bitwiseAndExprParser = nil;
    self.ampBitwiseAndExpressionParser = nil;
    self.equalityExprParser = nil;
    self.equalityOpEqualityExprParser = nil;
    self.relationalExprParser = nil;
    self.relationalExprRHSParser = nil;
    self.shiftExprParser = nil;
    self.shiftOpShiftExprParser = nil;
    self.additiveExprParser = nil;
    self.plusOrMinusExprParser = nil;
    self.plusExprParser = nil;
    self.minusExprParser = nil;
    self.multiplicativeExprParser = nil;
    self.unaryExprParser = nil;
    self.unaryExpr1Parser = nil;
    self.unaryExpr2Parser = nil;
    self.unaryExpr3Parser = nil;
    self.unaryExpr4Parser = nil;
    self.unaryExpr5Parser = nil;
    self.unaryExpr6Parser = nil;
    self.constructorParser = nil;
    self.constructorCallParser = nil;
    self.parenArgListParenParser = nil;
    self.memberExprParser = nil;
    self.dotBracketOrParenExprParser = nil;
    self.dotMemberExprParser = nil;
    self.bracketMemberExprParser = nil;
    self.parenMemberExprParser = nil;
    self.argListOptParser = nil;
    self.argListParser = nil;
    self.commaAssignmentExprParser = nil;
    self.primaryExprParser = nil;
    self.parenExprParenParser = nil;

    self.identifierParser = nil;
    self.stringParser = nil;
    self.numberParser = nil;

    self.ifParser = nil;
    self.elseParser = nil;
    self.whileParser = nil;
    self.forParser = nil;
    self.inParser = nil;
    self.breakParser = nil;
    self.continueParser = nil;
    self.withParser = nil;
    self.returnParser = nil;
    self.varParser = nil;
    self.deleteParser = nil;
    self.newParser = nil;
    self.thisParser = nil;
    self.falseParser = nil;
    self.trueParser = nil;
    self.nullParser = nil;
    self.undefinedParser = nil;
    self.voidParser = nil;
    self.typeofParser = nil;
    self.instanceofParser = nil;
    self.functionParser = nil;
    
    self.orParser = nil;
    self.andParser = nil;
    self.neParser = nil;
    self.isNotParser = nil;
    self.eqParser = nil;
    self.isParser = nil;
    self.leParser = nil;
    self.geParser = nil;
    self.plusPlusParser = nil;
    self.minusMinusParser = nil;
    self.plusEqParser = nil;
    self.minusEqParser = nil;
    self.timesEqParser = nil;
    self.divEqParser = nil;
    self.modEqParser = nil;
    self.shiftLeftParser = nil;
    self.shiftRightParser = nil;
    self.shiftRightExtParser = nil;
    self.shiftLeftEqParser = nil;
    self.shiftRightEqParser = nil;
    self.shiftRightExtEqParser = nil;
    self.andEqParser = nil;
    self.xorEqParser = nil;
    self.orEqParser = nil;
    
    self.openCurlyParser = nil;
    self.closeCurlyParser = nil;
    self.openParenParser = nil;
    self.closeParenParser = nil;
    self.openBracketParser = nil;
    self.closeBracketParser = nil;
    self.commaParser = nil;
    self.dotParser = nil;
    self.semiParser = nil;
    self.colonParser = nil;
    self.equalsParser = nil;
    self.notParser = nil;
    self.ltParser = nil;
    self.gtParser = nil;
    self.ampParser = nil;
    self.pipeParser = nil;
    self.caretParser = nil;
    self.tildeParser = nil;
    self.questionParser = nil;
    self.plusParser = nil;
    self.minusParser = nil;
    self.timesParser = nil;
    self.divParser = nil;
    self.modParser = nil;

    [super dealloc];
}


- (TDAlternation *)zeroOrOne:(TDParser *)p {
    TDAlternation *a = [TDAlternation alternation];
    [a add:[TDEmpty empty]];
    [a add:p];
    return a;
}


- (TDAlternation *)oneOrMore:(TDParser *)p {
    TDAlternation *s = [TDSequence sequence];
    [s add:p];
    [s add:[TDRepetition repetitionWithSubparser:p]];
    return s;
}


//- (TDCollectionParser *)XXXParser {
//    if (!XXXParser) {
//        XXXParser = [TDSequence sequence];
//    }
//    return XXXParser;
//}




// assignmentOperator  = equals | plusEq | minusEq | timesEq | divEq | modEq | shiftLeftEq | shiftRightEq | shiftRightExtEq | andEq | xorEq | orEq;
- (TDCollectionParser *)assignmentOperatorParser {
    if (!assignmentOperatorParser) {
        assignmentOperatorParser = [TDAlternation alternation];
        [assignmentOperatorParser add:self.equalsParser];
        [assignmentOperatorParser add:self.plusEqParser];
        [assignmentOperatorParser add:self.minusEqParser];
        [assignmentOperatorParser add:self.timesEqParser];
        [assignmentOperatorParser add:self.divEqParser];
        [assignmentOperatorParser add:self.modEqParser];
        [assignmentOperatorParser add:self.shiftLeftEqParser];
        [assignmentOperatorParser add:self.shiftRightEqParser];
        [assignmentOperatorParser add:self.shiftRightExtEqParser];
        [assignmentOperatorParser add:self.andEqParser];
        [assignmentOperatorParser add:self.orEqParser];
        [assignmentOperatorParser add:self.xorEqParser];
    }
    return assignmentOperatorParser;
}


// relationalOperator  = lt | gt | ge | le | instanceof;
- (TDCollectionParser *)relationalOperatorParser {
    if (!relationalOperatorParser) {
        relationalOperatorParser = [TDAlternation alternation];
        [relationalOperatorParser add:self.ltParser];
        [relationalOperatorParser add:self.gtParser];
        [relationalOperatorParser add:self.geParser];
        [relationalOperatorParser add:self.leParser];
        [relationalOperatorParser add:self.instanceofParser];
    }
    return relationalOperatorParser;
}


// equalityOperator    = eq | ne | is | isnot;
- (TDCollectionParser *)equalityOperatorParser {
    if (!equalityOperatorParser) {
        equalityOperatorParser = [TDAlternation alternation];;
        [equalityOperatorParser add:self.eqParser];
        [equalityOperatorParser add:self.neParser];
        [equalityOperatorParser add:self.isParser];
        [equalityOperatorParser add:self.isNotParser];
    }
    return equalityOperatorParser;
}


//shiftOperator       = shiftLeft | shiftRight | shiftRightExt;
- (TDCollectionParser *)shiftOperatorParser {
    if (!shiftOperatorParser) {
        shiftOperatorParser = [TDAlternation alternation];
        [shiftOperatorParser add:self.shiftLeftParser];
        [shiftOperatorParser add:self.shiftRightParser];
        [shiftOperatorParser add:self.shiftRightExtParser];
    }
    return shiftOperatorParser;
}


//incrementOperator   = plusPlus | minusMinus;
- (TDCollectionParser *)incrementOperatorParser {
    if (!incrementOperatorParser) {
        incrementOperatorParser = [TDAlternation alternation];
        [incrementOperatorParser add:self.plusPlusParser];
        [incrementOperatorParser add:self.minusMinusParser];
    }
    return incrementOperatorParser;
}


//unaryOperator       = tilde | delete | typeof | void;
- (TDCollectionParser *)unaryOperatorParser {
    if (!unaryOperatorParser) {
        unaryOperatorParser = [TDAlternation alternation];
        [unaryOperatorParser add:self.tildeParser];
        [unaryOperatorParser add:self.deleteParser];
        [unaryOperatorParser add:self.typeofParser];
        [unaryOperatorParser add:self.voidParser];
    }
    return unaryOperatorParser;
}


// multiplicativeOperator = times | div | mod;
- (TDCollectionParser *)multiplicativeOperatorParser {
    if (!multiplicativeOperatorParser) {
        multiplicativeOperatorParser = [TDAlternation alternation];
        [multiplicativeOperatorParser add:self.timesParser];
        [multiplicativeOperatorParser add:self.divParser];
        [multiplicativeOperatorParser add:self.modParser];
    }
    return multiplicativeOperatorParser;
}




// Program:
//           empty
//           Element Program
//
//program             = element*;
- (TDCollectionParser *)programParser {
    if (!programParser) {
        programParser = [TDRepetition repetitionWithSubparser:self.elementParser];
    }
    return programParser;
}



//  Element:
//           function Identifier ( ParameterListOpt ) CompoundStatement
//           Statement
//
//element             = func | stmt;
- (TDCollectionParser *)elementParser {
    if (!elementParser) {
        elementParser = [TDAlternation alternation];
        [elementParser add:self.funcParser];
        [elementParser add:self.stmtParser];
    }
    return elementParser;
}


//func                = function identifier openParen paramListOpt closeParen compoundStmt;
- (TDCollectionParser *)funcParser {
    if (!funcParser) {
        funcParser = [TDSequence sequence];
        [funcParser add:self.functionParser];
        [funcParser add:self.identifierParser];
        [funcParser add:self.openParenParser];
        [funcParser add:self.paramListOptParser];
        [funcParser add:self.closeParenParser];
        [funcParser add:self.compoundStmtParser];
    }
    return funcParser;
}



//  ParameterListOpt:
//           empty
//           ParameterList
//
//paramListOpt        = Empty | paramList;
- (TDCollectionParser *)paramListOptParser {
    if (!paramListOptParser) {
        paramListOptParser = [TDAlternation alternation];
        [paramListOptParser add:[self zeroOrOne:self.paramListParser]];
    }
    return paramListOptParser;
}



//  ParameterList:
//           Identifier
//           Identifier , ParameterList
//
//paramList           = identifier commaIdentifier*;
- (TDCollectionParser *)paramListParser {
    if (!paramListParser) {
        paramListParser = [TDSequence sequence];
        [paramListParser add:self.identifierParser];
        [paramListParser add:[TDRepetition repetitionWithSubparser:self.commaIdentifierParser]];
    }
    return paramListParser;
}


//commaIdentifier     = comma identifier;
- (TDCollectionParser *)commaIdentifierParser {
    if (!commaIdentifierParser) {
        commaIdentifierParser = [TDSequence sequence];
        [commaIdentifierParser add:self.commaParser];
        [commaIdentifierParser add:self.identifierParser];
    }
    return commaIdentifierParser;
}



//  CompoundStatement:
//           { Statements }
//
//compoundStmt        = openCurly stmts closeCurly;
- (TDCollectionParser *)compoundStmtParser {
    if (!compoundStmtParser) {
        compoundStmtParser = [TDSequence sequence];
        [compoundStmtParser add:self.openCurlyParser];
        [compoundStmtParser add:self.stmtsParser];
        [compoundStmtParser add:self.closeCurlyParser];
    }
    return compoundStmtParser;
}


//  Statements:
//           empty
//           Statement Statements
//
//stmts               = stmt*;
- (TDCollectionParser *)stmtsParser {
    if (!stmtsParser) {
        stmtsParser = [TDRepetition repetitionWithSubparser:self.stmtParser];
    }
    return stmtsParser;
}


//  Statement:
//           ;
//           if Condition Statement
//           if Condition Statement else Statement
//           while Condition Statement
//           ForParen ; ExpressionOpt ; ExpressionOpt ) Statement
//           ForBegin ; ExpressionOpt ; ExpressionOpt ) Statement
//           ForBegin in Expression ) Statement
//           break ;
//           continue ;
//           with ( Expression ) Statement
//           return ExpressionOpt ;
//           CompoundStatement
//           VariablesOrExpression ;
//
//stmt                = semi | ifStmt | ifElseStmt | whileStmt | forParenStmt | forBeginStmt | forInStmt | breakStmt | continueStmt | withStmt | returnStmt | compoundStmt | variablesOrExprStmt;
- (TDCollectionParser *)stmtParser {
    if (!stmtParser) {
        stmtParser = [TDAlternation alternation];
        [stmtParser add:self.semiParser];
        [stmtParser add:self.ifStmtParser];
        [stmtParser add:self.ifElseStmtParser];
        [stmtParser add:self.whileStmtParser];
        [stmtParser add:self.forParenStmtParser];
        [stmtParser add:self.forBeginStmtParser];
        [stmtParser add:self.forInStmtParser];
        [stmtParser add:self.breakStmtParser];
        [stmtParser add:self.continueStmtParser];
        [stmtParser add:self.withStmtParser];
        [stmtParser add:self.returnStmtParser];
        [stmtParser add:self.compoundStmtParser];
        [stmtParser add:self.variablesOrExprStmtParser];        
    }
    return stmtParser;
}


//ifStmt              = if condition stmt;
- (TDCollectionParser *)ifStmtParser {
    if (!ifStmtParser) {
        ifStmtParser = [TDSequence sequence];
        [ifStmtParser add:self.ifParser];
        [ifStmtParser add:self.conditionParser];
        [ifStmtParser add:self.stmtParser];
    }
    return ifStmtParser;
}


//ifElseStmt          = if condition stmt else stmt;
- (TDCollectionParser *)ifElseStmtParser {
    if (!ifElseStmtParser) {
        ifElseStmtParser = [TDSequence sequence];
        [ifElseStmtParser add:self.ifParser];
        [ifElseStmtParser add:self.conditionParser];
        [ifElseStmtParser add:self.stmtParser];
        [ifElseStmtParser add:self.elseParser];
        [ifElseStmtParser add:self.stmtParser];
    }
    return ifElseStmtParser;
}


//whileStmt           = while condition stmt;
- (TDCollectionParser *)whileStmtParser {
    if (!whileStmtParser) {
        whileStmtParser = [TDSequence sequence];
        [whileStmtParser add:self.whileParser];
        [whileStmtParser add:self.conditionParser];
        [whileStmtParser add:self.stmtParser];
    }
    return whileStmtParser;
}


//forParenStmt        = forParen semi exprOpt semi exprOpt closeParen stmt;
- (TDCollectionParser *)forParenStmtParser {
    if (!forParenStmtParser) {
        forParenStmtParser = [TDSequence sequence];
        [forParenStmtParser add:self.forParenParser];
        [forParenStmtParser add:self.semiParser];
        [forParenStmtParser add:self.exprOptParser];
        [forParenStmtParser add:self.semiParser];
        [forParenStmtParser add:self.exprOptParser];
        [forParenStmtParser add:self.closeParenParser];
        [forParenStmtParser add:self.stmtParser];
    }
    return forParenStmtParser;
}


//forBeginStmt        = forBegin semi exprOpt semi exprOpt closeParen stmt;
- (TDCollectionParser *)forBeginStmtParser {
    if (!forBeginStmtParser) {
        forBeginStmtParser = [TDSequence sequence];
        [forBeginStmtParser add:self.forBeginParser];
        [forParenStmtParser add:self.semiParser];
        [forParenStmtParser add:self.exprOptParser];
        [forParenStmtParser add:self.semiParser];
        [forParenStmtParser add:self.exprOptParser];
        [forParenStmtParser add:self.closeParenParser];
        [forParenStmtParser add:self.stmtParser];
    }
    return forBeginStmtParser;
}


//forInStmt           = forBegin in expr closeParen stmt;
- (TDCollectionParser *)forInStmtParser {
    if (!forInStmtParser) {
        forInStmtParser = [TDSequence sequence];
        [forInStmtParser add:self.forBeginParser];
        [forInStmtParser add:self.inParser];
        [forInStmtParser add:self.exprParser];
        [forInStmtParser add:self.closeParenParser];
        [forInStmtParser add:self.stmtParser];
    }
    return forInStmtParser;
}


//breakStmt           = break semi;
- (TDCollectionParser *)breakStmtParser {
    if (!breakStmtParser) {
        breakStmtParser = [TDSequence sequence];
        [breakStmtParser add:self.breakParser];
        [breakStmtParser add:self.semiParser];
    }
    return breakStmtParser;
}


//continueStmt        = continue semi;
- (TDCollectionParser *)continueStmtParser {
    if (!continueStmtParser) {
        continueStmtParser = [TDSequence sequence];
        [continueStmtParser add:self.continueParser];
        [continueStmtParser add:self.semiParser];
    }
    return continueStmtParser;
}


//withStmt            = with openParen expr closeParen stmt;
- (TDCollectionParser *)withStmtParser {
    if (!withStmtParser) {
        withStmtParser = [TDSequence sequence];
        [withStmtParser add:self.withParser];
        [withStmtParser add:self.openParenParser];
        [withStmtParser add:self.exprParser];
        [withStmtParser add:self.closeParenParser];
        [withStmtParser add:self.stmtParser];
    }
    return withStmtParser;
}


//returnStmt          = return exprOpt semi;
- (TDCollectionParser *)returnStmtParser {
    if (!returnStmtParser) {
        returnStmtParser = [TDSequence sequence];
        [returnStmtParser add:self.returnParser];
        [returnStmtParser add:self.exprOptParser];
        [returnStmtParser add:self.semiParser];
    }
    return returnStmtParser;
}


//variablesOrExprStmt = variablesOrExpr semi;
- (TDCollectionParser *)variablesOrExprStmtParser {
    if (!variablesOrExprStmtParser) {
        variablesOrExprStmtParser = [TDSequence sequence];
        [variablesOrExprStmtParser add:self.variablesOrExprParser];
        [variablesOrExprStmtParser add:self.semiParser];
    }
    return variablesOrExprStmtParser;
}


//  Condition:
//           ( Expression )
//
//condition           = openParen expr closeParen;
- (TDCollectionParser *)conditionParser {
    if (!conditionParser) {
        conditionParser = [TDSequence sequence];
        [conditionParser add:self.openParenParser];
        [conditionParser add:self.exprParser];
        [conditionParser add:self.closeParenParser];
    }
    return conditionParser;
}



//  ForParen:
//           for (
//
//forParen            = for openParen;
- (TDCollectionParser *)forParenParser {
    if (!forParenParser) {
        forParenParser = [TDSequence sequence];
        [forParenParser add:self.forParser];
        [forParenParser add:self.openParenParser];
    }
    return forParenParser;
}



//  ForBegin:
//           ForParen VariablesOrExpression
//
//forBegin            = forParen variablesOrExpr;
- (TDCollectionParser *)forBeginParser {
    if (!forBeginParser) {
        forBeginParser = [TDSequence sequence];
        [forBeginParser add:self.forParenParser];
        [forBeginParser add:self.variablesOrExprParser];
    }
    return forBeginParser;
}



//  VariablesOrExpression:
//           var Variables
//           Expression
//
//variablesOrExpr     = varVariables | expr;
- (TDCollectionParser *)variablesOrExprParser {
    if (!variablesOrExprParser) {
        variablesOrExprParser = [TDAlternation alternation];
        [variablesOrExprParser add:self.varVariablesParser];
        [variablesOrExprParser add:self.exprParser];
    }
    return variablesOrExprParser;
}


//varVariables        = var variables;
- (TDCollectionParser *)varVariablesParser {
    if (!varVariablesParser) {
        varVariablesParser = [TDSequence sequence];
        [varVariablesParser add:self.varParser];
        [varVariablesParser add:self.variablesParser];
    }
    return varVariablesParser;
}



//  Variables:
//           Variable
//           Variable , Variables
//
//variables           = variable commaVariable*;
- (TDCollectionParser *)variablesParser {
    if (!variablesParser) {
        variablesParser = [TDSequence sequence];
        [variablesParser add:self.variableParser];
        [variablesParser add:[TDRepetition repetitionWithSubparser:self.commaVariableParser]];
    }
    return variablesParser;
}


//commaVariable       = comma variable;
- (TDCollectionParser *)commaVariableParser {
    if (!commaVariableParser) {
        commaVariableParser = [TDSequence sequence];
        [commaVariableParser add:self.commaParser];
        [commaVariableParser add:self.variableParser];
    }
    return commaVariableParser;
}


//  Variable:
//           Identifier
//           Identifier = AssignmentExpression
//
//variable            = identifier assignment?;
- (TDCollectionParser *)variableParser {
    if (!variableParser) {
        variableParser = [TDSequence sequence];
        [variableParser add:self.identifierParser];
        [variableParser add:[self zeroOrOne:self.assignmentParser]];
    }
    return variableParser;
}

//assignment          = equals assignmentExpr;
- (TDCollectionParser *)assignmentParser {
    if (!assignmentParser) {
        assignmentParser = [TDSequence sequence];
        [assignmentParser add:self.equalsParser];
        [assignmentParser add:self.assignmentExprParser];
    }
    return assignmentParser;
}


//  ExpressionOpt:
//           empty
//           Expression
//
//    exprOpt             = Empty | expr;
- (TDCollectionParser *)exprOptParser {
    if (!exprOptParser) {
        exprOptParser = [self zeroOrOne:self.exprParser];
    }
    return exprOptParser;
}



//  Expression:
//           AssignmentExpression
//           AssignmentExpression , Expression
//
//expr                = assignmentExpr commaExpr?;
- (TDCollectionParser *)exprParser {
    if (!exprParser) {
        exprParser = [TDSequence sequence];
        [exprParser add:self.assignmentExprParser];
        [exprParser add:[self zeroOrOne:self.commaExprParser]];
    }
    return exprParser;
}


//commaExpr           = comma expr;
- (TDCollectionParser *)commaExprParser {
    if (!commaExprParser) {
        commaExprParser = [TDSequence sequence];
        [commaExprParser add:self.commaParser];
        [commaExprParser add:self.exprParser];
    }
    return commaExprParser;
}


//  AssignmentExpression:
//           ConditionalExpression
//           ConditionalExpression AssignmentOperator AssignmentExpression
//
// assignmentExpr      = conditionalExpr extraAssignment?;
// extraAssignment     = assignmentOperator assignmentExpr;

- (TDCollectionParser *)assignmentExprParser {
    if (!assignmentExprParser) {
        assignmentExprParser = [TDSequence sequence];
    }
    return assignmentExprParser;
}


//  ConditionalExpression:
//           OrExpression
//           OrExpression ? AssignmentExpression : AssignmentExpression
//
//    conditionalExpr     = orExpr ternaryExpr?;
//    ternaryExpr         = question assignmentExpr colon assignmentExpr;



//  OrExpression:
//           AndExpression
//           AndExpression || OrExpression
//
//    orExpr              = andExpr orAndExpr*;
//    orAndExpr           = or andExpr;



//  AndExpression:
//           BitwiseOrExpression
//           BitwiseOrExpression && AndExpression
//
//    andExpr             = bitwiseOrExpr andAndExpr?;
//    andAndExpr          = and andExpr;



//  BitwiseOrExpression:
//           BitwiseXorExpression
//           BitwiseXorExpression | BitwiseOrExpression
//
//    bitwiseOrExpr       = bitwiseXorExpr pipeBitwiseOrExpr?;
//    pipeBitwiseOrExpr   = pipe bitwiseOrExpr;



//  BitwiseXorExpression:
//           BitwiseAndExpression
//           BitwiseAndExpression ^ BitwiseXorExpression
//
//    bitwiseXorExpr      = bitwiseAndExpr caretBitwiseXorExpr?;
//    caretBitwiseXorExpr = caret bitwiseXorExpr;



//  BitwiseAndExpression:
//           EqualityExpression
//           EqualityExpression & BitwiseAndExpression
//
//    bitwiseAndExpr      = equalityExpr ampBitwiseAndExpression?;
//    ampBitwiseAndExpression = amp bitwiseAndExpr;



//  EqualityExpression:
//           RelationalExpression
//           RelationalExpression EqualityualityOperator EqualityExpression
//
//    equalityExpr        = relationalExpr equalityOpEqualityExpr?;
//    equalityOpEqualityExpr = equalityOperator equalityExpr;



//  RelationalExpression:
//           ShiftExpression
//           RelationalExpression RelationalationalOperator ShiftExpression
//
//    relationalExpr      = shiftExpr | relationalExprRHS;
//    relationalExprRHS   = relationalExpr relationalOperator shiftExpr;



//  ShiftExpression:
//           AdditiveExpression
//           AdditiveExpression ShiftOperator ShiftExpression
//
//    shiftExpr           = additiveExpr shiftOpShiftExpr?;
//    shiftOpShiftExpr    = shiftOperator shiftExpr;



//  AdditiveExpression:
//           MultiplicativeExpression
//           MultiplicativeExpression + AdditiveExpression
//           MultiplicativeExpression - AdditiveExpression
//
//    additiveExpr        = multiplicativeExpr plusOrMinusExpr?;
//    plusOrMinusExpr     = plusExpr | minusExpr;
//    plusExpr            = plus additiveExpr;
//    minusExpr           = minus additiveExpr;


//  MultiplicativeExpression:
//           UnaryExpression
//           UnaryExpression MultiplicativeOperator MultiplicativeExpression
//
//    multiplicativeExpr  = unaryExpr (multiplicativeOperator multiplicativeExpr)?;



//  UnaryExpression:
//           MemberExpression
//           UnaryOperator UnaryExpression
//           - UnaryExpression
//           IncrementOperator MemberExpression
//           MemberExpression IncrementOperator
//           new Constructor
//           delete MemberExpression
//
//    unaryExpr           = memberExpr | unaryExpr1 | unaryExpr2 | unaryExpr3 | unaryExpr4 | unaryExpr5 | unaryExpr6;
//    unaryExpr1          = unaryOperator unaryExpr;
//    unaryExpr2          = minus unaryExpr;
//    unaryExpr3          = incrementOperator memberExpr;
//    unaryExpr4          = memberExpr incrementOperator;
//    unaryExpr5          = new constructor;
//    unaryExpr6          = delete memberExpr;



//  Constructor:
//           this . ConstructorCall
//           ConstructorCall
//
//    constructor         = constructorCall; // TODO ???



//  ConstructorCall:
//           Identifier
//           Identifier ( ArgumentListOpt )
//           Identifier . ConstructorCall
//
//    constructorCall     = identifier parenArgListParen?;  // TODO
//    parenArgListParen   = openParen argListOpt closeParen;



//  MemberExpression:
//           PrimaryExpression
//           PrimaryExpression . MemberExpression
//           PrimaryExpression [ Expression ]
//           PrimaryExpression ( ArgumentListOpt )
//
//    memberExpr          = primaryExpr dotBracketOrParenExpr?;
//    dotBracketOrParenExpr = dotMemberExpr | bracketMemberExpr | parenMemberExpr;
//    dotMemberExpr       = dot memberExpr;
//    bracketMemberExpr   = openBracket expr closeBracket;
//    parenMemberExpr     = openParen argListOpt closeParen;



//  ArgumentListOpt:
//           empty
//           ArgumentList
//
// argListOpt          = argList?;
- (TDCollectionParser *)argListOptParser {
    if (!argListOptParser) {
        argListOptParser = [TDAlternation alternation];
        [argListOptParser add:[TDEmpty empty]];
        [argListOptParser add:self.argListParser];
    }
    return argListOptParser;
}


//  ArgumentList:
//           AssignmentExpression
//           AssignmentExpression , ArgumentList
//
// argList             = assignmentExpr commaAssignmentExpr*;
// commaAssignmentExpr = comma assignmentExpr;
- (TDCollectionParser *)argListParser {
    if (!argListParser) {
        argListParser = [TDSequence sequence];
        [argListParser add:self.assignmentExprParser];
        
        TDSequence *s = [TDSequence sequence];
        [s add:self.commaParser];
        [s add:self.assignmentExprParser];
        
        [argListParser add:[TDRepetition repetitionWithSubparser:s]];
    }
    return argListParser;
}


/*
 //  PrimaryExpression:
 //           ( Expression )
 //           Identifier
 //           IntegerLiteral
 //           FloatingPointLiteral
 //           StringLiteral
 //           false
 //           true
 //           null
 //           this
 
 primaryExpr         = parenExprParen | identifier | Num | QuotedString | false | true | null | undefined | this;
 parenExprParen      = openParen expr closeParen;
 identifier          = Word;
 */
- (TDCollectionParser *)primaryExprParser {
    if (!primaryExprParser) {
        primaryExprParser = [TDAlternation alternation];
        
        TDSequence *s = [TDSequence sequence];
        [s add:[TDLiteral literalWithString:@"("]];
        [s add:self.exprParser];
        [s add:[TDLiteral literalWithString:@")"]];
        [primaryExprParser add:s];
        
        [primaryExprParser add:self.identifierParser];
        [primaryExprParser add:self.numberParser];
        [primaryExprParser add:self.stringParser];
        [primaryExprParser add:self.trueParser];
        [primaryExprParser add:self.falseParser];
        [primaryExprParser add:self.nullParser];
        [primaryExprParser add:self.undefinedParser];
        [primaryExprParser add:self.thisParser];
    }
    return primaryExprParser;
}



- (TDParser *)identifierParser {
    if (!identifierParser) {
        identifierParser = [TDWord word];
    }
    return identifierParser;
}


- (TDParser *)stringParser {
    if (!stringParser) {
        stringParser = [TDQuotedString quotedString];
    }
    return stringParser;
}


- (TDParser *)numberParser {
    if (!numberParser) {
        numberParser = [TDNum num];
    }
    return numberParser;
}


#pragma mark -
#pragma mark keywords

- (TDParser *)ifParser {
    if (!ifParser) {
        ifParser = [TDLiteral literalWithString:@"if"];
    }
    return ifParser;
}


- (TDParser *)elseParser {
    if (!elseParser) {
        elseParser = [TDLiteral literalWithString:@"else"];
    }
    return elseParser;
}


- (TDParser *)whileParser {
    if (!whileParser) {
        whileParser = [TDLiteral literalWithString:@"while"];
    }
    return whileParser;
}


- (TDParser *)forParser {
    if (!forParser) {
        forParser = [TDLiteral literalWithString:@"for"];
    }
    return forParser;
}


- (TDParser *)inParser {
    if (!inParser) {
        inParser = [TDLiteral literalWithString:@"in"];
    }
    return inParser;
}


- (TDParser *)breakParser {
    if (!breakParser) {
        breakParser = [TDLiteral literalWithString:@"break"];
    }
    return breakParser;
}


- (TDParser *)continueParser {
    if (!continueParser) {
        continueParser = [TDLiteral literalWithString:@"continue"];
    }
    return continueParser;
}


- (TDParser *)withParser {
    if (!withParser) {
        withParser = [TDLiteral literalWithString:@"with"];
    }
    return withParser;
}


- (TDParser *)returnParser {
    if (!returnParser) {
        returnParser = [TDLiteral literalWithString:@"return"];
    }
    return returnParser;
}


- (TDParser *)varParser {
    if (!varParser) {
        varParser = [TDLiteral literalWithString:@"var"];
    }
    return varParser;
}


- (TDParser *)deleteParser {
    if (!deleteParser) {
        deleteParser = [TDLiteral literalWithString:@"delete"];
    }
    return deleteParser;
}


- (TDParser *)newParser {
    if (!newParser) {
        newParser = [TDLiteral literalWithString:@"new"];
    }
    return newParser;
}


- (TDParser *)thisParser {
    if (!thisParser) {
        thisParser = [TDLiteral literalWithString:@"this"];
    }
    return thisParser;
}


- (TDParser *)falseParser {
    if (!falseParser) {
        falseParser = [TDLiteral literalWithString:@"false"];
    }
    return falseParser;
}


- (TDParser *)trueParser {
    if (!trueParser) {
        trueParser = [TDLiteral literalWithString:@"true"];
    }
    return trueParser;
}


- (TDParser *)nullParser {
    if (!nullParser) {
        nullParser = [TDLiteral literalWithString:@"null"];
    }
    return nullParser;
}


- (TDParser *)undefinedParser {
    if (!undefinedParser) {
        undefinedParser = [TDLiteral literalWithString:@"undefined"];
    }
    return undefinedParser;
}


- (TDParser *)voidParser {
    if (!voidParser) {
        voidParser = [TDLiteral literalWithString:@"void"];
    }
    return voidParser;
}


- (TDParser *)typeofParser {
    if (!typeofParser) {
        typeofParser = [TDLiteral literalWithString:@"typeof"];
    }
    return typeofParser;
}


- (TDParser *)instanceofParser {
    if (!instanceofParser) {
        instanceofParser = [TDLiteral literalWithString:@"instanceof"];
    }
    return instanceofParser;
}


- (TDParser *)functionParser {
    if (!functionParser) {
        functionParser = [TDLiteral literalWithString:@"function"];
    }
    return functionParser;
}


#pragma mark -
#pragma mark single-char symbols

- (TDParser *)orParser {
    if (!orParser) {
        orParser = [TDSymbol symbolWithString:@"||"];
    }
    return orParser;
}


- (TDParser *)andParser {
    if (!andParser) {
        andParser = [TDSymbol symbolWithString:@"&&"];
    }
    return andParser;
}


- (TDParser *)neParser {
    if (!neParser) {
        neParser = [TDSymbol symbolWithString:@"!="];
    }
    return neParser;
}


- (TDParser *)isNotParser {
    if (!isNotParser) {
        isNotParser = [TDSymbol symbolWithString:@"!=="];
    }
    return isNotParser;
}


- (TDParser *)eqParser {
    if (!eqParser) {
        eqParser = [TDSymbol symbolWithString:@"=="];
    }
    return eqParser;
}


- (TDParser *)isParser {
    if (!isParser) {
        isParser = [TDSymbol symbolWithString:@"==="];
    }
    return isParser;
}


- (TDParser *)leParser {
    if (!leParser) {
        leParser = [TDSymbol symbolWithString:@"<="];
    }
    return leParser;
}


- (TDParser *)geParser {
    if (!geParser) {
        geParser = [TDSymbol symbolWithString:@">="];
    }
    return geParser;
}


- (TDParser *)plusPlusParser {
    if (!plusPlusParser) {
        plusPlusParser = [TDSymbol symbolWithString:@"++"];
    }
    return plusPlusParser;
}


- (TDParser *)minusMinusParser {
    if (!minusMinusParser) {
        minusMinusParser = [TDSymbol symbolWithString:@"--"];
    }
    return minusMinusParser;
}


- (TDParser *)plusEqParser {
    if (!plusEqParser) {
        plusEqParser = [TDSymbol symbolWithString:@"+="];
    }
    return plusEqParser;
}


- (TDParser *)minusEqParser {
    if (!minusEqParser) {
        minusEqParser = [TDSymbol symbolWithString:@"-="];
    }
    return minusEqParser;
}


- (TDParser *)timesEqParser {
    if (!timesEqParser) {
        timesEqParser = [TDSymbol symbolWithString:@"*="];
    }
    return timesEqParser;
}


- (TDParser *)divEqParser {
    if (!divEqParser) {
        divEqParser = [TDSymbol symbolWithString:@"/="];
    }
    return divEqParser;
}


- (TDParser *)modEqParser {
    if (!modEqParser) {
        modEqParser = [TDSymbol symbolWithString:@"%="];
    }
    return modEqParser;
}


- (TDParser *)shiftLeftParser {
    if (!shiftLeftParser) {
        shiftLeftParser = [TDSymbol symbolWithString:@"<<"];
    }
    return shiftLeftParser;
}


- (TDParser *)shiftRightParser {
    if (!shiftRightParser) {
        shiftRightParser = [TDSymbol symbolWithString:@">>"];
    }
    return shiftRightParser;
}


- (TDParser *)shiftRightExtParser {
    if (!shiftRightExtParser) {
        shiftRightExtParser = [TDSymbol symbolWithString:@">>>"];
    }
    return shiftRightExtParser;
}


- (TDParser *)shiftLeftEqParser {
    if (!shiftLeftEqParser) {
        shiftLeftEqParser = [TDSymbol symbolWithString:@"<<="];
    }
    return shiftLeftEqParser;
}


- (TDParser *)shiftRightEqParser {
    if (!shiftRightEqParser) {
        shiftRightEqParser = [TDSymbol symbolWithString:@">>="];
    }
    return shiftRightEqParser;
}


- (TDParser *)shiftRightExtEqParser {
    if (!shiftRightExtEqParser) {
        shiftRightExtEqParser = [TDSymbol symbolWithString:@">>>="];
    }
    return shiftRightExtEqParser;
}


- (TDParser *)andEqParser {
    if (!andEqParser) {
        andEqParser = [TDSymbol symbolWithString:@"&="];
    }
    return andEqParser;
}


- (TDParser *)xorEqParser {
    if (!xorEqParser) {
        xorEqParser = [TDSymbol symbolWithString:@"^="];
    }
    return xorEqParser;
}


- (TDParser *)orEqParser {
    if (!orEqParser) {
        orEqParser = [TDSymbol symbolWithString:@"|="];
    }
    return orEqParser;
}


#pragma mark -
#pragma mark single-char symbols

- (TDParser *)openCurlyParser {
    if (!openCurlyParser) {
        openCurlyParser = [TDSymbol symbolWithString:@"{"];
    }
    return openCurlyParser;
}


- (TDParser *)closeCurlyParser {
    if (!closeCurlyParser) {
        closeCurlyParser = [TDSymbol symbolWithString:@"}"];
    }
    return closeCurlyParser;
}


- (TDParser *)openParenParser {
    if (!openParenParser) {
        openParenParser = [TDSymbol symbolWithString:@"("];
    }
    return openParenParser;
}


- (TDParser *)closeParenParser {
    if (!closeParenParser) {
        closeParenParser = [TDSymbol symbolWithString:@")"];
    }
    return closeParenParser;
}


- (TDParser *)openBracketParser {
    if (!openBracketParser) {
        openBracketParser = [TDSymbol symbolWithString:@"["];
    }
    return openBracketParser;
}


- (TDParser *)closeBracketParser {
    if (!closeBracketParser) {
        closeBracketParser = [TDSymbol symbolWithString:@"]"];
    }
    return closeBracketParser;
}


- (TDParser *)commaParser {
    if (!commaParser) {
        commaParser = [TDSymbol symbolWithString:@","];
    }
    return commaParser;
}


- (TDParser *)dotParser {
    if (!dotParser) {
        dotParser = [TDSymbol symbolWithString:@"."];
    }
    return dotParser;
}


- (TDParser *)semiParser {
    if (!semiParser) {
        semiParser = [TDSymbol symbolWithString:@";"];
    }
    return semiParser;
}


- (TDParser *)colonParser {
    if (!colonParser) {
        colonParser = [TDSymbol symbolWithString:@":"];
    }
    return colonParser;
}


- (TDParser *)equalsParser {
    if (!equalsParser) {
        equalsParser = [TDSymbol symbolWithString:@"="];
    }
    return equalsParser;
}


- (TDParser *)notParser {
    if (!notParser) {
        notParser = [TDSymbol symbolWithString:@"!"];
    }
    return notParser;
}


- (TDParser *)ltParser {
    if (!ltParser) {
        ltParser = [TDSymbol symbolWithString:@"<"];
    }
    return ltParser;
}


- (TDParser *)gtParser {
    if (!gtParser) {
        gtParser = [TDSymbol symbolWithString:@">"];
    }
    return gtParser;
}


- (TDParser *)ampParser {
    if (!ampParser) {
        ampParser = [TDSymbol symbolWithString:@"&"];
    }
    return ampParser;
}


- (TDParser *)pipeParser {
    if (!pipeParser) {
        pipeParser = [TDSymbol symbolWithString:@"|"];
    }
    return pipeParser;
}


- (TDParser *)caretParser {
    if (!caretParser) {
        caretParser = [TDSymbol symbolWithString:@"^"];
    }
    return caretParser;
}


- (TDParser *)tildeParser {
    if (!tildeParser) {
        tildeParser = [TDSymbol symbolWithString:@"~"];
    }
    return tildeParser;
}


- (TDParser *)questionParser {
    if (!questionParser) {
        questionParser = [TDSymbol symbolWithString:@"?"];
    }
    return questionParser;
}


- (TDParser *)plusParser {
    if (!plusParser) {
        plusParser = [TDSymbol symbolWithString:@"+"];
    }
    return plusParser;
}


- (TDParser *)minusParser {
    if (!minusParser) {
        minusParser = [TDSymbol symbolWithString:@"-"];
    }
    return minusParser;
}


- (TDParser *)timesParser {
    if (!timesParser) {
        timesParser = [TDSymbol symbolWithString:@"x"];
    }
    return timesParser;
}


- (TDParser *)divParser {
    if (!divParser) {
        divParser = [TDSymbol symbolWithString:@"/"];
    }
    return divParser;
}


- (TDParser *)modParser {
    if (!modParser) {
        modParser = [TDSymbol symbolWithString:@"%"];
    }
    return modParser;
}

@synthesize assignmentOperatorParser;
@synthesize relationalOperatorParser;
@synthesize equalityOperatorParser;
@synthesize shiftOperatorParser;
@synthesize incrementOperatorParser;
@synthesize unaryOperatorParser;
@synthesize multiplicativeOperatorParser;

@synthesize programParser;
@synthesize elementParser;
@synthesize funcParser;
@synthesize paramListOptParser;
@synthesize paramListParser;
@synthesize commaIdentifierParser;
@synthesize compoundStmtParser;
@synthesize stmtsParser;
@synthesize stmtParser;
@synthesize ifStmtParser;
@synthesize ifElseStmtParser;
@synthesize whileStmtParser;
@synthesize forParenStmtParser;
@synthesize forBeginStmtParser;
@synthesize forInStmtParser;
@synthesize breakStmtParser;
@synthesize continueStmtParser;
@synthesize withStmtParser;
@synthesize returnStmtParser;
@synthesize variablesOrExprStmtParser;
@synthesize conditionParser;
@synthesize forParenParser;
@synthesize forBeginParser;
@synthesize variablesOrExprParser;
@synthesize varVariablesParser;
@synthesize variablesParser;
@synthesize commaVariableParser;
@synthesize variableParser;
@synthesize assignmentParser;
@synthesize exprOptParser;
@synthesize exprParser;
@synthesize commaExprParser;
@synthesize assignmentExprParser;
@synthesize extraAssignmentParser;
@synthesize conditionalExprParser;
@synthesize ternaryExprParser;
@synthesize orExprParser;
@synthesize orAndExprParser;
@synthesize andExprParser;
@synthesize andAndExprParser;
@synthesize bitwiseOrExprParser;
@synthesize pipeBitwiseOrExprParser;
@synthesize bitwiseXorExprParser;
@synthesize caretBitwiseXorExprParser;
@synthesize bitwiseAndExprParser;
@synthesize ampBitwiseAndExpressionParser;
@synthesize equalityExprParser;
@synthesize equalityOpEqualityExprParser;
@synthesize relationalExprParser;
@synthesize relationalExprRHSParser;
@synthesize shiftExprParser;
@synthesize shiftOpShiftExprParser;
@synthesize additiveExprParser;
@synthesize plusOrMinusExprParser;
@synthesize plusExprParser;
@synthesize minusExprParser;
@synthesize multiplicativeExprParser;
@synthesize unaryExprParser;
@synthesize unaryExpr1Parser;
@synthesize unaryExpr2Parser;
@synthesize unaryExpr3Parser;
@synthesize unaryExpr4Parser;
@synthesize unaryExpr5Parser;
@synthesize unaryExpr6Parser;
@synthesize constructorParser;
@synthesize constructorCallParser;
@synthesize parenArgListParenParser;
@synthesize memberExprParser;
@synthesize dotBracketOrParenExprParser;
@synthesize dotMemberExprParser;
@synthesize bracketMemberExprParser;
@synthesize parenMemberExprParser;
@synthesize argListOptParser;
@synthesize argListParser;
@synthesize commaAssignmentExprParser;
@synthesize primaryExprParser;
@synthesize parenExprParenParser;

@synthesize identifierParser;
@synthesize stringParser;
@synthesize numberParser;

@synthesize ifParser;
@synthesize elseParser;
@synthesize whileParser;
@synthesize forParser;
@synthesize inParser;
@synthesize breakParser;
@synthesize continueParser;
@synthesize withParser;
@synthesize returnParser;
@synthesize varParser;
@synthesize deleteParser;
@synthesize newParser;
@synthesize thisParser;
@synthesize falseParser;
@synthesize trueParser;
@synthesize nullParser;
@synthesize undefinedParser;
@synthesize voidParser;
@synthesize typeofParser;
@synthesize instanceofParser;
@synthesize functionParser;
            
@synthesize orParser;
@synthesize andParser;
@synthesize neParser;
@synthesize isNotParser;
@synthesize eqParser;
@synthesize isParser;
@synthesize leParser;
@synthesize geParser;
@synthesize plusPlusParser;
@synthesize minusMinusParser;
@synthesize plusEqParser;
@synthesize minusEqParser;
@synthesize timesEqParser;
@synthesize divEqParser;
@synthesize modEqParser;
@synthesize shiftLeftParser;
@synthesize shiftRightParser;
@synthesize shiftRightExtParser;
@synthesize shiftLeftEqParser;
@synthesize shiftRightEqParser;
@synthesize shiftRightExtEqParser;
@synthesize andEqParser;
@synthesize xorEqParser;
@synthesize orEqParser;
            
@synthesize openCurlyParser;
@synthesize closeCurlyParser;
@synthesize openParenParser;
@synthesize closeParenParser;
@synthesize openBracketParser;
@synthesize closeBracketParser;
@synthesize commaParser;
@synthesize dotParser;
@synthesize semiParser;
@synthesize colonParser;
@synthesize equalsParser;
@synthesize notParser;
@synthesize ltParser;
@synthesize gtParser;
@synthesize ampParser;
@synthesize pipeParser;
@synthesize caretParser;
@synthesize tildeParser;
@synthesize questionParser;
@synthesize plusParser;
@synthesize minusParser;
@synthesize timesParser;
@synthesize divParser;
@synthesize modParser;
@end
