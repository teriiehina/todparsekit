//
//  TODXmlEntity.h
//  TODParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TODXmlTerminal.h"

@interface TODXmlEntity : TODXmlTerminal {

}
+ (id)entity;
+ (id)entityWithString:(NSString *)s;
@end
