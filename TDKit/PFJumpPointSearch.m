//
//  PFJumpPointSearch.m
//  TDKit
//
//  Created by Tommy Allen on 7/19/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "PFJumpPointSearch.h"
#import "PFHeap.h"
#import "PFGrid.h"
#import "PFNode.h"

@implementation PFJumpPointSearch

-(id)initWithGrid:(PFGrid *)grid
{
	if (self = [self init])
	{
		_grid = [grid retain];
	}
	return self;
}

-(void)dealloc
{
	[_grid release];
	[super dealloc];
}

-(NSArray *)findNeighbors:(PFNode *)node
{
	PFNode *parent = [node parent];
	
	if (parent == nil)
	{
		return [_grid getNeighbors:[node position] allowDiagonal:YES crossCorners:NO];
	}
	
	NSMutableArray *neighbors = [NSMutableArray array];
	
	CGPoint parentPos = [parent position];
	CGPoint nodePos = [node position];
	CGPoint d = CGPointZero;
	d.x = (nodePos.x - parentPos.x) / MAX(fabsf(nodePos.x - parentPos.x), 1);
	d.y = (nodePos.y - parentPos.y) / MAX(fabsf(nodePos.y - parentPos.y), 1);
	
}

@end
