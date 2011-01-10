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
	Voronoi d;
	for(int i = 0; i < numControl; ++i){
		d.addPoint(JPoint(randf(minx,maxx),randf(miny,maxy)));
	}
	return d;
	
}
