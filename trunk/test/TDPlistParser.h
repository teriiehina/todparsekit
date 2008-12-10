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
    TDCollectionParser *stringParser;
    TDParser *numParser;
    TDParser *nullParser;
}
- (id)parse:(NSString *)s;

@property (retain) TDCollectionParser *dictParser;
@property (retain) TDCollectionParser *keyValuePairParser;
@property (retain) TDCollectionParser *arrayParser;
@property (retain) TDCollectionParser *commaValueParser;
@property (retain) TDCollectionParser *keyParser;
@property (retain) TDCollectionParser *valueParser;
@property (retain) TDCollectionParser *stringParser;
@property (retain) TDParser *numParser;
@property (retain) TDParser *nullParser;
@end
