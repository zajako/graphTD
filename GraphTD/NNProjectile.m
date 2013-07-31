//
//  NNProjectile.m
//  TDKit
//
//  Created by James Covey on 7/31/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "NNProjectile.h"
#import "NNTower.h"


@implementation NNProjectile

+(id)projectileWithTower:(NNTower *)tower
{
    return [[[self alloc] initWithTower:tower] autorelease];
}

-(id)initWithTower:(NNTower *)tower
{
    NSLog(@"init with tower: %@", tower.projectileSprite);
    
    self = [super initWithImageFile:tower.projectileSprite];
    
    [self setHp: tower.projectileDamage];
    [self setRange: [[tower projectileRange] floatValue]];
    [self setSpeed: [[tower projectileSpeed] floatValue]];
    [self setExplosionFile: [tower projectileExplosion]];
    
    return self;
}

@end
