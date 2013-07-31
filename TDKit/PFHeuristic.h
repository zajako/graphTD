//
//  PFHeuristic.h
//  TDKit
//
//  Created by Tommy Allen on 7/19/13.
//  Copyright (c) 2013 Nevernull. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline CGPoint PFHeuristicPrep(CGPoint a, CGPoint b)
{
	return CGPointMake(fabsf(a.x - b.x), fabsf(a.y - b.y));
}

static inline float PFManhattan(CGPoint a, CGPoint b)
{
	CGPoint d = PFHeuristicPrep(a, b);
	return d.x + d.y;
}

static inline float PFEuclidean(CGPoint a, CGPoint b)
{
	CGPoint d = PFHeuristicPrep(a, b);
	return sqrtf(d.x * d.x + d.y * d.y);
}

static inline float PFChebyshev(CGPoint a, CGPoint b)
{
	CGPoint d = PFHeuristicPrep(a, b);
	return MAX(d.x, d.y);
}
