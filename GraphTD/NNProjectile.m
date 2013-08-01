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

+(id)projectileWithTower:(NNTower *)tower
{
    return [[[self alloc] initWithTower:tower] autorelease];
}

+(id)projectileWithMonster:(NNMonster *)monster
{
    return [[[self alloc] initWithMonster:monster] autorelease];
}

-(id)initWithTower:(NNTower *)tower
{
    self = [super initWithImageFile:[tower projectileSprite]];
    
    [self setHp: [tower projectileDamage]];
    [self setRange: [[tower projectileRange] floatValue]];
    [self setSpeed: [[tower projectileSpeed] floatValue]];
    [self setExplosionFile: [tower projectileExplosion]];
    
    return self;
}

-(id)initWithMonster:(NNMonster *)monster
{
    self = [super initWithImageFile:[monster projectileSprite]];
    
    [self setHp: [monster projectileDamage]];
    [self setRange: [[monster projectileRange] floatValue]];
    [self setSpeed: [[monster projectileSpeed] floatValue]];
    [self setExplosionFile: [monster projectileExplosion]];
    
    return self;
}

@end
