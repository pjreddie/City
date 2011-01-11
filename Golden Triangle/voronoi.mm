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

bool isIn(JPoint p, list<Segment> poly){
	bool test = poly.front().isLeft(p);
	for(list<Segment>::iterator sit = poly.begin(); sit != poly.end(); ++sit){
		if((*sit).isLeft(p) != test){
			return false;
		}
	}
	return true;
}

Voronoi GenerateRoads(list<JPoint> points, double dx, double dy){
	list<Segment> bounds;
	JPoint minp = points.front();
	JPoint maxp = points.front();
	for(list<JPoint>::iterator pit = points.begin(), pit2 = ++points.begin(); pit2!= points.end();++pit2, ++pit){
		bounds.push_back(Segment(*pit, *pit2));
		minp.x = min(minp.x, (*pit2).x);
		minp.y = min(minp.y, (*pit2).y);
		maxp.x = max(maxp.x, (*pit2).x);
		maxp.y = max(maxp.y, (*pit2).y);
	}
	bounds.push_back(Segment(points.back(), points.front()));
	Voronoi d(bounds);
	for(double i = minp.x+dx/10; i < maxp.x; i += dx){
		for(double j = minp.y+dy/10; j < maxp.y; j += dy){
			d.addPoint(JPoint(i,j));
		}
	}
	return d;
}

list<JPoint> Shrink(list<JPoint> poly, double s){
	if(poly.size() < 3) return poly;
	
	list<JPoint> sp;
	
	list<JPoint>::iterator pit = --poly.end(), pit2 = poly.begin(), pit3 = ++poly.begin();
	double n1 = (*pit).distance(*pit2);
	double n3 = (*pit3).distance(*pit2);
	
	 JPoint p1((*pit2).x+((*pit).x-(*pit2).x)/n1, (*pit2).y+((*pit).y-(*pit2).y)/n1);
	 JPoint p3((*pit2).x+((*pit3).x-(*pit2).x)/n3, (*pit2).y+((*pit3).y-(*pit2).y)/n3);
	
	
	JPoint m = Segment(p1,p3).Midd();
	double dx = m.x-(*pit2).x;
	double dy = m.y-(*pit2).y;
	double n = sqrt(dx*dx + dy*dy);
	dx = dx/n;
	dy = dy/n;
	double dist = s/p1.distance(m);
	sp.push_back(JPoint((*pit2).x+dx*dist, (*pit2).y+dy*dist));	
	
	for(pit = poly.begin(), pit2 = ++poly.begin(), pit3 = ++++poly.begin(); pit3 != poly.end(); ++pit, ++pit2, ++pit3){
		n1 = (*pit).distance(*pit2);
		n3 = (*pit3).distance(*pit2);
		
		p1 = JPoint((*pit2).x+((*pit).x-(*pit2).x)/n1, (*pit2).y+((*pit).y-(*pit2).y)/n1);
		p3 = JPoint((*pit2).x+((*pit3).x-(*pit2).x)/n3, (*pit2).y+((*pit3).y-(*pit2).y)/n3);
		
		
		m = Segment(p1,p3).Midd();
		dx = m.x-(*pit2).x;
		dy = m.y-(*pit2).y;
		n = sqrt(dx*dx + dy*dy);
		dx = dx/n;
		dy = dy/n;
		dist = s/(p1).distance(m);
		sp.push_back(JPoint((*pit2).x+dx*dist, (*pit2).y+dy*dist));	
	}
	pit3 = poly.begin();
	
	n1 = (*pit).distance(*pit2);
	n3 = (*pit3).distance(*pit2);
	
	p1 = JPoint((*pit2).x+((*pit).x-(*pit2).x)/n1, (*pit2).y+((*pit).y-(*pit2).y)/n1);
	p3 = JPoint((*pit2).x+((*pit3).x-(*pit2).x)/n3, (*pit2).y+((*pit3).y-(*pit2).y)/n3);
	
	
	m = Segment(p1,p3).Midd();
	dx = m.x-(*pit2).x;
	dy = m.y-(*pit2).y;
	n = sqrt(dx*dx + dy*dy);
	dx = dx/n;
	dy = dy/n;
	dist = s/(p1).distance(m);
	sp.push_back(JPoint((*pit2).x+dx*dist, (*pit2).y+dy*dist));	
	
	return sp;
	
}

list<list<JPoint> > GenerateVoronoi(int seed, int numControl, double minx, double maxx, double miny, double maxy){
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
	
	list<list<JPoint> > blocks;
	
	list<list<JPoint> > polys = d.getPolygons(4);
	
	for(list<list<JPoint> > ::iterator pit = polys.begin(); pit != polys.end(); ++pit){
		Voronoi r = GenerateRoads(*pit, (maxx-minx)/35,(maxx-minx)/40);
		list<list<JPoint> > b = r.getPolygons(2);
		blocks.insert(blocks.begin(), b.begin(), b.end());
	}	

	list<list<JPoint> > buildings;

	for(list<list<JPoint> > ::iterator pit = blocks.begin(); pit != blocks.end(); ++pit){
		Voronoi r = GenerateRoads(*pit, (maxx-minx)/350,(maxx-minx)/400);
		list<list<JPoint> > b = r.getPolygons(0);
		buildings.insert(buildings.begin(), b.begin(), b.end());
	}	
	
	
	return buildings;
	
}
/*
void testdraw(){
	
	Voronoi d = GenerateVoronoi(1, 20, -5, 5, -10, 0);
	
	
	d.draw2(0.05);
	list<list<JPoint> > polys = d.getPolygons(.05);
	for(list<list<JPoint> > ::iterator pit = polys.begin(); pit != polys.end(); ++pit){
	 Voronoi r = GenerateRoads(*pit, .6,.3);
	 r.draw2(.007);
	}
}*/

/*
 int main(void){
	 std::list<std::list<JPoint> > polys = GenerateVoronoi(5, 30, -200, 200, -400, 0);
 }
*/