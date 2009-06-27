//
//  TDInclusion.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDParser.h>

@interface TDInclusion : TDParser {
    TDParser *subparser;
    TDParser *predicate;
}

+ (id)inclusionWithSubparser:(TDParser *)s predicate:(TDParser *)p;

- (id)initWithSubparser:(TDParser *)s predicate:(TDParser *)p;

@property (nonatomic, retain, readonly) TDParser *subparser;
@property (nonatomic, retain, readonly) TDParser *predicate;
@end
