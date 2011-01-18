//
//  FileIO.m
//  Golden Triangle
//
//  Created by Alex Bullard on 1/17/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import "FileIO.h"

@implementation FileIO

+ (NSMutableArray *) getPolygonObjectFromFile:(NSString *)filename scaler:(double)scaler{
	NSMutableArray * polygons = [[NSMutableArray alloc] init];
	NSError *error;
	NSArray * contentsArray = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: filename ofType: @"obj"] encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
	NSArray * materialsArray = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: filename ofType: @"mtl"] encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];

	NSString * line;
	int materialsBound = [[[[materialsArray objectAtIndex:1] componentsSeparatedByString:@" "] lastObject] intValue];
	NSMutableArray * coords =[[NSMutableArray alloc] init];
	NSMutableArray * materials = [[NSMutableArray alloc] initWithCapacity:materialsBound];
	for (int i=0; i<materialsBound; i++) {
		[materials addObject:[NSNull alloc]];
	}	
	NSLog(@"materials b%i", materialsBound);

	// Create materials array
	for (int i=2; i<materialsBound*10; i+=10){
		NSMutableArray * materialsContents = [[NSMutableArray alloc] initWithCapacity:7];
		// Currently only extracing difuse color
		NSArray * colorLine = [[materialsArray objectAtIndex:i+3] componentsSeparatedByString:@" "];
		[materialsContents addObject:[[NSNumber alloc] initWithDouble:[[colorLine objectAtIndex:1] doubleValue]]];
		[materialsContents addObject:[[NSNumber alloc] initWithDouble:[[colorLine objectAtIndex:2] doubleValue]]];
		[materialsContents addObject:[[NSNumber alloc] initWithDouble:[[colorLine objectAtIndex:3] doubleValue]]];
		
		if([[materialsArray objectAtIndex:i] length] == 15){
			[materials replaceObjectAtIndex:0 withObject:materialsContents];
		}else{
			[materials replaceObjectAtIndex:[[[materialsArray objectAtIndex:i] substringFromIndex:16] intValue] withObject:materialsContents];
		}
	}
	
	// Create Polygon Array
	int materialIndex = 0;
	for (line in contentsArray) {
		if([line length] != 0){
			NSArray *lineArray = [line componentsSeparatedByString:@" "];

		switch ([line characterAtIndex:0]) {
			case 'v': // Define vertex
				[coords addObject:[[NSNumber alloc] initWithDouble:scaler * [[lineArray objectAtIndex:1] doubleValue]]];
				[coords addObject:[[NSNumber alloc] initWithDouble:scaler * [[lineArray objectAtIndex:2] doubleValue]]];
				[coords addObject:[[NSNumber alloc] initWithDouble:scaler * [[lineArray objectAtIndex:3] doubleValue]]];
				
				break;
			case 'f': // Define face
				true;
				NSMutableArray * poly = [[NSMutableArray alloc] initWithArray:[materials objectAtIndex:materialIndex]];
				for(int i=1; i<[lineArray count]; i++){
					int coordIndex = ([[lineArray objectAtIndex:i] intValue]-1)*3;
					[poly addObject:[coords objectAtIndex:coordIndex]];
					[poly addObject:[coords objectAtIndex:coordIndex+1]];
					[poly addObject:[coords objectAtIndex:coordIndex+2]];
				}
				[polygons addObject:poly];
				break;
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
		
	return polygons;
	
}
@end
