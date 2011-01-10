//
//  CityPoint.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "CityPoint.h"


@implementation CityPoint
-(CityPoint *) initWithX:(float)ix y:(float)iy z:(float)iz{
	self = [super init];
	if(self){
		x = ix;
		y = iy;
		z = iz;
	}
	return self;
}

-(float) x {
	return x;
}

-(float) y {
	return y;
}

-(float) z {
	return z;
}

-(void) dealloc {
	[super dealloc];
}

@end
