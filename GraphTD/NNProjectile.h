//
//  NNProjectile.h
//  TDKit
//
//  Created by James Covey on 7/31/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "TDProjectile.h"

@class NNTower;
@class NNMonster;

@interface NNProjectile : TDProjectile {
    
}

@property (retain) NSNumber *splashRange;
@property kTDStatus *statusEffect;

+(id)projectileWithTower:(NNTower *)tower;
+(id)projectileWithMonster:(NNMonster *)monster;

-(id)initWithTower:(NNTower *)tower;
-(id)initWithMonster:(NNMonster *)monster;

-(void)checkCollision;
-(void)dealSplashDamage;


@end
