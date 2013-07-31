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
    //Load Confgif file for tower
    
    //get image file from config
    
    //load tower with image
	self = [super initWithImageFile: file];
    
    //Set Towers stats acording to config
    
    return self;
}


@end
