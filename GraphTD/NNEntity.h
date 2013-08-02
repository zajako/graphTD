//
//  NNEntity.h
//  TDKit
//
//  Created by James Covey on 7/30/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "TDEntity.h"

@class NNStatusEffect;

@interface NNEntity : TDEntity {
    
}

@property (retain) NSMutableArray *statusArray;

-(id)initWithImageFile:(NSString *)file;

-(void)addStatus: (kTDStatus)type forDuration: (NSInteger) duration;

-(void)removeStatus: (kTDStatus)type;
-(void)refreshPath;

@end
