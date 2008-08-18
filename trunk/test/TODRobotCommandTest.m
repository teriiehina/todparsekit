//
//  TODRobotCommandTest.m
//  TODParseKit
//
//  Created by Todd Ditchendorf on 7/14/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TODRobotCommandTest.h"

@interface RobotCommand : NSObject {
	NSString *location;
}
@property (copy) NSString *location;
@end

@implementation RobotCommand

- (void)dealloc {
	self.location = nil;
	[super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
	RobotCommand *c = [[RobotCommand allocWithZone:zone] init];
	c->location = [location copy];
    return c;
}

@synthesize location;
@end

@interface RobotPickCommand : RobotCommand {}
@end
@implementation RobotPickCommand
- (NSString *)description { return [NSString stringWithFormat:@"pick %@", self.location]; }
@end

@interface RobotPlaceCommand : RobotCommand {}
@end
@implementation RobotPlaceCommand
- (NSString *)description { return [NSString stringWithFormat:@"place %@", self.location]; }
@end

@interface RobotScanCommand : RobotCommand {}
@end
@implementation RobotScanCommand
- (NSString *)description { return [NSString stringWithFormat:@"scan %@", self.location]; }
@end

@implementation TODRobotCommandTest

//	e = command*
//	command = pickCommand | placeCommand | scanCommand
//	pickCommand = "pick" "carrier" "from" location
//	placeCommand = "place" "carrier" "at" location
//	scanCommand = "scan" location
//	location = Word

- (TODParser *)location {
	return [TODWord word];
}


- (TODParser *)pickCommand {
	TODSequence *s = [TODSequence sequence];
	[s add:[[TODCaseInsensitiveLiteral literalWithString:@"pick"] discard]];
	[s add:[[TODCaseInsensitiveLiteral literalWithString:@"carrier"] discard]];
	[s add:[[TODCaseInsensitiveLiteral literalWithString:@"from"] discard]];
	[s add:[self location]];
	[s setAssembler:self selector:@selector(workOnPickCommandAssembly:)];
	return s;
}


- (TODParser *)placeCommand {
	TODSequence *s = [TODSequence sequence];
	[s add:[[TODCaseInsensitiveLiteral literalWithString:@"place"] discard]];
	[s add:[[TODCaseInsensitiveLiteral literalWithString:@"carrier"] discard]];
	[s add:[[TODCaseInsensitiveLiteral literalWithString:@"at"] discard]];
	[s add:[self location]];
	[s setAssembler:self selector:@selector(workOnPlaceCommandAssembly:)];
	return s;
}


- (TODParser *)scanCommand {
	TODSequence *s = [TODSequence sequence];
	[s add:[[TODCaseInsensitiveLiteral literalWithString:@"scan"] discard]];
	[s add:[self location]];
	[s setAssembler:self selector:@selector(workOnScanCommandAssembly:)];
	return s;
}


- (TODParser *)command {
	TODAlternation *a = [TODAlternation alternation];
	[a add:[self pickCommand]];
	[a add:[self placeCommand]];
	[a add:[self scanCommand]];
	return a;
}


- (void)testPick {
	NSString *s1 = @"pick carrier from LINE_IN";
	
	TODTokenAssembly *a = [TODTokenAssembly assemblyWithString:s1];
	TODParser *p = [self command];
	TODAssembly *result = [p bestMatchFor:a];

	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[]pick/carrier/from/LINE_IN^", [result description], @"");	

	id target = result.target;
	STAssertNotNil(target, @"");
	STAssertEqualObjects(@"pick LINE_IN", [target description], @"");
}


- (void)testPlace {
	NSString *s2 = @"place carrier at LINE_OUT";
	
	TODTokenAssembly *a = [TODTokenAssembly assemblyWithString:s2];
	TODParser *p = [self command];
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[]place/carrier/at/LINE_OUT^", [result description], @"");	

	id target = result.target;
	STAssertNotNil(target, @"");
	STAssertEqualObjects(@"place LINE_OUT", [target description], @"");
}


- (void)testScan {
	NSString *s3 = @"scan DB101_OUT";
	
	TODTokenAssembly *a = [TODTokenAssembly assemblyWithString:s3];
	TODParser *p = [self command];
	TODAssembly *result = [p bestMatchFor:a];
	
	STAssertNotNil(result, @"");
	STAssertEqualObjects(@"[]scan/DB101_OUT^", [result description], @"");

	id target = result.target;
	STAssertNotNil(target, @"");
	STAssertEqualObjects(@"scan DB101_OUT", [target description], @"");
}


- (void)workOnPickCommandAssembly:(TODAssembly *)a {
	RobotPickCommand *c = [[[RobotPickCommand alloc] init] autorelease];
	TODToken *location = [a pop];
	c.location = location.stringValue;
	a.target = c;
}


- (void)workOnPlaceCommandAssembly:(TODAssembly *)a {
	RobotPlaceCommand *c = [[[RobotPlaceCommand alloc] init] autorelease];
	TODToken *location = [a pop];
	c.location = location.stringValue;
	a.target = c;
}


- (void)workOnScanCommandAssembly:(TODAssembly *)a {
	RobotScanCommand *c = [[[RobotScanCommand alloc] init] autorelease];
	TODToken *location = [a pop];
	c.location = location.stringValue;
	a.target = c;
}

@end
