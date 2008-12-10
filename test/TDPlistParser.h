//
//  TDPlistParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <TDParseKit/TDParseKit.h>

@interface TDPlistParser : TDAlternation {
    TDCollectionParser *dictParser;
    TDCollectionParser *keyValuePairParser;
    TDCollectionParser *arrayParser;
    TDCollectionParser *commaValueParser;
    TDCollectionParser *keyParser;
    TDCollectionParser *valueParser;
    TDParser *nullParser;
    TDParser *numParser;
    TDParser *stringParser;
}
- (id)parse:(NSString *)s;

@property (retain) TDCollectionParser *dictParser;
@property (retain) TDCollectionParser *keyValuePairParser;
@property (retain) TDCollectionParser *arrayParser;
@property (retain) TDCollectionParser *commaValueParser;
@property (retain) TDCollectionParser *keyParser;
@property (retain) TDCollectionParser *valueParser;
@property (retain) TDParser *nullParser;
@property (retain) TDParser *numParser;
@property (retain) TDParser *stringParser;
@end
