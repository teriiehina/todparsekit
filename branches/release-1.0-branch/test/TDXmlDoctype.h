//
//  TDXmlDoctype.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDXmlTerminal.h"

@interface TDXmlDoctype : TDXmlTerminal {

}
+ (id)doctype;
+ (id)doctypeWithString:(NSString *)s;
@end
