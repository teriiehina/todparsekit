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


// is a Program
@implementation TDJavaScriptParser

- (id)init {
    if (self = [super initWithSubparser:self.elementParser]) {
        self.tokenizer = [TDTokenizer tokenizer];
        
        tokenizer.numberState = [[[TDScientificNumberState alloc] init] autorelease];
        [tokenizer setTokenizerState:tokenizer.numberState from: '-' to: '-'];
        [tokenizer setTokenizerState:tokenizer.numberState from: '.' to: '.'];
        [tokenizer setTokenizerState:tokenizer.numberState from: '0' to: '9'];
        
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
    self.multiplicativeExprRHSParser = nil;
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
        self.assignmentOperatorParser = [TDAlternation alternation];
        assignmentOperatorParser.name = @"assignmentOperator";
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
        self.relationalOperatorParser = [TDAlternation alternation];
        relationalOperatorParser.name = @"relationalOperator";
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
        self.equalityOperatorParser = [TDAlternation alternation];;
        equalityOperatorParser.name = @"equalityOperator";
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
        self.shiftOperatorParser = [TDAlternation alternation];
        shiftOperatorParser.name = @"shiftOperator";
        [shiftOperatorParser add:self.shiftLeftParser];
        [shiftOperatorParser add:self.shiftRightParser];
        [shiftOperatorParser add:self.shiftRightExtParser];
    }
    return shiftOperatorParser;
}


//incrementOperator   = plusPlus | minusMinus;
- (TDCollectionParser *)incrementOperatorParser {
    if (!incrementOperatorParser) {
        self.incrementOperatorParser = [TDAlternation alternation];
        incrementOperatorParser.name = @"incrementOperator";
        [incrementOperatorParser add:self.plusPlusParser];
        [incrementOperatorParser add:self.minusMinusParser];
    }
    return incrementOperatorParser;
}


//unaryOperator       = tilde | delete | typeof | void;
- (TDCollectionParser *)unaryOperatorParser {
    if (!unaryOperatorParser) {
        self.unaryOperatorParser = [TDAlternation alternation];
        unaryOperatorParser.name = @"unaryOperator";
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
        self.multiplicativeOperatorParser = [TDAlternation alternation];
        multiplicativeOperatorParser.name = @"multiplicativeOperator";
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
        self.programParser = [TDRepetition repetitionWithSubparser:self.elementParser];
        programParser.name = @"program";
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
        self.elementParser = [TDAlternation alternation];
        elementParser.name = @"element";
        [elementParser add:self.funcParser];
        [elementParser add:self.stmtParser];
    }
    return elementParser;
}


//func                = function identifier openParen paramListOpt closeParen compoundStmt;
- (TDCollectionParser *)funcParser {
    if (!funcParser) {
        self.funcParser = [TDSequence sequence];
        funcParser.name = @"func";
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
        self.paramListOptParser = [TDAlternation alternation];
        paramListOptParser.name = @"paramListOpt";
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
        self.paramListParser = [TDSequence sequence];
        paramListParser.name = @"paramList";
        [paramListParser add:self.identifierParser];
        [paramListParser add:[TDRepetition repetitionWithSubparser:self.commaIdentifierParser]];
    }
    return paramListParser;
}


//commaIdentifier     = comma identifier;
- (TDCollectionParser *)commaIdentifierParser {
    if (!commaIdentifierParser) {
        self.commaIdentifierParser = [TDSequence sequence];
        commaIdentifierParser.name = @"commaIdentifier";
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
        self.compoundStmtParser = [TDSequence sequence];
        compoundStmtParser.name = @"compoundStmt";
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
        self.stmtsParser = [TDRepetition repetitionWithSubparser:self.stmtParser];
        stmtsParser.name = @"stmts";
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
        self.stmtParser = [TDAlternation alternation];
        stmtParser.name = @"stmt";
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
        self.ifStmtParser = [TDSequence sequence];
        ifStmtParser.name = @"ifStmt";
        [ifStmtParser add:self.ifParser];
        [ifStmtParser add:self.conditionParser];
        [ifStmtParser add:self.stmtParser];
    }
    return ifStmtParser;
}


//ifElseStmt          = if condition stmt else stmt;
- (TDCollectionParser *)ifElseStmtParser {
    if (!ifElseStmtParser) {
        self.ifElseStmtParser = [TDSequence sequence];
        ifElseStmtParser.name = @"ifElseStmt";
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
        self.whileStmtParser = [TDSequence sequence];
        whileStmtParser.name = @"whileStmt";
        [whileStmtParser add:self.whileParser];
        [whileStmtParser add:self.conditionParser];
        [whileStmtParser add:self.stmtParser];
    }
    return whileStmtParser;
}


//forParenStmt        = forParen semi exprOpt semi exprOpt closeParen stmt;
- (TDCollectionParser *)forParenStmtParser {
    if (!forParenStmtParser) {
        self.forParenStmtParser = [TDSequence sequence];
        forParenStmtParser.name = @"forParenStmt";
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
        self.forBeginStmtParser = [TDSequence sequence];
        forBeginStmtParser.name = @"forBeginStmt";
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
        self.forInStmtParser = [TDSequence sequence];
        forInStmtParser.name = @"forInStmt";
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
        self.breakStmtParser = [TDSequence sequence];
        breakStmtParser.name = @"breakStmt";
        [breakStmtParser add:self.breakParser];
        [breakStmtParser add:self.semiParser];
    }
    return breakStmtParser;
}


//continueStmt        = continue semi;
- (TDCollectionParser *)continueStmtParser {
    if (!continueStmtParser) {
        self.continueStmtParser = [TDSequence sequence];
        continueStmtParser.name = @"continueStmt";
        [continueStmtParser add:self.continueParser];
        [continueStmtParser add:self.semiParser];
    }
    return continueStmtParser;
}


//withStmt            = with openParen expr closeParen stmt;
- (TDCollectionParser *)withStmtParser {
    if (!withStmtParser) {
        self.withStmtParser = [TDSequence sequence];
        withStmtParser.name = @"withStmt";
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
        self.returnStmtParser = [TDSequence sequence];
        returnStmtParser.name = @"returnStmt";
        [returnStmtParser add:self.returnParser];
        [returnStmtParser add:self.exprOptParser];
        [returnStmtParser add:self.semiParser];
    }
    return returnStmtParser;
}


//variablesOrExprStmt = variablesOrExpr semi;
- (TDCollectionParser *)variablesOrExprStmtParser {
    if (!variablesOrExprStmtParser) {
        self.variablesOrExprStmtParser = [TDSequence sequence];
        variablesOrExprStmtParser.name = @"variablesOrExprStmt";
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
        self.conditionParser = [TDSequence sequence];
        conditionParser.name = @"condition";
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
        self.forParenParser = [TDSequence sequence];
        forParenParser.name = @"forParen";
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
        self.forBeginParser = [TDSequence sequence];
        forBeginParser.name = @"forBegin";
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
        self.variablesOrExprParser = [TDAlternation alternation];
        variablesOrExprParser.name = @"variablesOrExpr";
        [variablesOrExprParser add:self.varVariablesParser];
        [variablesOrExprParser add:self.exprParser];
    }
    return variablesOrExprParser;
}


//varVariables        = var variables;
- (TDCollectionParser *)varVariablesParser {
    if (!varVariablesParser) {
        self.varVariablesParser = [TDSequence sequence];
        varVariablesParser.name = @"varVariables";
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
        self.variablesParser = [TDSequence sequence];
        variablesParser.name = @"variables";
        [variablesParser add:self.variableParser];
        [variablesParser add:[TDRepetition repetitionWithSubparser:self.commaVariableParser]];
    }
    return variablesParser;
}


//commaVariable       = comma variable;
- (TDCollectionParser *)commaVariableParser {
    if (!commaVariableParser) {
        self.commaVariableParser = [TDSequence sequence];
        commaVariableParser.name = @"commaVariable";
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
        self.variableParser = [TDSequence sequence];
        variableParser.name = @"variableParser";
        [variableParser add:self.identifierParser];
        [variableParser add:[self zeroOrOne:self.assignmentParser]];
    }
    return variableParser;
}

//assignment          = equals assignmentExpr;
- (TDCollectionParser *)assignmentParser {
    if (!assignmentParser) {
        self.assignmentParser = [TDSequence sequence];
        assignmentParser.name = @"assignment";
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
        self.exprOptParser = [self zeroOrOne:self.exprParser];
        exprOptParser.name = @"exprOpt";
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
        self.exprParser = [TDSequence sequence];
        exprParser.name = @"exprParser";
        [exprParser add:self.assignmentExprParser];
        [exprParser add:[self zeroOrOne:self.commaExprParser]];
    }
    return exprParser;
}


//commaExpr           = comma expr;
- (TDCollectionParser *)commaExprParser {
    if (!commaExprParser) {
        self.commaExprParser = [TDSequence sequence];
        commaExprParser.name = @"commaExpr";
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
- (TDCollectionParser *)assignmentExprParser {
    if (!assignmentExprParser) {
        self.assignmentExprParser = [TDSequence sequence];
        assignmentExprParser.name = @"assignmentExpr";
        [assignmentExprParser add:self.conditionalExprParser];
        [assignmentExprParser add:[self zeroOrOne:self.extraAssignmentParser]];
    }
    return assignmentExprParser;
}


// extraAssignment     = assignmentOperator assignmentExpr;
- (TDCollectionParser *)extraAssignmentParser {
    if (!extraAssignmentParser) {
        self.extraAssignmentParser = [TDSequence sequence];
        extraAssignmentParser.name = @"extraAssignment";
        [extraAssignmentParser add:self.assignmentOperatorParser];
        [extraAssignmentParser add:self.assignmentExprParser];
    }
    return extraAssignmentParser;
}


//  ConditionalExpression:
//           OrExpression
//           OrExpression ? AssignmentExpression : AssignmentExpression
//
//    conditionalExpr     = orExpr ternaryExpr?;
- (TDCollectionParser *)conditionalExprParser {
    if (!conditionalExprParser) {
        self.conditionalExprParser = [TDSequence sequence];
        conditionalExprParser.name = @"conditionalExpr";
        [conditionalExprParser add:self.orExprParser];
        [conditionalExprParser add:[self zeroOrOne:self.ternaryExprParser]];
    }
    return conditionalExprParser;
}


//    ternaryExpr         = question assignmentExpr colon assignmentExpr;
- (TDCollectionParser *)ternaryExprParser {
    if (!ternaryExprParser) {
        self.ternaryExprParser = [TDSequence sequence];
        ternaryExprParser.name = @"ternaryExpr";
        [ternaryExprParser add:self.questionParser];
        [ternaryExprParser add:self.assignmentExprParser];
        [ternaryExprParser add:self.colonParser];
        [ternaryExprParser add:self.assignmentExprParser];
    }
    return ternaryExprParser;
}


//  OrExpression:
//           AndExpression
//           AndExpression || OrExpression
//
//    orExpr              = andExpr orAndExpr*;
- (TDCollectionParser *)orExprParser {
    if (!orExprParser) {
        self.orExprParser = [TDSequence sequence];
        orExprParser.name = @"orExpr";
        [orExprParser add:self.andExprParser];
        [orExprParser add:[TDRepetition repetitionWithSubparser:self.orAndExprParser]];
    }
    return orExprParser;
}


//    orAndExpr           = or andExpr;
- (TDCollectionParser *)orAndExprParser {
    if (!orAndExprParser) {
        self.orAndExprParser = [TDSequence sequence];
        orAndExprParser.name = @"orAndExpr";
        [orAndExprParser add:self.orParser];
        [orAndExprParser add:self.andExprParser];
    }
    return orAndExprParser;
}


//  AndExpression:
//           BitwiseOrExpression
//           BitwiseOrExpression && AndExpression
//
//    andExpr             = bitwiseOrExpr andAndExpr?;
- (TDCollectionParser *)andExprParser {
    if (!andExprParser) {
        self.andExprParser = [TDSequence sequence];
        andExprParser.name = @"andExpr";
        [andExprParser add:self.bitwiseOrExprParser];
        [andExprParser add:[self zeroOrOne:self.andAndExprParser]];
    }
    return andExprParser;
}


//    andAndExpr          = and andExpr;
- (TDCollectionParser *)andAndExprParser {
    if (!andAndExprParser) {
        self.andAndExprParser = [TDSequence sequence];
        andAndExprParser.name = @"andAndExpr";
        [andAndExprParser add:self.andParser];
        [andAndExprParser add:self.andExprParser];
    }
    return andAndExprParser;
}


//  BitwiseOrExpression:
//           BitwiseXorExpression
//           BitwiseXorExpression | BitwiseOrExpression
//
//    bitwiseOrExpr       = bitwiseXorExpr pipeBitwiseOrExpr?;
- (TDCollectionParser *)bitwiseOrExprParser {
    if (!bitwiseOrExprParser) {
        self.bitwiseOrExprParser = [TDSequence sequence];
        bitwiseOrExprParser.name = @"bitwiseOrExpr";
        [bitwiseOrExprParser add:self.bitwiseXorExprParser];
        [bitwiseOrExprParser add:[self zeroOrOne:self.pipeBitwiseOrExprParser]];
    }
    return bitwiseOrExprParser;
}


//    pipeBitwiseOrExpr   = pipe bitwiseOrExpr;
- (TDCollectionParser *)pipeBitwiseOrExprParser {
    if (!pipeBitwiseOrExprParser) {
        self.pipeBitwiseOrExprParser = [TDSequence sequence];
        pipeBitwiseOrExprParser.name = @"pipeBitwiseOrExpr";
        [pipeBitwiseOrExprParser add:self.pipeParser];
        [pipeBitwiseOrExprParser add:self.bitwiseOrExprParser];
    }
    return pipeBitwiseOrExprParser;
}


//  BitwiseXorExpression:
//           BitwiseAndExpression
//           BitwiseAndExpression ^ BitwiseXorExpression
//
//    bitwiseXorExpr      = bitwiseAndExpr caretBitwiseXorExpr?;
- (TDCollectionParser *)bitwiseXorExprParser {
    if (!bitwiseXorExprParser) {
        self.bitwiseXorExprParser = [TDSequence sequence];
        bitwiseXorExprParser.name = @"bitwiseXorExpr";
        [bitwiseXorExprParser add:self.bitwiseAndExprParser];
        [bitwiseXorExprParser add:[self zeroOrOne:self.caretBitwiseXorExprParser]];
    }
    return bitwiseXorExprParser;
}


//    caretBitwiseXorExpr = caret bitwiseXorExpr;
- (TDCollectionParser *)caretBitwiseXorExprParser {
    if (!caretBitwiseXorExprParser) {
        self.caretBitwiseXorExprParser = [TDSequence sequence];
        caretBitwiseXorExprParser.name = @"caretBitwiseXorExpr";
        [caretBitwiseXorExprParser add:self.caretParser];
        [caretBitwiseXorExprParser add:self.bitwiseXorExprParser];
    }
    return caretBitwiseXorExprParser;
}


//  BitwiseAndExpression:
//           EqualityExpression
//           EqualityExpression & BitwiseAndExpression
//
//    bitwiseAndExpr      = equalityExpr ampBitwiseAndExpression?;
- (TDCollectionParser *)bitwiseAndExprParser {
    if (!bitwiseAndExprParser) {
        self.bitwiseAndExprParser = [TDSequence sequence];
        bitwiseAndExprParser.name = @"bitwiseAndExpr";
        [bitwiseAndExprParser add:self.equalityExprParser];
        [bitwiseAndExprParser add:[self zeroOrOne:self.ampBitwiseAndExpressionParser]];
    }
    return bitwiseAndExprParser;
}


//    ampBitwiseAndExpression = amp bitwiseAndExpr;
- (TDCollectionParser *)ampBitwiseAndExpressionParser {
    if (!ampBitwiseAndExpressionParser) {
        self.ampBitwiseAndExpressionParser = [TDSequence sequence];
        ampBitwiseAndExpressionParser.name = @"ampBitwiseAndExpression";
        [ampBitwiseAndExpressionParser add:self.ampParser];
        [ampBitwiseAndExpressionParser add:self.bitwiseAndExprParser];
    }
    return ampBitwiseAndExpressionParser;
}


//  EqualityExpression:
//           RelationalExpression
//           RelationalExpression EqualityualityOperator EqualityExpression
//
//    equalityExpr        = relationalExpr equalityOpEqualityExpr?;
- (TDCollectionParser *)equalityExprParser {
    if (!equalityExprParser) {
        self.equalityExprParser = [TDSequence sequence];
        equalityExprParser.name = @"equalityExpr";
        [equalityExprParser add:self.relationalExprParser];
        [equalityExprParser add:[self zeroOrOne:self.equalityOpEqualityExprParser]];
    }
    return equalityExprParser;
}


//    equalityOpEqualityExpr = equalityOperator equalityExpr;
- (TDCollectionParser *)equalityOpEqualityExprParser {
    if (!equalityOpEqualityExprParser) {
        self.equalityOpEqualityExprParser = [TDSequence sequence];
        equalityOpEqualityExprParser.name = @"equalityOpEqualityExpr";
        [equalityOpEqualityExprParser add:equalityOperatorParser];
        [equalityOpEqualityExprParser add:equalityExprParser];
    }
    return equalityOpEqualityExprParser;
}


//  RelationalExpression:
//           ShiftExpression
//           RelationalExpression RelationalationalOperator ShiftExpression
//
//    relationalExpr      = shiftExpr | relationalExprRHS;
- (TDCollectionParser *)relationalExprParser {
    if (!relationalExprParser) {
        self.relationalExprParser = [TDAlternation alternation];
        relationalExprParser.name = @"relationalExpr";
        [relationalExprParser add:self.shiftExprParser];
        [relationalExprParser add:self.relationalExprRHSParser];
    }
    return relationalExprParser;
}


//    relationalExprRHS   = relationalExpr relationalOperator shiftExpr;
- (TDCollectionParser *)relationalExprRHSParser {
    if (!relationalExprRHSParser) {
        self.relationalExprRHSParser = [TDSequence sequence];
        relationalExprRHSParser.name = @"relationalExprRHS";
        [relationalExprRHSParser add:self.relationalExprParser];
        [relationalExprRHSParser add:self.relationalOperatorParser];
        [relationalExprRHSParser add:self.shiftExprParser];
    }
    return relationalExprRHSParser;
}


//  ShiftExpression:
//           AdditiveExpression
//           AdditiveExpression ShiftOperator ShiftExpression
//
//    shiftExpr           = additiveExpr shiftOpShiftExpr?;
- (TDCollectionParser *)shiftExprParser {
    if (!shiftExprParser) {
        self.shiftExprParser = [TDSequence sequence];
        shiftExprParser.name = @"shiftExpr";
        [shiftExprParser add:self.additiveExprParser];
        [shiftExprParser add:self.shiftOpShiftExprParser];
    }
    return shiftExprParser;
}


//    shiftOpShiftExpr    = shiftOperator shiftExpr;
- (TDCollectionParser *)shiftOpShiftExprParser {
    if (!shiftOpShiftExprParser) {
        self.shiftOpShiftExprParser = [TDSequence sequence];
        shiftOpShiftExprParser.name = @"shiftOpShiftExpr";
        [shiftOpShiftExprParser add:self.shiftOperatorParser];
        [shiftOpShiftExprParser add:self.shiftExprParser];
    }
    return shiftOpShiftExprParser;
}


//  AdditiveExpression:
//           MultiplicativeExpression
//           MultiplicativeExpression + AdditiveExpression
//           MultiplicativeExpression - AdditiveExpression
//
//    additiveExpr        = multiplicativeExpr plusOrMinusExpr?;
- (TDCollectionParser *)additiveExprParser {
    if (!additiveExprParser) {
        self.additiveExprParser = [TDSequence sequence];
        [additiveExprParser add:self.multiplicativeExprParser];
        [additiveExprParser add:[self zeroOrOne:self.plusOrMinusExprParser]];
    }
    return additiveExprParser;
}


//    plusOrMinusExpr     = plusExpr | minusExpr;
- (TDCollectionParser *)plusOrMinusExprParser {
    if (!plusOrMinusExprParser) {
        self.plusOrMinusExprParser = [TDAlternation alternation];
        [plusOrMinusExprParser add:self.plusExprParser];
        [plusOrMinusExprParser add:self.minusExprParser];
    }
    return plusOrMinusExprParser;
}


//    plusExpr            = plus additiveExpr;
- (TDCollectionParser *)plusExprParser {
    if (!plusExprParser) {
        self.plusExprParser = [TDSequence sequence];
        [plusExprParser add:self.plusParser];
        [plusExprParser add:self.additiveExprParser];
    }
    return plusExprParser;
}


//    minusExpr           = minus additiveExpr;
- (TDCollectionParser *)minusExprParser {
    if (!minusExprParser) {
        self.minusExprParser = [TDSequence sequence];
        [minusExprParser add:self.minusParser];
        [minusExprParser add:self.additiveExprParser];
    }
    return minusExprParser;
}


//  MultiplicativeExpression:
//           UnaryExpression
//           UnaryExpression MultiplicativeOperator MultiplicativeExpression
//
//    multiplicativeExpr  = unaryExpr multiplicativeExprRHS?;
- (TDCollectionParser *)multiplicativeExprParser {
    if (!multiplicativeExprParser) {
        self.multiplicativeExprParser = [TDSequence sequence];
        [multiplicativeExprParser add:self.unaryExprParser];
        [multiplicativeExprParser add:[self zeroOrOne:self.multiplicativeExprRHSParser]];
    }
    return multiplicativeExprParser;
}


// multiplicativeExprRHS = multiplicativeOperator multiplicativeExpr;
- (TDCollectionParser *)multiplicativeExprRHSParser {
    if (!multiplicativeExprRHSParser) {
        self.multiplicativeExprRHSParser = [TDSequence sequence];
        [multiplicativeExprRHSParser add:multiplicativeOperatorParser];
        [multiplicativeExprRHSParser add:multiplicativeExprParser];
    }
    return multiplicativeExprRHSParser;
}


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
- (TDCollectionParser *)unaryExprParser {
    if (!unaryExprParser) {
        self.unaryExprParser = [TDAlternation alternation];
        [unaryExprParser add:self.memberExprParser];
        [unaryExprParser add:self.unaryExpr1Parser];
        [unaryExprParser add:self.unaryExpr2Parser];
        [unaryExprParser add:self.unaryExpr3Parser];
        [unaryExprParser add:self.unaryExpr4Parser];
        [unaryExprParser add:self.unaryExpr5Parser];
        [unaryExprParser add:self.unaryExpr6Parser];
    }
    return unaryExprParser;
}


//    unaryExpr1          = unaryOperator unaryExpr;
- (TDCollectionParser *)unaryExpr1Parser {
    if (!unaryExpr1Parser) {
        self.unaryExpr1Parser = [TDSequence sequence];
        [unaryExpr1Parser add:self.unaryOperatorParser];
        [unaryExpr1Parser add:self.unaryExprParser];
    }
    return unaryExpr1Parser;
}


//    unaryExpr2          = minus unaryExpr;
- (TDCollectionParser *)unaryExpr2Parser {
    if (!unaryExpr2Parser) {
        self.unaryExpr2Parser = [TDSequence sequence];
        [unaryExpr1Parser add:self.minusParser];
        [unaryExpr1Parser add:self.unaryExprParser];
    }
    return unaryExpr2Parser;
}


//    unaryExpr3          = incrementOperator memberExpr;
- (TDCollectionParser *)unaryExpr3Parser {
    if (!unaryExpr3Parser) {
        self.unaryExpr3Parser = [TDSequence sequence];
        [unaryExpr3Parser add:self.incrementOperatorParser];
        [unaryExpr3Parser add:self.memberExprParser];
    }
    return unaryExpr3Parser;
}


//    unaryExpr4          = memberExpr incrementOperator;
- (TDCollectionParser *)unaryExpr4Parser {
    if (!unaryExpr4Parser) {
        self.unaryExpr4Parser = [TDSequence sequence];
        [unaryExpr4Parser add:self.memberExprParser];
        [unaryExpr4Parser add:self.incrementOperatorParser];
    }
    return unaryExpr4Parser;
}


//    unaryExpr5          = new constructor;
- (TDCollectionParser *)unaryExpr5Parser {
    if (!unaryExpr5Parser) {
        self.unaryExpr5Parser = [TDSequence sequence];
        [unaryExpr5Parser add:self.newParser];
        [unaryExpr5Parser add:self.constructorParser];
    }
    return unaryExpr5Parser;
}


//    unaryExpr6          = delete memberExpr;
- (TDCollectionParser *)unaryExpr6Parser {
    if (!unaryExpr6Parser) {
        self.unaryExpr6Parser = [TDSequence sequence];
        [unaryExpr6Parser add:self.deleteParser];
        [unaryExpr6Parser add:self.memberExprParser];
    }
    return unaryExpr6Parser;
}


//  Constructor:
//           this . ConstructorCall
//           ConstructorCall
//
//    constructor         = constructorCall; // TODO ???
- (TDCollectionParser *)constructorParser {
    if (!constructorParser) {
        self.constructorParser = [TDSequence sequence];
        [constructorParser add:self.constructorCallParser];
    }
    return constructorParser;
}


//  ConstructorCall:
//           Identifier
//           Identifier ( ArgumentListOpt )
//           Identifier . ConstructorCall
//
//    constructorCall     = identifier parenArgListParen?;  // TODO
- (TDCollectionParser *)constructorCallParser {
    if (!constructorCallParser) {
        self.constructorCallParser = [TDSequence sequence];
        [constructorCallParser add:self.identifierParser];
        [constructorCallParser add:[self zeroOrOne:self.parenArgListParenParser]];
    }
    return constructorCallParser;
}


//    parenArgListParen   = openParen argListOpt closeParen;
- (TDCollectionParser *)parenArgListParenParser {
    if (!parenArgListParenParser) {
        self.parenArgListParenParser = [TDSequence sequence];
        [parenArgListParenParser add:self.openParenParser];
        [parenArgListParenParser add:self.argListOptParser];
        [parenArgListParenParser add:self.closeParenParser];
    }
    return parenArgListParenParser;
}


//  MemberExpression:
//           PrimaryExpression
//           PrimaryExpression . MemberExpression
//           PrimaryExpression [ Expression ]
//           PrimaryExpression ( ArgumentListOpt )
//
//    memberExpr          = primaryExpr dotBracketOrParenExpr?;    // TODO ??????
- (TDCollectionParser *)memberExprParser {
    if (!memberExprParser) {
        self.memberExprParser = [TDSequence sequence];
        [memberExprParser add:self.primaryExprParser];
        [memberExprParser add:[self zeroOrOne:self.dotBracketOrParenExprParser]];
    }
    return memberExprParser;
}


//    dotBracketOrParenExpr = dotMemberExpr | bracketMemberExpr | parenMemberExpr;
- (TDCollectionParser *)dotBracketOrParenExprParser {
    if (!dotBracketOrParenExprParser) {
        self.dotBracketOrParenExprParser = [TDAlternation alternation];
        [dotBracketOrParenExprParser add:self.dotMemberExprParser];
        [dotBracketOrParenExprParser add:self.bracketMemberExprParser];
        [dotBracketOrParenExprParser add:self.parenMemberExprParser];
    }
    return dotBracketOrParenExprParser;
}


//    dotMemberExpr       = dot memberExpr;
- (TDCollectionParser *)dotMemberExprParser {
    if (!dotMemberExprParser) {
        self.dotMemberExprParser = [TDSequence sequence];
        [dotMemberExprParser add:self.dotParser];
        [dotMemberExprParser add:self.memberExprParser];
    }
    return dotMemberExprParser;
}


//    bracketMemberExpr   = openBracket expr closeBracket;
- (TDCollectionParser *)bracketMemberExprParser {
    if (!bracketMemberExprParser) {
        self.bracketMemberExprParser = [TDSequence sequence];
        [bracketMemberExprParser add:self.openBracketParser];
        [bracketMemberExprParser add:self.exprParser];
        [bracketMemberExprParser add:self.closeBracketParser];
    }
    return bracketMemberExprParser;
}


//    parenMemberExpr     = openParen argListOpt closeParen;
- (TDCollectionParser *)parenMemberExprParser {
    if (!parenMemberExprParser) {
        self.parenMemberExprParser = [TDSequence sequence];
        [parenMemberExprParser add:self.openParenParser];
        [parenMemberExprParser add:self.argListOptParser];
        [parenMemberExprParser add:self.closeParenParser];
    }
    return parenMemberExprParser;
}


//  ArgumentListOpt:
//           empty
//           ArgumentList
//
// argListOpt          = argList?;
- (TDCollectionParser *)argListOptParser {
    if (!argListOptParser) {
        self.argListOptParser = [TDAlternation alternation];
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
- (TDCollectionParser *)argListParser {
    if (!argListParser) {
        self.argListParser = [TDSequence sequence];
        [argListParser add:self.assignmentExprParser];
        [argListParser add:[TDRepetition repetitionWithSubparser:self.commaAssignmentExprParser]];
    }
    return argListParser;
}


// commaAssignmentExpr = comma assignmentExpr;
- (TDCollectionParser *)commaAssignmentExprParser {
    if (!commaAssignmentExprParser) {
        self.commaAssignmentExprParser = [TDSequence sequence];
        [commaAssignmentExprParser add:self.commaParser];
        [commaAssignmentExprParser add:self.assignmentExprParser];
    }
    return commaAssignmentExprParser;
}


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
// primaryExpr         = parenExprParen | identifier | Num | QuotedString | false | true | null | undefined | this;
- (TDCollectionParser *)primaryExprParser {
    if (!primaryExprParser) {
        self.primaryExprParser = [TDAlternation alternation];
        [primaryExprParser add:self.parenExprParenParser];
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

 
 
//  parenExprParen      = openParen expr closeParen;
- (TDCollectionParser *)parenExprParenParser {
    if (!parenExprParenParser) {
        self.parenExprParenParser = [TDSequence sequence];
        [parenExprParenParser add:self.openParenParser];
        [parenExprParenParser add:self.exprParser];
        [parenExprParenParser add:self.closeParenParser];
    }
    return parenExprParenParser;
}


//  identifier          = Word;
- (TDParser *)identifierParser {
    if (!identifierParser) {
        self.identifierParser = [TDWord word];
    }
    return identifierParser;
}


- (TDParser *)stringParser {
    if (!stringParser) {
        self.stringParser = [TDQuotedString quotedString];
    }
    return stringParser;
}


- (TDParser *)numberParser {
    if (!numberParser) {
        self.numberParser = [TDNum num];
    }
    return numberParser;
}


#pragma mark -
#pragma mark keywords

- (TDParser *)ifParser {
    if (!ifParser) {
        self.ifParser = [TDLiteral literalWithString:@"if"];
    }
    return ifParser;
}


- (TDParser *)elseParser {
    if (!elseParser) {
        self.elseParser = [TDLiteral literalWithString:@"else"];
    }
    return elseParser;
}


- (TDParser *)whileParser {
    if (!whileParser) {
        self.whileParser = [TDLiteral literalWithString:@"while"];
    }
    return whileParser;
}


- (TDParser *)forParser {
    if (!forParser) {
        self.forParser = [TDLiteral literalWithString:@"for"];
    }
    return forParser;
}


- (TDParser *)inParser {
    if (!inParser) {
        self.inParser = [TDLiteral literalWithString:@"in"];
    }
    return inParser;
}


- (TDParser *)breakParser {
    if (!breakParser) {
        self.breakParser = [TDLiteral literalWithString:@"break"];
    }
    return breakParser;
}


- (TDParser *)continueParser {
    if (!continueParser) {
        self.continueParser = [TDLiteral literalWithString:@"continue"];
    }
    return continueParser;
}


- (TDParser *)withParser {
    if (!withParser) {
        self.withParser = [TDLiteral literalWithString:@"with"];
    }
    return withParser;
}


- (TDParser *)returnParser {
    if (!returnParser) {
        self.returnParser = [TDLiteral literalWithString:@"return"];
    }
    return returnParser;
}


- (TDParser *)varParser {
    if (!varParser) {
        self.varParser = [TDLiteral literalWithString:@"var"];
    }
    return varParser;
}


- (TDParser *)deleteParser {
    if (!deleteParser) {
        self.deleteParser = [TDLiteral literalWithString:@"delete"];
    }
    return deleteParser;
}


- (TDParser *)newParser {
    if (!newParser) {
        self.newParser = [TDLiteral literalWithString:@"new"];
    }
    return newParser;
}


- (TDParser *)thisParser {
    if (!thisParser) {
        self.thisParser = [TDLiteral literalWithString:@"this"];
    }
    return thisParser;
}


- (TDParser *)falseParser {
    if (!falseParser) {
        self.falseParser = [TDLiteral literalWithString:@"false"];
    }
    return falseParser;
}


- (TDParser *)trueParser {
    if (!trueParser) {
        self.trueParser = [TDLiteral literalWithString:@"true"];
    }
    return trueParser;
}


- (TDParser *)nullParser {
    if (!nullParser) {
        self.nullParser = [TDLiteral literalWithString:@"null"];
    }
    return nullParser;
}


- (TDParser *)undefinedParser {
    if (!undefinedParser) {
        self.undefinedParser = [TDLiteral literalWithString:@"undefined"];
    }
    return undefinedParser;
}


- (TDParser *)voidParser {
    if (!voidParser) {
        self.voidParser = [TDLiteral literalWithString:@"void"];
    }
    return voidParser;
}


- (TDParser *)typeofParser {
    if (!typeofParser) {
        self.typeofParser = [TDLiteral literalWithString:@"typeof"];
    }
    return typeofParser;
}


- (TDParser *)instanceofParser {
    if (!instanceofParser) {
        self.instanceofParser = [TDLiteral literalWithString:@"instanceof"];
    }
    return instanceofParser;
}


- (TDParser *)functionParser {
    if (!functionParser) {
        self.functionParser = [TDLiteral literalWithString:@"function"];
    }
    return functionParser;
}


#pragma mark -
#pragma mark single-char symbols

- (TDParser *)orParser {
    if (!orParser) {
        self.orParser = [TDSymbol symbolWithString:@"||"];
    }
    return orParser;
}


- (TDParser *)andParser {
    if (!andParser) {
        self.andParser = [TDSymbol symbolWithString:@"&&"];
    }
    return andParser;
}


- (TDParser *)neParser {
    if (!neParser) {
        self.neParser = [TDSymbol symbolWithString:@"!="];
    }
    return neParser;
}


- (TDParser *)isNotParser {
    if (!isNotParser) {
        self.isNotParser = [TDSymbol symbolWithString:@"!=="];
    }
    return isNotParser;
}


- (TDParser *)eqParser {
    if (!eqParser) {
        self.eqParser = [TDSymbol symbolWithString:@"=="];
    }
    return eqParser;
}


- (TDParser *)isParser {
    if (!isParser) {
        self.isParser = [TDSymbol symbolWithString:@"==="];
    }
    return isParser;
}


- (TDParser *)leParser {
    if (!leParser) {
        self.leParser = [TDSymbol symbolWithString:@"<="];
    }
    return leParser;
}


- (TDParser *)geParser {
    if (!geParser) {
        self.geParser = [TDSymbol symbolWithString:@">="];
    }
    return geParser;
}


- (TDParser *)plusPlusParser {
    if (!plusPlusParser) {
        self.plusPlusParser = [TDSymbol symbolWithString:@"++"];
    }
    return plusPlusParser;
}


- (TDParser *)minusMinusParser {
    if (!minusMinusParser) {
        self.minusMinusParser = [TDSymbol symbolWithString:@"--"];
    }
    return minusMinusParser;
}


- (TDParser *)plusEqParser {
    if (!plusEqParser) {
        self.plusEqParser = [TDSymbol symbolWithString:@"+="];
    }
    return plusEqParser;
}


- (TDParser *)minusEqParser {
    if (!minusEqParser) {
        self.minusEqParser = [TDSymbol symbolWithString:@"-="];
    }
    return minusEqParser;
}


- (TDParser *)timesEqParser {
    if (!timesEqParser) {
        self.timesEqParser = [TDSymbol symbolWithString:@"*="];
    }
    return timesEqParser;
}


- (TDParser *)divEqParser {
    if (!divEqParser) {
        self.divEqParser = [TDSymbol symbolWithString:@"/="];
    }
    return divEqParser;
}


- (TDParser *)modEqParser {
    if (!modEqParser) {
        self.modEqParser = [TDSymbol symbolWithString:@"%="];
    }
    return modEqParser;
}


- (TDParser *)shiftLeftParser {
    if (!shiftLeftParser) {
        self.shiftLeftParser = [TDSymbol symbolWithString:@"<<"];
    }
    return shiftLeftParser;
}


- (TDParser *)shiftRightParser {
    if (!shiftRightParser) {
        self.shiftRightParser = [TDSymbol symbolWithString:@">>"];
    }
    return shiftRightParser;
}


- (TDParser *)shiftRightExtParser {
    if (!shiftRightExtParser) {
        self.shiftRightExtParser = [TDSymbol symbolWithString:@">>>"];
    }
    return shiftRightExtParser;
}


- (TDParser *)shiftLeftEqParser {
    if (!shiftLeftEqParser) {
        self.shiftLeftEqParser = [TDSymbol symbolWithString:@"<<="];
    }
    return shiftLeftEqParser;
}


- (TDParser *)shiftRightEqParser {
    if (!shiftRightEqParser) {
        self.shiftRightEqParser = [TDSymbol symbolWithString:@">>="];
    }
    return shiftRightEqParser;
}


- (TDParser *)shiftRightExtEqParser {
    if (!shiftRightExtEqParser) {
        self.shiftRightExtEqParser = [TDSymbol symbolWithString:@">>>="];
    }
    return shiftRightExtEqParser;
}


- (TDParser *)andEqParser {
    if (!andEqParser) {
        self.andEqParser = [TDSymbol symbolWithString:@"&="];
    }
    return andEqParser;
}


- (TDParser *)xorEqParser {
    if (!xorEqParser) {
        self.xorEqParser = [TDSymbol symbolWithString:@"^="];
    }
    return xorEqParser;
}


- (TDParser *)orEqParser {
    if (!orEqParser) {
        self.orEqParser = [TDSymbol symbolWithString:@"|="];
    }
    return orEqParser;
}


#pragma mark -
#pragma mark single-char symbols

- (TDParser *)openCurlyParser {
    if (!openCurlyParser) {
        self.openCurlyParser = [TDSymbol symbolWithString:@"{"];
    }
    return openCurlyParser;
}


- (TDParser *)closeCurlyParser {
    if (!closeCurlyParser) {
        self.closeCurlyParser = [TDSymbol symbolWithString:@"}"];
    }
    return closeCurlyParser;
}


- (TDParser *)openParenParser {
    if (!openParenParser) {
        self.openParenParser = [TDSymbol symbolWithString:@"("];
    }
    return openParenParser;
}


- (TDParser *)closeParenParser {
    if (!closeParenParser) {
        self.closeParenParser = [TDSymbol symbolWithString:@")"];
    }
    return closeParenParser;
}


- (TDParser *)openBracketParser {
    if (!openBracketParser) {
        self.openBracketParser = [TDSymbol symbolWithString:@"["];
    }
    return openBracketParser;
}


- (TDParser *)closeBracketParser {
    if (!closeBracketParser) {
        self.closeBracketParser = [TDSymbol symbolWithString:@"]"];
    }
    return closeBracketParser;
}


- (TDParser *)commaParser {
    if (!commaParser) {
        self.commaParser = [TDSymbol symbolWithString:@","];
    }
    return commaParser;
}


- (TDParser *)dotParser {
    if (!dotParser) {
        self.dotParser = [TDSymbol symbolWithString:@"."];
    }
    return dotParser;
}


- (TDParser *)semiParser {
    if (!semiParser) {
        self.semiParser = [TDSymbol symbolWithString:@";"];
    }
    return semiParser;
}


- (TDParser *)colonParser {
    if (!colonParser) {
        self.colonParser = [TDSymbol symbolWithString:@":"];
    }
    return colonParser;
}


- (TDParser *)equalsParser {
    if (!equalsParser) {
        self.equalsParser = [TDSymbol symbolWithString:@"="];
    }
    return equalsParser;
}


- (TDParser *)notParser {
    if (!notParser) {
        self.notParser = [TDSymbol symbolWithString:@"!"];
    }
    return notParser;
}


- (TDParser *)ltParser {
    if (!ltParser) {
        self.ltParser = [TDSymbol symbolWithString:@"<"];
    }
    return ltParser;
}


- (TDParser *)gtParser {
    if (!gtParser) {
        self.gtParser = [TDSymbol symbolWithString:@">"];
    }
    return gtParser;
}


- (TDParser *)ampParser {
    if (!ampParser) {
        self.ampParser = [TDSymbol symbolWithString:@"&"];
    }
    return ampParser;
}


- (TDParser *)pipeParser {
    if (!pipeParser) {
        self.pipeParser = [TDSymbol symbolWithString:@"|"];
    }
    return pipeParser;
}


- (TDParser *)caretParser {
    if (!caretParser) {
        self.caretParser = [TDSymbol symbolWithString:@"^"];
    }
    return caretParser;
}


- (TDParser *)tildeParser {
    if (!tildeParser) {
        self.tildeParser = [TDSymbol symbolWithString:@"~"];
    }
    return tildeParser;
}


- (TDParser *)questionParser {
    if (!questionParser) {
        self.questionParser = [TDSymbol symbolWithString:@"?"];
    }
    return questionParser;
}


- (TDParser *)plusParser {
    if (!plusParser) {
        self.plusParser = [TDSymbol symbolWithString:@"+"];
    }
    return plusParser;
}


- (TDParser *)minusParser {
    if (!minusParser) {
        self.minusParser = [TDSymbol symbolWithString:@"-"];
    }
    return minusParser;
}


- (TDParser *)timesParser {
    if (!timesParser) {
        self.timesParser = [TDSymbol symbolWithString:@"x"];
    }
    return timesParser;
}


- (TDParser *)divParser {
    if (!divParser) {
        self.divParser = [TDSymbol symbolWithString:@"/"];
    }
    return divParser;
}


- (TDParser *)modParser {
    if (!modParser) {
        self.modParser = [TDSymbol symbolWithString:@"%"];
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
@synthesize multiplicativeExprRHSParser;
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
