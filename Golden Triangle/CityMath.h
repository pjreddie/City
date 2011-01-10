//
//  CityMath.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <stdlib.h>

@interface CityMath : NSObject {

}
+ (float) gausian:(float)median deviation:(float)dev;
+ (int) poisson:(float)lambda;
@end
