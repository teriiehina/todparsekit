//
//  TDSyntaxHighlighter.m
//  HTTPClient
//
//  Created by Todd Ditchendorf on 12/26/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDSyntaxHighlighter.h"
#import <TDParseKit/TDParseKit.h>
#import "TDGrammarParserFactory.h"
#import "TDMiniCSSAssembler.h"
#import "TDGenericAssembler.h"

@interface TDSyntaxHighlighter ()
- (NSMutableDictionary *)attributesForGrammarNamed:(NSString *)grammarName;
- (TDParser *)parserForGrammarNamed:(NSString *)grammarName getTokenizer:(TDTokenizer **)t;

// all of the ivars for these properties are lazy loaded in the getters.
// thats so that if an application has syntax highlighting turned off, this class will
// consume much less memory/fewer resources.
@property (nonatomic, retain) TDGrammarParserFactory *parserFactory;
@property (nonatomic, retain) TDParser *miniCSSParser;
@property (nonatomic, retain) TDMiniCSSAssembler *miniCSSAssembler;
@property (nonatomic, retain) TDGenericAssembler *genericAssembler;
@property (nonatomic, retain) NSMutableDictionary *parserCache;
@property (nonatomic, retain) NSMutableDictionary *tokenizerCache;
@end

@implementation TDSyntaxHighlighter

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    TDReleaseSubparserTree(miniCSSParser);
    for (TDParser *p in parserCache) {
        TDReleaseSubparserTree(p);
    }
    
    self.parserFactory = nil;
    self.miniCSSParser = nil;
    self.miniCSSAssembler = nil;
    self.genericAssembler = nil;
    self.parserCache = nil;
    self.tokenizerCache = nil;
    [super dealloc];
}


- (TDGrammarParserFactory *)parserFactory {
    if (!parserFactory) {
        self.parserFactory = [TDGrammarParserFactory factory];
    }
    return parserFactory;
}


- (TDMiniCSSAssembler *)miniCSSAssembler {
    if (!miniCSSAssembler) {
        self.miniCSSAssembler = [[[TDMiniCSSAssembler alloc] init] autorelease];
    }
    return miniCSSAssembler;
}


- (TDParser *)miniCSSParser {
    if (!miniCSSParser) {
        // create mini-css parser
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"mini_css" ofType:@"grammar"];
        NSString *grammarString = [NSString stringWithContentsOfFile:path];

        self.miniCSSParser = [self.parserFactory parserFromGrammar:grammarString assembler:self.miniCSSAssembler];
    } 
    return miniCSSParser;
}


- (TDGenericAssembler *)genericAssembler {
    if (!genericAssembler) {
        self.genericAssembler = [[[TDGenericAssembler alloc] init] autorelease];
    }
    return genericAssembler;
}


- (NSMutableDictionary *)parserCache {
    if (!parserCache) {
        self.parserCache = [NSMutableDictionary dictionary];
    }
    return parserCache;
}


- (NSMutableDictionary *)attributesForGrammarNamed:(NSString *)grammarName {
    // parse CSS
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:grammarName ofType:@"css"];
    NSString *s = [NSString stringWithContentsOfFile:path];
    TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
    [self.miniCSSParser bestMatchFor:a]; // produce dict of attributes from the CSS
    return self.miniCSSAssembler.attributes;
}


- (TDParser *)parserForGrammarNamed:(NSString *)grammarName getTokenizer:(TDTokenizer **)t {
    // create parser or the grammar requested or fetch parser from cache
    TDParser *parser = nil;
    if (cacheParsers) {
        parser = [self.parserCache objectForKey:grammarName];
    }
    
    if (!parser) {
        // get attributes from css && give to the generic assembler
        self.genericAssembler.attributes = [self attributesForGrammarNamed:grammarName];
        
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:grammarName ofType:@"grammar"];
        NSString *grammarString = [NSString stringWithContentsOfFile:path];
        
        parser = [self.parserFactory parserFromGrammar:grammarString assembler:self.genericAssembler getTokenizer:t];
        
        if (cacheParsers) {
            [self.parserCache setObject:parser forKey:grammarName];
            [self.tokenizerCache setObject:(*t) forKey:grammarName];
        }
    }

    return parser;
}


- (NSAttributedString *)highlightedStringForString:(NSString *)s ofGrammar:(NSString *)grammarName {    
    // create or fetch the parser & tokenizer for this grammar
    TDTokenizer *t = nil;
    TDParser *parser = [self parserForGrammarNamed:grammarName getTokenizer:&t];
    
    // parse the string. take care to preseve the whitespace in the string
    t.string = s;
    t.whitespaceState.reportsWhitespaceTokens = YES;

    TDTokenAssembly *a = [TDTokenAssembly assemblyWithTokenizer:t];
    a.preservesWhitespaceTokens = YES;
    
    [parser completeMatchFor:a]; // finally, parse the input. stores attributed string in genericAssembler.displayString
    
    if (!cacheParsers) {
        TDReleaseSubparserTree(parser);
    }
    
    id result = [[genericAssembler.displayString copy] autorelease];
    genericAssembler.displayString = nil;
    return result;
}

@synthesize parserFactory;
@synthesize miniCSSParser;
@synthesize miniCSSAssembler;
@synthesize genericAssembler;
@synthesize cacheParsers;
@synthesize parserCache;
@synthesize tokenizerCache;
@end
