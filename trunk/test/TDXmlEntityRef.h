//
//  PKXmlEntityRef.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDXmlTerminal.h"

@interface TDXmlEntityRef : TDXmlTerminal {

}
+ (id)entityRef;
+ (id)entityRefWithString:(NSString *)s;
@end
