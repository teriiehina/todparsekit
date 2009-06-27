//
//  TDExclusion.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/26/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDParser.h>

@interface TDExclusion : TDParser {
    TDParser *subparser;
    TDParser *minus;
}

+ (id)exclusionWithSubparser:(TDParser *)p minus:(TDParser *)m;

- (id)initWithSubparser:(TDParser *)p minus:(TDParser *)m;

@property (nonatomic, retain, readonly) TDParser *subparser;
@property (nonatomic, retain, readonly) TDParser *minus;
@end
