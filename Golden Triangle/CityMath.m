//
//  CityMath.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "CityMath.h"


@implementation CityMath

// Box-Muller Polar Transform
+ (float) gausian:(float)mean deviation:(float)dev {
	float x1, x2, w, y1;
	//NSLog(@"here: %f", ((arc4random()%100000)/100000.0f));
	
	do {
		x1 = 2.0 * ((arc4random()%100000)/100000.0f) - 1.0;
		x2 = 2.0 * ((arc4random()%100000)/100000.0f) - 1.0;
		w = x1 * x1 + x2 * x2;
	} while ( w >= 1.0 );
	
	w = sqrt( (-2.0 * log( w ) ) / w );
	y1 = x1 * w;
	//y2 = x2 * w;*/
	return (mean + y1 * dev);
}



@end
