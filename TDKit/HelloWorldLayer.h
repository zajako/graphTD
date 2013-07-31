//
//  HelloWorldLayer.h
//  TDKit
//
//  Created by Tommy Allen on 7/11/13.
//  Copyright Nevernull 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "TDMap.h"
#import "NNEntity.h"
#import "TDTower.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	TDMap *_map;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void)spawnCreep;

@end
