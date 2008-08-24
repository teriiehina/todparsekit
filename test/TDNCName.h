//
//  TDNCName.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTerminal.h"
#import "TDToken.h"

extern const NSInteger TDTT_NCNAME;

@interface TDToken (NCNameAdditions)
@property (readonly, getter=isNCName) BOOL NCName;
@end

@interface TDNCName : TDTerminal {

}
+ (id)NCName;
@end
