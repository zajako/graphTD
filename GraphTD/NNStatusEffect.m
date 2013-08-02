//
//  NNStatusEffect.m
//  TDKit
//
//  Created by James Covey on 8/2/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "NNStatusEffect.h"
#import "NNEntity.h"


@implementation NNStatusEffect

@synthesize buffLength;

-(void)dealloc
{
    
    [super dealloc];
}

+(id)statusWithType:(kTDStatus)status duration:(NSInteger)duration
{
    return [[[self alloc] initStatusWithType:status duration:duration] autorelease];
}

-(id)initStatusWithType:(kTDStatus)status duration:(NSInteger)duration
{
    NSString *config = nil;
    if(status == kTDStatusSlow)
    {
        config = @"status_slow";
    }
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"gamedata/status/%@.plist", config]];
    NSDictionary *plistData = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
    
    //load tower with image
	self = [super initWithFile: [plistData objectForKey:@"sprite"]];
    
    self.buffLength = duration;
    self.tag = status;
    
    return self;
}

-(void)onEnter
{
	[super onEnter];
    [self applyStatus];
	[self schedule:@selector(removeStatus) interval:[self buffLength]];
}

-(void)applyStatus
{
    NNEntity *affected = (NNEntity *)_parent;
    if([self tag] == kTDStatusSlow)
    {
        NSInteger newSpeed = [affected speed] * 0.5;
        [affected setSpeed: newSpeed];
    }
    
    [affected refreshPath];
    NSLog(@"Buff Started: %f",[affected speed]);
}

-(void)endStatus
{
    [self removeStatus];
}

-(void)removeStatus
{
    NNEntity *affected = (NNEntity *)_parent;
    if([self tag] == kTDStatusSlow)
    {
        NSInteger newSpeed = [affected speed] * 2;
        [affected setSpeed: newSpeed];
    }
    [affected refreshPath];
    NSLog(@"Buff Ended: %f",[affected speed]);
    
    [self unscheduleAllSelectors];
    [self stopAllActions];
    [[self parent] removeChild:self];
}



@end
