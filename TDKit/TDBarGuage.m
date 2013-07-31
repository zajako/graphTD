//
//  TDBarGuage.m
//  TDKit
//
//  Created by Tommy Allen on 7/15/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import "TDBarGuage.h"


@implementation TDBarGuage

@synthesize autoShow;

+(TDBarGuage *)guage
{
	return [[self class] node];
}

-(id)init
{
	if (self = [super init])
	{
		_barScale = 1;
		
		_bg = [CCSprite spriteWithFile:@"pixel.png"];
		_bar = [CCSprite spriteWithFile:@"pixel.png"];
		[_bg setAnchorPoint:ccp(0, 0)];
		[_bar setAnchorPoint:ccp(0, 0)];
		
		[self setCascadeOpacityEnabled:YES];
		[self addChild:_bg];
		[self addChild:_bar];
		
		[self setColor:(ccColor3B){0, 255, 0}];
		[self setBGColor:(ccColor3B){0, 0, 0}];
		[self setAnchorPoint:ccp(0, 0)];
		[self setAutoShow:YES];
	}
	
	return self;
}

-(void)onExit
{
	[super onExit];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
}

-(void)setColor:(ccColor3B)color
{
//	_color = ccc4FFromccc3B(color);
	[_bar setColor:color];
}

-(void)setBGColor:(ccColor3B)color
{
	[_bg setColor:color];
}

-(void)setContentSize:(CGSize)contentSize
{
	float scaleX = contentSize.width;
	float scaleY = contentSize.height;
	
	[_bg setScaleX:scaleX];
	[_bg setScaleY:scaleY];
	
	scaleX = contentSize.width * _barScale;
	[_bar setScaleX:scaleX];
	[_bar setScaleY:scaleY];
	
	CGPoint pos = ccp(-contentSize.width / 2, 0);
	[_bar setPosition:pos];
	[_bg setPosition:pos];
	
	[super setContentSize:contentSize];
}

-(void)hide
{
	[self setVisible:NO];
}

-(void)fadeOut
{
	NSLog(@"Fade out");
	CCFadeTo *fade = [CCFadeTo actionWithDuration:0.5 opacity:0];
	CCCallFunc *f = [CCCallFunc actionWithTarget:self selector:@selector(hide)];
	[self runAction:[CCSequence actions:fade, f, nil]];
}

-(void)setBarValue:(float)n outOf:(float)t
{
	_barScale = n / t;
	float w = [self contentSize].width;
	float scaleX = (w * _barScale);
	[_bar setScaleX:scaleX];
	
	if (autoShow)
	{
		[self setVisible:YES];
		[self setOpacity:255];
		[self stopAllActions];
		[NSObject cancelPreviousPerformRequestsWithTarget:self];
		[self performSelector:@selector(fadeOut) withObject:nil afterDelay:1];
	}
}

@end
