//
//  TDEntity.h
//  TDKit
//
//  Created by Tommy Allen on 7/12/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TDMap.h"
#import "TDBarGuage.h"

@class TDMap;

@interface TDEntity : CCNode {
	TDMap *_map;
	CCParticleSystemQuad *_explosion;
	TDBarGuage *_healthGauge;
}

#pragma mark - Properties
@property (readonly) BOOL dead;
@property (readonly) CGPoint tile;

@property NSInteger hp;
@property NSInteger hpMax;

@property NSInteger mp;
@property NSInteger mpMax;

@property (retain) NSString *explosionFile;

@property float speed;

#pragma mark - Static
+(TDEntity *)entity;
+(TDEntity *)entityWithImageFile:(NSString *)file;

#pragma mark - Instance
-(id)initWithImageFile:(NSString *)file;

#pragma mark - Entity
-(void)despawn;
-(void)waitForExplosion;
-(void)explode;

#pragma mark - Characteristics
-(NSInteger)affectHP:(NSInteger)amount;
-(NSInteger)affectMP:(NSInteger)amount;

#pragma mark - Movement
-(void)recalculatePath;
-(void)travelToFinish;
-(void)travelEnded;

@end
