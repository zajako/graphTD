//
//  PFNode.m
//  TDKit
//
//  Created by Tommy Allen on 7/19/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "PFNode.h"

@implementation PFNode

@synthesize position;
@synthesize walkable;
@synthesize f;
@synthesize h;
@synthesize g;
@synthesize parent;

+(PFNode *)node
{
	return [[[[self class] alloc] init] autorelease];
}

-(id)init
{
	if (self = [super init])
	{
		[self setWalkable:YES];
	}
	return self;
}

-(void)dealloc
{
	[self reset];
	[super dealloc];
}

-(void)reset
{
	[self setF:0];
	[self setH:0];
	[self setG:0];
	[self setParent:nil];
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"<PFNode - %f>", f];
}

@end
