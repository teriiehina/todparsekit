//
//  TODXmlToken.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODToken.h"

extern const NSInteger TODTT_NAME;
extern const NSInteger TODTT_NMTOKEN;

@interface TODXmlToken : TODToken {
	BOOL name;
	BOOL nmtoken;
}
@property (readonly, getter=isName) BOOL name;
@property (readonly, getter=isNmtoken) BOOL nmtoken;
@end
