//
//  PFNode.h
//  TDKit
//
//  Created by Tommy Allen on 7/19/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFNode : NSObject

@property CGPoint position;
@property BOOL walkable;
@property double f; // Cost
@property double h; // Heuristic
@property double g; // Score
@property (retain) PFNode *parent;

+(PFNode *)node;

-(void)reset;

@end
