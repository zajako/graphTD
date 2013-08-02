//
//  NNMonster.m
//  TDKit
//
//  Created by James Covey on 7/31/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "NNMonster.h"
#import "NNProjectile.h"

@implementation NNMonster

@synthesize monsterFireRate, monsterRange, monsterRotateSpeed, monsterSpeedMin, monsterSpeedMax;
@synthesize projectileSprite, projectileExplosion;
@synthesize projectileDamage, projectileSplash, projectileSpeed, projectileRange;

-(void)dealloc
{
    [self setMonsterFireRate:nil];
    [self setMonsterRange:nil];
    [self setMonsterRotateSpeed:nil];
    [self setMonsterSpeedMin:nil];
    [self setMonsterSpeedMax:nil];
    
	[self setProjectileSprite:nil];
    [self setProjectileExplosion:nil];
    [self setProjectileDamage:nil];
    [self setProjectileSplash:nil];
    [self setProjectileSpeed:nil];
    [self setProjectileRange:nil];
	
	[super dealloc];
}

+(id)monsterWithConfig:(NSString *)file
{
	return [[[self alloc] initWithConfig:file] autorelease];
}

-(float)randFloatBetween:(float)low and:(float)high
{
	float diff = high - low;
	return (((float)rand() / RAND_MAX) * diff) + low;
}

-(id)initWithConfig:(NSString *)file
{
    //Load Confg file for tower
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"gamedata/monsters/%@.plist", file]];
    NSDictionary *plistData = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
    
    //load tower with image
	self = [super initWithImageFile: [plistData objectForKey:@"sprite"]];
    
    //Set Towers Stats From Config
    [self setMonsterFireRate:[plistData valueForKey:@"monster-fireRate"]];
    [self setMonsterRange:[plistData valueForKey:@"monster-range"]];
    [self setMonsterRotateSpeed:[plistData valueForKey:@"monster-rotateSpeed"]];
    [self setMonsterSpeedMin:[plistData valueForKey:@"monster-speedMin"]];
    [self setMonsterSpeedMax:[plistData valueForKey:@"monster-speedMax"]];
    [self setExplosionFile:[plistData valueForKey:@"monster-deathExplosion"]];
    [self setHp:[[plistData valueForKey:@"monster-hp"] floatValue]];
    [self setHpMax:[[plistData valueForKey:@"monster-hp"] floatValue]];
    [self setMp:[[plistData valueForKey:@"monster-mp"] floatValue]];
    [self setMpMax:[[plistData valueForKey:@"monster-mp"] floatValue]];
    
    //Set Projectile stats acording to config
    [self setProjectileSprite:[plistData objectForKey:@"projectile-sprite"]];
    [self setProjectileExplosion:[plistData objectForKey:@"projectile-explosion"]];
    [self setProjectileDamage:[plistData valueForKey:@"projectile-damage"]];
    [self setProjectileSplash:[plistData valueForKey:@"projectile-splash"]];
    [self setProjectileSpeed:[plistData valueForKey:@"projectile-speed"]];
    [self setProjectileRange:[plistData valueForKey:@"projectile-range"]];
    
    
    float speed = [self randFloatBetween:[[self monsterSpeedMin] floatValue] and: [[self monsterSpeedMax] floatValue]];
    [self setSpeed:speed];
    
    NSLog(@"Speed: %f, Health: %i", speed, [self hp]);
    
    return self;
}

-(void)onEnter
{
	[super onEnter];
    
    if([self monsterFireRate] > 0)
    {
        [self schedule:@selector(seekAndDestroy) interval:[[self monsterFireRate] floatValue]];
    }
	
}

-(void)seekAndDestroy
{
    //	[self stopActionByTag:kTDActionRotate];
	
	TDEntity *target = [_map entity:kTDEntityTower withinRange:[[self monsterRange] intValue] from:[self position]];
	
	if (target == nil)
	{
		return;
	}
	
	float angle = ccpToAngle(ccpSub([target position], [self position]));
	angle = -1 * CC_RADIANS_TO_DEGREES(angle) + 90;
	
    
    //Needs to somehow pause the intraval so that it doesn't fire while turning
	//CCRotateTo *rotate = [CCRotateTo actionWithDuration:[[self towerRotateSpeed] floatValue] angle:angle];
	
	CCCallBlock *f = [CCCallBlock actionWithBlock:^{
		NNProjectile *projectile = [NNProjectile projectileWithMonster:self];
		[projectile setTarget:target];
		[projectile setSource:self];
		[projectile setRotation:angle];
		[projectile setPosition:[self position]];
		[_map addProjectile:projectile];
	}];
	
	CCSequence *seq = [CCSequence actions:f, nil];
	
	[[self getChildByTag:kTDEntitySprite] runAction:seq];
}



@end
