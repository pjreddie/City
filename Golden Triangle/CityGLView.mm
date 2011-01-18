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
	for(int i=0; i<3; i++){
		glCallList(displayLists[i]);
	}
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
	glFogf(GL_FOG_START, 3.0f);
	glFogf(GL_FOG_END, 15.0f);
	*/
	/*
	glEnable ( GL_LIGHTING ) ;
	glEnable(GL_LIGHT0);

	
	GLfloat ambient[] = {0.5f, 0.5f, 0.5f, 1.0f};
	glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
	GLint position[] = {-5.0f,5.0f,10.0f,0.0f};//1?
	glLightiv(GL_LIGHT0, GL_POSITION, position);
	
	GLfloat specular[] = {1.0f, 1.0f, 1.0f, 1.0f};
	glLightfv(GL_LIGHT0, GL_SPECULAR, specular);
	GLfloat diffuse[] = {1.0f, 1.0f, 1.0f, 1.0f};
	glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
	
	//glColor3f(1.0, 0.0, 0.0);
	glEnable(GL_COLOR_MATERIAL);
	glColorMaterial(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE);
	GLfloat matSpec[] = {1.0f, 1.0f, 1.0f, 1.0f};
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, matSpec);
	GLfloat matEm[] = {0.0f, 0.0f, 0.0f, 1.0f};
	glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, matEm);*/
	
}

- (void) createPolygonObject:(NSMutableArray *) polygonArray index:(int)index {
	glNewList(displayLists[index], GL_COMPILE);
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);

	glBegin(GL_TRIANGLES);
	for (int polygon=0; polygon<[polygonArray count]; polygon++) {
		for (int i=0; i<[[polygonArray objectAtIndex:polygon] count]; i+=3) {
			if(i==0){
				glColor3f([[[polygonArray objectAtIndex:polygon] objectAtIndex:0] floatValue],
						  [[[polygonArray objectAtIndex:polygon] objectAtIndex:1] floatValue],
						  [[[polygonArray objectAtIndex:polygon] objectAtIndex:2] floatValue]);
			}else{
				glVertex3f([[[polygonArray objectAtIndex:polygon] objectAtIndex:i] floatValue],
						   [[[polygonArray objectAtIndex:polygon] objectAtIndex:i+1] floatValue],
						   [[[polygonArray objectAtIndex:polygon] objectAtIndex:i+2] floatValue]);				
			}
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
	NSMutableArray * stopSign = [FileIO getPolygonObjectFromFile:@"stopsign" scaler:0.1];
	[self createPolygonObject:stopSign index:0];
	NSMutableArray * stopLight = [FileIO getPolygonObjectFromFile:@"stoplight" scaler:0.1];
	[self createPolygonObject:stopLight index:1];

	
	// Populates polygonsToDraw with all generated polygons
	NSArray * polygonsToDraw = [CityGen masterGenerate:self];
	polygonsToDrawCount = [polygonsToDraw count];

	//Draw polygons
	CityPoint * pt;
	BoundingPolygon * polygon;
	glNewList(displayLists[2], GL_COMPILE);

	double xCor = 0.0;
	
	//Loop around drawing polygons and outlines
	for(int l=0; l<2; l++){
		if (l==0) {
			glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
		}else {
			glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
		}
		glColor3f( 0.0, 0.0, 0.0 ); //define default color
		// Loop around drawing constructs
		for (int j=3; j<6; j++) {
			switch (j) {
				case 3: glBegin(GL_TRIANGLES); break;
				case 4: glBegin(GL_QUADS); break;
				default: break;			
			}
			for(int i=0; i<polygonsToDrawCount; i++){
				for(polygon in [[polygonsToDraw objectAtIndex:i] polygons]){
					if([[polygon coordinates] count] == j || (j>4 && [[polygon coordinates] count] > 4)){
						if(l==0){ //Draw with defined color
							glColor3f( [polygon red], [polygon blue], [polygon green] );
						}
						if(j>4){ // Polygons must be defined independantly
							glBegin(GL_POLYGON);
						}
						for(pt in [polygon coordinates]){
							glVertex3f([pt x], [pt y], [pt z]);
						}
						if(j>4){ // Polygons must be defined independantly
							glEnd();
						}
					}
				}				
			}
			if (j<5) {
				glEnd();
			}
		}
	}
	
	glEndList();
	[polygonsToDraw release]; //IS this enough?
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
	glRotated(dRotated, 0.0, 1.0, 0.0);
	glRotated(xRotated,  cos(t), 0.0, sin(t));
	glTranslated(xTranslate,yTranslate,zTranslate);
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
	
	if( [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_north.bmp" ] intoIndex:0 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_west.bmp" ] intoIndex:1 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_south.bmp" ] intoIndex:2 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_east.bmp" ] intoIndex:3 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_up.bmp" ] intoIndex:4 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_down.bmp" ] intoIndex:5 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"loading1.bmp" ] intoIndex:6 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"loading2.bmp" ] intoIndex:7 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"loading3.bmp" ] intoIndex:8 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"loading4.bmp" ] intoIndex:9 ]

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
	
	glVertex3f( -1.0f, -1.0f,  1.0f );
	glTexCoord2f( 1.0f, 1.0f );
	
	glVertex3f(  1.0f, -1.0f,  1.0f );
	glTexCoord2f( 0.0f, 1.0f );
	
	glVertex3f(  1.0f, -1.0f, -1.0f );
    glEnd();
	
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
