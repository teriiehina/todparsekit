//
//  TDTrack.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 8/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDSequence.h>

/*!
	@class      TDTrack 
	@brief		A <tt>TDTrack</tt> is a sequence that throws a <tt>TrackException</tt> if the sequence begins but does not complete.
	@details	If <tt>-[TDTrack allMatchesFor:] begins but does not complete, it throws a <tt>TrackException</tt>.
*/
@interface TDTrack : TDSequence {

}

/*!
	@fn			track
	@brief		Convenience factory method for initializing an autoreleased <tt>TDTrack</tt> parser.
	@result		an initialized autoreleased <tt>TDTrack</tt> parser.
*/
+ (id)track;
@end
