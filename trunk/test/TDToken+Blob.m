//
//  TDToken+Blob.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/7/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import "TDToken+Blob.h"

const NSInteger TDTokenTypeBlob = 200;

@implementation TDToken (Blob)

- (BOOL)isBlob {
    return TDTokenTypeBlob == self.tokenType;
}

@end

