//
//  CityGen.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "CityGen.h"

@implementation CityGen

//TODO change to instance of CityGLView
+ (NSMutableArray *) masterGenerate:(NSView *)glView {
	NSMutableArray * polygons3D = [[NSMutableArray alloc] initWithObjects:nil];
	//[CityGen addPlane:polygons3D];
	[glView addLoadingMessage:@"building city..."];
	[glView addLoadingMessage:@"generating voronoi diagrams..."];
	pair<list<list<JPoint> >, pair<list<Segment>,list<Segment> > > city = GenerateVoronoi(RANDSEED, NUMCONTROL, MINX, MAXX, MINZ, MAXZ);
	[glView addLoadingMessage:@"constructing buildings..."];
	double cx = MINX + (MAXX-MINX)/2;
	double cz = MINZ + (MAXZ-MINZ)/2;
	
	double maxDist = MAXX-cx + MAXZ - cz;
	
	[CityGen addCityBuildings:polygons3D diagram:city.first centerX:cx z:cz maxDist:maxDist];
	[glView addLoadingMessage:@"paving roads..."];

	for(list<Segment>::iterator sit = city.second.first.begin(); sit != city.second.first.end(); ++sit){
		[polygons3D addObject:[[RoadObject alloc] initWithEndPoints:6.0 x1:(*sit).p.x y1:-.9 z1:(*sit).p.y x2:(*sit).q.x y2:-0.9 z2:(*sit).q.y]];
	}
	for(list<Segment>::iterator sit = city.second.second.begin(); sit != city.second.second.end(); ++sit){
		[polygons3D addObject:[[RoadObject alloc] initWithEndPoints:3.0 x1:(*sit).p.x y1:-.9 z1:(*sit).p.y x2:(*sit).q.x y2:-0.9 z2:(*sit).q.y]];
	}
	return polygons3D;
}

+ (void) addPlane:(NSMutableArray *)polygons3D {
	[polygons3D addObject:[[PlaneObject alloc] initWithPolygons:[[NSArray alloc] initWithObjects:
													[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-500.0],
																	[[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-1.0],
																	[[CityPoint alloc] initWithX:20.0 y:-1.0 z:-1.0],
																	[[CityPoint alloc] initWithX:20.0 y:-1.0 z:-500.0], nil] andColorRed:1.0 green:1.0 blue:1.0],nil]]];
}

+ (void) addCityBuildings:(NSMutableArray *) polygons3D diagram:(std::list<std::list<JPoint> >)polys centerX:(double)cx z:(double)cz maxDist:(double)mD{
	
	for(std::list<std::list<JPoint> >::iterator p = polys.begin(); p != polys.end(); ++p){
		NSMutableArray * points = [[NSMutableArray alloc] init];
		for(std::list<JPoint>::iterator pit = (*p).begin(); pit != (*p).end(); ++pit){
			double x = (*pit).x;
			double z = (*pit).y;
			[points addObject: [[CityPoint alloc] initWithX:x y:-0.9 z:z]];
			
		}
		double x = (*p).front().x;
		double z = (*p).front().y;

		double dist = abs(cz-z) + abs(cx-x);
		double avgH = 2+30*[CityMath bell:dist/40 sigma:.7 mu:0];
		[polygons3D addObject:[[BuildingObject alloc] initWithBounds:[[BoundingPolygon alloc] initWithCoord:points andColorRed:1 green:1 blue:1] avgHeight:avgH]];
	}
	
	// For each polygon call addBuilding w/ height generated from gausian
	/*
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
	 */
}

@end
