/*
 *  voronoi.cpp
 *  Golden Triangle
 *
 *  Created by Joe Redmon on 1/4/11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */


/*
struct DPoint{
	float x,y;
	DEdge *incidentEdge;
	DPoint (float _x, float _y){
		x = _x;
		y = _y;
	}
	float distance(DPoint &p){
		return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2));
	}
};

struct DEdge{
	DPoint *origin;
	DEdge *twin;
	DFace *incidentFace;
	DEdge *next;
	DEdge *prev;
};

struct DFace{
	list<DEdge*> outer;
	list<DEdge*> inner;
};

struct DCEL{	
	list<DPoint> points;
	list<DFace> faces;
	list<DEdge> edges;	
	
};

int main(void){
 Voronoi d;
 d.addPoint(JPoint(0.0,-10.0));
 d.addPoint(JPoint(0.0,-11.0));
 //d.addPoint(JPoint(3.0,-10.5));
 //d.addPoint(JPoint(-3.0, -7.0));
 return 0;
 }*/