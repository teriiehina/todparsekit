//
//  TODSymbolNode.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2006 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TODSymbolNode : NSObject {
	NSString *ancestry;
	TODSymbolNode *parent;
	NSMutableDictionary *children;
	NSInteger character;
}
- (id)initWithParent:(TODSymbolNode *)p character:(NSInteger)c;
@property (nonatomic, readonly, retain) NSString *ancestry;
@property (nonatomic, readonly, assign) TODSymbolNode *parent; // this must be 'assign' to avoid retain loop leak
@property (nonatomic, readonly, retain) NSMutableDictionary *children;
@property (nonatomic, readonly) NSInteger character;
@end
