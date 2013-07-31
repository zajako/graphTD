//
//  PFGrid.h
//  TDKit
//
//  Created by Tommy Allen on 7/19/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class PFNode;

@interface PFGrid : NSObject
{
	UInt32 _tiles;
	NSMutableArray *_nodes;
}

@property CGSize size;

-(id)initWithSize:(CGSize)size;
-(PFNode *)nodeAt:(CGPoint)pos;
-(BOOL)isWalkableAt:(CGPoint)pos;
-(void)setWalkable:(BOOL)walkable at:(CGPoint)pos;
-(NSArray *)getNeighbors:(CGPoint)pos allowDiagonal:(BOOL)diagonal crossCorners:(BOOL)corners;

@end
