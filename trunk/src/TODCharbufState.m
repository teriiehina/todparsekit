//
//  TODCharbufState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODCharbufState.h"


@implementation TODCharbufState

- (void)dealloc {
	free(charbuf);
	[super dealloc];
}


- (void)reset {
	if (charbuf) {
		free(charbuf);
	}
	len = 16;
	charbuf = [self mallocCharbuf:len];
}


- (void)checkBufLength:(NSInteger)i {
	if (i >= len) {
		char *nb = [self mallocCharbuf:len*2];
		
		NSInteger j;
		for (j = 0; j < len; j++) {
			nb[j] = charbuf[j];
		}
		free(charbuf);
		charbuf = nb;
		
		len = len * 2;
	}
}


- (char *)mallocCharbuf:(NSInteger)size {
	char *result;
	if ((result = (char *)malloc(sizeof(size))) == NULL) {
		[NSException raise:@"Out of memory" format:nil];
	}
	return result;
}

@end
