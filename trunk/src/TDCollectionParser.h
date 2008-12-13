//
//  TDCollectionParser.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TDParseKit/TDParser.h>

/*!
    @class      TDCollectionParser 
    @brief      An Abstract class. This class abstracts the behavior common to parsers that consist of a series of other parsers.
*/
@interface TDCollectionParser : TDParser {
    NSMutableArray *subparsers;
}

/*!
    @brief      Adds a parser to the collection.
    @detail     This method returns this parser so the method can be used in chaining expressions
    @param      p parser to add
    @result     this parser
*/
- (TDParser *)add:(TDParser *)p;

/*!
    @property   subparsers
    @brief      This parser's subparsers.
*/
@property (nonatomic, readonly, retain) NSMutableArray *subparsers;
@end
