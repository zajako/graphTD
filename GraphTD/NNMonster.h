//
//  NNMonster.h
//  TDKit
//
//  Created by James Covey on 7/31/13.
//  Copyright 2013 Nevernull. All rights reserved.
//


#import "NNEntity.h"

@interface NNMonster : NNEntity {
    
}

@property (retain) NSNumber *unitFireRate;
@property (retain) NSNumber *unitRange;
@property (retain) NSNumber *unitRotateSpeed;
@property (retain) NSNumber *unitSpeedMin;
@property (retain) NSNumber *unitSpeedMax;

@property (retain) NSString *projectileSprite;
@property (retain) NSString *projectileExplosion;
@property (retain) NSNumber *projectileDamage;
@property (retain) NSNumber *projectileSplash;
@property (retain) NSNumber *projectileSpeed;
@property (retain) NSNumber *projectileRange;

+(id)monsterWithConfig:(NSString *)file;

-(id)initWithConfig:(NSString *)file;
-(float)randFloatBetween:(float)low and:(float)high;

-(void)seekAndDestroy;

@end
