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
	[CityGen addPlane:polygons];
	[CityGen addCityBuildings:polygons];
	return polygons;
}

+ (void) addPlane:(NSMutableArray *)polygons {
	[polygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-500.0],
																[[CityPoint alloc] initWithX:-20.0 y:-1.0 z:-1.0],
																[[CityPoint alloc] initWithX:20.0 y:-1.0 z:-1.0],
																[[CityPoint alloc] initWithX:20.0 y:-1.0 z:-500.0], nil] andColorRed:1.0 green:1.0 blue:1.0]];
}

+ (void) addCityBuildings:(NSMutableArray *) polygons {
	// For each polygon call addBuilding w/ height generated from gausian
	[CityGen addBuilding:polygons bPolygon:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-1.0 y:-0.9 z:-20.0],
																 [[CityPoint alloc] initWithX:-1.0 y:-0.9 z:-17.0],
																 [[CityPoint alloc] initWithX:0.0 y:-0.9 z:-17.0],
																 [[CityPoint alloc] initWithX:0.0 y:-0.9 z:-20.0], nil] andColorRed:0.99 green:0.99 blue:0.99]
	  height:5.0f];
	
	[CityGen addBuilding:polygons bPolygon:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:-3.0 y:-0.9 z:-20.0],
																				   [[CityPoint alloc] initWithX:-3.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:-2.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:-2.0 y:-0.9 z:-20.0], nil] andColorRed:1.0 green:1.0 blue:1.0]
				  height:5.0f];
	
	[CityGen addBuilding:polygons bPolygon:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:1.0 y:-0.9 z:-20.0],
																				   [[CityPoint alloc] initWithX:1.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:2.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:2.0 y:-0.9 z:-20.0], nil] andColorRed:1.0 green:1.0 blue:1.0]
				  height:5.0f];
	[CityGen addBuilding:polygons bPolygon:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:5.0 y:-0.9 z:-20.0],
																				   [[CityPoint alloc] initWithX:5.0 y:-0.9 z:-17.0],
																				   [[CityPoint alloc] initWithX:6.0 y:-0.9 z:-20.0], nil] andColorRed:1.0 green:0.0 blue:0.0]
				  height:5.0f];
	
}

+ (void) addBuilding:(NSMutableArray *)polygons bPolygon:(BoundingPolygon *)boundingPoly height:(float)height {
	float buildingHeight = [CityMath gausian:height deviation:0.5];
	float windowSizeX = [CityMath gausian:0.1 deviation:0.05];
	float windowSizeY = [CityMath gausian:0.2 deviation:0.05];
	float windowSeperationX = [CityMath gausian:0.1 deviation:0.05];
	float windowSeperationY = [CityMath gausian:0.1 deviation:0.1];
	if(true){ // Build a rectangular building
		//Get dimensions for building <= to polygon passed in
		int bounds = [[boundingPoly coordinates] count];
		int nextindex;
		NSMutableArray * roofPolygon = [[NSMutableArray alloc] init];
		// Draw walls
		for(int i=0; i<[[boundingPoly coordinates] count]; i++){
			if (i==bounds-1) {
				nextindex = 0;
			}else{
				nextindex = i+1;
			}
			CityPoint * pointa = [[boundingPoly coordinates] objectAtIndex:i];
			CityPoint * pointb = [[boundingPoly coordinates] objectAtIndex:nextindex];
			[polygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:pointa,
																		[[CityPoint alloc] initWithX:[pointa x] y:[pointa y]+buildingHeight z:[pointa z]],
																		[[CityPoint alloc] initWithX:[pointb x] y:[pointb y]+buildingHeight z:[pointb z]],
																		pointb,
																		nil] andColorRed:[boundingPoly red] green:[boundingPoly green] blue:[boundingPoly blue] border:true]];
			[roofPolygon addObject:[[CityPoint alloc] initWithX:[pointa x] y:[pointa y]+buildingHeight z:[pointa z]]];
			// Populate Windows
			float cornerWindowBufferX;
			float topWindowBufferY;
			int numOfWindowsX;
			int numOfWindowsY;
			float deltaX;
			float deltaZ;
			float xAccum;
			float zAccum;
			float yAccum;
			float zInit;
			float xInit;
			float directionAdjustX = 1.0;
			float deltaY = buildingHeight + [pointa y];
			if ([pointa x] > [pointb x]) {
				deltaX = [pointa x] - [pointb x];
			}else {
				deltaX = [pointb x] - [pointa x];
			}
			if ([pointa z] > [pointb z]) {
				deltaZ = [pointa z] - [pointb z];
				xInit = [pointb x];
				zInit = [pointb z];
				if ([pointa x] < [pointb x]) {
					directionAdjustX = -1.0;
				}
			}else {
				deltaZ = [pointb z] - [pointa z];
				xInit = [pointa x];
				zInit = [pointa z];
				if ([pointb x] < [pointa x]) {
					directionAdjustX = -1.0;
				}				
			}
			float buildingFaceWidth = sqrt(pow(deltaX, 2)+pow(deltaZ, 2));

			numOfWindowsX = buildingFaceWidth/(windowSizeX+windowSeperationX*2);
			cornerWindowBufferX = (buildingFaceWidth-(numOfWindowsX*(windowSizeX+windowSeperationX*2)))/2;
			numOfWindowsY = (deltaY/(windowSizeY+windowSeperationY*2)); 
			topWindowBufferY = (deltaY-(numOfWindowsY*(windowSizeY+windowSeperationY*2)))/2;
			//Absolute, need positive/negative direction
			float adjustedWindowX = deltaX*(windowSizeX/buildingFaceWidth);
			float adjustedWindowZ = deltaZ*(windowSizeX/buildingFaceWidth);
			float adjustedWindowSpacerX = deltaX*(windowSeperationX/buildingFaceWidth);
			float adjustedWindowSpacerZ = deltaZ*(windowSeperationX/buildingFaceWidth);

			
			yAccum = topWindowBufferY;
			// Loop through the side and make windows
			for(int i=0; i<numOfWindowsY; i++) {
				xAccum = xInit+directionAdjustX*(deltaX*(cornerWindowBufferX/buildingFaceWidth)+adjustedWindowSpacerX);
				zAccum = zInit+(deltaZ*(cornerWindowBufferX/buildingFaceWidth)+adjustedWindowSpacerZ);
				for(int j=0; j<numOfWindowsX; j++){
					[polygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:xAccum y:deltaY-yAccum	z:zAccum],
																				[[CityPoint alloc] initWithX:xAccum+directionAdjustX*adjustedWindowX y:deltaY-yAccum z:zAccum+adjustedWindowZ],
																				[[CityPoint alloc] initWithX:xAccum+directionAdjustX*adjustedWindowX y:deltaY-yAccum-windowSizeY z:zAccum+adjustedWindowZ],
																				[[CityPoint alloc] initWithX:xAccum y:deltaY-yAccum-windowSizeY z:zAccum],
																				nil] andColorRed:0.0 green:1.0 blue:0.0 border:true]];
					xAccum = xAccum+directionAdjustX*(adjustedWindowX+2*adjustedWindowSpacerX);
					zAccum = zAccum+(adjustedWindowZ+2*adjustedWindowSpacerZ);
				}
				yAccum += windowSizeY+2*windowSeperationY;
			}
			
			//Update accums and loop until all are defined
		}
		//add flat top
		[polygons addObject:[[BoundingPolygon alloc] initWithCoord:roofPolygon andColorRed:[boundingPoly red] green:[boundingPoly green] blue:[boundingPoly blue] border:true]];
	}//else { // Build a circular building
		// NEED A CENTER POINT AND A RADIUS - obtain from passed in polygon
		float x=3.0, y=-0.9, z=-2.0, r = 3.0;
		float panelSize = 0.01;
		NSMutableArray * bottom = [[NSMutableArray alloc] init];
		NSMutableArray * top = [[NSMutableArray alloc] init];
		for(float i=0; i<2*3.14159265; i+=panelSize){
			[polygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:
																		[[CityPoint alloc] initWithX:x+cos(i)*r y:y+buildingHeight z:z+sin(i)*r],
																		[[CityPoint alloc] initWithX:x+cos(i+panelSize)*r y:y+buildingHeight z:z+sin(i+panelSize)*r],
																		[[CityPoint alloc] initWithX:x+cos(i+panelSize)*r y:y z:z+sin(i+panelSize)*r],
																		[[CityPoint alloc] initWithX:x+cos(i)*r y:y z:z+sin(i)*r], nil]
																		andColorRed:0.0 green:1.0 blue:0.0 border:false]];
			[bottom addObject:[[CityPoint alloc] initWithX:x+cos(i)*r y:y z:z+sin(i)*r]];
			[top addObject:[[CityPoint alloc] initWithX:x+cos(i)*r y:y z:z+sin(i)*r]];
		}
		[polygons addObject:[[BoundingPolygon alloc] initWithCoord:bottom andColorRed:0.0 green:1.0 blue:0.0 border:true]];
		[polygons addObject:[[BoundingPolygon alloc] initWithCoord:top andColorRed:0.0 green:1.0 blue:0.0 border:true]];

	//}
}

@end
