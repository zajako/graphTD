//
//  TDProjectile.m
//  TDKit
//
//  Created by Tommy Allen on 7/14/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "TDProjectile.h"

@implementation TDProjectile

@synthesize speed;
@synthesize range;
@synthesize source;
@synthesize target;

-(void)dealloc
{
	[self setSource:nil];
	[self setTarget:nil];
	
	[super dealloc];
}

-(void)despawn
{
	[[self parent] removeChild:self];
}

-(void)checkCollision
{
	if ([self target] != nil && [[self target] parent] != nil)
	{
		float targetRadius = [target contentSize].width / 2;
		float projectileRadius = [self contentSize].width / 2;
		
		float dist = ccpDistance([target position], [self position]);
		if (dist < (targetRadius + projectileRadius))
		{
			[target affectHP:[self hp]];
			[self stopAllActions];
			[self unscheduleAllSelectors];
			[self explode];
		}
	}
}

-(void)onEnter
{
	[super onEnter];
	
	[_healthGauge setVisible:NO];
	
	float angle = ccpToAngle(ccpSub([target position], [source position]));
	CGPoint dest = [source position];
	dest.x += range * cosf(angle);
	dest.y += range * sinf(angle);
	
	float duration = ccpDistance([source position], dest) / speed;
	
	CCMoveTo *move = [CCMoveTo actionWithDuration:duration position:dest];
	CCCallFunc *f = [CCCallFunc actionWithTarget:self selector:@selector(despawn)];
	CCSequence *seq = [CCSequence actions:move, f, nil];
	
	[self schedule:@selector(checkCollision)];
	[self runAction:seq];
}

@end
