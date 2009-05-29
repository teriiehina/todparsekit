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

@interface PredicateParser : NSObject {
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
    TDCollectionParser *eqStringPredicateParser;
    TDCollectionParser *eqNumberPredicateParser;
    TDCollectionParser *eqBoolPredicateParser;
    TDCollectionParser *neStringPredicateParser;
    TDCollectionParser *neNumberPredicateParser;
    TDCollectionParser *neBoolPredicateParser;
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
    TDParser *stringParser;
    TDParser *numberParser;
}
- (id)initWithDelegate:(id <PredicateParserDelegate>)d;
- (NSPredicate *)parse:(NSString *)s;

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
@property (nonatomic, retain) TDCollectionParser *eqStringPredicateParser;
@property (nonatomic, retain) TDCollectionParser *eqNumberPredicateParser;
@property (nonatomic, retain) TDCollectionParser *eqBoolPredicateParser;
@property (nonatomic, retain) TDCollectionParser *neStringPredicateParser;
@property (nonatomic, retain) TDCollectionParser *neNumberPredicateParser;
@property (nonatomic, retain) TDCollectionParser *neBoolPredicateParser;
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
@property (nonatomic, retain) TDParser *stringParser;
@property (nonatomic, retain) TDParser *numberParser;
@end
