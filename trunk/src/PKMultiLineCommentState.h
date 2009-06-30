//
//  PKMultiLineCommentState.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 12/28/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ParseKit/PKTokenizerState.h>

@interface PKMultiLineCommentState : PKTokenizerState {
    NSMutableArray *startMarkers;
    NSMutableArray *endMarkers;
    NSString *currentStartMarker;
}

@end
