//
//  CCTMXLayer+CCTMXLayer_Helpers.h
//  TDKit
//
//  Created by Tommy Allen on 7/11/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "cocos2d.h"

@interface CCTMXLayer (Helpers)
-(BOOL)hasProperty:(NSString *)name;
-(NSDictionary *)propertiesForTile:(CGPoint)coord;
-(BOOL)tile:(CGPoint) coords hasProperty:(NSString *)name;
@end
