//
//  TDBarGuage.h
//  TDKit
//
//  Created by Tommy Allen on 7/15/13.
//  Copyright 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TDBarGuage : CCSprite {
    CGPoint _r1;
	CGPoint _r2;
	
	CCSprite *_bar;
	CCSprite *_bg;
	
	ccColor4F _color;
	ccColor4F _bgColor;
	float _barScale;
	CCRenderTexture *_rt;
}

@property BOOL autoShow;

+(TDBarGuage *)guage;

-(void)setColor:(ccColor3B)color;
-(void)setBGColor:(ccColor3B)color;
-(void)setBarValue:(float)n outOf:(float)t;

@end
