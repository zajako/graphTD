//
//  NNTower.m
//  TDKit
//
//  Created by James Covey on 7/30/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "NNTower.h"


@implementation NNTower

+(id)entityWithConfig:(NSString *)file
{
	return [[[self alloc] initWithConfig:file] autorelease];
}

-(id)initWithConfig:(NSString *)file
{
    //Load Confg file for tower
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"gamedata/towers/%@.plist", file]];
    NSDictionary *plistData = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
    
    //load tower with image
	self = [super initWithImageFile: [NSString stringWithFormat:@"%@", [plistData objectForKey:@"sprite"]]];
    
    //Set Towers stats acording to config
    
    return self;
}


@end
