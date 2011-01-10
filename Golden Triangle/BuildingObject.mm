

#import "BuildingObject.h"


@implementation BuildingObject

-(BuildingObject *) initWithBounds:(BoundingPolygon *)bounds avgHeight:(float)height {
	[super initWithPolygons:[[NSArray alloc] init]];
	wallPolygons = [[NSMutableArray alloc] init];
	basePolygon = bounds;
	numberOfTiers = [CityMath poisson:0.5]+1;
	buildingHeight = [CityMath gausian:height deviation:0.5];
	windowSizeX = [CityMath gausian:0.2 deviation:0.05];
	windowSizeY = [CityMath gausian:0.2 deviation:0.05];
	windowSeperationX = [CityMath gausian:0.1 deviation:0.05];
	windowSeperationY = [CityMath gausian:0.1 deviation:0.1];
	
	if(true){
		[self buildRectangularBuilding];
	}else {
		[self buildCircularBuilding];
	}
	return self;
}

- (void) buildRectangularBuilding {
	int bounds = [[basePolygon coordinates] count];
	int nextindex;
	NSMutableArray * roofPolygon = [[NSMutableArray alloc] init];
	// Draw walls
	for(int t=0; t<numberOfTiers;t++){
		//Change Me! I dont look as good as possible
		int tierHeight = buildingHeight;//[CityMath gausian:buildingHeight/numberOfTiers deviation:1.0];
		for(int i=0; i<bounds; i++){
			if (i==bounds-1) {
				nextindex = 0;
			}else{
				nextindex = i+1;
			}
			CityPoint * pointa = [[basePolygon coordinates] objectAtIndex:i];
			CityPoint * pointb = [[basePolygon coordinates] objectAtIndex:nextindex];
			[wallPolygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:pointa,
																			[[CityPoint alloc] initWithX:[pointa x] y:[pointa y]+tierHeight z:[pointa z]],
																			[[CityPoint alloc] initWithX:[pointb x] y:[pointb y]+tierHeight z:[pointb z]],
																			pointb,
																			nil] andColorRed:[basePolygon red] green:[basePolygon green] blue:[basePolygon blue] border:true]];
			[roofPolygon addObject:[[CityPoint alloc] initWithX:[pointa x] y:[pointa y]+tierHeight z:[pointa z]]];
			[self addWindowsToFace:pointa pt2:pointb h:tierHeight];
		}
		//Update basePolygon
		if (t+1<numberOfTiers) {
			//Use current base as bounds for a new polygon
		}
	}
	//add flat top
	[wallPolygons addObject:[[BoundingPolygon alloc] initWithCoord:roofPolygon andColorRed:[basePolygon red] green:[basePolygon green] blue:[basePolygon blue] border:true]];
}

- (void) buildCircularBuilding {
	// NEED A CENTER POINT AND A RADIUS - obtain from passed in polygon
	float x=3.0, y=-0.9, z=-2.0, r = 3.0;
	float panelSize = 0.01;
	NSMutableArray * bottom = [[NSMutableArray alloc] init];
	NSMutableArray * top = [[NSMutableArray alloc] init];
	for(float i=0; i<2*3.14159265; i+=panelSize){
		[polygonList addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:
																	[[CityPoint alloc] initWithX:x+cos(i)*r y:y+buildingHeight z:z+sin(i)*r],
																	[[CityPoint alloc] initWithX:x+cos(i+panelSize)*r y:y+buildingHeight z:z+sin(i+panelSize)*r],
																	[[CityPoint alloc] initWithX:x+cos(i+panelSize)*r y:y z:z+sin(i+panelSize)*r],
																	[[CityPoint alloc] initWithX:x+cos(i)*r y:y z:z+sin(i)*r], nil]
													   andColorRed:0.0 green:1.0 blue:0.0 border:false]];
		[bottom addObject:[[CityPoint alloc] initWithX:x+cos(i)*r y:y z:z+sin(i)*r]];
		[top addObject:[[CityPoint alloc] initWithX:x+cos(i)*r y:y z:z+sin(i)*r]];
	}
	[polygonList addObject:[[BoundingPolygon alloc] initWithCoord:bottom andColorRed:0.0 green:1.0 blue:0.0 border:true]];
	[polygonList addObject:[[BoundingPolygon alloc] initWithCoord:top andColorRed:0.0 green:1.0 blue:0.0 border:true]];	
}

- (void) addWindowsToFace:(CityPoint *)pointa pt2:(CityPoint *)pointb h:(float)faceHeight{
	// Populate Windows
	float deltaX,deltaZ,xAccum,zAccum,yAccum,zInit,xInit;
	float directionAdjustX = 1.0;
	float deltaY = faceHeight + [pointa y];
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
	
	int numOfWindowsX = buildingFaceWidth/(windowSizeX+windowSeperationX*2);
	float cornerWindowBufferX = (buildingFaceWidth-(numOfWindowsX*(windowSizeX+windowSeperationX*2)))/2;
	int numOfWindowsY = (deltaY/(windowSizeY+windowSeperationY*2)); 
	float topWindowBufferY = (deltaY-(numOfWindowsY*(windowSizeY+windowSeperationY*2)))/2;

	float adjustedWindowX = deltaX*(windowSizeX/buildingFaceWidth);
	float adjustedWindowZ = deltaZ*(windowSizeX/buildingFaceWidth);
	float adjustedWindowSpacerX = deltaX*(windowSeperationX/buildingFaceWidth);
	float adjustedWindowSpacerZ = deltaZ*(windowSeperationX/buildingFaceWidth);
	
	yAccum = topWindowBufferY;
	// Loop through the plane and make windows
	NSLog(@"%i",numOfWindowsY*numOfWindowsX);
	for(int i=0; i<numOfWindowsY; i++) {
		xAccum = xInit+directionAdjustX*(deltaX*(cornerWindowBufferX/buildingFaceWidth)+adjustedWindowSpacerX);
		zAccum = zInit+(deltaZ*(cornerWindowBufferX/buildingFaceWidth)+adjustedWindowSpacerZ);
		for(int j=0; j<numOfWindowsX; j++){
			//CounterClockwise?
			[wallPolygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:xAccum y:deltaY-yAccum	z:zAccum],
																		[[CityPoint alloc] initWithX:xAccum+directionAdjustX*adjustedWindowX y:deltaY-yAccum z:zAccum+adjustedWindowZ],
																		[[CityPoint alloc] initWithX:xAccum+directionAdjustX*adjustedWindowX y:deltaY-yAccum-windowSizeY z:zAccum+adjustedWindowZ],
																		[[CityPoint alloc] initWithX:xAccum y:deltaY-yAccum-windowSizeY z:zAccum],
																		nil] andColorRed:0.0 green:1.0 blue:0.0 border:true]];
			xAccum = xAccum+directionAdjustX*(adjustedWindowX+2*adjustedWindowSpacerX);
			zAccum = zAccum+(adjustedWindowZ+2*adjustedWindowSpacerZ);
		}
		yAccum += windowSizeY+2*windowSeperationY;
	}
}

- (NSArray *) polygons {
	return wallPolygons;
}
- (void) dealloc {
	[super dealloc];
	[self release];
}


@end
