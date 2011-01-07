//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import "CityGLView.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

@implementation CityGLView


// Draw from polygonList
- (void) drawPolygons 
{
	BoundingPolygon * polygon;
	CityPoint * pt;
	for(polygon in polygonsToDraw){
		glBegin(GL_POLYGON);
		glColor3f( [polygon red], [polygon blue], [polygon green] );
		for(pt in [polygon coordinates]){
			glVertex3f([pt x], [pt y], [pt z]);
		}
		glEnd();
	}
}

- (void) drawSkybox {
	glPushMatrix();
	
    // Reset and transform the matrix.
    glLoadIdentity();
   /* gluLookAt(
			  0,0,0,
			  camera->x(),camera->y(),camera->z(),
			  0,1,0);*/
	
    // Enable/Disable features
    //glPushAttrib(GL_ENABLE_BIT);
    glDisable(GL_DEPTH_TEST);
    //glDisable(GL_LIGHTING);
    //glDisable(GL_BLEND);
	
    // Just in case we set all vertices to white.
    glColor3f(0,1,0);
	
    // Render the front quad
    glBegin(GL_POLYGON);
	 glVertex3f(  1.5f, -1.5f, -1.5f );
	 glVertex3f( -1.5f, -1.5f, -1.5f );
	 glVertex3f( -1.5f,  1.5f, -1.5f );
	 glVertex3f(  1.5f,  1.5f, -1.5f );
    glEnd();
	
    // Render the left quad
    glBegin(GL_QUADS);
	 glVertex3f(  1.5f, -1.5f,  1.5f );
	 glVertex3f(  1.5f, -1.5f, -1.5f );
	 glVertex3f(  1.5f,  1.5f, -1.5f );
	 glVertex3f(  1.5f,  1.5f,  1.5f );
    glEnd();
	
    // Render the back quad
    glBegin(GL_QUADS);
	glVertex3f( -1.5f, -1.5f,  1.5f );
	glVertex3f(  1.5f, -1.5f,  1.5f );
	glVertex3f(  1.5f,  1.5f,  1.5f );
	glVertex3f( -1.5f,  1.5f,  1.5f );
	
    glEnd();
	
    // Render the right quad
    glBegin(GL_QUADS);
	 glVertex3f( -1.5f, -1.5f, -1.5f );
	 glVertex3f( -1.5f, -1.5f,  1.5f );
	 glVertex3f( -1.5f,  1.5f,  1.5f );
	 glVertex3f( -1.5f,  1.5f, -1.5f );
    glEnd();
	
    // Render the top quad
    glBegin(GL_QUADS);
	glVertex3f( -1.5f,  1.5f, -1.5f );
	glVertex3f( -1.5f,  1.5f,  1.5f );
	glVertex3f(  1.5f,  1.5f,  1.5f );
	glVertex3f(  1.5f,  1.5f, -1.5f );
    glEnd();
	
    // Render the bottom quad
    glBegin(GL_QUADS);
	glVertex3f( -1.5f, -1.5f, -1.5f );
	glVertex3f( -1.5f, -1.5f,  1.5f );
	glVertex3f(  1.5f, -1.5f,  1.5f );
	glVertex3f(  1.5f, -1.5f, -1.5f );
    glEnd();
	
    // Restore enable bits and matrix
    //glPopAttrib();
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
	gluPerspective( 45.0f, frame.size.width / frame.size.height, 1.0f, 100.0f );
	glMatrixMode( GL_MODELVIEW );    // Select the modelview matrix
	glLoadIdentity();                // and reset it
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
	
	// Populates polygonsToDraw with all generated polygons
	polygonsToDraw = [CityGen masterGenerate];
	
	[self reshape:frame];
	glShadeModel( GL_SMOOTH );                // Enable smooth shading
	glClearColor( 0.0f, 0.0f, 0.0f, 0.5f );   // Black background
	glEnable( GL_DEPTH_TEST );                // Enable depth testing
	glDepthFunc( GL_LEQUAL );                 // Type of depth test to do
	glClearDepth( 1.0f );                     // Depth buffer setup
	// Really nice perspective calculations
	glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST );
}

/*  Draw Method - 
	Called every 0.005 seconds */
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
	[self drawSkybox];

	[self drawPolygons];

	[ [ self openGLContext ] flushBuffer ];
	[ self setNeedsDisplay: YES ] ;
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
	//xRotated+=deltaY/6.0;
}

@end
