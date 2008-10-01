//
//  TDParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDAssembly;

@interface NSString (TDParseKitAdditions)
- (NSString *)stringByRemovingFirstAndLastCharacters;
@end

/*!
	@class       TDParser 
	@superclass  NSObject
	@abstract    An Abstract class. A <tt>TDParser</tt> is an object that recognizes the elements of a language.
	@discussion  <p>An Abstract Class. A <tt>TDParser</tt> is an object that recognizes the elements of a language.
				 <p>Each <tt>TDParser</tt> object is either a <tt>TDTerminal</tt> or a composition of other parsers. The <tt>TDTerminal</tt> class is a subclass of Parser, and is itself a hierarchy of parsers that recognize specific patterns of text. For example, a <tt>TDWord</tt> recognizes any word, and a <tt>TDLiteral</tt> matches a specific string.</p>
				 <p>In addition to <tt>TDTerminal</tt>, other subclasses of <tt>TDParser</tt> provide composite parsers, describing sequences, alternations, and repetitions of other parsers. For example, the following <tt>TDParser</tt> objects culminate in a good parser that recognizes a description of good coffee.</p>
<pre>
	TDAlternation *adjective = [TDAlternation alternation];
	[adjective add:[TDLiteral literalWithString:@"steaming"]];
	[adjective add:[TDLiteral literalWithString:@"hot"]];
	TDSequence *good = [TDSequence sequence];
	[good add:[TDRepetition repetitionWithSubparser:adjective]];
	[good add:[TDLiteral literalWithString:@"coffee"]];
	NSString *s = @"hot hot steaming hot coffee";
	TDAssembly *a = [TDTokenAssembly assemblyWithString:s];
	NSLog([good bestMatchFor:a]);
</pre>
				 <p>This prints out:</p>
<pre>
	[hot, hot, steaming, hot, coffee]
	hot/hot/steaming/hot/coffee^
 <pre>
				 <p>The parser does not match directly against a string, it matches against a <tt>TDAssembly</tt>. The resulting assembly shows its stack, with four words on it, along with its sequence of tokens, and the index at the end of these. In practice, parsers will do some work on an assembly, based on the text they recognize.</p>
*/
@interface TDParser : NSObject {
	id assembler;
	SEL selector;
	NSString *name;
}

/*!
	@method     parser
	@abstract   Convenience factory method for initializing an autoreleased parser.
	@result     an initialized autoreleased parser.
*/
+ (id)parser;

/*!
	@method     setAssembler:selector:
	@abstract   Sets the object and method that will work on an assembly whenever this parser successfully matches against the assembly.
	@discussion The method represented by <tt>sel</tt> must accept a single <tt>TDAssembly</tt> argument. The signature of <tt>sel</tt> should be similar to: <tt>-workOnAssembly:(TDAssembly *)a</tt>.
	@param      a the assembler this parser will use to work on an assembly
	@param      sel a selector that assembler <tt>a</tt> responds to which will work on an assembly
*/
- (void)setAssembler:(id)a selector:(SEL)sel;

/*!
	@method     bestMatchFor:
	@abstract   Returns the most-matched assembly in a collection.
	@param      inAssembly the assembly for which to find the best match
	@result     an assembly with the greatest possible number of elements consumed by this parser
*/
- (TDAssembly *)bestMatchFor:(TDAssembly *)inAssembly;

/*!
	@method     completeMatchFor:
	@abstract   Returns either <tt>nil</tt>, or a completely matched version of the supplied assembly.
	@param      inAssembly the assembly for which to find the complete match
	@result     either <tt>nil</tt>, or a completely matched version of the supplied assembly
*/
- (TDAssembly *)completeMatchFor:(TDAssembly *)inAssembly;

/*!
	@method     allMatchesFor:
	@abstract   Given a set of assemblies, this method matches this parser against all of them, and returns a new set of the assemblies that result from the matches.
	@discussion <p>Given a set of assemblies, this method matches this parser against all of them, and returns a new set of the assemblies that result from the matches.</p>
				<p>For example, consider matching the regular expression <tt>a*</tt> against the string <tt>aaab</tt>. The initial set of states is <tt>{^aaab}</tt>, where the <tt>^</tt> indicates how far along the assembly is. When <tt>a*</tt> matches against this initial state, it creates a new set <tt>{^aaab, a^aab, aa^ab, aaa^b}</tt>.</p>
	@param      inAssemblies set of assemblies to match against
	@result     a set of assemblies that result from matching against a beginning set of assemblies
*/
- (NSSet *)allMatchesFor:(NSSet *)inAssemblies;

/*!
	@method     
	@abstract   The assembler this parser will use to work on a matched assembly.
	@discussion <tt>assembler</tt> should respond to the selector held by this parser's <tt>selector</tt> property.
*/
@property (nonatomic, retain) id assembler;

/*!
	@method     
	@abstract   The method of <tt>assembler</tt> this parser will call to work on a matched assembly.
	@discussion The method represented by <tt>selector</tt> must accept a single <tt>TDAssembly</tt> argument. The signature of <tt>selector</tt> should be similar to: <tt>-workOnAssembly:(TDAssembly *)a</tt>.
*/
@property (nonatomic, assign) SEL selector;

/*!
	@method     
	@abstract   The name of this parser.
	@discussion	Use this property to help in identifying a parser or for debugging purposes.
*/
@property (nonatomic, copy) NSString *name;
@end
