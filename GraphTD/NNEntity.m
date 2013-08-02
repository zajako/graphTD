//
//  NNEntity.m
//  TDKit
//
//  Created by James Covey on 7/30/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "NNEntity.h"
#import "NNStatusEffect.h"

@implementation NNEntity

@synthesize statusArray;

-(id)initWithImageFile:(NSString *)file
{
	self = [super initWithImageFile: file];
    
    statusArray = [NSMutableArray array];
    
    return self;
}

-(void)addStatus: (kTDStatus)type forDuration: (NSInteger) duration
{
    NNStatusEffect *status = [NNStatusEffect statusWithType:type duration:duration];
    [self addChild: status];
    [statusArray addObject:status];
}

-(void)removeStatus: (kTDStatus)type
{
    for (NNStatusEffect *status in statusArray)
    {
        if([status tag] == type)
        {
            [statusArray removeObject: status];
            status = nil;
        }
    }
}

@end
