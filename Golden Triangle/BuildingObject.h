//
//  BuildingObject.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/7/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CityObject.h"
#import <cmath>
#import "BoundingPolygon.h"


#define MINHEIGHT 2

@interface BuildingObject : CityObject {
	// Building Vars
	int numberOfTiers;
	//float * tierHeights;
	float buildingHeight;
	float windowSizeX;
	float windowSizeY;
	float windowSeperationX; 
	float windowSeperationY;
	BoundingPolygon * basePolygon;
	vector<CityVertex> vertices;
	vector<CityPolygon> faces;
	CityPolyObject building;
}

-(BuildingObject *) initWithBounds:(vector<CityVertex>)v avgHeight:(float)height;
- (void) buildRectangularBuilding;
- (void) buildCircularBuilding;
- (CityPolyObject) cityPoly;
- (CityPolyObject) addWindowsToFace:(CityPolygon)face;
- (NSArray *) polygons;

@end
