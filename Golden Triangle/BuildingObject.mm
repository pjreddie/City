

#import "BuildingObject.h"
#import "BoundingPolygon.h"


@implementation BuildingObject

-(BuildingObject *) initWithBounds:(vector<CityVertex>)v avgHeight:(float)height{
	[super initWithPolygons:[[NSArray alloc] init]];
	//wallPolygons = [[NSMutableArray alloc] init];
	//basePolygon = bounds;
	
	vertices = vector<CityVertex>(v);
	faces = vector<CityPolygon>();
	
	
	
	numberOfTiers = [CityMath poisson:0.5]+1;

	buildingHeight = std::max([CityMath gausian:height deviation:3], (float)MINHEIGHT);
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
	// Colors
	GLfloat dl[4] = {0.5,0.5,0.5,1.0};
	GLfloat sl[4] = {0.0,0.0,0.0,1.0};
	GLfloat el[4] = {0.0,0.0,0.0,1.0};	
	// Add roof vertices
	int ovn = vertices.size();
	for (int v=0; v<ovn; v++) {
		vertices.push_back(CityVertex(vertices[v].x, vertices[v].y+buildingHeight, vertices[v].z));
	}

	// Define faces, every original vertex is the starting point for a face
	int nextIndex=0;
	for (int v=0; v<ovn; v++) {
		nextIndex++;
		if (v==(ovn-1)) {
			nextIndex = 0;
		}
		int fv[4] = {v,nextIndex,nextIndex+ovn,v+ovn};
		vector<int> vv = vector<int>(fv, fv + sizeof(fv)/sizeof(fv[0]));
		faces.push_back(CityPolygon(vv,dl,sl,el));
	}
	//Add Top
	vector<int> tv = vector<int>();
	for (int v=ovn; v<vertices.size(); v++) {
		tv.push_back(v);
	}
	faces.push_back(CityPolygon(tv,dl,sl,el));
	// defining the building also generates the normals
	building = CityPolyObject(vertices, faces);
	
	// Add Windows to all building faces except top
	/*
	ovn = faces.size();
	for (int i=0; i<ovn-1; i++) {
		CityPolyObject tmp = [self addWindowsToFace:faces[i]];
		//change indices
		int vertexEnd = vertices.size();
		for (int p=0; p<tmp.polygons.size(); p++) {
			for (int j=0; j<tmp.polygons[p].vertexList.size(); j++) {
				int tmpv = tmp.polygons[p].vertexList[j];
				tmp.polygons[p].vertexList[j] = tmpv + vertexEnd; ///problem
			}
		}
		vertices.insert(vertices.end(), tmp.vertices.begin(), tmp.vertices.end());
		faces.insert(faces.end(), tmp.polygons.begin(), tmp.polygons.end());
	}
	building = CityPolyObject(vertices, faces);*/
	
}

- (CityPolyObject) cityPoly{
	return building;
}

// Populate Windows
- (CityPolyObject) addWindowsToFace:(CityPolygon)face{
	// First two points are the base of the face
	CityVertex pointa = vertices[face.vertexList[0]];
	CityVertex pointb = vertices[face.vertexList[1]];
	double faceHeight = vertices[face.vertexList[2]].y - pointa.y;
	
	vector<CityVertex> wVertices = vector<CityVertex>();
	vector<CityPolygon> wPolygons = vector<CityPolygon>();
	
	float deltaX,deltaZ,xAccum,zAccum,yAccum,zInit,xInit;
	float directionAdjustX = 1.0;
	float deltaY = faceHeight + pointa.y;
	if (pointa.x > pointb.x) {
		deltaX = pointa.x - pointb.x;
	}else {
		deltaX = pointb.x - pointa.x;
	}
	if (pointa.z > pointb.z) {
		deltaZ = pointa.z - pointb.z;
		xInit = pointb.x;
		zInit = pointb.z;
		if (pointa.x < pointb.x) {
			directionAdjustX = -1.0;
		}
	}else {
		deltaZ = pointb.z - pointa.z;
		xInit = pointa.x;
		zInit = pointa.z;
		if (pointb.x < pointa.x) {
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
	int vertexIndex =0;
	// Loop through the plane and make windows
	for(int i=0; i<numOfWindowsY; i++) {
		xAccum = xInit+directionAdjustX*(deltaX*(cornerWindowBufferX/buildingFaceWidth)+adjustedWindowSpacerX);
		zAccum = zInit+(deltaZ*(cornerWindowBufferX/buildingFaceWidth)+adjustedWindowSpacerZ);
		for(int j=0; j<numOfWindowsX; j++){
			//CounterClockwise?
			wVertices.push_back(CityVertex(xAccum, deltaY-yAccum, zAccum));
			wVertices.push_back(CityVertex(xAccum+directionAdjustX*adjustedWindowX, deltaY-yAccum, zAccum+adjustedWindowZ));
			wVertices.push_back(CityVertex(xAccum+directionAdjustX*adjustedWindowX, deltaY-yAccum-windowSizeY, zAccum+adjustedWindowZ));
			wVertices.push_back(CityVertex(xAccum, deltaY-yAccum-windowSizeY, zAccum));
/*
			[wallPolygons addObject:[[BoundingPolygon alloc] initWithCoord:[[NSArray alloc] initWithObjects:[[CityPoint alloc] initWithX:xAccum y:deltaY-yAccum	z:zAccum],
																		[[CityPoint alloc] initWithX:xAccum+directionAdjustX*adjustedWindowX y:deltaY-yAccum z:zAccum+adjustedWindowZ],
																		[[CityPoint alloc] initWithX:xAccum+directionAdjustX*adjustedWindowX y:deltaY-yAccum-windowSizeY z:zAccum+adjustedWindowZ],
																		[[CityPoint alloc] initWithX:xAccum y:deltaY-yAccum-windowSizeY z:zAccum],
																		nil] andColorRed:1.0 green:1.0 blue:.328 border:true]];*/
			xAccum = xAccum+directionAdjustX*(adjustedWindowX+2*adjustedWindowSpacerX);
			zAccum = zAccum+(adjustedWindowZ+2*adjustedWindowSpacerZ);
			
			// Add the window!
			GLfloat dl[4] = {0.5,0.5,0.0,1.0};
			GLfloat sl[4] = {0.0,0.0,0.0,1.0};
			GLfloat el[4] = {0.0,0.0,0.0,1.0};				
			int wv[4] = {vertexIndex, vertexIndex+1, vertexIndex+2, vertexIndex+3};
			vector<int> vwv = vector<int>(wv, wv + sizeof(wv)/sizeof(wv[0]));
			vertexIndex += 4;
			wPolygons.push_back(CityPolygon(vwv, dl,sl,el));
		}
		yAccum += windowSizeY+2*windowSeperationY;
	}
	return CityPolyObject(wVertices, wPolygons);
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


- (NSArray *) polygons {
	//return wallPolygons;
}
- (void) dealloc {
	[super dealloc];
	[self release];
}


@end
