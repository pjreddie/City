//
//  RoadObject.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/9/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "RoadObject.h"


@implementation RoadObject

-(RoadObject *) initWithEndPoints:(double)roadWidth x1:(double)x_1 y1:(double)y_1 z1:(double)z_1 x2:(double)x_2 y2:(double)y_2 z2:(double)z_2 {
	[super init];
	x1=x_1; x2=x_2; y1=y_1; y2=y_2; z1=z_1; z2=z_2; totalRoadWidth = roadWidth;
	wallPolygons = [[NSMutableArray alloc] init];
	[self calculateRoadPolygons];
	return self;
}

// Currently just using left over space for 
- (void) calculateRoadPolygons {
	float deltaX = x2-x1;
	float deltaZ = z2-z1;
	double angle = atan2(deltaZ,deltaX);
	float intersectiondx = CONST_INTERSECTION_SIZE*cos(angle);
	float intersectiondz = CONST_INTERSECTION_SIZE*sin(angle);
	
	intersectionx1 = x1+intersectiondx;
	intersectionx2 = x2-intersectiondx;
	
	intersectionz1 = z1+intersectiondz;
	intersectionz2 = z2-intersectiondz;
	
	vector<CityPolygon> vp = vector<CityPolygon>();
	vector<CityVertex> cv = vector<CityVertex>();
	// Street
	vector<CityVertex> tmp = [self generateRectangleFromLine:totalRoadWidth-2*CONST_SIDEWALK_SIZE x1:x1 y1:y1 z1:z1 x2:x2 y2:y2 z2:z2];
	cv.insert(cv.end(), tmp.begin(), tmp.end());
	GLfloat dl[4] = {0.0,0.0,0.0,1.0};
	GLfloat sl[4] = {0.0,0.0,0.0,1.0};
	GLfloat el[4] = {0.0,0.0,0.0,1.0};
	int vn[4] = {0,1,2,3};
	vector<int> vvn = vector<int>(vn, vn + sizeof(vn)/sizeof(vn[0]));
	vp.push_back(CityPolygon(vvn,dl,sl,el,cv));
	
	//CityPolyObject r1 = CityPolyObject([self generateRectangleFromLine:totalRoadWidth-2*CONST_SIDEWALK_SIZE x1:x1 y1:y1 z1:z1 x2:x2 y2:y2 z2:z2],
	//								   vp);
	
	// Lane Seperator
	tmp = [self generateRectangleFromLine:CONST_LANE_SEPERATOR_SIZE x1:intersectionx1 y1:y1+.03 z1:intersectionz1 x2:intersectionx2 y2:y2+.03 z2:intersectionz2];
	cv.insert(cv.end(), tmp.begin(), tmp.end());
	GLfloat dl2[4] = {0.9,0.9,0.0,1.0};
	GLfloat sl2[4] = {0.0,0.0,0.0,1.0};
	GLfloat el2[4] = {0.0,0.0,0.0,1.0};
	int vn2[4] = {4,5,6,7};
	vvn = vector<int>(vn2, vn2 + sizeof(vn2)/sizeof(vn2[0]));
	vp.push_back(CityPolygon(vvn,dl2,sl2,el2,cv));
	
	//CityPolyObject r2 = CityPolyObject(,
	//								   vp);

	// sidewalk
	tmp = [self generateRectangleFromLine:totalRoadWidth x1:intersectionx1 y1:y1-.03 z1:intersectionz1 x2:intersectionx2 y2:y2-.03 z2:intersectionz2];
	cv.insert(cv.end(), tmp.begin(), tmp.end());
	GLfloat dl3[4] = {1.0,1.0,1.0,1.0};
	GLfloat sl3[4] = {0.0,0.0,0.0,1.0};
	GLfloat el3[4] = {0.0,0.0,0.0,1.0};
	int vn3[4] = {8,9,10,11};
	vvn = vector<int>(vn3, vn3 + sizeof(vn3)/sizeof(vn3[0]));
	vp.push_back(CityPolygon(vvn,dl3,sl3,el3,cv));	
	//vector<CityVertex> vcv = [self generateRectangleFromLine:totalRoadWidth x1:intersectionx1 y1:y1-.03 z1:intersectionz1 x2:intersectionx2 y2:y2-.03 z2:intersectionz2];
	vertices = cv;
	faces = vp;
	//road = CityPolyObject(cv,vp);;
}

- (vector<CityCoordinate>) intersections{
	float deltaX = x2-x1;
	float deltaZ = z2-z1;
	double mag = sqrt((deltaX*deltaX) + (deltaZ)*(deltaZ));
	double dx = deltaX/mag;
	double dz = deltaZ/mag;
	
	double angle= atan2(dz,dx);
	
	double adjustX = (totalRoadWidth/2)*cos(angle+PI/2);
	double adjustZ = (totalRoadWidth/2)*sin(angle+PI/2);
	
	//return make_pair(make_pair(JPoint(intersectionx1-adjustX, intersectionz1-adjustZ), -angle+PI/2),make_pair(JPoint(intersectionx2+adjustX, intersectionz2+adjustZ), -angle-PI/2));
	CityCoordinate a,b;
	vector<CityCoordinate> coords = vector<CityCoordinate>();
	double nx, nz, nr,tx,tz;
	for (int j=0; j<2; j++) {
		tx = 0.0; tz = 0.0;
		if (j==0) {
			nx = intersectionx1-adjustX;
			nz = intersectionz1-adjustZ;
			nr = -angle+PI/2;
		}else {
			nx = intersectionx2+adjustX;
			nz = intersectionz2+adjustZ;
			nr = -angle-PI/2;
		}
		tx = nx*cos(nr)-nz*sin(nr);
		tz = nx*sin(nr)+nz*cos(nr);
		
		nr = (nr/3.14159265)*180;
		coords.push_back(CityCoordinate(tx,y1,tz,nr));
	}		
	
	return coords;
}

- (NSArray *) polygons {
	return wallPolygons;
}
//Make me better!
- (void) roadPoly:(vector<CityVertex> &)v f:(vector<CityPolygon> &)f {
	int initsize = v.size();
	for (int i=0; i<faces.size(); i++) {
		for (int j=0; j<faces[i].vertexList.size(); j++) {
			faces[i].vertexList[j] += initsize;
		}
	}
	v.insert(v.end(), vertices.begin(), vertices.end());
	f.insert(f.end(), faces.begin(), faces.end());
}

- (double) roadWidth{
	return totalRoadWidth;
}

- (double) roadLength{
	float deltaX = x2-x1;
	float deltaZ = z2-z1;
	double mag = sqrt((deltaX*deltaX) + (deltaZ)*(deltaZ));
	return mag;
}

- (vector<CityVertex>) generateRectangleFromLine:(double)width x1:(double)x_1 y1:(double)y_1 z1:(double)z_1 x2:(double)x_2 y2:(double)y_2 z2:(double)z_2{
	float deltaX = x_2-x_1;
	float deltaZ = z_2-z_1;
	
	/*int adjust = 1;
	if((x_2>x_1&&z_2>z_1)||(x_1>x_2&&z_1>z_2)){
		adjust = -1;
	}*/
	double angle = atan2(deltaZ,deltaX);
	deltaX = (width/2)*cos(angle+PI/2);
	deltaZ = (width/2)*sin(angle+PI/2);
		
	CityVertex vt[4] = {CityVertex(x_2+deltaX, y_2, z_2+deltaZ),
					CityVertex(x_2-deltaX, y_2, z_2-deltaZ),
					CityVertex(x_1-deltaX, y_1, z_1-deltaZ),			
					CityVertex(x_1+deltaX, y_1, z_1+deltaZ)};
	vector<CityVertex> vvt = vector<CityVertex>(vt, vt + sizeof(vt)/sizeof(vt[0]));
	return vvt;
}
@end
