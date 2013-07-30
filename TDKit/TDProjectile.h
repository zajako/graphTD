//
//  TDProjectile.h
//  TDKit
//
//  Created by Tommy Allen on 7/14/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "TDEntity.h"

@interface TDProjectile : TDEntity
{

}

@property float speed;
@property float range;
@property float a;
@property (retain) TDEntity *source;
@property (retain) TDEntity *target;

@end
