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
+ (void) masterGenerate:(NSView *)glView polyObjs:(vector<CityPolyObject> *)polygons3D pregenObjs:(CityPregen *)pregenList{

	//NSMutableArray * polygons3D = [[NSMutableArray alloc] initWithObjects:nil];
	//vector<CityPolyObject> polygons3D = vector<CityPolyObject>(500);
	//CityPregen pregenList = CityPregen();
	[glView addLoadingMessage:@"building city..."];
	[glView addLoadingMessage:@"generating voronoi diagrams..."];
	[CityGen addPlane:polygons3D];
	pair<list<list<JPoint> >, pair<list<Segment>,list<Segment> > > city = GenerateVoronoi(RANDSEED, NUMCONTROL, MINX, MAXX, MINZ, MAXZ);
	[glView addLoadingMessage:@"constructing buildings..."];
	double cx = MINX + (MAXX-MINX)/2;
	double cz = MINZ + (MAXZ-MINZ)/2;
	
	double maxDist = MAXX-cx + MAXZ - cz;
	
	[CityGen addCityBuildings:polygons3D diagram:city.first centerX:cx z:cz maxDist:maxDist];
	[glView addLoadingMessage:@"paving roads..."];

	//list<pair<JPoint, double> > stoplightPos;
	for(list<Segment>::iterator sit = city.second.first.begin(); sit != city.second.first.end(); ++sit){
		RoadObject * tmp = [[RoadObject alloc] initWithEndPoints:6.0 x1:(*sit).p.x y1:-.9 z1:(*sit).p.y x2:(*sit).q.x y2:-0.9 z2:(*sit).q.y];
		vector<CityCoordinate> tmpV = [tmp intersections];

		(*pregenList).coordinates[STOPLIGHT_INDEX].insert((*pregenList).coordinates[STOPLIGHT_INDEX].end(), tmpV.begin(), tmpV.end());
		

		(*polygons3D).push_back([tmp roadPoly]);
	}
	for(list<Segment>::iterator sit = city.second.second.begin(); sit != city.second.second.end(); ++sit){
		RoadObject * tmp =[[RoadObject alloc] initWithEndPoints:3.0 x1:(*sit).p.x y1:-.9 z1:(*sit).p.y x2:(*sit).q.x y2:-0.9 z2:(*sit).q.y];
		vector<CityCoordinate> tmpV = [tmp intersections];
		(*pregenList).coordinates[STOPSIGN_INDEX].insert((*pregenList).coordinates[STOPSIGN_INDEX].end(), tmpV.begin(), tmpV.end());
		(*polygons3D).push_back([tmp roadPoly]);
	}
}

+ (void) addPlane:(vector<CityPolyObject> *)polygons3D {
	CityVertex vertices[4] = {CityVertex(MINX, -1.0, MINZ), CityVertex(MINX, -1.0, MAXZ), CityVertex(MAXX, -1.0, MAXZ), CityVertex(MAXX, -1.0, MINZ)}; 
	GLfloat dl[4] = {.1289,.4,.125,1.0};
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
		for(std::list<JPoint>::iterator pit = (*p).begin(); pit != (*p).end(); ++pit){
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
}

@end
