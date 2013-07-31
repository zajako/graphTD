//
//  PFJumpPointSearch.h
//  TDKit
//
//  Created by Tommy Allen on 7/19/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFNode;
@class PFGrid;

@interface PFJumpPointSearch : NSObject
{
	PFGrid *_grid;
}

-(id)initWithGrid:(PFGrid *)grid;

-(NSArray *)findPathFrom:(CGPoint)start To:(CGPoint)end;
-(void)identifySuccessors:(PFNode *)node;
-(NSArray *)findNeighbors:(PFNode *)node;
-(CGPoint)jumpFrom:(PFNode *)a To:(PFNode *)b;

@end
