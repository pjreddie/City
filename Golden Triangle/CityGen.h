//
//  CityGen.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "CityPoint.h"

#include "CityMath.h"


@interface CityGen : NSObject {

}

+ (NSMutableArray *) masterGenerate;
+ (void) drawPlane:(NSMutableArray *)polygons;
@end
