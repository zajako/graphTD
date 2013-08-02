//
//  TDMap.m
//  TDKit
//
//  Created by Tommy Allen on 7/11/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "TDMap.h"
#import "NSString+NSString_Search.h"
#import "CCTMXLayer+Helpers.h"
#import "TDAStar.h"
#import "TDEntity.h"

@interface TDMap (Private)
-(void)_setupLayer:(CCTMXLayer *)layer;
-(void)_buildCollisionMap:(CCTMXLayer *)layer;
-(void)_dumpCollisionMap;
@end

@implementation TDMap

#pragma mark - Instance
-(id)initWithTMXFile:(NSString *)tmxFile
{
	if (self = [super initWithTMXFile:tmxFile])
	{
		CGSize size = [self mapSize];
		_width = size.width;
		_height = size.height;
		_tiles = _width * _height;
		
		// Initialize the collision map and blank it out with zeros
		// The map size cannot be resized after this. If it needs to resize,
		// there will need to be a method to reallocate a new _collision_map
		_collision_map = (uint8_t *)malloc(_tiles);
		memset(_collision_map, 0, _tiles);
		
		CCNode *child;
		CCARRAY_FOREACH([self children], child)
		{
			if ([child isKindOfClass:[CCTMXLayer class]])
			{
				[self _setupLayer:(CCTMXLayer *)child];
			}
		}
		
		_pathFinder = [[TDAStar alloc] initWithMap:self];
		
		[[CCTextureCache sharedTextureCache] addImage:@"Creeps/triangle-black.png"];
		
		[self recalculateCreepPath];
	}

	return self;
}

-(void)dealloc
{
	free(_collision_map);
	
	[_pathFinder release];
	[super dealloc];
}

#pragma mark - Specific Entities
-(void)addTower:(TDEntity *)entity atTile:(CGPoint)pos
{
	[entity setTag:kTDEntityTower];
	[self addEntity:entity atTile:pos];
	[self addWallAt:pos];
}

-(void)addProjectile:(TDEntity *)entity
{
	[entity setTag:kTDEntityProjectile];
	CGPoint pos = [entity position];
	[self addEntity:entity atPosition:pos];
}

-(void)spawnCreep:(TDEntity *)entity
{
	[entity setTag:kTDEntityCreep];
	[self addEntity:entity atTile:_start];
	[entity travelToFinish];
}

-(TDEntity *)entity:(kTDEntity)entityType withinRange:(float)range from:(CGPoint)pos
{
	float closestRange = FLT_MAX;
	CCNode *closest = nil;
	CCNode *node;
	CCARRAY_FOREACH(_children, node)
	{
		if ([node tag] == entityType && ![(TDEntity *)node dead])
		{
			float distance = ccpDistance(pos, [node position]);
			if (distance < range && distance < closestRange)
			{
				closestRange = distance;
				closest = node;
			}
		}
	}
	
	if (closest != nil)
	{
		return (TDEntity *)closest;
	}
	
	return nil;
}

-(NSMutableArray *)entities:(kTDEntity)entityType withinRange:(float)range from:(CGPoint)pos
{
    NSMutableArray *list = [NSMutableArray array];
    float closestRange = FLT_MAX;
	CCNode *node;
	CCARRAY_FOREACH(_children, node)
	{
		if ([node tag] == entityType && ![(TDEntity *)node dead])
		{
			float distance = ccpDistance(pos, [node position]);
			if (distance < range && distance < closestRange)
			{
                [list addObject:node];
			}
		}
	}

    return list;
}


#pragma mark - Entity Reporting
-(void)entityDied:(TDEntity *)entity
{
	// The entity will remove itself after this call completes. Leave it alone.
    NSLog(@"Entity Died: %@", entity);
    if([entity tag] == kTDEntityTower)
    {
        NSLog(@"Tower Died removing wall");
        [self removeWallAt:[entity tile]];
    }
}

-(void)entityEscaped:(TDEntity *)entity
{
	// Same as above.  Leave entity alone.
	NSLog(@"Entity Escaped: %@", entity);
}

-(void)entityStopped:(TDEntity *)entity
{
	// This essentially means that the entity got stuck and can't reach the end.
	// Manual removal or something is needed here.
	NSLog(@"Entity Stuck: %@", entity);
}

#pragma mark - Walls
-(void)addWallAt:(CGPoint)pos
{
	uint32_t index = [self pointToIndex:pos];
	_collision_map[index] = 1;
	[self recalculateCreepPath];
}

-(void)removeWallAt:(CGPoint)pos
{
    //NSLog(@"Wall Removed at %f,%f",pos.x,pos.y);
	uint32_t index = [self pointToIndex:pos];
	_collision_map[index] = 0;
    [self recalculateCreepPath];
}

-(BOOL)isWallAt:(CGPoint)pos
{
	if (pos.x < 0 || pos.x >= _width || pos.y < 0 || pos.y >= _height)
	{
		// Outside of the boundaries there are walls.
		return YES;
	}
	
	uint32_t index = [self pointToIndex:pos];
	return _collision_map[index] == 1;
}

-(void)recalculateCreepPath
{
	if (_pathCache != nil)
	{
		[_pathCache release];
		_pathCache = nil;
	}
	
	_pathCache = [[_pathFinder pathFrom:_start To:_finish] retain];
	
	CCNode *child;
	CCARRAY_FOREACH(_children, child)
	{
		if ([child tag] == kTDEntityCreep)
		{
			[(TDEntity *)child recalculatePath];
		}
	}
	
}

-(NSArray *)creepPath
{
	return _pathCache;
}

#pragma mark - Sprites
-(void)addEntity:(TDEntity *)entity
{
	[self addChild:entity z:[[self layerNamed:@"Background"] zOrder]];
	// Position it at the start position
	CGPoint pos = [self positionForTile:_start];
	[entity setPosition:pos];
}

-(void)addEntity:(TDEntity *)entity atTile:(CGPoint)pos
{
	[self addEntity:entity];
	[entity setPosition:[self positionForTile:pos]];
}

-(void)addEntity:(TDEntity *)entity atPosition:(CGPoint)pos
{
	[self addEntity:entity];
	[entity setPosition:pos];
}

-(CGPoint)tileForPosition:(CGPoint)pos
{
	pos = [[CCDirector sharedDirector] convertToGL:pos];
	CGSize size = [self tileSize];
	int h = [self mapSize].height;
	int x = pos.x / size.width;
	int y = ((h * size.height) - pos.y) / size.height;
	return ccp(x, y);
}

-(CGPoint)positionForTile:(CGPoint)pos
{
	CGSize size = [self tileSize];
	int h = [self mapSize].height;
	int x = (pos.x * size.width) + size.width / 2;
    int y = (h * size.height) - (pos.y * size.height) - size.height / 2;
    return ccp(x, y);
}

-(CGPoint)tileForNode:(CCNode *)node
{
	CGPoint pos = [[CCDirector sharedDirector] convertToUI:[node position]];
	return [self tileForPosition:pos];
}

-(NSArray *)pathForEntity:(TDEntity *)entity
{
	CGPoint pos = [self tileForNode:entity];
	return [_pathFinder pathFrom:pos To:_finish];
}

#pragma mark - Private Methods
-(uint32_t)pointToIndex:(CGPoint)pos
{
	return (int)pos.x + (int)pos.y * _width;
}

-(void)_setupLayer:(CCTMXLayer *)layer
{
	BOOL visible = YES;
	
	NSLog(@"LAYER: %@", [layer layerName]);
	
	if ([layer hasProperty:@"pathing"] || [[layer layerName] containsString:@"Pathing"])
	{
		visible = NO;
		[self _buildCollisionMap:layer];
	}
	
	[layer setAnchorPoint:ccp(0, 0)];
	[layer setVisible:visible];
}

-(void)_buildCollisionMap:(CCTMXLayer *)layer
{	
	for (uint8_t x = 0; x < _width; x++)
	{
		for (uint8_t y = 0; y < _height; y++)
		{
			CGPoint pos = ccp(x, y);
			CCSprite *tile = [layer tileAt:pos];
			
			if (tile != nil)
			{
				NSDictionary *props = [layer propertiesForTile:pos];
				if ([props objectForKey:@"Start"] != nil)
				{
					_start = pos;
				}
				else if ([props objectForKey:@"Finish"] != nil)
				{
					_finish = pos;
				}
				else
				{
					_collision_map[x + y * _width] = 1;
				}
			}
		}
	}
}

-(void)_dumpCollisionMap
{
	NSMutableString *line = [[[NSMutableString alloc] init] autorelease];
	
	for (uint8_t y = 0; y < _height; y++)
	{
		for (uint8_t x = 0; x < _width; x++)
		{
			if (_collision_map[x + y * _width] == 1)
			{
				[line appendString:@"#"];
			}
			else
			{
				[line appendString:@"."];
			}
		}
		NSLog(@"%@", line);
		[line setString:@""];
	}
}

@end
