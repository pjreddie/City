/*
 *  voronoi.cpp
 *  Golden Triangle
 *
 *  Created by Joe Redmon on 1/4/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

#import "voronoi.h"


double randf(double high, double low){
	int r = rand();
	r = r%10000;
	double f = r/10000.0;
	double dist = high-low;
	return f*dist + low;
}
Voronoi GenerateVoronoi(int seed, int numControl, double minx, double maxx, double miny, double maxy){
	srand(seed);
	
	list<Segment> bounds;
	JPoint bl( minx, miny);
	JPoint br( maxx, miny);
	JPoint ur( maxx, maxy);
	JPoint ul( minx, maxy);
	
	bounds.push_back(Segment(bl,br));
	bounds.push_back(Segment(br,ur));
	bounds.push_back(Segment(ur,ul));
	bounds.push_back(Segment(ul,bl));
	
	Voronoi d(bounds);
	for(int i = 0; i < numControl; ++i){
		d.addPoint(JPoint(randf(maxx,minx),randf(maxy, miny)));
	}
	return d;
	
}
/*
int main(void){
	Voronoi d = GenerateVoronoi(1, 4, -20, 20, -50, 0);
	std::list<std::list<JPoint> > polys = d.getPolygons();
	return 0;
}
*/