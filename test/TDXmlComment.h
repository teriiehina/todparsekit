//
//  TDXmlComment.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDXmlTerminal.h"

@interface TDXmlComment : TDXmlTerminal {

}
+ (id)comment;
+ (id)commentWithString:(NSString *)s;
@end
