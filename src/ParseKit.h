//
//  ParseKit.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

/*!
    @mainpage   TDParseKit
                TDParseKit is a Mac OS X Framework written by Todd Ditchendorf in Objective-C 2.0 and released under the MIT Open Source License.
				The framework is an Objective-C implementation of the tools described in <a href="http://www.amazon.com/Building-Parsers-Java-Steven-Metsker/dp/0201719622" title="Amazon.com: Building Parsers With Java(TM): Steven John Metsker: Books">"Building Parsers with Java" by Steven John Metsker</a>. 
				TDParseKit includes some significant additions beyond the designs from the book (many of them hinted at in the book itself) in order to enhance the framework's feature set, usefulness and ease-of-use. Other changes have been made to the designs in the book to match common Cocoa/Objective-C design patterns and conventions. 
				However, these changes are relatively superficial, and Metsker's book is the best documentation available for this framework.
                
                Classes in the TDParseKit Framework offer 2 basic services of general use to Cocoa developers:
    @li Tokenization via a tokenizer class
    @li Parsing via a high-level parser-building toolkit
                Learn more on the <a target="_top" href="http://code.google.com/p/todparsekit/">project site</a>
*/
 
#import <Foundation/Foundation.h>

// io
#import <ParseKit/PKTypes.h>
#import <ParseKit/PKReader.h>

// parse
#import <ParseKit/PKParser.h>
#import <ParseKit/PKAssembly.h>
#import <ParseKit/PKSequence.h>
#import <ParseKit/PKExclusion.h>
#import <ParseKit/PKIntersection.h>
#import <ParseKit/PKCollectionParser.h>
#import <ParseKit/PKAlternation.h>
#import <ParseKit/PKRepetition.h>
#import <ParseKit/PKEmpty.h>
#import <ParseKit/PKTerminal.h>
#import <ParseKit/PKTrack.h>
#import <ParseKit/PKTrackException.h>

//chars
#import <ParseKit/TDCharacterAssembly.h>
#import <ParseKit/TDChar.h>
#import <ParseKit/TDSpecificChar.h>
#import <ParseKit/TDLetter.h>
#import <ParseKit/TDDigit.h>

// tokens
#import <ParseKit/PKToken.h>
#import <ParseKit/PKTokenizer.h>
#import <ParseKit/PKTokenArraySource.h>
#import <ParseKit/PKTokenAssembly.h>
#import <ParseKit/PKTokenizerState.h>
#import <ParseKit/PKNumberState.h>
#import <ParseKit/PKQuoteState.h>
#import <ParseKit/PKDelimitState.h>
#import <ParseKit/PKCommentState.h>
#import <ParseKit/PKSingleLineCommentState.h>
#import <ParseKit/PKMultiLineCommentState.h>
#import <ParseKit/PKSymbolNode.h>
#import <ParseKit/PKSymbolRootNode.h>
#import <ParseKit/PKSymbolState.h>
#import <ParseKit/PKWordState.h>
#import <ParseKit/PKWhitespaceState.h>
#import <ParseKit/PKWord.h>
#import <ParseKit/TDNum.h>
#import <ParseKit/TDQuotedString.h>
#import <ParseKit/TDWhitespace.h>
#import <ParseKit/TDDelimitedString.h>
#import <ParseKit/TDSymbol.h>
#import <ParseKit/TDComment.h>
#import <ParseKit/TDLiteral.h>
#import <ParseKit/TDCaseInsensitiveLiteral.h>
#import <ParseKit/PKAny.h>
#import <ParseKit/TDPattern.h>

// ext
#import <ParseKit/TDScientificNumberState.h>
#import <ParseKit/TDUppercaseWord.h>
#import <ParseKit/TDLowercaseWord.h>

// grammar
#import <ParseKit/TDParserFactory.h>

