//
//  TDAStar.h
//  TDKit
//
//  Created by Tommy Allen on 7/12/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TDMap;

@interface TDAStarNode:NSObject
@property CGPoint position;
@property double g;
@property double h;
@property double f;
@property (retain) TDAStarNode *parent;

+(id)node;
+(id)nodeWithPosition:(CGPoint)pos;

@end


@interface TDAStar : NSObject
{
@private;
	TDMap *_map;
	NSMutableArray *_opened;
	NSMutableArray *_closed;
}

-(id)initWithMap:(TDMap *)map;
-(NSArray *)pathFrom:(CGPoint)start To:(CGPoint)stop;

@end
