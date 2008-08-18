//
//  TODNCName.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/16/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODTerminal.h"
#import "TODToken.h"

extern const NSInteger TODTT_NCNAME;

@interface TODToken (NCNameAdditions)
@property (readonly, getter=isNCName) BOOL NCName;
@end

@interface TODNCName : TODTerminal {

}
+ (id)NCName;
@end
