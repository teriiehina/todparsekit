//
//  TDRegularParser.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDRegularParser.h"

@interface TDRegularParser ()
- (void)workOnCharAssembly:(TDAssembly *)a;
- (void)workOnStarAssembly:(TDAssembly *)a;
//- (void)workOnAndAssembly:(TDAssembly *)a;
- (void)workOnOrAssembly:(TDAssembly *)a;
- (void)workOnExpressionAssembly:(TDAssembly *)a;
@end

@implementation TDRegularParser

- (id)init {
    self = [super init];
    if (self) {
        [self add:self.expressionParser];
    }
    return self;
}


- (void)dealloc {
    self.expressionParser = nil;
    self.termParser = nil;
    self.orTermParser = nil;
    self.factorParser = nil;
    self.nextFactorParser = nil;
    self.phraseParser = nil;
    self.phraseStarParser = nil;
    self.letterOrDigitParser = nil;
    [super dealloc];
}


+ (id)parserForLanguage:(NSString *)s {
    TDRegularParser *p = [TDRegularParser parser];
    TDAssembly *a = [TDCharacterAssembly assemblyWithString:s];
    a = [p completeMatchFor:a];
    return [a pop];
}


// expression        = term orTerm*
// term              = factor nextFactor*
// orTerm            = '|' term
// factor            = phrase | phraseStar
// nextFactor        = factor
// phrase            = letterOrDigit | '(' expression ')'
// phraseStar        = phrase '*'
// letterOrDigit     = Letter | Digit


// expression        = term orTerm*
- (TDCollectionParser *)expressionParser {
    if (!expressionParser) {
        self.expressionParser = [TDSequence sequence];
        expressionParser.name = @"expression";
        [expressionParser add:self.termParser];
        [expressionParser add:[TDRepetition repetitionWithSubparser:self.orTermParser]];
        [expressionParser setAssembler:self selector:@selector(workOnExpressionAssembly:)];
    }
    return expressionParser;
}


// term                = factor nextFactor*
- (TDCollectionParser *)termParser {
    if (!termParser) {
        self.termParser = [TDSequence sequence];
        termParser.name = @"term";
        [termParser add:self.factorParser];
        [termParser add:[TDRepetition repetitionWithSubparser:self.nextFactorParser]];
    }
    return termParser;
}


// orTerm            = '|' term
- (TDCollectionParser *)orTermParser {
    if (!orTermParser) {
        self.orTermParser = [TDSequence sequence];
        orTermParser.name = @"orTerm";
        [orTermParser add:[[TDSpecificChar specificCharWithChar:'|'] discard]];
        [orTermParser add:self.termParser];
        [orTermParser setAssembler:self selector:@selector(workOnOrAssembly:)];
    }
    return orTermParser;
}


// factor            = phrase | phraseStar
- (TDCollectionParser *)factorParser {
    if (!factorParser) {
        self.factorParser = [TDAlternation alternation];
        factorParser.name = @"factor";
        [factorParser add:self.phraseParser];
        [factorParser add:self.phraseStarParser];
    }
    return factorParser;
}


// nextFactor        = factor
- (TDCollectionParser *)nextFactorParser {
    if (!nextFactorParser) {
        self.nextFactorParser = [TDAlternation alternation];
        nextFactorParser.name = @"nextFactor";
        [nextFactorParser add:self.phraseParser];
        [nextFactorParser add:self.phraseStarParser];
//        [nextFactorParser setAssembler:self selector:@selector(workOnAndAssembly:)];
    }
    return nextFactorParser;
}


// phrase            = letterOrDigit | '(' expression ')'
- (TDCollectionParser *)phraseParser {
    if (!phraseParser) {
        TDSequence *s = [TDSequence sequence];
        [s add:[[TDSpecificChar specificCharWithChar:'('] discard]];
        [s add:self.expressionParser];
        [s add:[[TDSpecificChar specificCharWithChar:')'] discard]];

        self.phraseParser = [TDAlternation alternation];
        phraseParser.name = @"phrase";
        [phraseParser add:self.letterOrDigitParser];
        [phraseParser add:s];
    }
    return phraseParser;
}


// phraseStar        = phrase '*'
- (TDCollectionParser *)phraseStarParser {
    if (!phraseStarParser) {
        self.phraseStarParser = [TDSequence sequence];
        phraseStarParser.name = @"phraseStar";
        [phraseStarParser add:self.phraseParser];
        [phraseStarParser add:[[TDSpecificChar specificCharWithChar:'*'] discard]];
        [phraseStarParser setAssembler:self selector:@selector(workOnStarAssembly:)];
    }
    return phraseStarParser;
}


// letterOrDigit    = Letter | Digit
- (TDCollectionParser *)letterOrDigitParser {
    if (!letterOrDigitParser) {
        self.letterOrDigitParser = [TDAlternation alternation];
        letterOrDigitParser.name = @"letterOrDigit";
        [letterOrDigitParser add:[TDLetter letter]];
        [letterOrDigitParser add:[TDDigit digit]];
        [letterOrDigitParser setAssembler:self selector:@selector(workOnCharAssembly:)];
    }
    return letterOrDigitParser;
}


- (void)workOnCharAssembly:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    id obj = [a pop];
    NSAssert([obj isKindOfClass:[NSNumber class]], @"");
    NSInteger c = [obj integerValue];
    [a push:[TDSpecificChar specificCharWithChar:c]];
}


- (void)workOnStarAssembly:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    id top = [a pop];
    NSAssert([top isKindOfClass:[TDParser class]], @"");
    TDRepetition *p = [TDRepetition repetitionWithSubparser:top];
    [a push:p];
}


//- (void)workOnAndAssembly:(TDAssembly *)a {
////    NSLog(@"%s", _cmd);
////    NSLog(@"a: %@", a);
//    id second = [a pop];
//    id first = [a pop];
//    NSAssert([first isKindOfClass:[TDParser class]], @"");
//    NSAssert([second isKindOfClass:[TDParser class]], @"");
//    TDSequence *p = [TDSequence sequence];
//    [p add:first];
//    [p add:second];
//    [a push:p];
//}


- (void)workOnExpressionAssembly:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    
    id obj = nil;
    NSMutableArray *objs = [NSMutableArray array];
    while (![a isStackEmpty]) {
        obj = [a pop];
        if ([obj isKindOfClass:[TDSpecificChar class]]) {
            NSAssert([obj isKindOfClass:[TDSpecificChar class]], @"");
            [objs addObject:obj];
        } else {
            NSAssert([obj isKindOfClass:[TDParser class]], @"");
            [a push:obj];
            break;
        }
    }
    
    if (objs.count > 1) {
//        NSLog(@"making a sequence");
        TDSequence *seq = [TDSequence sequence];
        NSEnumerator *e = [objs reverseObjectEnumerator];
        while (obj = [e nextObject]) {
            [seq add:obj];
        }
        [a push:seq];
    } else if (objs.count) {
//        NSLog(@"NOT making a sequence");
        TDSpecificChar *c = [objs objectAtIndex:0];
        [a push:c];
    }
}


- (void)workOnOrAssembly:(TDAssembly *)a {
//    NSLog(@"%s", _cmd);
//    NSLog(@"a: %@", a);
    id second = [a pop];
    id first = [a pop];
//    NSLog(@"first: %@", first);
//    NSLog(@"second: %@", second);
    NSAssert(first, @"");
    NSAssert(second, @"");
    NSAssert([first isKindOfClass:[TDParser class]], @"");
    NSAssert([second isKindOfClass:[TDParser class]], @"");
    TDAlternation *p = [TDAlternation alternation];
    [p add:first];
    [p add:second];
    [a push:p];
}

@synthesize expressionParser;
@synthesize termParser;
@synthesize orTermParser;
@synthesize factorParser;
@synthesize nextFactorParser;
@synthesize phraseParser;
@synthesize phraseStarParser;
@synthesize letterOrDigitParser;
@end
