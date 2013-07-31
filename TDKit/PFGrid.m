//
//  PFGrid.m
//  TDKit
//
//  Created by Tommy Allen on 7/19/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "PFGrid.h"
#import "PFNode.h"

@implementation PFGrid

@synthesize size;

-(id)initWithSize:(CGSize)gridSize
{
	if (self = [self init])
	{
		size = gridSize;
		_tiles = size.width * size.height;
		_nodes = [[NSMutableArray alloc] initWithCapacity:_tiles];
		for (int i = 0; i < _tiles; i++)
		{
			[_nodes addObject:[PFNode node]];
		}
	}
	return self;
}

-(void)dealloc
{
	[_nodes removeAllObjects];
	[_nodes release];
	[super dealloc];
}

-(PFNode *)nodeAt:(CGPoint)pos
{
	int i = pos.x + pos.y * size.width;
	if (i < _tiles)
	{
		return [_nodes objectAtIndex:i];
	}
	return nil;
}

-(BOOL)isWalkableAt:(CGPoint)pos
{
	PFNode *node = [self nodeAt:pos];
	if (node != nil)
	{
		return [node walkable];
	}
	return NO;
}

-(void)setWalkable:(BOOL)walkable at:(CGPoint)pos
{
	PFNode *node = [self nodeAt:pos];
	if (node != nil)
	{
		[node setWalkable:walkable];
	}
}

-(NSArray *)getNeighbors:(CGPoint)pos allowDiagonal:(BOOL)diagonal crossCorners:(BOOL)corners
{
	NSMutableArray *neighbors = [NSMutableArray array];
	
	CGPoint p;
	
	BOOL s0 = NO;
	BOOL s1 = NO;
	BOOL s2 = NO;
	BOOL s3 = NO;
	
	BOOL d0 = NO;
	BOOL d1 = NO;
	BOOL d2 = NO;
	BOOL d3 = NO;
	
	p = ccpAdd(pos, ccp(0, -1));
	if ([self isWalkableAt:p])
	{
		s0 = YES;
		[neighbors addObject:[self nodeAt:p]];
	}
	
	p = ccpAdd(pos, ccp(1, 0));
	if ([self isWalkableAt:p])
	{
		s1 = YES;
		[neighbors addObject:[self nodeAt:p]];
	}
	
	p = ccpAdd(pos, ccp(0, 1));
	if ([self isWalkableAt:p])
	{
		s2 = YES;
		[neighbors addObject:[self nodeAt:p]];
	}
	
	p = ccpAdd(pos, ccp(-1, 0));
	if ([self isWalkableAt:p])
	{
		s3 = YES;
		[neighbors addObject:[self nodeAt:p]];
	}
	
	if (!diagonal)
	{
		return neighbors;
	}
	
	if (!corners)
	{
		d0 = s3 && s0;
		d1 = s0 && s1;
		d2 = s1 && s2;
		d3 = s2 && s3;
	}
	else
	{
		d0 = s3 || s0;
		d1 = s0 || s1;
		d2 = s1 || s2;
		d3 = s2 || s3;
	}
	
	p = ccpAdd(pos, ccp(-1, -1));
	if (d0 && [self isWalkableAt:p])
	{
		[neighbors addObject:[self nodeAt:p]];
	}
	
	p = ccpAdd(pos, ccp(1, -1));
	if (d1 && [self isWalkableAt:p])
	{
		[neighbors addObject:[self nodeAt:p]];
	}
	
	p = ccpAdd(pos, ccp(1, 1));
	if (d2 && [self isWalkableAt:p])
	{
		[neighbors addObject:[self nodeAt:p]];
	}
	
	p = ccpAdd(pos, ccp(-1, 1));
	if (d3 && [self isWalkableAt:p])
	{
		[neighbors addObject:[self nodeAt:p]];
	}
	
	return neighbors;
}

@end
