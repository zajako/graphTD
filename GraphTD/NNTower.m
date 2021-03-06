//
//  NNTower.m
//  TDKit
//
//  Created by James Covey on 7/30/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "NNTower.h"
#import "NNProjectile.h"

@implementation NNTower

@synthesize unitFireRate, unitRange, unitRotateSpeed;
@synthesize projectileSprite, projectileExplosion;
@synthesize projectileDamage, projectileSplash, projectileSpeed,projectileRange, projectileStatus;


-(void)dealloc
{
    [self setUnitFireRate:nil];
    [self setUnitRange:nil];
    [self setUnitRotateSpeed:nil];
    
	[self setProjectileSprite:nil];
    [self setProjectileExplosion:nil];
    [self setProjectileDamage:nil];
    [self setProjectileSplash:nil];
    [self setProjectileSpeed:nil];
    [self setProjectileRange:nil];
	
	[super dealloc];
}

+(id)entityWithConfig:(NSString *)file
{
	return [[[self alloc] initWithConfig:file] autorelease];
}

-(id)initWithConfig:(NSString *)file
{
    //Load Confg file for tower
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"gamedata/towers/%@.plist", file]];
    NSDictionary *plistData = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
    
    //load tower with image
	self = [super initWithImageFile: [plistData objectForKey:@"sprite"]];
    
    //Set Towers Stats From Config
    [self setUnitFireRate:[plistData valueForKey:@"tower-fireRate"]];
    [self setUnitRange:[plistData valueForKey:@"tower-range"]];
    [self setUnitRotateSpeed:[plistData valueForKey:@"tower-rotateSpeed"]];
    [self setHp:[[plistData valueForKey:@"tower-hp"] floatValue]];
    [self setHpMax:[[plistData valueForKey:@"tower-hp"] floatValue]];
    [self setMp:[[plistData valueForKey:@"tower-mp"] floatValue]];
    [self setMpMax:[[plistData valueForKey:@"tower-mp"] floatValue]];
    
    //Set Projectile stats acording to config
    [self setProjectileSprite:[plistData objectForKey:@"projectile-sprite"]];
    [self setProjectileExplosion:[plistData objectForKey:@"projectile-explosion"]];
    [self setProjectileDamage:[plistData valueForKey:@"projectile-damage"]];
    [self setProjectileSplash:[plistData valueForKey:@"projectile-splash"]];
    [self setProjectileSpeed:[plistData valueForKey:@"projectile-speed"]];
    [self setProjectileRange:[plistData valueForKey:@"projectile-range"]];
    [self setProjectileStatus:[[plistData valueForKey:@"projectile-status"] intValue]];
    
    return self;
}

-(void)onEnter
{
	[super onEnter];
	[self schedule:@selector(seekAndDestroy) interval:[[self unitFireRate] floatValue]];
}

-(void)seekAndDestroy
{
    //	[self stopActionByTag:kTDActionRotate];
	
	TDEntity *target = [_map entity:kTDEntityCreep withinRange:[[self unitRange] intValue] from:[self position]];
	
	if (target == nil)
	{
		return;
	}
	
	float angle = ccpToAngle(ccpSub([target position], [self position]));
	angle = -1 * CC_RADIANS_TO_DEGREES(angle) + 90;
	
    
    //Needs to somehow pause the intraval so that it doesn't fire while turning
	CCRotateTo *rotate = [CCRotateTo actionWithDuration:[[self unitRotateSpeed] floatValue] angle:angle];
	
	CCCallBlock *f = [CCCallBlock actionWithBlock:^{
		NNProjectile *projectile = [NNProjectile projectileWithTower:self];
		[projectile setTarget:target];
		[projectile setSource:self];
		[projectile setRotation:angle];
		[projectile setPosition:[self position]];
		[_map addProjectile:projectile];
	}];
	
	CCSequence *seq = [CCSequence actions:rotate, f, nil];
	
	[[self getChildByTag:kTDEntitySprite] runAction:seq];
}



@end
