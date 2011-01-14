//
//  CityGen.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BuildingObject.h"
#import "PlaneObject.h"
#import "RoadObject.h"
#import "voronoi.h"
#import "CityGLView.h"


@interface CityGen : NSObject {

}

+ (NSMutableArray *) masterGenerate:(NSView *)glView;
+ (void) addPlane:(NSMutableArray *)polygons;
+ (void) addCityBuildings:(NSMutableArray *) polygons3D diagram: (std::list<std::list<JPoint> > ) polys;
@end
