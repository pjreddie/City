//
//  RoadObject.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/9/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CityObject.h"

#define CONST_LANE_SIZE 0.5
#define CONST_SIDEWALK_SIZE 0.1

@interface RoadObject : CityObject {
	double x1,y1,z1,x2,y2,z2,totalRoadWidth;
}

-(RoadObject *) initWithEndPoints:(double)x_1 y1:(double)y_1 z1:(double)z_1 x2:(double)x_2 y2:(double)y_2 z2:(double)z_2;
- (void) calculateRoadPolygons;

@end
