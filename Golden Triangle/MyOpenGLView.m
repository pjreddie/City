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


static void drawTriangle(float r, float g, float b){
	glBegin(GL_POLYGON);
	glColor3f( r, g, b );
	glVertex3f(-5.0, -1.0, -1000.0);
	glVertex3f(-5.0, -1.0, -1.0);
	glVertex3f(5.0, -1.0, -1.0);
	glVertex3f(5.0, -1.0, -1000.0);
    glEnd();
}

static void drawAnObject () 
{
	drawTriangle(1, 1, 1);
}

/*
 * Resize ourself
 */
- (void) reshape
{ 
	NSRect sceneBounds;
	
	[ [ self openGLContext ] update ];
	sceneBounds = [ self bounds ];
	// Reset current viewport
	glViewport( 0, 0, sceneBounds.size.width, sceneBounds.size.height );
	glMatrixMode( GL_PROJECTION );   // Select the projection matrix
	glLoadIdentity();                // and reset it
	// Calculate the aspect ratio of the view
	gluPerspective( 45.0f, sceneBounds.size.width / sceneBounds.size.height,
                   0.1f, 100.0f );
	glMatrixMode( GL_MODELVIEW );    // Select the modelview matrix
	glLoadIdentity();                // and reset it
}

/*
 * Initial OpenGL setup
 */
- (void) initializeGL
{ 	
	[self reshape];
	glShadeModel( GL_SMOOTH );                // Enable smooth shading
	glClearColor( 0.0f, 0.0f, 0.0f, 0.5f );   // Black background
	glClearDepth( 1.0f );                     // Depth buffer setup
	glEnable( GL_DEPTH_TEST );                // Enable depth testing
	glDepthFunc( GL_LEQUAL );                 // Type of depth test to do
	// Really nice perspective calculations
	glHint( GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST );
}

/*  Draw Method - 
	Called every 0.005 seconds */
-(void) drawRect:(NSRect) bounds {
	glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
	
	if(movingLeft == true){
		glTranslated(0.01,0.0,0.0);				
	}if(movingRight == true){
		glTranslated(-0.01,0.0,0.0);				
	}if(movingUp == true){
		glTranslated(0.0,0.0,0.01);				
	}if(movingDown == true){
		glTranslated(0.0,0.0,-0.01);				
	}
	drawAnObject();
	[ [ self openGLContext ] flushBuffer ];
	[ self setNeedsDisplay: YES ] ;
}

-(void) resetView {
	[self reshape];
	glClearColor(0,0,0,0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
	glFlush();	
}

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

@end
