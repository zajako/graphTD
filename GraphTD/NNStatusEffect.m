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
    NNEntity *parent = (NNEntity *)[self parent];
    if([self tag] == kTDStatusSlow)
    {
        NSInteger newSpeed = [parent speed] * 0.5;
        [parent setSpeed: newSpeed];
    }
    
    [parent refreshPath];
}

-(void)endStatus
{
    [self removeStatus];
}

-(void)removeStatus
{
    NNEntity *parent = (NNEntity *)[self parent];
    if([self tag] == kTDStatusSlow)
    {
        NSInteger newSpeed = [parent speed] * 2;
        [parent setSpeed: newSpeed];
    }
    
    //Refresh the path to apply the change of speed
    [parent refreshPath];
    
    //Remove the Status Effect
    [self unscheduleAllSelectors];
    [self stopAllActions];
    [[self parent] removeChild:self];
}



@end
