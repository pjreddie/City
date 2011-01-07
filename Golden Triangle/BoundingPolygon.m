//
//  BoundingPolygon.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "BoundingPolygon.h"


@implementation BoundingPolygon
-(BoundingPolygon *) initWithCoord:(NSArray *)coord andColorRed:(float)r green:(float)g blue:(float)b{
	self = [super init];
	coordinates = coord;
	red = r;
	green = g;
	blue = b;
	return self;
}

-(NSArray *) coordinates{
	return coordinates;
}
-(float) red {
	return red;
}
-(float) green{
	return green;
}
-(float) blue{
	return blue;
}
-(void) dealloc{
	[coordinates release];
	[super release];
}

@end
