//
//  TDToken+Blob.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/7/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/TDToken.h>

extern const NSInteger TDTokenTypeBlob;

@interface TDToken (Blob)
- (BOOL)isBlob;
@end

