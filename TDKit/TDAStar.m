//
//  TDAStar.m
//  TDKit
//
//  Created by Tommy Allen on 7/12/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "TDAStar.h"
#import "TDMap.h"

#pragma mark - TDAStarNode
@implementation TDAStarNode

@synthesize position, g, h, f, parent;

+(id)node
{
	return [[[TDAStarNode alloc] init] autorelease];
}

+(id)nodeWithPosition:(CGPoint)pos
{
	TDAStarNode *n = [TDAStarNode node];
	[n setPosition:pos];
	return n;
}

-(void)dealloc
{
	[self setParent:nil];
	[super dealloc];
}

@end


#pragma mark - TDAStar
@implementation TDAStar

-(id)initWithMap:(TDMap *)map
{
	if (self = [super init])
	{
		// This class will not care about the collision map, but instead check
		// with _map to see if walls exist.
		_map = [map retain];
		_opened = [[NSMutableArray array] retain];
		_closed = [[NSMutableArray array] retain];
	}

	return self;
}

-(void)dealloc
{
	[_map release];
	
	[_opened removeAllObjects];
	[_opened release];
	
	[_closed removeAllObjects];
	[_closed release];
	[super dealloc];
}

#pragma mark - Instance
-(NSArray *)pathFrom:(CGPoint)start To:(CGPoint)stop
{
	if ([_map isWallAt:start])
	{
		return nil;
	}
	
	double startTime = [[NSDate date] timeIntervalSince1970];
	
	[_opened removeAllObjects];
	[_closed removeAllObjects];
	
	TDAStarNode *startNode = [TDAStarNode nodeWithPosition:start];
	TDAStarNode *node = nil;
	NSArray *neighbors;
	
	[_opened addObject:startNode];
	
	double SQRT2 = sqrt(2);
	NSUInteger escape = 0;
	
	while ([_opened count] > 0)
	{
		escape++;
		if (escape > 5000)
		{
			NSLog(@"Stopping A* prematurely.");
			break;
		}
		
		node = [self lowestCostingNode:_opened];
		[_closed addObject:node];
		
		if (CGPointEqualToPoint([node position], stop))
		{
			// Break out and create the path.
			NSLog(@"A* Found path end.");
			break;
		}
		
		neighbors = [self getNeighbors:[node position] allowDiagonal:YES crossCorners:NO];
		for (TDAStarNode *neighbor in neighbors)
		{
			if ([self isNodeClosed:neighbor])
			{
				continue;
			}
			
			NSInteger dx = [neighbor position].x - [node position].x;
			NSInteger dy = [neighbor position].y - [node position].y;
			double ng = [node g] + ((dx == 0 || dy == 0) ? 1 : SQRT2);
			
			if (![self isNodeOpened:neighbor] || ng < [neighbor g])
			{
				[neighbor setG:ng];
				[neighbor setH:[self heuristicManhattanFrom:[neighbor position] To:stop]];
				[neighbor setF:[neighbor g] + [neighbor h]];
				[neighbor setParent:node];
				[_opened addObject:neighbor];
			}
		}
	}
	
	NSMutableArray *path = [NSMutableArray array];
	TDAStarNode *parent = node;
	while (parent != nil)
	{
		[path insertObject:[NSValue valueWithCGPoint:[parent position]] atIndex:0];
		parent = [parent parent];
	}
	
	[_opened removeAllObjects];
	[_closed removeAllObjects];
	
	NSLog(@"A* Path finding elapsed: %f", [[NSDate date] timeIntervalSince1970] - startTime);
	
	return path;
}

#pragma mark - Private
-(double)heuristicManhattanFrom:(CGPoint)start To:(CGPoint)stop
{
	return abs(start.x - stop.x) + abs(start.y - stop.y);
}

-(BOOL)isNodeOpened:(TDAStarNode *)node
{
	for (TDAStarNode *openedNode in _opened)
	{
		if (CGPointEqualToPoint([node position], [openedNode position]))
		{
			return YES;
		}
	}
	return NO;
}

-(BOOL)isNodeClosed:(TDAStarNode *)node
{
	for (TDAStarNode *closedNode in _closed)
	{
		if (CGPointEqualToPoint([node position], [closedNode position]))
		{
			return YES;
		}
	}
	return NO;
}

-(TDAStarNode *)lowestCostingNode:(NSMutableArray *)nodeList
{
	TDAStarNode *lowest = nil;
	for (TDAStarNode *node in nodeList)
	{
		if (lowest == nil || node.f < lowest.f)
		{
			lowest = node;
		}
	}
	
	if (lowest != nil)
	{
		[nodeList removeObject:lowest];
	}
	else
	{
		NSLog(@"Could not find the lowest costing node.  Is problem!");
	}
	
	return lowest;
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
	if (![_map isWallAt:p])
	{
		s0 = YES;
		[neighbors addObject:[TDAStarNode nodeWithPosition:p]];
	}
	
	p = ccpAdd(pos, ccp(1, 0));
	if (![_map isWallAt:p])
	{
		s1 = YES;
		[neighbors addObject:[TDAStarNode nodeWithPosition:p]];
	}
	
	p = ccpAdd(pos, ccp(0, 1));
	if (![_map isWallAt:p])
	{
		s2 = YES;
		[neighbors addObject:[TDAStarNode nodeWithPosition:p]];
	}
	
	p = ccpAdd(pos, ccp(-1, 0));
	if (![_map isWallAt:p])
	{
		s3 = YES;
		[neighbors addObject:[TDAStarNode nodeWithPosition:p]];
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
	if (d0 && ![_map isWallAt:p])
	{
		[neighbors addObject:[TDAStarNode nodeWithPosition:p]];
	}
	
	p = ccpAdd(pos, ccp(1, -1));
	if (d1 && ![_map isWallAt:p])
	{
		[neighbors addObject:[TDAStarNode nodeWithPosition:p]];
	}
	
	p = ccpAdd(pos, ccp(1, 1));
	if (d2 && ![_map isWallAt:p])
	{
		[neighbors addObject:[TDAStarNode nodeWithPosition:p]];
	}
	
	p = ccpAdd(pos, ccp(-1, 1));
	if (d3 && ![_map isWallAt:p])
	{
		[neighbors addObject:[TDAStarNode nodeWithPosition:p]];
	}
	
	return neighbors;
}

@end
