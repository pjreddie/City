//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import "MyOpenGLView.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>

@implementation MyOpenGLView


- (void) drawBuilding:(double)height x:(double)xCord z:(double)zCord r:(double)radius {
	glBegin(GL_QUADS);
	glColor3f( 0, 1, 0);
	
	//Far face
	glVertex3f(xCord-radius, height, zCord-radius);
	glVertex3f(xCord+radius, height, zCord-radius);
	glVertex3f(xCord+radius, -1, zCord-radius);
	glVertex3f(xCord-radius, -1, zCord-radius);
    glEnd();
	//Near Face
	glBegin(GL_QUADS);
	glColor3f( 1, 0, 0);
	glVertex3f(xCord-radius, height, zCord+radius);
	glVertex3f(xCord+radius, height, zCord+radius);
	glVertex3f(xCord+radius, -1, zCord+radius);
	glVertex3f(xCord-radius, -1, zCord+radius);
	glEnd();
	//Left face
	glBegin(GL_QUADS);
	glColor3f( 0, 0, 1);
	glVertex3f(xCord-radius, height, zCord-radius);
	glVertex3f(xCord-radius, height, zCord+radius);
	glVertex3f(xCord-radius, -1, zCord+radius);
	glVertex3f(xCord-radius, -1, zCord-radius);
	glEnd();
	//Right Face
	glBegin(GL_QUADS);
	glColor3f( 0, 0, 1);
	glVertex3f(xCord+radius, height, zCord-radius);
	glVertex3f(xCord+radius, height, zCord+radius);
	glVertex3f(xCord+radius, -1, zCord+radius);
	glVertex3f(xCord+radius, -1, zCord-radius);
	glEnd();
	
	
}

- (void) drawAnObject 
{
	glBegin(GL_POLYGON);
	glColor3f( 1, 1, 1 );
	glVertex3f(-20.0, -1.0, -500.0);
	glVertex3f(-20.0, -1.0, -1.0);
	glVertex3f(20.0, -1.0, -1.0);
	glVertex3f(20.0, -1.0, -500.0);
    glEnd();
	[self drawBuilding:5 x:2 z:-40 r:1];
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
-(void) drawRect:(NSRect) bounds {
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
	glTranslated(xTranslate,yTranslate,zTranslate);				
	
	[self drawAnObject];

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

@end
