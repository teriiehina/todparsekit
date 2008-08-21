//
//  TODXmlSignificantWhitespace.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlTerminal.h"

@interface TODXmlSignificantWhitespace : TODXmlTerminal {

}
+ (id)significantWhitespace;
+ (id)significantWhitespaceWithString:(NSString *)s;
@end
