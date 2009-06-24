//
//  TDXMLParserTest.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/19/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDXMLParserTest.h"

@implementation TDXMLParserTest

- (void)setUp {
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"xml" ofType:@"grammar"];
	g = [NSString stringWithContentsOfFile:path];
    factory = [TDParserFactory factory];
	p = [factory parserFromGrammar:g assembler:self];
    t = p.tokenizer;
}


- (void)testSTag {
    TDParser *sTag = [p parserNamed:@"sTag"];
    
	t.string = @"<foo>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo, >]</foo/>^", [res description]);

	t.string = @"<foo >";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , >]</foo/ />^", [res description]);
    
	t.string = @"<foo \t>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  \t, >]</foo/ \t/>^", [res description]);
    
	t.string = @"<foo \n >";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  \n , >]</foo/ \n />^", [res description]);
    
	t.string = @"<foo bar='baz'>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , bar, =, 'baz', >]</foo/ /bar/=/'baz'/>^", [res description]);

	t.string = @"<foo bar='baz' baz='bat'>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , bar, =, 'baz',  , baz, =, 'bat', >]</foo/ /bar/=/'baz'/ /baz/=/'bat'/>^", [res description]);
    
	t.string = @"<foo bar='baz' baz=\t'bat'>";
    res = [sTag bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
	TDEqualObjects(@"[<, foo,  , bar, =, 'baz',  , baz, =, \t, 'bat', >]</foo/ /bar/=/'baz'/ /baz/=/\t/'bat'/>^", [res description]);
    
    t.string = @"<foo/>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [p bestMatchFor:a];
	TDEqualObjects(@"[<, foo, />]</foo//>^", [res description]);
    
	t.string = @"<foo></foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, </, foo, >]</foo/>/<//foo/>^", [res description]);
    
	t.string = @"<foo> </foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >,  , </, foo, >]</foo/>/ /<//foo/>^", [res description]);
    
	t.string = @"<foo>&bar;</foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &, bar, ;, </, foo, >]</foo/>/&/bar/;/<//foo/>^", [res description]);
    
	t.string = @"<foo>&#20;</foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#, 20, ;, </, foo, >]</foo/>/&#/20/;/<//foo/>^", [res description]);
    
	t.string = @"<foo>&#xFF20;</foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#x, FF20, ;, </, foo, >]</foo/>/&#x/FF20/;/<//foo/>^", [res description]);
    
	t.string = @"<foo>&#xFF20; </foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#x, FF20, ;,  , </, foo, >]</foo/>/&#x/FF20/;/ /<//foo/>^", [res description]);
    
	t.string = @"<foo><![CDATA[bar]]></foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, <![CDATA[bar]]>, </, foo, >]</foo/>/<![CDATA[bar]]>/<//foo/>^", [res description]);
    
	t.string = @"<foo>&#xFF20;<![CDATA[bar]]></foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#x, FF20, ;, <![CDATA[bar]]>, </, foo, >]</foo/>/&#x/FF20/;/<![CDATA[bar]]>/<//foo/>^", [res description]);
    
	t.string = @"<foo>&#xFF20; <![CDATA[bar]]></foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#x, FF20, ;,  , <![CDATA[bar]]>, </, foo, >]</foo/>/&#x/FF20/;/ /<![CDATA[bar]]>/<//foo/>^", [res description]);    
}


- (void)testSmallSTagGrammar {
    g = @"@delimitState='<';@reportsWhitespaceTokens=YES;@start=sTag;sTag='<' name (S attribute)* S? '>';name=/[^-:\\.]\\w+/;attribute=name eq attValue;eq=S? '=' S?;attValue=QuotedString;";
    TDParser *sTag = [factory parserFromGrammar:g assembler:nil];
    t = sTag.tokenizer;

    t.string = @"<foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [sTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo, >]</foo/>^", [res description]);

    t.string = @"<foo >";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [sTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  , >]</foo/ />^", [res description]);

    t.string = @"<foo \n>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [sTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  \n, >]</foo/ \n/>^", [res description]);

    t.string = @"< foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [sTag bestMatchFor:a];
	TDNil(res);
}


- (void)testSmallETagGrammar {
    g = @"@symbols = '&#' '&#x' '</' '/>' '<![' '<?xml' '<!DOCTYPE' '<!ELEMENT' '<!ATTLIST' '#PCDATA' '#REQUIRED' '#IMPLIED' '#FIXED' ')*';"
        @"@delimitState = '<';"
        @"@delimitedString='<!--' '-->' nil; @delimitedString='<?' '?>' nil; @delimitedString='<![CDATA[' ']]>' nil;"
        @"@reportsWhitespaceTokens = YES;"
        @"@start = eTag;"
        @"eTag='</' name S? '>';"
        @"name=/[^-:\\.]\\w+/;";
    
    TDParser *eTag = [factory parserFromGrammar:g assembler:nil];
    t = eTag.tokenizer;
    
    t.string = @"</foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [eTag bestMatchFor:a];
	TDEqualObjects(@"[</, foo, >]<//foo/>^", [res description]);
    
    t.string = @"</foo >";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [eTag bestMatchFor:a];
	TDEqualObjects(@"[</, foo,  , >]<//foo/ />^", [res description]);
    
    t.string = @"</ foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [eTag bestMatchFor:a];
	TDNil(res);

    t.string = @"< /foo>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [eTag bestMatchFor:a];
	TDNil(res);
}
    
    
- (void)testETag {
	t.string = @"</foo>";
    res = [[p parserNamed:@"eTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[</, foo, >]<//foo/>^", [res description]);
}


- (void)test1 {
	t.string = @"<foo></foo>";
    res = [[p parserNamed:@"element"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, </, foo, >]</foo/>/<//foo/>^", [res description]);
    
	t.string = @"<foo/>";
    res = [[p parserNamed:@"emptyElemTag"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, />]</foo//>^", [res description]);
}


- (void)testXmlDecl {
    // versionInfo = S 'version' eq QuotedString; #TODO
	t.string = @" version='1.0'";
    res = [[p parserNamed:@"versionInfo"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[ , version, =, '1.0'] /version/=/'1.0'^", [res description]);
    
    // encodingDecl = S 'encoding' eq QuotedString; # TODO
	t.string = @" encoding='UTF-8'";
    res = [[p parserNamed:@"encodingDecl"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[ , encoding, =, 'UTF-8'] /encoding/=/'UTF-8'^", [res description]);
    
    // sdDecl = S 'standalone' eq QuotedString; # /(["'])(yes|no)\1/; # TODO
	t.string = @" standalone='no'";
    res = [[p parserNamed:@"sdDecl"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[ , standalone, =, 'no'] /standalone/=/'no'^", [res description]);
    
	t.string = @"<?xml";
    TDToken *tok = [t nextToken];
    TDEqualObjects(@"<?xml", tok.stringValue);
    
    // xmlDecl = '<?xml' versionInfo encodingDecl? sdDecl? S? '?>';
	t.string = @"<?xml version='1.0'?>";
    res = [[p parserNamed:@"xmlDecl"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<?xml,  , version, =, '1.0', ?>]<?xml/ /version/=/'1.0'/?>^", [res description]);

    // xmlDecl = '<?xml' versionInfo encodingDecl? sdDecl? S? '?>';
	t.string = @"<?xml version='1.0' encoding='utf-8'?>";
    res = [[p parserNamed:@"xmlDecl"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<?xml,  , version, =, '1.0',  , encoding, =, 'utf-8', ?>]<?xml/ /version/=/'1.0'/ /encoding/=/'utf-8'/?>^", [res description]);
    
    // xmlDecl = '<?xml' versionInfo encodingDecl? sdDecl? S? '?>';
	t.string = @"<?xml version='1.0' encoding='utf-8' standalone='no'?>";
    res = [[p parserNamed:@"xmlDecl"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<?xml,  , version, =, '1.0',  , encoding, =, 'utf-8',  , standalone, =, 'no', ?>]<?xml/ /version/=/'1.0'/ /encoding/=/'utf-8'/ /standalone/=/'no'/?>^", [res description]);    

}


- (void)testSmallEmptyElemTagGrammar {
    g = @"@delimitState='<';@symbols='/>';@reportsWhitespaceTokens=YES;@start=emptyElemTag;emptyElemTag='<' name (S attribute)* S? '/>';name=/[^-:\\.]\\w+/;attribute=name eq attValue;eq=S? '=' S?;attValue=QuotedString;";
    TDParser *emptyElemTag = [factory parserFromGrammar:g assembler:nil];
    t = emptyElemTag.tokenizer;
    
    t.string = @"<foo/>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [emptyElemTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo, />]</foo//>^", [res description]);
    
    t.string = @"<foo />";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [emptyElemTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  , />]</foo/ //>^", [res description]);
    
    t.string = @"<foo bar='baz'/>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [emptyElemTag bestMatchFor:a];
	TDEqualObjects(@"[<, foo,  , bar, =, 'baz', />]</foo/ /bar/=/'baz'//>^", [res description]);
}


- (void)testSmallCharDataGrammar {
    g = @"@symbols = '&#' '&#x' '</' '/>' '<![' '<?xml' '<!DOCTYPE' '<!ELEMENT' '<!ATTLIST' '#PCDATA' '#REQUIRED' '#IMPLIED' '#FIXED' ')*';"
        @"@delimitState = '<';"
        @"@delimitedString='<!--' '-->' nil '<?' '?>' nil '<![CDATA[' ']]>' nil;"
        @"@reportsWhitespaceTokens = YES;"
        @"@start = charData+;"
        @"charData = /[^<\\&]+/;";

    TDParser *charData = [factory parserFromGrammar:g assembler:nil];
    t = charData.tokenizer;

    t.string = @" ";
    res = [charData bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[ ] ^", [res description]);

    t.string = @"foo % 1";
    res = [charData bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[foo,  , %,  , 1]foo/ /%/ /1^", [res description]);

    t.string = @"foo & 1";
    res = [charData bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[foo,  ]foo/ ^&/ /1", [res description]);
}


- (void)testSmallElementGrammar {
    g = @"@symbols = '&#' '&#x' '</' '/>' '<![' '<?xml' '<!DOCTYPE' '<!ELEMENT' '<!ATTLIST' '#PCDATA' '#REQUIRED' '#IMPLIED' '#FIXED' ')*';"
        @"@delimitState = '<';"
        @"@delimitedStrings = '<!--' '-->' nil  '<?' '?>' nil  '<![CDATA[' ']]>' nil;"
        @"@reportsWhitespaceTokens = YES;"
        @"@start = element;"
        @"element = emptyElemTag | sTag content eTag;"
        @"eTag = '</' name S? '>';"
        @"sTag = '<' name (S attribute)* S? '>';"
        @"emptyElemTag = '<' name (S attribute)* S? '/>';"
        //@"content = Empty | (element | reference | cdSect | pi | comment | charData)+;"
        @"content = Empty | (element | reference | cdSect | charData)+;"
        @"name = /[^-:\\.]\\w+/;"
        @"attribute = name eq attValue;"
        @"eq=S? '=' S?;"
        @"attValue = QuotedString;"
        @"charData = /[^<\\&]+/;"
        @"reference = entityRef | charRef;"
        @"entityRef = '&' name ';';"
        @"charRef = '&#' /[0-9]+/ ';' | '&#x' /[0-9a-fA-F]+/ ';';"
        @"cdSect = DelimitedString('<![CDATA[', ']]>');"
    ;
    
    //NSLog(@"g: %@", g);
    TDParser *element = [factory parserFromGrammar:g assembler:nil];
    t = element.tokenizer;
    
    t.string = @"<foo/>";
    a = [TDTokenAssembly assemblyWithTokenizer:t];
    res = [element bestMatchFor:a];
	TDEqualObjects(@"[<, foo, />]</foo//>^", [res description]);

	t.string = @"<foo></foo>";
    res = [element bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, </, foo, >]</foo/>/<//foo/>^", [res description]);
    
	t.string = @"<foo> </foo>";
    res = [element bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >,  , </, foo, >]</foo/>/ /<//foo/>^", [res description]);
    
	t.string = @"<foo>&bar;</foo>";
    res = [element bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &, bar, ;, </, foo, >]</foo/>/&/bar/;/<//foo/>^", [res description]);

	t.string = @"<foo>&#20;</foo>";
    res = [element bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#, 20, ;, </, foo, >]</foo/>/&#/20/;/<//foo/>^", [res description]);
    
	t.string = @"<foo>&#xFF20;</foo>";
    res = [element bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#x, FF20, ;, </, foo, >]</foo/>/&#x/FF20/;/<//foo/>^", [res description]);

	t.string = @"<foo>&#xFF20; </foo>";
    res = [element bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#x, FF20, ;,  , </, foo, >]</foo/>/&#x/FF20/;/ /<//foo/>^", [res description]);
    
	t.string = @"<foo><![CDATA[bar]]></foo>";
    res = [element bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, <![CDATA[bar]]>, </, foo, >]</foo/>/<![CDATA[bar]]>/<//foo/>^", [res description]);

	t.string = @"<foo>&#xFF20;<![CDATA[bar]]></foo>";
    res = [element bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#x, FF20, ;, <![CDATA[bar]]>, </, foo, >]</foo/>/&#x/FF20/;/<![CDATA[bar]]>/<//foo/>^", [res description]);

	t.string = @"<foo>&#xFF20; <![CDATA[bar]]></foo>";
    res = [element bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<, foo, >, &#x, FF20, ;,  , <![CDATA[bar]]>, </, foo, >]</foo/>/&#x/FF20/;/ /<![CDATA[bar]]>/<//foo/>^", [res description]);
}


// [1]
- (void)testDocument {
    // xmlDecl = '<?xml' versionInfo encodingDecl? sdDecl? S? '?>';
	t.string = @"<?xml version='1.0' encoding='utf-8' standalone='no'?><foo></foo>";
    res = [[p parserNamed:@"document"] bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<?xml,  , version, =, '1.0',  , encoding, =, 'utf-8',  , standalone, =, 'no', ?>, <, foo, >, </, foo, >]<?xml/ /version/=/'1.0'/ /encoding/=/'utf-8'/ /standalone/=/'no'/?>/</foo/>/<//foo/>^", [res description]);    

    // xmlDecl = '<?xml' versionInfo encodingDecl? sdDecl? S? '?>';
	t.string = @"<?xml version='1.0' encoding='utf-8' standalone='no'?><foo></foo>";
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDEqualObjects(@"[<?xml,  , version, =, '1.0',  , encoding, =, 'utf-8',  , standalone, =, 'no', ?>, <, foo, >, </, foo, >]<?xml/ /version/=/'1.0'/ /encoding/=/'utf-8'/ /standalone/=/'no'/?>/</foo/>/<//foo/>^", [res description]);    

    // xmlDecl = '<?xml' versionInfo encodingDecl? sdDecl? S? '?>';
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"apple-boss" ofType:@"xml"];
	t.string = [NSString stringWithContentsOfFile:path];
    res = [p bestMatchFor:[TDTokenAssembly assemblyWithTokenizer:t]];
    TDNotNil(res);
//    NSLog(@"%@", [res description]);
    TDTrue([[res description] hasSuffix:@"^"]);
}


// [2]
- (void)test {
    
}

@end
