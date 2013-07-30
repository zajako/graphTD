//
//  CCTMXLayer+CCTMXLayer_Helpers.m
//  TDKit
//
//  Created by Tommy Allen on 7/11/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import "CCTMXLayer+Helpers.h"

@implementation CCTMXLayer (Helpers)

-(BOOL)hasProperty:(NSString *)name
{
	return [[self properties] objectForKey:name] != nil;
}

-(NSDictionary *)propertiesForTile:(CGPoint)coord
{
	// Parent BETTER be a CCTMXTiledMap
	CCTMXTiledMap *parent = (CCTMXTiledMap *)[self parent];
	uint32_t gid = [self tileGIDAt:coord];
	return [parent propertiesForGID:gid];
}

-(BOOL)tile:(CGPoint)coords hasProperty:(NSString *)name
{
	NSDictionary *properties = [self propertiesForTile:coords];
	return properties != nil && [properties objectForKey:name] != nil;
}

@end
