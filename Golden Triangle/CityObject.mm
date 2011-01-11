//
//  CityObject.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/7/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "CityObject.h"


@implementation CityObject

-(CityObject *) initWithPolygons:(NSArray *)poly{
	self = [super init];
	polygonList = [[NSArray alloc] initWithArray:poly];
	return self;

}

-(CityObject *) init {
	self = [super init];
	polygonList = [[NSArray alloc] init];
	return self;
}

-(NSArray *) polygons {
	return polygonList;
}

-(void) addPolygon:(BoundingPolygon *)polygon{
	[polygonList addObject:polygon];
}

-(void) dealloc {
	[polygonList release];
	[super dealloc];
}

@end
