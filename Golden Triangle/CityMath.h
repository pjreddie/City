//
//  CityMath.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <stdlib.h>
#import <algorithm>
//#import "CityPoint.h"
#import "BoundingPolygon.h"

#define PI 3.14159265
#define E 2.71828183

using namespace std;

@interface CityMath : NSObject {

}
+ (float) gausian:(float)median deviation:(float)dev;
+ (int) poisson:(float)lambda;
+ (double) bell:(double)x sigma:(double)s mu:(double)m;
+(bool) isLeftOf:(float)x_1 y1:(float)y_1 toX2:(float)x_2 y2:(float)y_2 x3:(float)x_3 y3:(float)y_3;
								  
@end
