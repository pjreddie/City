

#import "BuildingObject.h"
#import "BoundingPolygon.h"


@implementation BuildingObject

+ (void) initWithBounds:(vector<CityVertex> &)vertices faces:(vector<CityPolygon> &)faces startIndex:(int)si avgHeight:(float)height{
	//[super initWithPolygons:[[NSArray alloc] init]];
	//wallPolygons = [[NSMutableArray alloc] init];
	//basePolygon = bounds;
	//vector<CityVertex> vertices = *v;
	//vector<CityPolygon> faces = *f;
	
	int numberOfTiers = [CityMath poisson:0.5]+1;

	double buildingHeight = std::max([CityMath gausian:height deviation:4], (float)MINHEIGHT);
	double windowSizeX = [CityMath gausian:0.2 deviation:0.05];
	double windowSizeY = [CityMath gausian:0.2 deviation:0.05];
	double windowSeparationX = [CityMath gausian:0.1 deviation:0.05];
	double windowSeparationY = [CityMath gausian:0.1 deviation:0.1];
	
	if(windowSeparationX < 0){
		windowSeparationX = 0.1;
	}if(windowSeparationY <0){
		windowSeparationY = 0.1;
	}
	
	/*if(true){
		[self buildRectangularBuilding];
	}else {
		[self buildCircularBuilding];
	}
	return self;*/
	
	// Colors
	GLfloat dl[4] = {0.5,0.5,0.5,1.0};
	GLfloat sl[4] = {0.0,0.0,0.0,1.0};
	GLfloat el[4] = {0.0,0.0,0.0,1.0};	

	// Add roof vertices
	int ovn = vertices.size();
	int baseSize = ovn - si;
	int startIndexFace = faces.size();
	for (int v=si; v<ovn; v++) {
		vertices.push_back(CityVertex(vertices[v].x, vertices[v].y+buildingHeight, vertices[v].z));
	}
	// Define faces, every original vertex is the starting point for a face

	int nextIndex=si;
	for (int v=si; v<ovn; v++) {
		nextIndex++;
		if (v==(ovn-1)) {
			nextIndex = si;
		}
		int fv[4] = {v,nextIndex,nextIndex+baseSize,v+baseSize};
		vector<int> vv = vector<int>(fv, fv + sizeof(fv)/sizeof(fv[0]));
		faces.push_back(CityPolygon(vv,dl,sl,el, vertices));
	}
	int povn = faces.size();
	//Add Top
	double cx = 0.0, cy = 0.0, cz = 0.0;

	for (int v=ovn; v<vertices.size(); v++) {
		cx += vertices[v].x;
		cy += vertices[v].y;
		cz += vertices[v].z;
	}
	cx /= vertices.size()-ovn;
	cy /= vertices.size()-ovn;
	cz /= vertices.size()-ovn;
	cy += max([CityMath gausian:1.0 deviation:.5],0.0f);
	CityVertex center(cx, cy, cz);
	vertices.push_back(center);
	for (int v=ovn; v<vertices.size()-1; v++) {
		vector<int> tv;
		tv.push_back(v);
		if(v+2 != vertices.size()) tv.push_back(v+1);
		else tv.push_back(ovn);
		tv.push_back(vertices.size()-1);
		
		faces.push_back(CityPolygon(tv, dl, sl,el, vertices));
	}
	
	
	//faces.push_back(CityPolygon(tv,dl,sl,el));
	// defining the building also generates the normals
	//building = CityPolyObject(vertices, faces);
	
	// Add Windows to all building faces except top
	
	//use pointeres!!!!
	//ovn = faces.size();
	
	for (int i=startIndexFace; i<povn; i++) {
		[self addWindowsToFace:i v:vertices f:faces wx:windowSizeX wy:windowSizeY sx:windowSeparationX sy:windowSeparationY];
	}
	//building = CityPolyObject(vertices, faces);	


}
/*
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
		faces.back().calculateNormal(vertices);
	}
	//Add Top
	vector<int> tv = vector<int>();
	for (int v=ovn; v<vertices.size(); v++) {
		tv.push_back(v);
	}
	faces.push_back(CityPolygon(tv,dl,sl,el));
	// defining the building also generates the normals
	//building = CityPolyObject(vertices, faces);
	
	// Add Windows to all building faces except top
	/*ovn = faces.size();
	for (int i=0; i<ovn-1; i++) {
		CityPolyObject tmp = [self addWindowsToFace:faces[i]];
		//change indices
		int vertexEnd = vertices.size();
		for (int p=0; p<tmp.polygons.size(); p++) {
			for (int j=0; j<tmp.polygons[p].vertexList.size(); j++) {
				int tmpv = tmp.polygons[p].vertexList[j];
				tmp.polygons[p].vertexList[j] = tmpv + vertexEnd;
			}
		}
		vertices.insert(vertices.end(), tmp.vertices.begin(), tmp.vertices.end());
		faces.insert(faces.end(), tmp.polygons.begin(), tmp.polygons.end());
	}
	//building = CityPolyObject(vertices, faces);	
}

- (CityPolyObject) cityPoly{
	return building;
}*/

// Populate Windows
+ (void) addWindowsToFace:(int)faceIndex v:(vector<CityVertex> &)vertices f:(vector<CityPolygon> &)faces wx:(double)windowSizeX wy:(double) windowSizeY sx:(double)windowSeparationX sy:(double)windowSeparationY{
	
	// First two points are the base of the face
	CityVertex pointa = vertices[faces[faceIndex].vertexList[0]];
	CityVertex pointb = vertices[faces[faceIndex].vertexList[1]];
	double faceHeight = vertices[faces[faceIndex].vertexList[2]].y - pointa.y;
	
	int initVertexEnd = vertices.size();
	
	//vector<CityVertex> wVertices = vector<CityVertex>(10000);
	//vector<CityPolygon> wPolygons = vector<CityPolygon>(1000);
	
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
	
	int numOfWindowsX = buildingFaceWidth/(windowSizeX+windowSeparationX*2);
	float cornerWindowBufferX = (buildingFaceWidth-(numOfWindowsX*(windowSizeX+windowSeparationX*2)))/2;
	int numOfWindowsY = (deltaY/(windowSizeY+windowSeparationY*2)); 
	float topWindowBufferY = (deltaY-(numOfWindowsY*(windowSizeY+windowSeparationY*2)))/2;

	float adjustedWindowX = deltaX*(windowSizeX/buildingFaceWidth);
	float adjustedWindowZ = deltaZ*(windowSizeX/buildingFaceWidth);
	float adjustedWindowSpacerX = deltaX*(windowSeparationX/buildingFaceWidth);
	float adjustedWindowSpacerZ = deltaZ*(windowSeparationX/buildingFaceWidth);
	
	yAccum = topWindowBufferY;
	int vertexIndex = initVertexEnd;
	// Loop through the plane and make windows
	for(int i=0; i<numOfWindowsY; i++) {
		xAccum = xInit+directionAdjustX*(deltaX*(cornerWindowBufferX/buildingFaceWidth)+adjustedWindowSpacerX);
		zAccum = zInit+(deltaZ*(cornerWindowBufferX/buildingFaceWidth)+adjustedWindowSpacerZ);
		for(int j=0; j<numOfWindowsX; j++){
			//CounterClockwise?
			CityNormal norm = faces[faceIndex].faceNormal;
			vertices.push_back(CityVertex(xAccum + norm.x*.01, deltaY-yAccum + norm.y*.01, zAccum + norm.z*.01));
			vertices.push_back(CityVertex(xAccum+directionAdjustX*adjustedWindowX+ norm.x*.01, deltaY-yAccum+ norm.y*.01, zAccum+adjustedWindowZ+ norm.z*.01));
			vertices.push_back(CityVertex(xAccum+directionAdjustX*adjustedWindowX+ norm.x*.01, deltaY-yAccum-windowSizeY+ norm.y*.01, zAccum+adjustedWindowZ+ norm.z*.01));
			vertices.push_back(CityVertex(xAccum+ norm.x*.01, deltaY-yAccum-windowSizeY+ norm.y*.01, zAccum+ norm.z*.01));
			xAccum = xAccum+directionAdjustX*(adjustedWindowX+2*adjustedWindowSpacerX);
			zAccum = zAccum+(adjustedWindowZ+2*adjustedWindowSpacerZ);
			
			// Add the window!
			if(rand()%4 != 1){
				GLfloat dl[4] = {0.7,0.7,0.7,1.0};
				GLfloat sl[4] = {1.0,1.0,1.0,1.0};
				GLfloat el[4] = {0.0,0.0,0.0,1.0};
				
				int wv[4] = {vertexIndex, vertexIndex+1, vertexIndex+2, vertexIndex+3};
				vector<int> vwv = vector<int>(wv, wv + sizeof(wv)/sizeof(wv[0]));
				vertexIndex += 4;
				faces.push_back(CityPolygon(vwv, dl,sl,el,faces[faceIndex].faceNormal));
				//wPolygons.back().faceNormal = face.faceNormal;
				
			}else{
				GLfloat dl[4] = {0.69,0.7,0.7,1.0};
				GLfloat sl[4] = {1.0,1.0,1.0,1.0};
				GLfloat el[4] = {1.0,1.0,0.3,1.0};	
				
				int wv[4] = {vertexIndex, vertexIndex+1, vertexIndex+2, vertexIndex+3};
				vector<int> vwv = vector<int>(wv, wv + sizeof(wv)/sizeof(wv[0]));
				vertexIndex += 4;
				faces.push_back(CityPolygon(vwv, dl,sl,el,faces[faceIndex].faceNormal));
				//wPolygons.back().faceNormal = face.faceNormal;
				
			}
		}
		yAccum += windowSizeY+2*windowSeparationY;
	}
	//return CityPolyObject(wVertices, wPolygons);
}

/*
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
*/

@end
