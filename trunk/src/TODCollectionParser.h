//
//  TODCollectionParser.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TODParseKit/TODParser.h>

// Abstract Class
@interface TODCollectionParser : TODParser {
	NSMutableArray *subparsers;
}
- (void)add:(TODParser *)p;

@property (nonatomic, readonly, retain) NSMutableArray *subparsers;
@end
