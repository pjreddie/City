//
//  RoadObject.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/9/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CityObject.h"
#import "voronoi.h"

#define CONST_LANE_SIZE 0.5
#define CONST_SIDEWALK_SIZE 0.2
#define CONST_INTERSECTION_SIZE totalRoadWidth/2
#define CONST_LANE_SEPERATOR_SIZE 0.2

using namespace std;

@interface RoadObject : CityObject {
	//CityPolyObject road;
	vector<CityVertex> vertices;
	vector<CityPolygon> faces;
	float x1,y1,z1,x2,y2,z2,totalRoadWidth;
	float intersectionx1,intersectionx2, intersectionz1, intersectionz2;
	NSMutableArray * wallPolygons; //Stupid extra var that should be inherited, dont know why it wasnt working
}

- (double) roadWidth;
- (double) roadLength;

-(RoadObject *) initWithEndPoints:(double)roadWidth x1:(double)x_1 y1:(double)y_1 z1:(double)z_1 x2:(double)x_2 y2:(double)y_2 z2:(double)z_2;
- (vector<CityCoordinate>) intersections;
- (vector<CityVertex>) generateRectangleFromLine:(double)width x1:(double)x_1 y1:(double)y_1 z1:(double)z_1 x2:(double)x_2 y2:(double)y_2 z2:(double)z_2;
- (void) calculateRoadPolygons;
- (void) roadPoly:(vector<CityVertex> &)vertices f:(vector<CityPolygon> &)faces;

@end
