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

@synthesize splashRange;

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
    
    return self;
}

-(id)initWithMonster:(NNMonster *)monster
{
    self = [super initWithImageFile:[monster projectileSprite]];
    
    [self setHp: [monster projectileDamage]];
    [self setRange: [[monster projectileRange] floatValue]];
    [self setSpeed: [[monster projectileSpeed] floatValue]];
    [self setExplosionFile: [monster projectileExplosion]];
    [self setSplashRange: [monster projectileSplash]];
    
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
			[[self target] affectHP:[self hp]];
			[self stopAllActions];
			[self unscheduleAllSelectors];
			[self explode];
            
            //if splash damage nearby monsters
            if([self splashRange] > 0)
            {
                //This should be fetching an array of targets then looping them
                TDEntity *nearbyTargets = [_map entity:kTDEntityCreep withinRange:[[self splashRange] intValue] from:[[self target] position]];
                if (nearbyTargets == nil || nearbyTargets == [self target])
                {
                    return;
                }
                [nearbyTargets affectHP:[self hp]];
            }
            
            
            
		}
	}
}

@end
