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

+ (double) bell:(double)x sigma:(double)s mu:(double)m{
	return 1/sqrt(2*PI*s*s)*pow(E,(-((x-m)*(x-m))/(2*s*s)));
}

// Poisson generation from uniform distribution Donald Knuth
+ (int) poisson:(float)lambda{
	float l = pow(2.71828183, -lambda),p = 1;
	int k = 0;
	do {
		k += 1;
		p = p*((arc4random()%100000)/100000.0f);
	} while (p>l);
	return k-1;
}

// Returns true if (x3,y3) is left of the line from (x1,y1) to (x2,y2)
+(bool) isLeftOf:(float)x_1 y1:(float)y_1 toX2:(float)x_2 y2:(float)y_2 x3:(float)x_3 y3:(float)y_3 {
	return ((x_2-x_1) * (y_3-y_1) - (y_2-y_1)*(x_3-x_1)) >= 0;
}


@end
