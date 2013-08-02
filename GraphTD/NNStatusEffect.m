//
//  NNStatusEffect.m
//  TDKit
//
//  Created by James Covey on 8/2/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "NNStatusEffect.h"


@implementation NNStatusEffect

@synthesize buffLength;

+(id)statusWithType:(kTDStatus)status duration:(NSInteger)duration
{
    return [[[self alloc] initStatusWithType:status duration:duration] autorelease];
}

-(id)initStatusWithType:(kTDStatus)status duration:(NSInteger)duration
{
    self = [super init];
    
    self.buffLength = duration;
    self.tag = status;
    
    return self;
}

-(void)applyStatus
{
    
}

@end
