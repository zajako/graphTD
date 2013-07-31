//
//  NNTower.h
//  TDKit
//
//  Created by James Covey on 7/30/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "TDEntity.h"

@interface NNTower : TDEntity {
    
}

@property (retain) NSNumber *towerFireRate;
@property (retain) NSNumber *towerRange;
@property (retain) NSNumber *towerRotateSpeed;

@property (retain) NSString *projectileSprite;
@property (retain) NSString *projectileExplosion;
@property (retain) NSNumber *projectileDamage;
@property (retain) NSNumber *projectileSpeed;
@property (retain) NSNumber *projectileRange;

+(id)entityWithConfig:(NSString *)file;

-(id)initWithConfig:(NSString *)file;

-(void)seekAndDestroy;

@end
