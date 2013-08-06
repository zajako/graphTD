//
//  GameLayer.h
//  TDKit
//
//  Created by James Covey on 8/5/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "cocos2d.h"
#import "TDMap.h"
#import "NNEntity.h"
#import "NNTower.h"
#import "NNMonster.h"

@interface GameLayer : CCLayer {
    TDMap *_map;
    int _selectedTool;
    TDBarGuage *_healthGauge;
}

@property NSInteger hp;
@property NSInteger hpMax;

@property NSInteger mp;
@property NSInteger mpMax;

+(CCScene *) scene;
-(void)spawnCreep;
-(void)removeHealth: (NSInteger) amount;

@end
