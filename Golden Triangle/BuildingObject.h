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
	//int numberOfTiers;
	//float * tierHeights;
	/*float buildingHeight;
	float windowSizeX;
	float windowSizeY;
	float windowSeperationX; 
	float windowSeperationY;*/
	//BoundingPolygon * basePolygon;
	//vector<CityVertex> vertices;
	//vector<CityPolygon> faces;
	//CityPolyObject building;
}

+ (void) initWithBounds:(vector<CityVertex> &)vertices faces:(vector<CityPolygon> &)faces startIndex:(int)si avgHeight:(float)height;
+ (void) addWindowsToFace:(int)faceIndex v:(vector<CityVertex> &)vertices f:(vector<CityPolygon> &)faces wx:(double)windowSizeX wy:(double) windowSizeY sx:(double)windowSeparationX sy:(double)windowSeparationY;
//- (void) buildRectangularBuilding;
//- (void) buildCircularBuilding;
//- (CityPolyObject) cityPoly;
//- (CityPolyObject) addWindowsToFace:(CityPolygon)face;
//- (NSArray *) polygons;

@end
