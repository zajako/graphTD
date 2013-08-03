//
//  NNProjectile.m
//  TDKit
//
//  Created by James Covey on 7/31/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "NNProjectile.h"
#import "NNTower.h"
#import "NNMonster.h"


@implementation NNProjectile

@synthesize splashRange,statusEffect;

+(id)projectileWithTower:(NNTower *)tower
{
    return [[[self alloc] initWithTower:tower] autorelease];
}

+(id)projectileWithMonster:(NNMonster *)monster
{
    return [[[self alloc] initWithMonster:monster] autorelease];
}

-(void)dealloc
{
    [self setSplashRange:nil];
    
    [super dealloc];
}

-(id)initWithTower:(NNTower *)tower
{
    self = [super initWithImageFile:[tower projectileSprite]];
    
    [self setHp: [[tower projectileDamage] intValue]];
    [self setRange: [[tower projectileRange] floatValue]];
    [self setSpeed: [[tower projectileSpeed] floatValue]];
    [self setExplosionFile: [tower projectileExplosion]];
    [self setSplashRange: [tower projectileSplash]];
    [self setStatusEffect: [tower projectileStatus]];
    
    return self;
}

-(id)initWithMonster:(NNMonster *)monster
{
    self = [super initWithImageFile:[monster projectileSprite]];
    
    [self setHp: [[monster projectileDamage] intValue]];
    [self setRange: [[monster projectileRange] floatValue]];
    [self setSpeed: [[monster projectileSpeed] floatValue]];
    [self setExplosionFile: [monster projectileExplosion]];
    [self setSplashRange: [monster projectileSplash]];
    [self setStatusEffect: [monster projectileStatus]];
    
    return self;
}

-(void)checkCollision
{
	if ([self target] != nil && [[self target] parent] != nil)
	{
		float targetRadius = [[self target] contentSize].width / 2;
		float projectileRadius = [self contentSize].width / 2;
		
		float dist = ccpDistance([[self target] position], [self position]);
		if (dist < (targetRadius + projectileRadius))
		{
            if([self statusEffect] > 0)
            {
                [(NNEntity *)[self target] addStatus: (kTDStatus)[self statusEffect] forDuration: 5];
            }
            
			[[self target] affectHP:[self hp]];
			[self stopAllActions];
			[self unscheduleAllSelectors];
			[self explode];
            
            //if splash damage nearby monsters
            if([self splashRange] > 0)
            {
                [self dealSplashDamage];
            }
		}
	}
}

-(void)dealSplashDamage
{
    NSMutableArray *nearbyTargets = nil;
    //This should be fetching an array of targets then looping them
    if([[self target] tag] == kTDEntityTower)
    {
        nearbyTargets = [_map entities:kTDEntityTower withinRange:[[self splashRange] intValue] from:[[self target] position]];
    }
    else if([[self target] tag] == kTDEntityCreep)
    {
        nearbyTargets = [_map entities:kTDEntityCreep withinRange:[[self splashRange] intValue] from:[[self target] position]];
    }
    
    if([nearbyTargets count] <= 0)
    {
        return;
    }
    
    for (NNEntity *splashTarget in nearbyTargets)
    {
        if(splashTarget != [self target])
        {
            if([self statusEffect] > 0)
            {
                [splashTarget addStatus: [self statusEffect] forDuration: 5];
            }
            [splashTarget affectHP:[self hp]];
        }
    }
}

@end
