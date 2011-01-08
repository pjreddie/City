//
//  CityGen.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "BuildingObject.h"
#include "PlaneObject.h"


@interface CityGen : NSObject {

}

+ (NSMutableArray *) masterGenerate;
+ (void) addPlane:(NSMutableArray *)polygons;
+ (void) addCityBuildings:(NSMutableArray *) polygons;
@end
