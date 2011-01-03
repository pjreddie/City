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
	glVertex3f(0.0, 0.0, -4.0);
	glVertex3f(0.0, 1.0, -4.0);
	glVertex3f(1.5, 1.0, -4.0);
    glEnd();
}

static void drawAnObject () 
{
	drawTriangle(1, 0, 0);
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


-(void) drawRect:(NSRect) bounds {
	[self reshape];
	glClearColor(0,0,0,0);
	glClear(GL_COLOR_BUFFER_BIT);
	drawAnObject();
	glFlush();
}

@end
