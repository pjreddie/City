//
//  MyOpenGLView.h
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import	<math.h>
#include "CityGen.h"


@interface CityGLView : NSOpenGLView {
	// Polygon array
	NSMutableArray * polygonsToDraw;
	// Texture Data
	GLenum texFormat[ 6 ];   // Format of texture (GL_RGB, GL_RGBA)
	NSSize texSize[ 6 ];     // Width and height
	char *texBytes[ 6 ];     // Texture data
	GLuint texture[ 6 ];     // Storage for one texture

	//Movement Vars
	bool movingLeft;
	bool movingRight;
	bool movingUp;
	bool movingDown;
	bool rotating;
	double xTranslate;
	double yTranslate;
	double zTranslate;
	double dRotated;
	double xRotated;
	int rotateDirection;
}

- (void) moveLeft:(bool)move;
- (void) moveRight:(bool)move;
- (void) moveUp:(bool)move;
- (void) moveDown:(bool)move;
- (void) rotateScene:(bool)rotate direction:(int)dir;
- (void) rotateFromMouse:(float)deltaX deltaY:(float)deltaY;
- (void) drawPolygons;
- (void) drawSkybox;
- (void) draw: (NSRect) bounds;
- (void) initializeGL:(NSRect)frame;
- (BOOL) loadGLTextures;
- (BOOL) loadBitmap:(NSString *)filename intoIndex:(int)texIndex;
@end
