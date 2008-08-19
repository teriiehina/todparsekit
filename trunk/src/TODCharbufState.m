//
//  TODCharbufState.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <TODParseKit/TODCharbufState.h>

// NOTE: this class is not currently in use or included in the build Framework. Using TODMutableStringState instead

@implementation TODCharbufState

- (void)dealloc {
	free(charbuf);
	[super dealloc];
}


- (void)reset {
	if (charbuf && ![[NSGarbageCollector defaultCollector] isEnabled]) {
		free(charbuf);
	}
	len = 16;
	charbuf = [self mallocCharbuf:len];
}


- (void)checkBufLength:(NSInteger)i {
	if (i >= len) {
		char *nb = [self mallocCharbuf:len*2];
		
		NSInteger j = 0;
		for ( ; j < len; j++) {
			nb[j] = charbuf[j];
		}
		if (![[NSGarbageCollector defaultCollector] isEnabled]) {
			free(charbuf);
		}
		charbuf = nb;
		
		len = len * 2;
	}
}


- (char *)mallocCharbuf:(NSInteger)size {
	char *result = NULL;
	if ((result = (char *)NSAllocateCollectable(size, 0)) == NULL) {
		[NSException raise:@"Out of memory" format:nil];
	}
	return result;
}

@end
