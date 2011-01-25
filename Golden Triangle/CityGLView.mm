//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import "CityGLView.h"

@implementation CityGLView


// Draw from polygonList
- (void) drawPolygons 
{
	glCallList(displayLists[2]);
}

/*
 * Resize ourself
 */
- (void) reshape:(NSRect)frame
{ 	
	[ [ self openGLContext ] update ];
	// Reset current viewport
	glViewport( 0, 0, frame.size.width, frame.size.height );
	glMatrixMode( GL_PROJECTION );   // Select the projection matrix
	glLoadIdentity();                // and reset it
	// Calculate the aspect ratio of the view
	gluPerspective( 45.0f, frame.size.width / frame.size.height, 0.5f, 1000.0f );
	glMatrixMode( GL_MODELVIEW );    // Select the modelview matrix
	glLoadIdentity();                // and reset it
}

- (void) initLighting {	
	/*
	 glEnable(GL_FOG);
	 glFogi(GL_FOG_MODE, GL_LINEAR);
	 glFogf(GL_FOG_START, 20.0f);
	 glFogf(GL_FOG_END, 100.0f);
	 */
	time = 6.0;
	glEnable ( GL_LIGHTING ) ;
	glEnable(GL_LIGHT0);
	//glEnable(GL_COLOR_MATERIAL);
	//glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
	//glEnable(GL_NORMALIZE);
	
	glColor3f(1.0, 0.0, 0.0);
	
	glShadeModel(GL_SMOOTH);
	
	//GLfloat matSpec[] = {0.2f, 0.2f, 0.2f, 1.0f};
	//glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, matSpec);
	//GLfloat matEm[] = {0.1f, 0.1f, 0.1f, 1.0f};
	//glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, matEm);
	
}

- (void) createPolygonObject:(CityPolyObject) polygon index:(int)index {
	glNewList(displayLists[index], GL_COMPILE);
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
	glBegin(GL_TRIANGLES);
	for(int i=0; i<polygon.polygons.size(); i++){
		glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, polygon.polygons[i].diffuseLight);
		glMaterialfv(GL_FRONT, GL_SPECULAR, polygon.polygons[i].specularLight);
		glMaterialfv(GL_FRONT, GL_EMISSION, polygon.polygons[i].emissiveLight);		
		for(int j=0; j<polygon.polygons[i].vertexList.size(); j++){
			CityVertex v = polygon.vertices[polygon.polygons[i].vertexList[j]];
			glNormal3f(v.vertexNormal.x, v.vertexNormal.y, v.vertexNormal.z);
			glVertex3f(v.x, v.y, v.z);
		}
	}
	glEnd();
	glEndList();
	displayLists[index+1] = displayLists[index]+1;
}

- (void) initDisplayLists {	
	// Draw static display lists
	// Stop sign
	displayLists[0] = glGenLists(MAX_DISPLAY_LISTS);
	[self createPolygonObject:[FileIO getPolygonObjectFromFile:@"stopsign" scaler:STOPSIGN_SCALER] index:0];
	[self createPolygonObject:[FileIO getPolygonObjectFromFile:@"stoplight" scaler:STOPLIGHT_SCALER] index:1];
	
	// Populates polygonsToDraw with all generated polygons
	vector<CityPolyObject> polygonObjToDraw = vector<CityPolyObject>();
	CityPregen pregenCoords = CityPregen();
	[CityGen masterGenerate:self polyObjs:&polygonObjToDraw pregenObjs:&pregenCoords];
	NSLog(@"creating display lists...");

	// Draw generated ojbects
	glNewList(displayLists[2], GL_COMPILE);
	for(int l=0; l<2; l++){
		if (l==0) {
			glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		}else {
			glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
		}
		
		
		for (int vn=3; vn<=5; vn++) {
			switch (vn) {
				case 3: glBegin(GL_TRIANGLES); break;
				case 4: glBegin(GL_QUADS); break;
				default: break;			
			}
			for(int obj=0; obj<polygonObjToDraw.size(); obj++){
				for (int face=0; face<polygonObjToDraw[obj].polygons.size(); face++) {
					if(l==0){
						glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, polygonObjToDraw[obj].polygons[face].diffuseLight);
						glMaterialfv(GL_FRONT, GL_SPECULAR, polygonObjToDraw[obj].polygons[face].specularLight);
						glMaterialfv(GL_FRONT, GL_EMISSION, polygonObjToDraw[obj].polygons[face].emissiveLight);
						glNormal3f(polygonObjToDraw[obj].polygons[face].faceNormal.x,
								   polygonObjToDraw[obj].polygons[face].faceNormal.y,
								   polygonObjToDraw[obj].polygons[face].faceNormal.z );
						
					}else{
						GLfloat t[4] ={1.0,1.0,1.0,1.0};
						glMaterialfv(GL_FRONT, GL_AMBIENT_AND_DIFFUSE, t);
					}
					if(polygonObjToDraw[obj].polygons[face].vertexList.size() == vn || (vn==5 && polygonObjToDraw[obj].polygons[face].vertexList.size() > 4)){
						if (vn==5) {
							glBegin(GL_POLYGON);
						}
						for (int vertex=0; vertex<polygonObjToDraw[obj].polygons[face].vertexList.size(); vertex++) {
							//glNormal3f(polygonObjToDraw[obj].vertices[polygonObjToDraw[obj].polygons[face].vertexList[vertex]].vertexNormal.x,
							//		   polygonObjToDraw[obj].vertices[polygonObjToDraw[obj].polygons[face].vertexList[vertex]].vertexNormal.y, 
							//		   polygonObjToDraw[obj].vertices[polygonObjToDraw[obj].polygons[face].vertexList[vertex]].vertexNormal.z);
							glVertex3f(polygonObjToDraw[obj].vertices[polygonObjToDraw[obj].polygons[face].vertexList[vertex]].x,
									   polygonObjToDraw[obj].vertices[polygonObjToDraw[obj].polygons[face].vertexList[vertex]].y, 
									   polygonObjToDraw[obj].vertices[polygonObjToDraw[obj].polygons[face].vertexList[vertex]].z);
							
						}
						if (vn==5){
							glEnd();
						}
					}
				}
			}
			if (vn<5) {
				glEnd();
			}
		}
	}
	
	// Draw pregenerated objects
	glTranslated(0.0, -0.9, 0.0);
	for (int i=0; i<=PREGEN_MAX; i++) {
		for(int j=0; j<pregenCoords.coordinates[i].size(); j++){
			CityCoordinate tcc = pregenCoords.coordinates[i][j];
			glRotated(tcc.r, 0.0, 1.0, 0.0);
			glTranslated(tcc.x,0.0,tcc.z);
			glCallList(displayLists[i]);
			glTranslated(-tcc.x,0.0,-tcc.z);
			glRotated(-tcc.r, 0.0, 1.0, 0.0);
		}
	}
	glEndList();
}

- (void) addLoadingMessage:(NSString *)message {
	NSLog(message);

		glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
		glLoadIdentity();
		glPushAttrib(GL_ENABLE_BIT);
		glEnable(GL_TEXTURE_2D);
		glDisable(GL_DEPTH_TEST);
		glDisable(GL_LIGHTING);
		glDisable(GL_BLEND);
	
		// Just in case we set all vertices to white.
		glColor3f(1,1,1);
		glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		float verticalOffset = 1.50;
		for(int i=0; i<=numberOfLoadMessages; i++){
			glBindTexture( GL_TEXTURE_2D, texture[ TEXTURE_LOADING_START+i ] ); 
			glBegin(GL_POLYGON);
			glTexCoord2f(0.0f, 0.0f); glVertex3f(-9.0f, -6.0f + i*verticalOffset, -15.0f);
			glTexCoord2f(1.0f, 0.0f); glVertex3f( 2.0f, -6.0f+ i*verticalOffset, -15.0f);
			glTexCoord2f(1.0f, 1.0f); glVertex3f( 2.0f, -4.0f+ i*verticalOffset, -15.0f);
			glTexCoord2f(0.0f, 1.0f); glVertex3f(-9.0f, -4.0f+ i*verticalOffset, -15.0f);
			glEnd();		
		}
		glPopAttrib();
		glEnable(GL_DEPTH_TEST);
	
		[ [ self openGLContext ] flushBuffer ];
		numberOfLoadMessages++;
	
}

/*
 * Initial OpenGL setup
 */
- (void) initializeGL:(NSRect)frame
{ 	
	[self reshape:frame];
	if( ![ self loadGLTextures]){
		
		NSLog(@"Error loading textures");
	}
	
	glShadeModel( GL_SMOOTH );                // Enable smooth shading
	glEnable(GL_LINE_SMOOTH);
	glClearColor( 0.0f, 0.0f, 0.0f, 0.5f );   // Black background
	glEnable( GL_DEPTH_TEST );                // Enable depth testing
	glDepthFunc( GL_LEQUAL );                 // Type of depth test to do
	glClearDepth( 1.0f );                     // Depth buffer setup
	// Really nice perspective calculations
	glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST );
	[self initLighting];
	[ self setNeedsDisplay: YES ] ;
	
	
}

- (void) initializeData {

	fullscreen = false;
	xTranslate = 0.0;
	yTranslate = 0.0;
	zTranslate = 0.0;
	dRotated = 0.0;
	loadState = 0;
	
}

-(bool) fullscreen {
	fullscreen = !fullscreen;
	return !fullscreen;
}

/*  Draw Method - 
 Called every 0.015 seconds */
-(void) draw:(NSRect) bounds {
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
	glLoadIdentity();
	if(loadState == 2){
		double t = (3.14159265*dRotated)/180;
		double s = (3.14159265*xRotated)/180;
		if(movingLeft == true){
			zTranslate += DMOVE*-cos(t+3.14159265/2);
			xTranslate += DMOVE*sin(t+3.14159265/2);
		}if(movingRight == true){
			zTranslate += DMOVE*-cos(t-3.14159265/2);
			xTranslate += DMOVE*sin(t-3.14159265/2);
		}if(movingUp == true){
			zTranslate += DMOVE*cos(t)*cos(s);
			xTranslate += DMOVE*-sin(t)*cos(s);
			yTranslate += DMOVE*sin(s);
		}if(movingDown == true){
			zTranslate += DMOVE*-cos(t)*cos(s);
			xTranslate += DMOVE*sin(t)*cos(s);
			yTranslate += DMOVE*-sin(s);
		}if (rotating) {
			dRotated += 0.5*rotateDirection;
		}
				
		time = fmod(time+.01, 24.);		
		
		glRotated(dRotated, 0.0, 1.0, 0.0);
		glRotated(xRotated,  cos(t), 0.0, sin(t));
		glTranslated(xTranslate,yTranslate,zTranslate);		
		
		
		if ( time > 6 && time < 18){
			double p = 1.5*PI*(time-6)/12;
			// Create light components
			GLfloat ambientLight[] = { 0.5f, 0.5f, 0.5f, 1.0f };
			GLfloat diffuseLight[] = { 1.0f, 1.0f, 1.0, 1.0f };
			GLfloat specularLight[] = { 0.7f, 0.7f, 0.7f, 1.0f };
			GLfloat position[] = { 0.0f, 1000.0*sin(p), 1000.0*cos(p),1.0f };
			
			// Assign created components to GL_LIGHT0
			glLightfv(GL_LIGHT0, GL_AMBIENT, ambientLight);
			glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuseLight);
			glLightfv(GL_LIGHT0, GL_SPECULAR, specularLight);
			glLightfv(GL_LIGHT0, GL_POSITION, position);
						
			
		}else{
			
			// Create light components
			GLfloat ambientLight[] = { 0.2f, 0.2f, 0.4f, 1.0f };
			GLfloat diffuseLight[] = { 0.8f, 0.8f, 1.0, 1.0f };
			GLfloat specularLight[] = { 0.5f, 0.5f, 0.8f, 1.0f };
			GLfloat position[] = { -1.5f, 1.0f, -4.0f, 1.0f };
			
			// Assign created components to GL_LIGHT0
			glLightfv(GL_LIGHT0, GL_AMBIENT, ambientLight);
			glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuseLight);
			glLightfv(GL_LIGHT0, GL_SPECULAR, specularLight);
			glLightfv(GL_LIGHT0, GL_POSITION, position);
			
		}
		
		[self drawSkybox];
		[self drawPolygons];
	}else if (loadState == 0){
		loadState = 1;
		numberOfLoadMessages = 0;
		[self initDisplayLists];
		loadState = 2;
	}
	[ [ self openGLContext ] flushBuffer ];
}

- (BOOL) loadGLTextures
{
	BOOL status = FALSE;
	
	if( [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"north.bmp" ] intoIndex:0 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"west.bmp" ] intoIndex:1 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"south.bmp" ] intoIndex:2 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"east.bmp" ] intoIndex:3 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"up.bmp" ] intoIndex:4 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"down.bmp" ] intoIndex:5 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"loading1.bmp" ] intoIndex:6 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"loading2.bmp" ] intoIndex:7 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"loading3.bmp" ] intoIndex:8 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"loading4.bmp" ] intoIndex:9 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"Sun.bmp" ] intoIndex:10 ]

	   
	   )
	{
		status = TRUE;
		for(int i=0; i<=TEXTURE_END; i++){
			glGenTextures( 1, &texture[ i ] );   // Create the texture
			// Typical texture generation using data from the bitmap
			glBindTexture( GL_TEXTURE_2D, texture[ i ] );
			
			glTexImage2D( GL_TEXTURE_2D, 0, 3, texSize[ i ].width,
						 texSize[ i ].height, 0, texFormat[ i ],
						 GL_UNSIGNED_BYTE, texBytes[ i ] );
			
			// Linear filtering
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
			glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
			//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
			//glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
			
			
			free( texBytes[ i ] );
		}
	}
	
	return status;
}

/*
 * The NSBitmapImageRep is going to load the bitmap, but it will be
 * setup for the opposite coordinate system than what OpenGL uses, so
 * we copy things around.
 */
- (BOOL) loadBitmap:(NSString *)filename intoIndex:(int)texIndex
{
	BOOL success = FALSE;
	NSBitmapImageRep *theImage;
	int bitsPPixel, bytesPRow;
	unsigned char *theImageData;
	int rowNum, destRowNum;
	
	theImage = [ NSBitmapImageRep imageRepWithContentsOfFile:filename ];
	if( theImage != nil )
	{
		bitsPPixel = [ theImage bitsPerPixel ];
		bytesPRow = [ theImage bytesPerRow ];
		if( bitsPPixel == 24 )        // No alpha channel
			texFormat[ texIndex ] = GL_RGB;
		else if( bitsPPixel == 32 )   // There is an alpha channel
			texFormat[ texIndex ] = GL_RGBA;
		texSize[ texIndex ].width = [ theImage pixelsWide ];
		texSize[ texIndex ].height = [ theImage pixelsHigh ];
		texBytes[ texIndex ] = (char*)calloc( bytesPRow * texSize[ texIndex ].height, 
											 1 );
		if( texBytes[ texIndex ] != NULL )
		{
			success = TRUE;
			theImageData = [ theImage bitmapData ];
			destRowNum = 0;
			for( rowNum = texSize[ texIndex ].height - 1; rowNum >= 0;
				rowNum--, destRowNum++ )
			{
				// Copy the entire row in one shot
				memcpy( texBytes[ texIndex ] + ( destRowNum * bytesPRow ),
					   theImageData + ( rowNum * bytesPRow ),
					   bytesPRow );
			}
		}
	}
	
	return success;
}

/*
 * Draws the skybox
 */
- (void) drawSkybox {
	glPushMatrix();
	
	double t = (3.14159265*dRotated)/180;
	
    // Reset and transform the matrix.
    glLoadIdentity();
	glRotated(dRotated, 0.0, 1.0, 0.0);
	glRotated(xRotated,  cos(t), 0.0, sin(t));
	
	/* gluLookAt(
	 0,0,0,
	 camera->x(),camera->y(),camera->z(),
	 0,1,0);*/
	
    // Enable/Disable features
    glPushAttrib(GL_ENABLE_BIT);
	glEnable(GL_TEXTURE_2D);
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_LIGHTING);
    glDisable(GL_BLEND);
	
    // Just in case we set all vertices to white.
    glColor3f(1,1,1);
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
	
    // Render the front quad
	glBindTexture( GL_TEXTURE_2D, texture[ 0 ] ); 
    glBegin(GL_POLYGON);
	glTexCoord2f( 0.0f, 0.0f );
	glVertex3f(  1.5f, -1.5f, -1.5f );
	glTexCoord2f( 1.0f, 0.0f );
	glVertex3f( -1.5f, -1.5f, -1.5f );
	glTexCoord2f( 1.0f, 1.0f );
	glVertex3f( -1.5f,  1.5f, -1.5f );
	glTexCoord2f( 0.0f, 1.0f );
	glVertex3f(  1.5f,  1.5f, -1.5f );
    glEnd();
	
    // Render the left quad
	glBindTexture( GL_TEXTURE_2D, texture[ 1 ] ); 
	
    glBegin(GL_QUADS);
	glTexCoord2f( 0.0f, 0.0f );
	
	glVertex3f(  1.0f, -1.0f,  1.0f );
	glTexCoord2f( 1.0f, 0.0f );
	
	glVertex3f(  1.0f, -1.0f, -1.0f );
	glTexCoord2f( 1.0f, 1.0f );
	glVertex3f(  1.0f,  1.0f, -1.0f );
	glTexCoord2f( 0.0f, 1.0f );
	glVertex3f(  1.0f,  1.0f,  1.0f );
    glEnd();
	
    // Render the back quad
	glBindTexture( GL_TEXTURE_2D, texture[ 2 ] ); 
	
    glBegin(GL_QUADS);
	glTexCoord2f( 0.0f, 0.0f );
	glVertex3f( -1.0f, -1.0f,  1.0f );
	glTexCoord2f( 1.0f, 0.0f );
	
	glVertex3f(  1.0f, -1.0f,  1.0f );
	glTexCoord2f( 1.0f, 1.0f );
	glVertex3f(  1.0f,  1.0f,  1.0f );
	glTexCoord2f( 0.0f, 1.0f );
	glVertex3f( -1.0f,  1.0f,  1.0f );
	
    glEnd();
	
    // Render the right quad	
	glBindTexture( GL_TEXTURE_2D, texture[ 3 ] ); 
	
    glBegin(GL_QUADS);
	glTexCoord2f( 0.0f, 0.0f );
	
	glVertex3f( -1.0f, -1.0f, -1.0f );
	glTexCoord2f( 1.0f, 0.0f );
	glVertex3f( -1.0f, -1.0f,  1.0f );
	glTexCoord2f( 1.0f, 1.0f );
	glVertex3f( -1.0f,  1.0f,  1.0f );
	glTexCoord2f( 0.0f, 1.0f );
	glVertex3f( -1.0f,  1.0f, -1.0f );
    glEnd();
	
    // Render the top quad
	glBindTexture( GL_TEXTURE_2D, texture[ 4 ] ); 
	
    glBegin(GL_QUADS);
	glTexCoord2f( 0.0f, 1.0f );
	
	glVertex3f( -1.0f,  1.0f, -1.0f );
	glTexCoord2f( 0.0f, 0.0f );
	
	
	glVertex3f( -1.0f,  1.0f,  1.0f );
	glTexCoord2f( 1.0f, 0.0f );
	
	glVertex3f(  1.0f,  1.0f,  1.0f );
	glTexCoord2f( 1.0f, 1.0f );
	
	glVertex3f(  1.0f,  1.0f, -1.0f );
	
    glEnd();
	
    // Render the bottom quad
	glBindTexture( GL_TEXTURE_2D, texture[ 5 ] ); 
	
    glBegin(GL_QUADS);
	glTexCoord2f( 0.0f, 0.0f );
	glVertex3f( -1.0f, -1.0f, -1.0f );
	
	glTexCoord2f( 1.0f, 0.0f );
	glVertex3f( 1.0f, -1.0f,  -1.0f );
	
	glTexCoord2f( 1.0f, 1.0f );
	glVertex3f(  1.0f, -1.0f,  1.0f );
	
	glTexCoord2f( 0.0f, 1.0f );
	glVertex3f(  -1.0f, -1.0f, 1.0f );
    
	glEnd();

	// Draw the Sun
	if(time > 6 && time < 18){
		double p = PI*((time-6)/12);
		
		glBindTexture( GL_TEXTURE_2D, texture[ 10 ] );
		glTranslatef(0.0f, 10.0*sin(p), 10.0*cos(p));
		drawsphere(1, 1.0f);
		glTranslatef(0.0f, -10.0*sin(p), -10.0*cos(p));
	}
	
	
    // Restore enable bits and matrix
    glPopAttrib();
	glEnable(GL_DEPTH_TEST);
    glPopMatrix();
}

/* Methods used to move the camera */
- (void) moveLeft:(bool)move {
	movingLeft = move;
}
- (void) moveRight:(bool)move {
	movingRight = move;
}
- (void) moveUp:(bool)move {
	movingUp = move;
}
- (void) moveDown:(bool)move {
	movingDown = move;
}
- (void) rotateScene:(bool)rotate direction:(int)dir{
	rotating = rotate;
	rotateDirection = dir;
}
- (void) rotateFromMouse:(float)deltaX deltaY:(float)deltaY {
	dRotated+=deltaX/6.0;
	xRotated+=deltaY/6.0;
}

@end
