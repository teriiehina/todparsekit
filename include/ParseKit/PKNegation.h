//
//  PKNegation.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 7/2/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <ParseKit/PKParser.h>

@interface PKNegation : PKParser {
    PKParser *subparser;
    PKParser *difference;
}

+ (id)negationWithSubparser:(PKParser *)s;

- (id)initWithSubparser:(PKParser *)s;

@property (nonatomic, retain, readonly) PKParser *subparser;
@end
