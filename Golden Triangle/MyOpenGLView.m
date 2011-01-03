//
//  MyOpenGLView.m
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import "MyOpenGLView.h"
#include <OpenGL/gl.h>


@implementation MyOpenGLView

static void drawAnObject () 
{
	glColor3f(1.0f, 0.85f, 0.35f);
	glBegin(GL_QUADS);
	{
		glVertex4f(-1, -1, 0, 0);
		glVertex4f(-1, 1, 0, 0);
		glVertex4f(1, 1, 0, 0);
		glVertex4f(1, -1, 0, 0);
		
	}
	glEnd();
}



-(void) drawRect:(NSRect) bounds {
	glClearColor(0,0,0,0);
	glClear(GL_COLOR_BUFFER_BIT);
	drawAnObject();
	glFlush();
}

@end
