//
//  HelloWorldLayer.m
//  TDKit
//
//  Created by Tommy Allen on 7/11/13.
//  Copyright Nevernull 2013. All rights reserved.
//

// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "PFHeap.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        _selectedTool = kTDBlaster;
		
		_map = [[TDMap alloc] initWithTMXFile:@"Maps/Template.tmx"];
		[self addChild:_map];
		[self schedule:@selector(spawnCreep) interval:1];
		
		PFHeap *heap = [[[PFHeap alloc] init] autorelease];
		PFNode *node = nil;
		
		for (int i = 0; i < 300; i++) {
			node = [[[PFNode alloc] init] autorelease];
			[node setF:[self randFloatBetween:0 and:100]];
			[heap push:node];
		}
		
		[heap dump];
	}
	return self;
}

-(float)randFloatBetween:(float)low and:(float)high
{
	float diff = high - low;
	return (((float)rand() / RAND_MAX) * diff) + low;
}

-(void)selectTool: (int)tool
{
    _selectedTool = tool;
}

-(void)spawnCreep
{
    int rand = [self randFloatBetween:1 and:100];
    NSString *monsterType = @"monster_circle";
    if(rand <= 90)
    {
        monsterType = @"monster_circle";
    }
    else
    {
        monsterType = @"monster_boss";
    }
    
	NNMonster *ent = [NNMonster monsterWithConfig:monsterType];
	[_map spawnCreep:ent];
}

-(void)onEnter
{
	[super onEnter];
	[self setTouchEnabled:YES];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint pos = [touch locationInView:[touch view]];
	pos = [_map tileForPosition:pos];
    
    
    
    
    if((pos.x >= 7 && pos.x <= 9) && (pos.y >= 21 && pos.y <= 23))
    {
        _selectedTool = kTDBlaster;
    }
    
    if((pos.x >= 10 && pos.x <= 12) && (pos.y >= 21 && pos.y <= 23))
    {
        _selectedTool = kTDBeam;
    }
    
    if((pos.x >= 13 && pos.x <= 15) && (pos.y >= 21 && pos.y <= 23))
    {
        _selectedTool = kTDSpazer;
    }

	
	if (![_map isWallAt:pos])
	{
        if(_selectedTool == kTDBlaster)
        {
            [_map addTower:[NNTower entityWithConfig:@"tower_blaster"] atTile:pos];
        }
        else if(_selectedTool == kTDBeam)
        {
            [_map addTower:[NNTower entityWithConfig:@"tower_beam"] atTile:pos];
        }
        else if(_selectedTool == kTDSpazer)
        {
            [_map addTower:[NNTower entityWithConfig:@"tower_spazer"] atTile:pos];
        }
        
        /*
        int rand = [self randFloatBetween:1 and:100];
        if(rand < 33)
        {
            [_map addTower:[NNTower entityWithConfig:@"tower_blaster"] atTile:pos];
        }
        else if(rand < 66)
        {
            [_map addTower:[NNTower entityWithConfig:@"tower_spazer"] atTile:pos];
        }
        else
        {
            [_map addTower:[NNTower entityWithConfig:@"tower_beam"] atTile:pos];
        }
         */
	}
    else
    {
        NSLog(@"Wall in current position");
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
