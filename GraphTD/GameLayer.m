//
//  GameLayer.m
//  TDKit
//
//  Created by James Covey on 8/5/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "GameLayer.h"
#import "AppDelegate.h"
#import "PFHeap.h"
#import "HelloWorldLayer.h"

@implementation GameLayer

@synthesize hp;
@synthesize hpMax;
@synthesize mp;
@synthesize mpMax;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
        CCSprite* backgroundImage = [CCSprite spriteWithFile:@"gameimg/backgrounds/title.png"];
        backgroundImage.position = ccp(512, 384);
        [self addChild:backgroundImage z:0];
        
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
        
        
        hpMax = 10000;
		hp = 10000;
		mpMax = 100;
		mp = 100;
        
        _healthGauge = [TDBarGuage guage];
		[_healthGauge setContentSize:CGSizeMake(100, 10)];
        _healthGauge.position = ccp(70, 75);
        [_healthGauge setAutoShow:NO];
		[self addChild:_healthGauge];
        
        
        [_healthGauge setBarValue:hp outOf:hpMax];
        
	}
	return self;
}

-(void)removeHealth: (NSInteger) amount
{
    hp = max(0, min(hpMax, hp - amount));
	[_healthGauge setBarValue:hp outOf:hpMax];
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
    
    //These are the normal tower buttons
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
     
    if((pos.x >= 16 && pos.x <= 18) && (pos.y >= 21 && pos.y <= 23))
    {
        _selectedTool = kTDSplash;
    }
     
    if((pos.x >= 19 && pos.x <= 21) && (pos.y >= 21 && pos.y <= 23))
    {
        _selectedTool = kTDTime;
    }
    
    if((pos.x >= 29 && pos.x <= 30) && (pos.y >= 21 && pos.y <= 23))
    {
        NSLog(@"MENUUUUUU!!!");
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
    }
    
    /*
    //Buttons for titles
    if((pos.x >= 4 && pos.x <= 6) && (pos.y >= 21 && pos.y <= 23))
    {
        NSLog(@"Start Button Pressed LETS GET IT STARTED!");
    }
    
    if((pos.x >= 15 && pos.x <= 18) && (pos.y >= 21 && pos.y <= 23))
    {
        NSLog(@"AHHHHHH SHITTTT, Lets get Back to the ACTION!");
    }
    
    if((pos.x >= 26 && pos.x <= 28) && (pos.y >= 21 && pos.y <= 23))
    {
        NSLog(@"UPGRAYEDD, with a double D for a double dose of pimping!");
    }
    */
    
	
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
        else if(_selectedTool == kTDSplash)
        {
            [_map addTower:[NNTower entityWithConfig:@"tower_splash"] atTile:pos];
        }
        else if(_selectedTool == kTDTime)
        {
            [_map addTower:[NNTower entityWithConfig:@"tower_time"] atTile:pos];
        }
	}
    else
    {
        NSLog(@"Wall in current position");
    }
}

- (void) dealloc
{

	[super dealloc];
}


@end
