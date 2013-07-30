//
//  TDEntity.m
//  TDKit
//
//  Created by Tommy Allen on 7/12/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "TDEntity.h"

@implementation TDEntity

@synthesize dead;
@synthesize tile;
@synthesize hp;
@synthesize hpMax;
@synthesize mp;
@synthesize mpMax;
@synthesize speed;
@synthesize explosionFile;

#pragma mark - Static
+(TDEntity *)entity
{
	return [[[self alloc] init] autorelease];
}

+(TDEntity *)entityWithImageFile:(NSString *)file
{
	return [[[self alloc] initWithImageFile:file] autorelease];
}

#pragma mark - Instance
-(id)init
{
	if (self = [super init])
	{
		hpMax = 100;
		hp = 100;
		mpMax = 100;
		mp = 100;
		speed = 50;
	}
	return self;
}

-(id)initWithImageFile:(NSString *)file
{
	if (self = [self init])
	{
		CCSprite *sprite = [CCSprite spriteWithFile:file];
		[self addChild:sprite z:0 tag:kTDEntitySprite];
		
		// Health guage might be better as a separate class
		_healthGauge = [CCNode node];
		CGSize size = [sprite contentSize];
		
		sprite = [CCSprite spriteWithFile:@"health-bg.png"];
		[sprite setAnchorPoint:ccp(0, 0)];
		[sprite setPosition:ccp(-15, 0)];
		[_healthGauge addChild:sprite];
		
		sprite = [CCSprite spriteWithFile:@"health.png"];
		[sprite setAnchorPoint:ccp(0, 0)];
		[sprite setPosition:ccp(-15, 0)];
		[_healthGauge addChild:sprite];
		
		CGPoint pos = CGPointZero;
		pos.y = (size.height / 2) + 8;
		[_healthGauge setAnchorPoint:ccp(0.5, 0.5)];
		[_healthGauge setPosition:pos];
//		[_healthGauge setVisible:NO];
		
		[self addChild:_healthGauge];
		
		[self schedule:@selector(rotateHealth)];
	}
	return self;
}

-(void)dealloc
{
	[self setExplosionFile:nil];
	[super dealloc];
}

-(void)rotateHealth
{
	[_healthGauge setRotation:-[self rotation]];
	float scale = max(0, (float)hp / (float)hpMax);
	[[[_healthGauge children] objectAtIndex:1] setScaleX:scale];
}

#pragma mark - Properties
-(CGPoint)tile
{
	if (_map == nil)
	{
		return CGPointZero;
	}
	
	return [_map tileForNode:self];
}

#pragma mark - Entity
-(void)despawn
{
	[self unscheduleAllSelectors];
	[self stopAllActions];
	[[self parent] removeChild:self];
}

-(void)waitForExplosion
{
	if (![_explosion active] && [_explosion particleCount] == 0)
	{
		[self removeChild:_explosion];
		[self despawn];
	}
}

-(void)explode
{
	// This is basically the end of the entity.  If there's no explosion file, just despawn.
	
	if ([self explosionFile] == nil)
	{
		return [self despawn];
	}
	
	[self unscheduleAllSelectors];
	[self stopAllActions];
	
	// The explosion particles should be the only thing left.
	[self removeAllChildren];
	
	_explosion = [CCParticleSystemQuad particleWithFile:[self explosionFile]];
	[self addChild:_explosion];
	[_explosion setPosition:ccp(0, 0)];
	[_explosion resetSystem];
	
	[self schedule:@selector(waitForExplosion)];
}

#pragma mark - Characteristics
-(NSInteger)affectHP:(NSInteger)amount
{
	if (dead)
	{
		return 0;
	}
	
	hp = hp - amount;
	if (hp <= 0)
	{
		dead = YES;
		[_map entityDied:self];
		[self explode];
	}
	return hp;
}

-(NSInteger)affectMP:(NSInteger)amount
{
	if (dead)
	{
		return 0;
	}
	
	mp = mp - amount;
	return mp;
}

#pragma mark - Cocos2d Override

-(CGSize)contentSize
{
	return [[self getChildByTag:kTDEntitySprite] contentSize];
}

-(void)onEnter
{
	[super onEnter];
	
	if ([_parent isKindOfClass:[TDMap class]])
	{
		_map = (TDMap *)_parent;
	}
}

#pragma mark - Movement
-(void)recalculatePath
{
	if ([self tag] == kTDEntityCreep)
	{
		CGPoint tilePos = [self tile];
		
		// Get a cached copy of the path
		NSArray *path = [_map creepPath];
		BOOL inCache = NO;
		NSUInteger i = 0;
		
		for (; i < [path count]; i++)
		{
			CGPoint p = [(NSValue *)[path objectAtIndex:i] CGPointValue];
			if (CGPointEqualToPoint(p, tilePos))
			{
				inCache = YES;
				break;
			}
		}
		
		if (inCache)
		{
			NSLog(@"Continuing on pre-determined path");
			NSRange r = NSMakeRange(i, [path count] - i);
			[self travelOnPath:[path subarrayWithRange:r]];
		}
		else
		{
			path = [_map pathForEntity:self];
			if (path == nil)
			{
				NSLog(@"Could not find a path!");
			}
			else
			{
				NSLog(@"Recalculated path");
				[self travelOnPath:path];
			}
		}
	}
}

-(void)travelEnded
{
	if (CGPointEqualToPoint([self tile], [_map finish]))
	{
		[_map entityEscaped:self];
		[self despawn];
	}
	else
	{
		[_map entityStopped:self];
	}
}

-(void)travelToFinish
{
	[self recalculatePath];
}

#pragma mark - Private
-(void)travelOnPath:(NSArray *)path
{
	[self stopActionByTag:kTDActionMove];
	NSMutableArray *moves = [NSMutableArray array];
	
	CCSequence *seq = nil;
	
	// Change speed to pixels per second
	float lastAngle = 0;
	
	CGPoint cur = [self position];
	
	for (NSUInteger i = 0, l = [path count] - 1; i < l; i++)
	{
		CGPoint nextTile = [(NSValue *)[path objectAtIndex:i + 1] CGPointValue];
		
		CGPoint next = [_map positionForTile:nextTile];
		
		float duration = ccpDistance(cur, next) / speed;
		
		float angle = ccpToAngle(ccpSub(next, cur));
		angle = -1 * CC_RADIANS_TO_DEGREES(angle) + 90;
		
		if (angle != lastAngle)
		{
			CCCallBlock *fu = [CCCallBlock actionWithBlock:^{
				[self stopActionByTag:kTDActionRotate]; // Just in case there's another rotate happening
				CCRotateTo *rotate = [CCRotateTo actionWithDuration:0.2 angle:angle];
				[rotate setTag:kTDActionRotate];
				[[self getChildByTag:kTDEntitySprite] runAction:rotate];
			}];
			
			[moves addObject:fu];
			
			lastAngle = angle;
		}
		
		CCMoveTo *move = [CCMoveTo actionWithDuration:duration position:next];
		[moves addObject:move];
		
		cur = next;
	}
	
	CCCallFunc *f = [CCCallFunc actionWithTarget:self selector:@selector(travelEnded)];
	[moves addObject:f];
	
	seq = [CCSequence actionWithArray:moves];
	[seq setTag:kTDActionMove];
	[self runAction:seq];
}

@end
