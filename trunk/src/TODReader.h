//
//  TODPushbackInputStream.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/21/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TODReader : NSObject {
	NSString *string;
	NSInteger cursor;
}
- (id)initWithString:(NSString *)s;
- (NSInteger)read;
- (void)unread;

@property (nonatomic, copy) NSString *string;
@end
