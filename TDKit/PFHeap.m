//
//  PFHeap.m
//  TDKit
//
//  Created by Tommy Allen on 7/19/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "PFHeap.h"

@implementation PFHeap

-(id)init
{
	if (self = [super init])
	{
		_nodes = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)dealloc
{
	[_nodes removeAllObjects];
	[_nodes release];
	
	[super dealloc];
}

#pragma mark - Heap
-(BOOL)empty
{
	return [_nodes count] == 0;
}

-(void)clear
{
	[_nodes removeAllObjects];
}

-(UInt32)size
{
	return [_nodes count];
}

-(PFNode *)push:(PFNode *)obj
{
	[_nodes addObject:obj];
	return [self siftDownFrom:0 to:[_nodes count] - 1];
}

-(PFNode *)pop
{
	PFNode *ret = nil;
	PFNode *last = [_nodes lastObject];
	[_nodes removeLastObject];
	
	if ([_nodes count] > 0)
	{
		ret = [_nodes objectAtIndex:0];
		[_nodes replaceObjectAtIndex:0 withObject:last];
		[self siftUpFrom:0];
	}
	else
	{
		ret = last;
	}
	
	return ret;
}

-(PFNode *)replace:(PFNode *)obj
{
	PFNode *ret = [_nodes objectAtIndex:0];
	[_nodes replaceObjectAtIndex:0 withObject:obj];
	[self siftUpFrom:0];
	return ret;
}

-(PFNode *)pushPop:(PFNode *)obj
{
	PFNode *ret = obj;
	if ([_nodes count] > 0 && [self cmpA:[_nodes objectAtIndex:0] B:obj] < 0)
	{
		ret = [_nodes objectAtIndex:0];
		[_nodes replaceObjectAtIndex:0 withObject:obj];
		[self siftUpFrom:0];
	}
	return ret;
}

-(PFNode *)peek
{
	if ([_nodes count] == 0)
	{
		return nil;
	}
	
	return [_nodes objectAtIndex:0];
}

-(void)dump
{
	NSLog(@"Heap: %@", _nodes);
}

#pragma mark - Private
-(int)cmpA:(PFNode *)a B:(PFNode *)b
{
	return [a f] - [b f];
}

-(PFNode *)siftDownFrom:(int)start to:(int)end
{
	PFNode *new = [_nodes objectAtIndex:end];
	PFNode *parent = nil;
	int parentPos = 0;
	
	while (end > start)
	{
		parentPos = (end - 1) >> 1;
		parent = [_nodes objectAtIndex:parentPos];
		if ([self cmpA:new B:parent] < 0)
		{
			[_nodes replaceObjectAtIndex:end withObject:parent];
			end = parentPos;
			continue;
		}
		break;
	}
	
	[_nodes replaceObjectAtIndex:end withObject:new];
	return new;
}

-(PFNode *)siftUpFrom:(int)pos
{
	int endPos = [_nodes count];
	int startPos = pos;
	void *new = [_nodes objectAtIndex:pos];
	int childPos = 2 * pos + 1;
	int rightPos = 0;
	
	while (childPos < endPos)
	{
		rightPos = childPos + 1;
		if (rightPos < endPos && (![self cmpA:[_nodes objectAtIndex:childPos] B:[_nodes objectAtIndex:rightPos]] < 0))
		{
			childPos = rightPos;
		}
		[_nodes replaceObjectAtIndex:pos withObject:[_nodes objectAtIndex:childPos]];
		pos = childPos;
		childPos = 2 * pos + 1;
	}
	
	[_nodes replaceObjectAtIndex:pos withObject:new];
	return [self siftDownFrom:startPos to:pos];
}

@end
