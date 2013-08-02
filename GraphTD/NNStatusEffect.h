//
//  NNStatusEffect.h
//  TDKit
//
//  Created by James Covey on 8/2/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TDConstants.h"

@interface NNStatusEffect : CCSprite {
    
}

@property float buffLength;

+(id)statusWithType:(kTDStatus)status duration:(NSInteger)duration;

-(id)initStatusWithType:(kTDStatus)status duration:(NSInteger)duration;

-(void)applyStatus;

-(void)endStatus;

-(void)removeStatus;

@end
