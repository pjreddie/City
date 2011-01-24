//
//  CityGen.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "CityGen.h"
#import "BoundingPolygon.h"

@implementation CityGen

//TODO change to instance of CityGLView
+ (vector<CityPolyObject>) masterGenerate:(NSView *)glView {
	//NSMutableArray * polygons3D = [[NSMutableArray alloc] initWithObjects:nil];
	vector<CityPolyObject> polygons3D = vector<CityPolyObject>();
	[glView addLoadingMessage:@"building city..."];
	[glView addLoadingMessage:@"generating voronoi diagrams..."];
	[CityGen addPlane:&polygons3D];
	pair<list<list<JPoint> >, pair<list<Segment>,list<Segment> > > city = GenerateVoronoi(RANDSEED, NUMCONTROL, MINX, MAXX, MINZ, MAXZ);
	[glView addLoadingMessage:@"constructing buildings..."];
	double cx = MINX + (MAXX-MINX)/2;
	double cz = MINZ + (MAXZ-MINZ)/2;
	
	double maxDist = MAXX-cx + MAXZ - cz;
	
	[CityGen addCityBuildings:&polygons3D diagram:city.first centerX:cx z:cz maxDist:maxDist];
	[glView addLoadingMessage:@"paving roads..."];

	//list<pair<JPoint, double> > stoplightPos;
	NSLog(@"sssize %i", polygons3D.size());
	for(list<Segment>::iterator sit = city.second.first.begin(); sit != city.second.first.end(); ++sit){
	//	[polygons3D addObject:[[RoadObject alloc] initWithEndPoints:6.0 x1:(*sit).p.x y1:-.9 z1:(*sit).p.y x2:(*sit).q.x y2:-0.9 z2:(*sit).q.y]];
		RoadObject * tmp = [[RoadObject alloc] initWithEndPoints:6.0 x1:(*sit).p.x y1:-.9 z1:(*sit).p.y x2:(*sit).q.x y2:-0.9 z2:(*sit).q.y];
		polygons3D.push_back([tmp roadPoly]);
	}
	NSLog(@"sssize %i", polygons3D.size());
	for(list<Segment>::iterator sit = city.second.second.begin(); sit != city.second.second.end(); ++sit){
	//	[polygons3D addObject:[[RoadObject alloc] initWithEndPoints:3.0 x1:(*sit).p.x y1:-.9 z1:(*sit).p.y x2:(*sit).q.x y2:-0.9 z2:(*sit).q.y]];
		RoadObject * tmp =[[RoadObject alloc] initWithEndPoints:3.0 x1:(*sit).p.x y1:-.9 z1:(*sit).p.y x2:(*sit).q.x y2:-0.9 z2:(*sit).q.y];
		polygons3D.push_back([tmp roadPoly]);
	}
	return polygons3D;
}

+ (void) addPlane:(vector<CityPolyObject> *)polygons3D {
	CityVertex vertices[4] = {CityVertex(MINX, -1.0, MINZ), CityVertex(MINX, -1.0, MAXZ), CityVertex(MAXX, -1.0, MAXZ), CityVertex(MAXX, -1.0, MINZ)}; 
	GLfloat dl[4] = {.1289,.1484,.125,1.0};
	GLfloat sl[4] = {0.0,0.0,0.0,1.0};
	GLfloat el[4] = {0.0,0.0,0.0,1.0};
	int planeVerts[4] = {0,1,2,3};
	vector<int> vpv = vector<int>(planeVerts, planeVerts+sizeof(planeVerts)/sizeof(planeVerts[0]));
	CityPolygon polygons[1] = {CityPolygon(vpv,dl,sl,el)};
	vector<CityVertex> vv = vector<CityVertex>(vertices, vertices + sizeof(vertices)/sizeof(vertices[0]));
	vector<CityPolygon> vp = vector<CityPolygon>(polygons, polygons + sizeof(polygons)/sizeof(polygons[0]));
	(*polygons3D).push_back(CityPolyObject(vv, vp));
}

+ (void) addCityBuildings:(vector<CityPolyObject> *)polygons3D diagram:(std::list<std::list<JPoint> >)polys centerX:(double)cx z:(double)cz maxDist:(double)mD{
	
	for(std::list<std::list<JPoint> >::iterator p = polys.begin(); p != polys.end(); ++p){
		// allocate space for vertices building height
		vector<CityVertex> vertices = vector<CityVertex>();
		int ti = 0;
		for(std::list<JPoint>::iterator pit = (*p).begin(); pit != (*p).end(); ++pit){
			//double x = (*pit).x;
			//double z = (*pit).y;
			//[points addObject: [[CityPoint alloc] initWithX:x y:-0.9 z:z]];
			vertices.push_back(CityVertex((*pit).x,-0.9,(*pit).y));
		}
		double x = (*p).front().x;
		double z = (*p).front().y;

		double dist = abs(cz-z) + abs(cx-x);
		double avgH = 2+30*[CityMath bell:dist/40 sigma:.7 mu:0];
		BuildingObject * temp = [[BuildingObject alloc] initWithBounds:vertices avgHeight:avgH];
		CityPolyObject t = [temp cityPoly];
		(*polygons3D).push_back(t);
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
