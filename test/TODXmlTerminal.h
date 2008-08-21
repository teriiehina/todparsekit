//
//  TODXmlTerminal.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <TODParseKit/TODTerminal.h>

@class TODXmlToken;

@interface TODXmlTerminal : TODTerminal {
	TODXmlToken *tok;
}
@property (nonatomic, retain) TODXmlToken *tok;
@end
