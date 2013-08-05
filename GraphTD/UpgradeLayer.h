//
//  UpgradeLayer.h
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

@interface UpgradeLayer : CCLayer {
    TDMap *_map;
    int _selectedTool;
}

+(CCScene *) scene;
-(void)spawnCreep;

@end
