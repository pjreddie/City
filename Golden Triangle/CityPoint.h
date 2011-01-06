//
//  CityPoint.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CityPoint : NSObject {
	float  x;
	float  y;
	float  z;	
}

-(CityPoint *) initWithX:(float)ix y:(float)iy z:(float)iz;
-(float) x;
-(float) y;
-(float) z;
-(void) dealloc;

@end
