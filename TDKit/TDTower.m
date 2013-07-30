//
//  TDTower.m
//  TDKit
//
//  Created by Tommy Allen on 7/14/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "TDTower.h"
#import "TDProjectile.h"

@implementation TDTower

-(void)onEnter
{
	[super onEnter];
	[self schedule:@selector(seekAndDestroy) interval:0.2];
}

-(void)seekAndDestroy
{
//	[self stopActionByTag:kTDActionRotate];
	
	TDEntity *target = [_map entity:kTDEntityCreep withinRange:100 from:[self position]];
	
	if (target == nil)
	{
		return;
	}
	
	float angle = ccpToAngle(ccpSub([target position], [self position]));
	angle = -1 * CC_RADIANS_TO_DEGREES(angle) + 90;
	
	CCRotateTo *rotate = [CCRotateTo actionWithDuration:0.1 angle:angle];
	
	CCCallBlock *f = [CCCallBlock actionWithBlock:^{
		TDProjectile *projectile = (TDProjectile *)[TDProjectile entityWithImageFile:@"WarTanks_GameArt/bullet_blue.png"];
		[projectile setHp:2];
		[projectile setTarget:target];
		[projectile setSource:self];
		[projectile setRotation:angle];
		[projectile setRange:100];
		[projectile setSpeed:300];
		[projectile setPosition:[self position]];
		[projectile setExplosionFile:@"ProjectileExplosion.plist"];
		[_map addProjectile:projectile];
	}];
	
	CCSequence *seq = [CCSequence actions:rotate, f, nil];
	
	[[self getChildByTag:kTDEntitySprite] runAction:seq];
}

@end
