//
//  NSString+NSString_Search.h
//  TDKit
//
//  Created by Tommy Allen on 7/11/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_Search)
-(BOOL)containsString:(NSString *)search;
-(BOOL)containsString:(NSString *)search ignoreCase:(BOOL)ignore;
@end
