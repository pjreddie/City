//
//  CityGen.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "CityGen.h"


@implementation CityGen

+ (NSMutableArray *) masterGenerate {
	NSMutableArray * polygons = [[NSMutableArray alloc] initWithObjects:nil];
	[CityGen drawPlane:polygons];
	NSLog(@"THe Count : %i", [polygons count]);
	return polygons;
}

+ (void) drawPlane:(NSMutableArray *)polygons {
	[polygons addObject:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-500.0],
						 [[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-1.0],
						 [[CityPoint alloc] initWithX:20.0 y:-1.0 z:-1.0],
						 [[CityPoint alloc] initWithX:20.0 y:-1.0 z:-500.0], nil]];
}

+ (void) drawBuilding:(NSArray *)boundingPoly height:(double)height {
	//for(int i=0; i<20; i++){
	//}
	//[boundingPoly enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {<#code#>}
	/*for(id point in boundingPoly){
	 NSLog(@"%d point", point.x);
	 }
	 glBegin(GL_QUADS);
	 glColor3f( 0, 1, 0);
	 
	 //Far face
	 glVertex3f(xCord-radius, height, zCord-radius);
	 glVertex3f(xCord+radius, height, zCord-radius);
	 glVertex3f(xCord+radius, -1, zCord-radius);
	 glVertex3f(xCord-radius, -1, zCord-radius);
	 glEnd();
	 //Near Face
	 glBegin(GL_QUADS);
	 glColor3f( 1, 0, 0);
	 glVertex3f(xCord-radius, height, zCord+radius);
	 glVertex3f(xCord+radius, height, zCord+radius);
	 glVertex3f(xCord+radius, -1, zCord+radius);
	 glVertex3f(xCord-radius, -1, zCord+radius);
	 glEnd();
	 //Left face
	 glBegin(GL_QUADS);
	 glColor3f( 0, 0, 1);
	 glVertex3f(xCord-radius, height, zCord-radius);
	 glVertex3f(xCord-radius, height, zCord+radius);
	 glVertex3f(xCord-radius, -1, zCord+radius);
	 glVertex3f(xCord-radius, -1, zCord-radius);
	 glEnd();
	 //Right Face
	 glBegin(GL_QUADS);
	 glColor3f( 0, 0, 1);
	 glVertex3f(xCord+radius, height, zCord-radius);
	 glVertex3f(xCord+radius, height, zCord+radius);
	 glVertex3f(xCord+radius, -1, zCord+radius);
	 glVertex3f(xCord+radius, -1, zCord-radius);
	 glEnd();
	 
	 */
}


@end
