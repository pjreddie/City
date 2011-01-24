//
//  FileIO.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/17/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CityObject.h"
#import "voronoi.h"
#import "BoundingPolygon.h"


@interface FileIO : NSObject {

}

+ (CityPolyObject) getPolygonObjectFromFile:(NSString *)filename scaler:(double)scaler;

@end
