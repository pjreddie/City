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
	for(int i=0; i<2; i++){
		glCallList(displayLists[i]);
	}
}

- (void) drawSkybox {
	glPushMatrix();
	
    // Reset and transform the matrix.
    glLoadIdentity();
	glRotated(dRotated, 0.0, 1.0, 0.0);
	glRotated(xRotated, 1.0, 0.0, 0.0);

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
	gluPerspective( 45.0f, frame.size.width / frame.size.height, 0.5f, 85.0f );
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

- (void) initDisplayLists {	
	// Populates polygonsToDraw with all generated polygons
	NSArray * polygonsToDraw = [CityGen masterGenerate];
	polygonsToDrawCount = [polygonsToDraw count];

	//Draw polygons
	displayLists[0] = glGenLists(MAX_DISPLAY_LISTS);
	CityPoint * pt;
	BoundingPolygon * polygon;
	glNewList(displayLists[0], GL_COMPILE);
	glPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
	for(int i=0; i<polygonsToDrawCount; i++){
		for(polygon in [[polygonsToDraw objectAtIndex:i] polygons]){
			glColor3f( [polygon red], [polygon blue], [polygon green] );
			glBegin(GL_POLYGON);
			for(pt in [polygon coordinates]){
				glVertex3f([pt x], [pt y], [pt z]);
			}
			glEnd();
		}
	}
	glEndList();
	
	// Draw line polygons
	displayLists[1]= displayLists[0]+1;
	glNewList(displayLists[1], GL_COMPILE);
	glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
	glLineWidth(3.0f);
	glColor3f( 0.0, 0.0, 0.0 );
	for(int i=0; i<polygonsToDrawCount; i++){
		glBegin(GL_QUADS);

		for(polygon in [[polygonsToDraw objectAtIndex:i] polygons]){
			if([polygon border]){
				for(pt in [polygon coordinates]){
					glVertex3f([pt x], [pt y], [pt z]);
				}
			}
		}
		glEnd();			

	}

	glEndList();
	
	//displayLists[i+1]= displayLists[i]+1;

	[polygonsToDraw release]; //IS this enough?
}


/*
 * Initial OpenGL setup
 */
- (void) initializeGL:(NSRect)frame
{ 	
	xTranslate = 0.0;
	yTranslate = 0.0;
	zTranslate = 0.0;
	dRotated = 0.0;
	[self reshape:frame];
	/*if( ![ self loadGLTextures ] ){
		NSLog(@"Error loading textures");
	}*/
	[self initDisplayLists];
	glShadeModel( GL_SMOOTH );                // Enable smooth shading
	glEnable(GL_LINE_SMOOTH);
	glClearColor( 0.0f, 0.0f, 0.0f, 0.5f );   // Black background
	glEnable( GL_DEPTH_TEST );                // Enable depth testing
	glDepthFunc( GL_LEQUAL );                 // Type of depth test to do
	glClearDepth( 1.0f );                     // Depth buffer setup
	// Really nice perspective calculations
	glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST );
	[self initLighting];
}

/*  Draw Method - 
	Called every 0.015 seconds */
-(void) draw:(NSRect) bounds {
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
	glLoadIdentity();
	double t = (3.14159265*dRotated)/180;
	if(movingLeft == true){
		zTranslate += 0.03*-cos(t+3.14159265/2);
		xTranslate += 0.03*sin(t+3.14159265/2);
	}if(movingRight == true){
		zTranslate += 0.03*-cos(t-3.14159265/2);
		xTranslate += 0.03*sin(t-3.14159265/2);
	}if(movingUp == true){
		zTranslate += 0.03*cos(t);
		xTranslate += 0.03*-sin(t);
	}if(movingDown == true){
		zTranslate += 0.03*-cos(t);
		xTranslate += 0.03*sin(t);
	}if (rotating) {
		dRotated += 0.5*rotateDirection;
	}
	glRotated(dRotated, 0.0, 1.0, 0.0);
	glRotated(xRotated, 1.0, 0.0, 0.0);
	glTranslated(xTranslate,yTranslate,zTranslate);
	//[self drawSkybox];

	[self drawPolygons];

	[ [ self openGLContext ] flushBuffer ];
	[ self setNeedsDisplay: YES ] ;
}

/*
 * Setup a texture from our model
 */
/*
- (BOOL) loadGLTextures
{
	BOOL status = FALSE;
	
	if( [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_north.bmp" ] intoIndex:0 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_west.bmp" ] intoIndex:1 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_south.bmp" ] intoIndex:2 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_east.bmp" ] intoIndex:3 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_up.bmp" ] intoIndex:4 ] &&
	   [ self loadBitmap:[ NSString stringWithFormat:@"%@/%s",[ [ NSBundle mainBundle ] resourcePath ],"alpine_down.bmp" ] intoIndex:5 ]
	   )
	{
		status = TRUE;
		for(int i=0; i<6; i++){
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
}*/

/*
 * The NSBitmapImageRep is going to load the bitmap, but it will be
 * setup for the opposite coordinate system than what OpenGL uses, so
 * we copy things around.
 */
/*
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
		texBytes[ texIndex ] = calloc( bytesPRow * texSize[ texIndex ].height,
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
}*/



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
