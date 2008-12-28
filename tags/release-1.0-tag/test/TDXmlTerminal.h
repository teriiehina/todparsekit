//
//  TDXmlTerminal.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTerminal.h>

@class TDXmlToken;

@interface TDXmlTerminal : TDTerminal {
    TDXmlToken *tok;
}
@property (nonatomic, retain) TDXmlToken *tok;
@end
