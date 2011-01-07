//
//  BoundingPolygon.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/6/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BoundingPolygon : NSObject {
	NSArray * coordinates;
	float red;
	float green;
	float blue;
	bool border;
}

-(BoundingPolygon *) initWithCoord:(NSArray *)coord andColorRed:(float)r green:(float)g blue:(float)b border:(bool)bor;
-(BoundingPolygon *) initWithCoord:(NSArray *)coord andColorRed:(float)r green:(float)g blue:(float)b;
-(NSArray *) coordinates;
-(float) red;
-(float) green;
-(float) blue;
-(bool) border;
-(void) dealloc;

@end
