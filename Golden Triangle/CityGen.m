//
//  CityGen.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "CityGen.h"


@implementation CityGen

+ (NSMutableArray *) masterGenerate {
	NSMutableArray * polygons = [[NSMutableArray alloc] initWithObjects:nil];
	[CityGen addPlane:polygons];
	[CityGen addCityBuildings:polygons];
	return polygons;
}

+ (void) addPlane:(NSMutableArray *)polygons {
	[polygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-500.0],
																[[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-1.0],
																[[CityPoint alloc] initWithX:20.0 y:-1.0 z:-1.0],
																[[CityPoint alloc] initWithX:20.0 y:-1.0 z:-500.0], nil] andColorRed:1.0 green:1.0 blue:1.0]];
}

+ (void) addCityBuildings:(NSMutableArray *) polygons {
	// For each polygon call addBuilding w/ height generated from gausian
	[CityGen addBuilding:polygons bPolygon:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-1.0 y:-0.9 z:-20.0],
																 [[CityPoint alloc] initWithX:-1.0 y:-0.9 z:-17.0],
																 [[CityPoint alloc] initWithX:0.0 y:-0.9 z:-17.0],
																 [[CityPoint alloc] initWithX:0.0 y:-0.9 z:-20.0], nil] andColorRed:0.99 green:0.99 blue:0.99]
	  height:5.0f];
	
	[CityGen addBuilding:polygons bPolygon:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-3.0 y:-0.9 z:-20.0],
																				   [[CityPoint alloc] initWithX:-3.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:-2.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:-2.0 y:-0.9 z:-20.0], nil] andColorRed:1.0 green:1.0 blue:1.0]
				  height:5.0f];
	
	[CityGen addBuilding:polygons bPolygon:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:1.0 y:-0.9 z:-20.0],
																				   [[CityPoint alloc] initWithX:1.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:2.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:2.0 y:-0.9 z:-20.0], nil] andColorRed:1.0 green:1.0 blue:1.0]
				  height:5.0f];
	[CityGen addBuilding:polygons bPolygon:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:5.0 y:-0.9 z:-20.0],
																				   [[CityPoint alloc] initWithX:5.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:6.0 y:-0.9 z:-20.0], nil] andColorRed:1.0 green:0.0 blue:0.0]
				  height:5.0f];
	
}

+ (void) addBuilding:(NSMutableArray *)polygons bPolygon:(BoundingPolygon *)boundingPoly height:(float)height {
	int buildingHeight = [CityMath gausian:height deviation:0.5];
	
	if(true){ // Build a rectangular building
		//Get dimensions for building <= to polygon passed in
		int bounds = [[boundingPoly coordinates] count];
		int nextindex;
		NSMutableArray * roofPolygon = [[NSMutableArray alloc] init];
		// Draw walls
		for(int i=0; i<[[boundingPoly coordinates] count]; i++){
			if (i==bounds-1) {
				nextindex = 0;
			}else{
				nextindex = i+1;
			}
			CityPoint * pointa = [[boundingPoly coordinates] objectAtIndex:i];
			CityPoint * pointb = [[boundingPoly coordinates] objectAtIndex:nextindex];
			[polygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:pointa,
																		[[CityPoint alloc] initWithX:[pointa x] y:[pointa y]+buildingHeight z:[pointa z]],
																		[[CityPoint alloc] initWithX:[pointb x] y:[pointb y]+buildingHeight z:[pointb z]],
																		pointb,
																		nil] andColorRed:[boundingPoly red] green:[boundingPoly green] blue:[boundingPoly blue] border:true]];
			[roofPolygon addObject:[[CityPoint alloc] initWithX:[pointa x] y:[pointa y]+buildingHeight z:[pointa z]]];
		}
		//add flat top
		[polygons addObject:[[BoundingPolygon alloc] initWithCoord:roofPolygon andColorRed:[boundingPoly red] green:[boundingPoly green] blue:[boundingPoly blue] border:true]];
	}//else { // Build a circular building
		// NEED A CENTER POINT AND A RADIUS - obtain from passed in polygon
		float x=3.0, y=-0.9, z=-2.0, r = 3.0;
		float panelSize = 0.01;
		NSMutableArray * bottom = [[NSMutableArray alloc] init];
		NSMutableArray * top = [[NSMutableArray alloc] init];
		for(float i=0; i<2*3.14159265; i+=panelSize){
			[polygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:
																		[[CityPoint alloc] initWithX:x+cos(i)*r y:y+buildingHeight z:z+sin(i)*r],
																		[[CityPoint alloc] initWithX:x+cos(i+panelSize)*r y:y+buildingHeight z:z+sin(i+panelSize)*r],
																		[[CityPoint alloc] initWithX:x+cos(i+panelSize)*r y:y z:z+sin(i+panelSize)*r],
																		[[CityPoint alloc] initWithX:x+cos(i)*r y:y z:z+sin(i)*r], nil]
																		andColorRed:0.0 green:1.0 blue:0.0 border:false]];
			[bottom addObject:[[CityPoint alloc] initWithX:x+cos(i)*r y:y z:z+sin(i)*r]];
			[top addObject:[[CityPoint alloc] initWithX:x+cos(i)*r y:y z:z+sin(i)*r]];
		}
		[polygons addObject:[[BoundingPolygon alloc] initWithCoord:bottom andColorRed:0.0 green:1.0 blue:0.0 border:true]];
		[polygons addObject:[[BoundingPolygon alloc] initWithCoord:top andColorRed:0.0 green:1.0 blue:0.0 border:true]];

	//}
}

@end
