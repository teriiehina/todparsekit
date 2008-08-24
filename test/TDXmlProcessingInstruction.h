//
//  TDXmlProcessingInstruction.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TDXmlTerminal.h"

@interface TDXmlProcessingInstruction : TDXmlTerminal {

}
+ (id)processingInstruction;
+ (id)processingInstructionWithString:(NSString *)s;
@end
