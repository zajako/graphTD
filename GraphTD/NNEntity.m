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
    
    statusArray = [[NSMutableArray alloc] init];
    
    return self;
}

-(void)dealloc
{
    self.statusArray = nil;
    
    [super dealloc];
}

-(void)addStatus: (kTDStatus)type forDuration: (NSInteger) duration
{
    if(![self hasStatus:type])
    {
        NNStatusEffect *status = [NNStatusEffect statusWithType:type duration:duration];
        [self addChild: status];
        [status setAnchorPoint:ccp(0, 0)];
        [status setPosition:ccp(-15, -15)];
        [status setVisible:YES];
        [statusArray addObject:status];
    }
    
}

-(BOOL)hasStatus: (kTDStatus)type
{
    for (NNStatusEffect *status in statusArray)
    {
        if([status tag] == type)
        {
            return YES;
        }
    }
    return NO;
}

-(void)removeStatus: (kTDStatus)type
{
    for (NNStatusEffect *status in statusArray)
    {
        if([status tag] == type)
        {
            [statusArray removeObject: status];
            [status endStatus];
            status = nil;
        }
    }
}

-(void)refreshPath
{
    [_map recalculateCreepPath];
}

@end
