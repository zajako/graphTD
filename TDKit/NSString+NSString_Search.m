//
//  NSString+NSString_Search.m
//  TDKit
//
//  Created by Tommy Allen on 7/11/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "NSString+NSString_Search.h"

@implementation NSString (NSString_Search)

-(BOOL)containsString:(NSString *)search
{
	return [self containsString:search ignoreCase:NO];
}

- (BOOL)containsString:(NSString *)search ignoreCase:(BOOL)ignore
{
	NSRange found = [self rangeOfString:search options:(ignore ? NSCaseInsensitiveSearch : 0)];
	return found.length > 0;
}

@end
