//
//  PredicateParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 5/27/09.
//  Copyright 2009 Todd Ditchendorf. All rights reserved.
//

#import <TDParseKit/TDParseKit.h>

@protocol PredicateParserDelegate <NSObject>
- (id)valueForAttributeKey:(NSString *)key;
- (CGFloat)floatForAttributeKey:(NSString *)key;
- (BOOL)boolForAttributeKey:(NSString *)key;
@end

@interface PredicateParser : TDSequence {
    id <PredicateParserDelegate>delegate;
    TDCollectionParser *exprParser;
    TDCollectionParser *orTermParser;
    TDCollectionParser *termParser;
    TDCollectionParser *andPrimaryExprParser;
    TDCollectionParser *primaryExprParser;
    TDCollectionParser *phraseParser;
    TDCollectionParser *negatedPredicateParser;
    TDCollectionParser *predicateParser;
    TDCollectionParser *attrParser;
    TDCollectionParser *tagParser;
    TDCollectionParser *eqPredicateParser;
    TDCollectionParser *nePredicateParser;
    TDCollectionParser *gtPredicateParser;
    TDCollectionParser *gteqPredicateParser;
    TDCollectionParser *ltPredicateParser;
    TDCollectionParser *lteqPredicateParser;
    TDCollectionParser *beginswithPredicateParser;
    TDCollectionParser *containsPredicateParser;
    TDCollectionParser *endswithPredicateParser;
    TDCollectionParser *matchesPredicateParser;
    TDCollectionParser *valueParser;
    TDCollectionParser *boolParser;
    TDParser *trueParser;
    TDParser *falseParser;
}
- (id)initWithDelegate:(id <PredicateParserDelegate>)d;

@property (nonatomic, retain) TDCollectionParser *exprParser;
@property (nonatomic, retain) TDCollectionParser *orTermParser;
@property (nonatomic, retain) TDCollectionParser *termParser;
@property (nonatomic, retain) TDCollectionParser *andPrimaryExprParser;
@property (nonatomic, retain) TDCollectionParser *primaryExprParser;
@property (nonatomic, retain) TDCollectionParser *phraseParser;
@property (nonatomic, retain) TDCollectionParser *negatedPredicateParser;
@property (nonatomic, retain) TDCollectionParser *predicateParser;
@property (nonatomic, retain) TDCollectionParser *attrParser;
@property (nonatomic, retain) TDCollectionParser *tagParser;
@property (nonatomic, retain) TDCollectionParser *eqPredicateParser;
@property (nonatomic, retain) TDCollectionParser *nePredicateParser;
@property (nonatomic, retain) TDCollectionParser *gtPredicateParser;
@property (nonatomic, retain) TDCollectionParser *gteqPredicateParser;
@property (nonatomic, retain) TDCollectionParser *ltPredicateParser;
@property (nonatomic, retain) TDCollectionParser *lteqPredicateParser;
@property (nonatomic, retain) TDCollectionParser *beginswithPredicateParser;
@property (nonatomic, retain) TDCollectionParser *containsPredicateParser;
@property (nonatomic, retain) TDCollectionParser *endswithPredicateParser;
@property (nonatomic, retain) TDCollectionParser *matchesPredicateParser;
@property (nonatomic, retain) TDCollectionParser *valueParser;
@property (nonatomic, retain) TDCollectionParser *boolParser;
@property (nonatomic, retain) TDParser *trueParser;
@property (nonatomic, retain) TDParser *falseParser;
@end
