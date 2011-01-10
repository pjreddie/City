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
	int r = arc4random();
	r = r%10000;
	double f = r/10000.0;
	double dist = high-low;
	return f*dist + low;
}
Voronoi GenerateVoronoi(int seed, int numControl, double minx, double maxx, double miny, double maxy){
	//srand(seed); dont need w/ arc4random i think
	Voronoi d;
	for(int i = 0; i < numControl; ++i){
		d.addPoint(JPoint(randf(maxx,minx),randf(maxy, miny)));
	}
	return d;
	
}
