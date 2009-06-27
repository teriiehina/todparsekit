//
//  TDExclusion.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 6/26/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDInclusion.h>

@interface TDExclusion : TDInclusion {

}

+ (id)exclusionWithSubparser:(TDParser *)p predicate:(TDParser *)p;

@end
