//
//  PFHeap.h
//  TDKit
//
//  Created by Tommy Allen on 7/19/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFNode.h"

@interface PFHeap : NSObject
{
	NSMutableArray *_nodes;
}

-(BOOL)empty;
-(void)clear;
-(UInt32)size;
-(PFNode *)push:(PFNode *)obj;
-(PFNode *)pop;
-(PFNode *)replace:(PFNode *)obj;
-(PFNode *)pushPop:(PFNode *)obj;
-(PFNode *)peek;
-(void)dump;

@end
