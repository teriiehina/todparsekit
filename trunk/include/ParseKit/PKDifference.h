//
//  PKDifference.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 6/26/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/PKParser.h>

@interface PKDifference : PKParser {
    PKParser *subparser;
    PKParser *minus;
}

+ (id)differenceWithSubparser:(PKParser *)s minus:(PKParser *)m;

- (id)initWithSubparser:(PKParser *)s minus:(PKParser *)m;

@property (nonatomic, retain, readonly) PKParser *subparser;
@property (nonatomic, retain, readonly) PKParser *minus;
@end
