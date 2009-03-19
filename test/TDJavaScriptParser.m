//
//  TDJavaScriptParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 3/17/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDJavaScriptParser.h"

/*

assignmentOperator  = equals | plusEq | minusEq | timesEq | divEq | modEq | shiftLeftEq | shiftRightEq | shiftRightExtEq | andEq | xorEq | orEq;

relationalOperator  = lt | gt | ge | le | instanceof;
equalityOperator    = eq | ne | is | isnot;

shiftOperator       = shiftLeft | shiftRight | shiftRightExt;
incrementOperator   = plusPlus | minusMinus;
unaryOperator       = tilde | delete | typeof | void;

multiplicativeOperator = times | div | mod;



// Program:
//           empty
//           Element Program

program             = element+;



//  Element:
//           function Identifier ( ParameterListOpt ) CompoundStatement
//           Statement

element             = func | stmt;
func                = function identifier openParen paramListOpt closeParen compoundStmt;



//  ParameterListOpt:
//           empty
//           ParameterList

paramListOpt        = Empty | paramList;



//  ParameterList:
//           Identifier
//           Identifier , ParameterList

paramList           = identifier commaIdentifier*;
commaIdentifier     = comma identifier;



//  CompoundStatement:
//           { Statements }

compoundStmt        = openCurly stmts closeCurly;



//  Statements:
//           empty
//           Statement Statements

stmts               = stmt*;



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

stmt                = semi | ifStmt | ifElseStmt | whileStmt | forParenStmt | forBeginStmt | forInStmt | breakStmt | continueStmt | withStmt | returnStmt | compoundStmt | variablesOrExprStmt;
ifStmt              = if condition stmt;
ifElseStmt          = if condition stmt else stmt;
whileStmt           = while condition stmt;
forParenStmt        = forParen semi exprOpt semi exprOpt closeParen stmt;
forBeginStmt        = forBegin semi exprOpt semi exprOpt closeParen stmt;
forInStmt           = forBegin in expr closeParen stmt;
breakStmt           = break semi;
continueStmt        = continue semi;
withStmt            = with openParen expr closeParen stmt;
returnStmt          = return exprOpt semi;
variablesOrExprStmt = variablesOrExpr semi;



//  Condition:
//           ( Expression )

condition           = openParen expr closeParen;



//  ForParen:
//           for (

forParen            = for openParen;



//  ForBegin:
//           ForParen VariablesOrExpression

forBegin            = forParen variablesOrExpr;



//  VariablesOrExpression:
//           var Variables
//           Expression

variablesOrExpr     = varVariables | expr;
varVariables        = var variables;



//  Variables:
//           Variable
//           Variable , Variables

variables           = variable commaVariable*;
commaVariable       = comma variable;



//  Variable:
//           Identifier
//           Identifier = AssignmentExpression

variable            = identifier assignment?;
assignment          = equals assignmentExpr;



//  ExpressionOpt:
//           empty
//           Expression

exprOpt             = Empty | expr; // TODO -- Empty | expr;



//  Expression:
//           AssignmentExpression
//           AssignmentExpression , Expression

expr                = assignmentExpr commaExpr?;
commaExpr           = comma expr;



//  AssignmentExpression:
//           ConditionalExpression
//           ConditionalExpression AssignmentOperator AssignmentExpression

assignmentExpr      = conditionalExpr extraAssignment?;
extraAssignment     = assignmentOperator assignmentExpr;



//  ConditionalExpression:
//           OrExpression
//           OrExpression ? AssignmentExpression : AssignmentExpression

conditionalExpr     = orExpr ternaryExpr?;
ternaryExpr         = question assignmentExpr colon assignmentExpr;



//  OrExpression:
//           AndExpression
//           AndExpression || OrExpression

orExpr              = andExpr orAndExpr*;
orAndExpr           = or andExpr;



//  AndExpression:
//           BitwiseOrExpression
//           BitwiseOrExpression && AndExpression

andExpr             = bitwiseOrExpr andAndExpr?;
andAndExpr          = and andExpr;



//  BitwiseOrExpression:
//           BitwiseXorExpression
//           BitwiseXorExpression | BitwiseOrExpression

bitwiseOrExpr       = bitwiseXorExpr pipeBitwiseOrExpr?;
pipeBitwiseOrExpr   = pipe bitwiseOrExpr;



//  BitwiseXorExpression:
//           BitwiseAndExpression
//           BitwiseAndExpression ^ BitwiseXorExpression

bitwiseXorExpr      = bitwiseAndExpr caretBitwiseXorExpr?;
caretBitwiseXorExpr = caret bitwiseXorExpr;



//  BitwiseAndExpression:
//           EqualityExpression
//           EqualityExpression & BitwiseAndExpression

bitwiseAndExpr      = equalityExpr ampBitwiseAndExpression?;
ampBitwiseAndExpression = amp bitwiseAndExpr;



//  EqualityExpression:
//           RelationalExpression
//           RelationalExpression EqualityualityOperator EqualityExpression

equalityExpr        = relationalExpr equalityOpEqualityExpr?;
equalityOpEqualityExpr = equalityOperator equalityExpr;



//  RelationalExpression:
//           ShiftExpression
//           RelationalExpression RelationalationalOperator ShiftExpression

relationalExpr      = shiftExpr | relationalExprRHS;
relationalExprRHS   = relationalExpr relationalOperator shiftExpr;



//  ShiftExpression:
//           AdditiveExpression
//           AdditiveExpression ShiftOperator ShiftExpression

shiftExpr           = additiveExpr shiftOpShiftExpr?;
shiftOpShiftExpr    = shiftOperator shiftExpr;



//  AdditiveExpression:
//           MultiplicativeExpression
//           MultiplicativeExpression + AdditiveExpression
//           MultiplicativeExpression - AdditiveExpression

additiveExpr        = multiplicativeExpr plusOrMinusExpr?;
plusOrMinusExpr     = plusExpr | minusExpr;
plusExpr            = plus additiveExpr;
minusExpr           = minus additiveExpr;



//  MultiplicativeExpression:
//           UnaryExpression
//           UnaryExpression MultiplicativeOperator MultiplicativeExpression

multiplicativeExpr  = unaryExpr (multiplicativeOperator multiplicativeExpr)?;



//  UnaryExpression:
//           MemberExpression
//           UnaryOperator UnaryExpression
//           - UnaryExpression
//           IncrementOperator MemberExpression
//           MemberExpression IncrementOperator
//           new Constructor
//           delete MemberExpression

unaryExpr           = memberExpr | unaryExpr1 | unaryExpr2 | unaryExpr3 | unaryExpr4 | unaryExpr5 | unaryExpr6;
unaryExpr1          = unaryOperator unaryExpr;
unaryExpr2          = minus unaryExpr;
unaryExpr3          = incrementOperator memberExpr;
unaryExpr4          = memberExpr incrementOperator;
unaryExpr5          = new constructor;
unaryExpr6          = delete memberExpr;



//  Constructor:
//           this . ConstructorCall
//           ConstructorCall

constructor         = constructorCall; // TODO ???



//  ConstructorCall:
//           Identifier
//           Identifier ( ArgumentListOpt )
//           Identifier . ConstructorCall

constructorCall     = identifier parenArgListParen?;  // TODO
parenArgListParen   = openParen argListOpt closeParen;



//  MemberExpression:
//           PrimaryExpression
//           PrimaryExpression . MemberExpression
//           PrimaryExpression [ Expression ]
//           PrimaryExpression ( ArgumentListOpt )

memberExpr          = primaryExpr dotBracketOrParenExpr?;
dotBracketOrParenExpr = dotMemberExpr | bracketMemberExpr | parenMemberExpr;
dotMemberExpr       = dot memberExpr;
bracketMemberExpr   = openBracket expr closeBracket;
parenMemberExpr     = openParen argListOpt closeParen;



*/
 
@interface TDParser ()
- (void)setTokenizer:(TDTokenizer *)t;
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
    self.tokenizer = nil;
    
    self.primaryExprParser = nil;
    
    self.exprParser = nil;
    self.identifierParser = nil;
    self.assignmentExprParser = nil;
    self.assignmentParser = nil;

    self.argListOptParser = nil;
    self.argListParser = nil;
    
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
        [s add:self.assignmentParser];
        
        [argListParser add:[TDRepetition repetitionWithSubparser:s]];
    }
    return argListParser;
}


- (TDCollectionParser *)exprParser {
    if (!exprParser) {
        exprParser = [TDSequence sequence];
    }
    return exprParser;
}


- (TDCollectionParser *)identifierParser {
    if (!identifierParser) {
        identifierParser = [TDSequence sequence];
    }
    return identifierParser;
}


- (TDCollectionParser *)assignmentExprParser {
    if (!assignmentExprParser) {
        assignmentExprParser = [TDSequence sequence];
    }
    return assignmentExprParser;
}


- (TDCollectionParser *)assignmentParser {
    if (!assignmentParser) {
        assignmentParser = [TDSequence sequence];
    }
    return assignmentParser;
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

@synthesize primaryExprParser;
            
@synthesize exprParser;
@synthesize identifierParser;
@synthesize assignmentExprParser;
@synthesize assignmentParser;

@synthesize argListOptParser;
@synthesize argListParser;
            
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
