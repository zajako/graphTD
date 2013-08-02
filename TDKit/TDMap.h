//
//  TDMap.h
//  TDKit
//
//  Created by Tommy Allen on 7/11/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "cocos2d.h"
#import "TDConstants.h"

@class TDEntity;
@class TDAStar;

@interface TDMap : CCTMXTiledMap
{
@private
	uint8_t *_collision_map;
	uint32_t _tiles;
	TDAStar *_pathFinder;
	NSArray *_pathCache;
}

@property(readonly) CGPoint start;
@property(readonly) CGPoint finish;
@property(readonly) NSUInteger width;
@property(readonly) NSUInteger height;

-(id)initWithTMXFile:(NSString *)tmxFile;

#pragma mark - Specific Entities
-(void)addTower:(TDEntity *)entity atTile:(CGPoint)pos;
-(void)addProjectile:(TDEntity *)entity;
-(void)spawnCreep:(TDEntity *)entity;
-(TDEntity *)entity:(kTDEntity)entityType withinRange:(float)range from:(CGPoint)pos;
-(NSMutableArray *)entities:(kTDEntity)entityType withinRange:(float)range from:(CGPoint)pos;

#pragma mark - Entity Reporting
-(void)entityDied:(TDEntity *)entity;
-(void)entityEscaped:(TDEntity *)entity;
-(void)entityStopped:(TDEntity *)entity;

#pragma mark - Walls
-(void)addWallAt:(CGPoint)pos;
-(void)removeWallAt:(CGPoint)pos;
-(BOOL)isWallAt:(CGPoint)pos;
-(void)recalculateCreepPath;
-(NSArray *)creepPath;

#pragma mark - Sprites
-(void)addEntity:(TDEntity *)entity;
-(void)addEntity:(TDEntity *)entity atTile:(CGPoint)pos;
-(void)addEntity:(TDEntity *)entity atPosition:(CGPoint)pos;
-(CGPoint)tileForPosition:(CGPoint)pos;
-(CGPoint)positionForTile:(CGPoint)pos;
-(CGPoint)tileForNode:(CCNode *)node;
-(NSArray *)pathForEntity:(TDEntity *)entity;

@end
