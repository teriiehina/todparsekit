//
//  TDBlob.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/7/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDTerminal.h>

@interface TDBlob : TDTerminal {

}
+ (id)blob;

+ (id)blobWithStartMarker:(NSString *)s;
@end
