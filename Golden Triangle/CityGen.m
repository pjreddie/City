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
	NSMutableArray * polygons3D = [[NSMutableArray alloc] initWithObjects:nil];
	[CityGen addPlane:polygons3D];
	[CityGen addCityBuildings:polygons3D];
	return polygons3D;
}

+ (void) addPlane:(NSMutableArray *)polygons3D {
	[polygons3D addObject:[[PlaneObject alloc] initWithPolygons:[[NSArray alloc] initWithObjects:
													[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-500.0],
																	[[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-1.0],
																	[[CityPoint alloc] initWithX:20.0 y:-1.0 z:-1.0],
																	[[CityPoint alloc] initWithX:20.0 y:-1.0 z:-500.0], nil] andColorRed:1.0 green:1.0 blue:1.0],nil]]];
}

+ (void) addCityBuildings:(NSMutableArray *) polygons3D {
	// For each polygon call addBuilding w/ height generated from gausian
	[polygons3D addObject:[[BuildingObject alloc] initWithBounds:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:
									[[CityPoint alloc] initWithX:-1.0 y:-0.9 z:-20.0],
									[[CityPoint alloc] initWithX:-1.0 y:-0.9 z:-17.0],
									[[CityPoint alloc] initWithX:0.0 y:-0.9 z:-17.0],
									[[CityPoint alloc] initWithX:0.0 y:-0.9 z:-20.0], nil] andColorRed:0.99 green:0.99 blue:0.99] avgHeight:5.0f]];
	
	[polygons3D addObject:[[BuildingObject alloc] initWithBounds:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-3.0 y:-0.9 z:-20.0],
																				   [[CityPoint alloc] initWithX:-3.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:-2.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:-2.0 y:-0.9 z:-20.0], nil] andColorRed:1.0 green:1.0 blue:1.0]
				  avgHeight:5.0f]];
	
	[polygons3D addObject:[[BuildingObject alloc] initWithBounds:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:1.0 y:-0.9 z:-20.0],
																				   [[CityPoint alloc] initWithX:1.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:2.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:2.0 y:-0.9 z:-20.0], nil] andColorRed:5.0 green:5.0 blue:0.0]
				  avgHeight:5.0f]];
	[polygons3D addObject:[[BuildingObject alloc] initWithBounds:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:5.0 y:-0.9 z:-20.0],
																				   [[CityPoint alloc] initWithX:5.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:6.0 y:-0.9 z:-20.0], nil] andColorRed:1.0 green:0.0 blue:0.0]
				  avgHeight:5.0f]];
}

@end
