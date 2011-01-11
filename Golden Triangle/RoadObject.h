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
#define CONST_INTERSECTION_SIZE 1.0
#define CONST_LANE_SEPERATOR_SIZE 0.03

@interface RoadObject : CityObject {
	float x1,y1,z1,x2,y2,z2,totalRoadWidth;
	NSMutableArray * wallPolygons; //Stupid extra var that should be inherited, dont know why it wasnt working
}

-(RoadObject *) initWithEndPoints:(double)roadWidth x1:(double)x_1 y1:(double)y_1 z1:(double)z_1 x2:(double)x_2 y2:(double)y_2 z2:(double)z_2;
- (NSArray *) generateRectangleFromLine:(double)width x1:(double)x_1 y1:(double)y_1 z1:(double)z_1 x2:(double)x_2 y2:(double)y_2 z2:(double)z_2;
- (void) calculateRoadPolygons;

@end
