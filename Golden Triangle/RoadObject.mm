//
//  RoadObject.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/9/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "RoadObject.h"


@implementation RoadObject

-(RoadObject *) initWithEndPoints:(double)roadWidth x1:(double)x_1 y1:(double)y_1 z1:(double)z_1 x2:(double)x_2 y2:(double)y_2 z2:(double)z_2 {
	[super init];
	x1=x_1; x2=x_2; y1=y_1; y2=y_2; z1=z_1; z2=z_2; totalRoadWidth = roadWidth;
	wallPolygons = [[NSMutableArray alloc] init];
	[self calculateRoadPolygons];
	return self;
}

// Currently just using left over space for 
- (void) calculateRoadPolygons {
	float deltaX = x2-x1;
	float deltaZ = z2-z1;
	double angle = atan2(deltaZ,deltaX);
	float intersectiondx = CONST_INTERSECTION_SIZE*cos(angle);
	float intersectiondz = CONST_INTERSECTION_SIZE*sin(angle);
	
	intersectionx1 = x1+intersectiondx;
	intersectionx2 = x2-intersectiondx;
	
	intersectionz1 = z1+intersectiondz;
	intersectionz2 = z2-intersectiondz;
	
	int numLanes = totalRoadWidth/CONST_LANE_SIZE;
	//float sidewalkSize = (totalRoadWidth - (CONST_LANE_SIZE*numLanes))/2;
	
	// Street
	[wallPolygons addObject:[[BoundingPolygon alloc] initWithCoord:[self generateRectangleFromLine:totalRoadWidth-2*CONST_SIDEWALK_SIZE x1:x1 y1:y1 z1:z1 x2:x2 y2:y2 z2:z2] andColorRed:0.0 green:0.0 blue:0.0]];
	// Lane Seperator
	[wallPolygons addObject:[[BoundingPolygon alloc] initWithCoord:[self generateRectangleFromLine:CONST_LANE_SEPERATOR_SIZE x1:intersectionx1 y1:y1+.03 z1:intersectionz1 x2:intersectionx2 y2:y2+.03 z2:intersectionz2] andColorRed:.16797 green:.16797 blue:.05859]];
	// sidewalk
	[wallPolygons addObject:[[BoundingPolygon alloc] initWithCoord:[self generateRectangleFromLine:totalRoadWidth x1:intersectionx1 y1:y1-.03 z1:intersectionz1 x2:intersectionx2 y2:y2-.03 z2:intersectionz2] andColorRed:.234 green:.234 blue:.234]];
	
}

- (pair<pair<JPoint, double>, pair<JPoint, double> >) intersections{
	float deltaX = x2-x1;
	float deltaZ = z2-z1;
	double mag = sqrt((deltaX*deltaX) + (deltaZ)*(deltaZ));
	double dx = deltaX/mag;
	double dz = deltaZ/mag;
	
	double angle= atan2(dz,dx);
	
	double adjustX = (totalRoadWidth/2)*cos(angle+PI/2);
	double adjustZ = (totalRoadWidth/2)*sin(angle+PI/2);
	
	//adjustX = 0;
	//adjustZ = 0;
	
	return make_pair(make_pair(JPoint(intersectionx1-adjustX, intersectionz1-adjustZ), -angle+PI/2),make_pair(JPoint(intersectionx2+adjustX, intersectionz2+adjustZ), -angle-PI/2));
}

- (NSArray *) polygons {
	return wallPolygons;
}
- (double) roadWidth{
	return totalRoadWidth;
}

- (double) roadLength{
	float deltaX = x2-x1;
	float deltaZ = z2-z1;
	double mag = sqrt((deltaX*deltaX) + (deltaZ)*(deltaZ));
	return mag;
}

- (NSArray *) generateRectangleFromLine:(double)width x1:(double)x_1 y1:(double)y_1 z1:(double)z_1 x2:(double)x_2 y2:(double)y_2 z2:(double)z_2{
	float deltaX = x_2-x_1;
	float deltaZ = z_2-z_1;
	
	/*int adjust = 1;
	if((x_2>x_1&&z_2>z_1)||(x_1>x_2&&z_1>z_2)){
		adjust = -1;
	}*/
	double angle = atan2(deltaZ,deltaX);
	deltaX = (width/2)*cos(angle+PI/2);
	deltaZ = (width/2)*sin(angle+PI/2);
	
	NSMutableArray * roadPoints = [[NSMutableArray alloc] init];

	[roadPoints addObject:[[CityPoint alloc] initWithX:x_2+deltaX y:y_2 z:z_2+deltaZ]];
	[roadPoints addObject:[[CityPoint alloc] initWithX:x_2-deltaX y:y_2 z:z_2-deltaZ]];
	[roadPoints addObject:[[CityPoint alloc] initWithX:x_1-deltaX y:y_1 z:z_1-deltaZ]];
	[roadPoints addObject:[[CityPoint alloc] initWithX:x_1+deltaX y:y_1 z:z_1+deltaZ]];
	
	
	return roadPoints;
}
@end
