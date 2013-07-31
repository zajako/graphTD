//
//  NNProjectile.h
//  TDKit
//
//  Created by James Covey on 7/31/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "TDProjectile.h"

@class NNTower;

@interface NNProjectile : TDProjectile {
    
}

+(id)projectileWithTower:(NNTower *)tower;

-(id)initWithTower:(NNTower *)tower;


@end
