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
	//[self calculateRoadPolygon];
	return self;
}

// Currently just using left over space for 
- (void) calculateRoadPolygons {
	int numLanes = totalRoadWidth/CONST_LANE_SIZE;
	float sidewalkSize = (totalRoadWidth - (CONST_LANE_SIZE*numLanes))/2;

	// Wrong way to define endpoints! Need to adjust x and z!
	[self addPolygon:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:<#(id)firstObj#> andColorRed:<#(float)r#> green:<#(float)g#> blue:<#(float)b#>
	for(int i = 0; i<numLanes; i++){
		

	}
}

@end
