//
//  FileIO.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/17/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "FileIO.h"
#import "BoundingPolygon.h"


@implementation FileIO

+ (CityPolyObject) getPolygonObjectFromFile:(NSString *)filename scaler:(double)scaler{
	//NSMutableArray * polygons = [[NSMutableArray alloc] init];
	NSError *error;
	NSArray * contentsArray = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: filename ofType: @"obj"] encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
	NSArray * materialsArray = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: filename ofType: @"mtl"] encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];

	NSString * line;
	int materialsBound = [[[[materialsArray objectAtIndex:1] componentsSeparatedByString:@" "] lastObject] intValue];
	//NSMutableArray * coords =[[NSMutableArray alloc] init];
	vector<CityVertex> vertices = vector<CityVertex>();
	vector<CityPolygon> faces = vector<CityPolygon>();
	GLfloat diffuseColors [materialsBound][4];

	// Create materials array
	for (int i=2; i<materialsBound*10; i+=10){
		//NSMutableArray * materialsContents = [[NSMutableArray alloc] initWithCapacity:7];
		// Currently only extracing difuse color
		NSArray * colorLine = [[materialsArray objectAtIndex:i+3] componentsSeparatedByString:@" "];						
		if([[materialsArray objectAtIndex:i] length] == 15){
			//[materials replaceObjectAtIndex:0 withObject:materialsContents];
			diffuseColors[0][0] = [[colorLine objectAtIndex:1] doubleValue];
			diffuseColors[0][1] = [[colorLine objectAtIndex:2] doubleValue];
			diffuseColors[0][2] = [[colorLine objectAtIndex:3] doubleValue];
			diffuseColors[0][3] = 1.0;
		}else{
			int dindex = [[[materialsArray objectAtIndex:i] substringFromIndex:16] intValue];
			diffuseColors[dindex][0] = [[colorLine objectAtIndex:1] doubleValue];
			diffuseColors[dindex][1] = [[colorLine objectAtIndex:2] doubleValue];
			diffuseColors[dindex][2] = [[colorLine objectAtIndex:3] doubleValue];
			diffuseColors[dindex][3] = 1.0;
		}
	}
	
	// Create Polygon Array
	int materialIndex = 0;
	for (line in contentsArray) {
		if([line length] != 0){
			NSArray *lineArray = [line componentsSeparatedByString:@" "];

		switch ([line characterAtIndex:0]) {
			case 'v': // Define vertex
				vertices.push_back(CityVertex(scaler * [[lineArray objectAtIndex:1] doubleValue],
											  scaler * [[lineArray objectAtIndex:2] doubleValue],
											  scaler * [[lineArray objectAtIndex:3] doubleValue]));				
				break;
			case 'f': // Define face
			{
				// Default colors for specular and emmissive
				GLfloat sc[4] = {0.0,0.0,0.0,1.0};

				GLfloat ec[4] = {0.0,0.0,0.0,1.0};
				//NSMutableArray * poly = [[NSMutableArray alloc] initWithArray:[materials objectAtIndex:materialIndex]];
				vector<int> vIndices = vector<int>();
				for(int i=1; i<[lineArray count]; i++){
					vIndices.push_back([[lineArray objectAtIndex:i] intValue]-1);
					//int coordIndex = ([[lineArray objectAtIndex:i] intValue]-1)*3;
					//[poly addObject:[coords objectAtIndex:coordIndex]];
					//[poly addObject:[coords objectAtIndex:coordIndex+1]];
					//[poly addObject:[coords objectAtIndex:coordIndex+2]];
				}
				faces.push_back(CityPolygon(vIndices, diffuseColors[materialIndex], sc, ec));
				//[polygons addObject:poly];
				break;
			}
			case 'u': //Change material
				if ([line length] <= 16 || [line characterAtIndex:16] == '(') {
					materialIndex = 0;
				}else {
					materialIndex = [[line substringFromIndex:16] intValue];
				}

				break;

			default:
				break;
		}
		}
	}
	NSLog(@"helloo90");
	NSLog(@"sv %i sf %i", vertices.size(), faces.size());
	return CityPolyObject(vertices, faces);
	
}
@end
