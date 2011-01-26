//
//  MyOpenGLView.h
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import	<math.h>
#import "CityGen.h"
#import <OpenGL/OpenGL.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import "Sphere.h"

#define MAX_DISPLAY_LISTS 128
#define DMOVE 0.40

// Blender Objects
#define STOPSIGN_INDEX 0
#define STOPSIGN_SCALER 0.05
#define STOPLIGHT_INDEX 1
#define STOPLIGHT_SCALER 0.1
#define PREGEN_MAX 1

//Texture Constants
#define TEXTURE_END 11
#define TEXTURE_SKYBOX_START 0
#define TEXTURE_SKYBOX_END 5
#define TEXTURE_LOADING_START 6
#define TEXTURE_LOADING_END 9


@interface CityGLView : NSOpenGLView {
	// Polygon data
	int polygonsToDrawCount;
	GLuint displayLists[MAX_DISPLAY_LISTS];
	// Texture Data
	GLenum texFormat[ 12 ];   // Format of texture (GL_RGB, GL_RGBA)
	NSSize texSize[ 12 ];     // Width and height
	char *texBytes[ 12 ];     // Texture data
	GLuint texture[ 12 ];     // Storage for one texture
	// Loading Screen Data
	int numberOfLoadMessages;
	int loadState; // 0 - init 1 - loading in Progress 2 - loaded
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
	// Fullscreen
	bool fullscreen;
	double time;
	double moon;
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
- (void) initializeData;
- (void) initDisplayLists;
- (BOOL) loadGLTextures;
- (BOOL) loadBitmap:(NSString *)filename intoIndex:(int)texIndex;
- (void) addLoadingMessage:(NSString *)message;
- (void) initializeData;
- (bool) fullscreen;
@end
