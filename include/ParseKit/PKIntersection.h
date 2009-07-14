//
//  PKIntersection.h
//  ParseKit
//
//  Created by Todd Ditchendorf on 6/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/PKCollectionParser.h>

@interface PKIntersection : PKCollectionParser {

}

+ (id)intersection;

+ (id)intersectionWithSubparsers:(PKParser *)p1, ...;
@end
