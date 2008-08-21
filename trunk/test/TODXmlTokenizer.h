//
//  TODXmlTokenizer.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TODXmlToken;
@class XMLPullParser;

@interface TODXmlTokenizer : NSObject {
	XMLPullParser *reader;
}
+ (id)tokenizerWithContentsOfFile:(NSString *)path;

- (id)initWithContentsOfFile:(NSString *)path;
- (TODXmlToken *)nextToken;
@end
