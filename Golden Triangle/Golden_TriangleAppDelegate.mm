//
//  Golden_TriangleAppDelegate.m
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import "Golden_TriangleAppDelegate.h"

@interface Golden_TriangleAppDelegate (InternalMethods)
- (void) setupRenderTimer;
- (void) updateGLView:(NSTimer *)timer;
@end


@implementation Golden_TriangleAppDelegate



@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
	[ NSApp setDelegate:self ];   // We want delegate notifications
	[ window makeFirstResponder:self ];
	
	
	renderTimer = nil;
	// Set and activate full screen
	 mainDisplayRect = [[NSScreen mainScreen] frame];
	//fullScreenWindow = [[NSWindow alloc] initWithContentRect:mainDisplayRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];
	//[fullScreenWindow setLevel:NSMainMenuWindowLevel+1];
	
	CGAssociateMouseAndMouseCursorPosition(FALSE);
	CGDisplayHideCursor(NULL);
	
	NSOpenGLPixelFormatAttribute attrs[] =
	{
		NSOpenGLPFADoubleBuffer,
		NSOpenGLPFAAccelerated,
		NSOpenGLPFAColorSize, 32,
		NSOpenGLPFADepthSize, 16,
		0
	};
	pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
	
	viewFullRect = NSMakeRect(0.0, 0.0, mainDisplayRect.size.width, mainDisplayRect.size.height);
	viewRect = NSMakeRect(0.0, 0.0, 500, 400);
	
	glView = [[CityGLView alloc] initWithFrame:viewRect pixelFormat: pixelFormat];
	//[fullScreenWindow setContentView: glView];
	//[fullScreenWindow makeKeyAndOrderFront:self];
	
	[window setContentView: glView];
	[window makeKeyAndOrderFront:self];
	
	[window setAcceptsMouseMovedEvents:YES];
	
	if(glView != nil){
		[glView initializeGL:mainDisplayRect];
		[ self setupRenderTimer ];
	}else {
		NSLog(@"Error Initializing OpenGL -A");
	}
	
}


/*
 * Setup timer to update the OpenGL view.
 */
- (void) setupRenderTimer
{
	NSTimeInterval timeInterval = 0.015;
	
	renderTimer = [ [ NSTimer scheduledTimerWithTimeInterval:timeInterval
													  target:self
													selector:@selector( updateGLView: )
													userInfo:nil repeats:YES ] retain ];
	[ [ NSRunLoop currentRunLoop ] addTimer:renderTimer
									forMode:NSEventTrackingRunLoopMode ];
	[ [ NSRunLoop currentRunLoop ] addTimer:renderTimer
									forMode:NSModalPanelRunLoopMode ];
}


/*
 * Called by the rendering timer.
 */
- (void) updateGLView:(NSTimer *)timer
{

	if( glView != nil )
		[ glView draw:[ glView frame ] ];
} 

- (void) keyDown:(NSEvent *)theEvent
{
	unichar unicodeKey;
	
	unicodeKey = [ [ theEvent characters ] characterAtIndex:0 ];
	if(unicodeKey == NSRightArrowFunctionKey || unicodeKey == 'd'){
		[ glView moveRight:true];
	}else if(unicodeKey == NSLeftArrowFunctionKey || unicodeKey == 'a'){
		[ glView moveLeft:true];
	}else if(unicodeKey == NSDownArrowFunctionKey || unicodeKey == 's'){
		[ glView moveDown:true];
	}else if(unicodeKey == NSUpArrowFunctionKey || unicodeKey == 'w'){
		[ glView moveUp:true];
	}else if(unicodeKey == 'q'){
		[glView rotateScene:true direction:-1];
	}else if(unicodeKey == 'e'){
		[glView rotateScene:true direction:1];
	}else if(unicodeKey == 'f'){
		[window setContentView:nil];
		[[glView openGLContext] clearDrawable];
		if(![glView fullscreen]){
			NSLog(@"enter fullscreen");

			NSOpenGLContext * newContext = [[NSOpenGLContext alloc] initWithFormat:pixelFormat shareContext:nil];
			[glView setFrame:mainDisplayRect];
			[glView setOpenGLContext:newContext];
			[newContext makeCurrentContext];
			[newContext setFullScreen];
			[glView initializeGL:viewFullRect];
			[window setContentView:glView];

		}else{
			NSLog(@"exit fullscreen");
		}
	}
}

- (void) keyUp:(NSEvent *)theEvent
{
	unichar unicodeKey;
	unicodeKey = [ [ theEvent characters ] characterAtIndex:0 ];
	if(unicodeKey == NSRightArrowFunctionKey  || unicodeKey == 'd'){
		[ glView moveRight:false];
	}else if(unicodeKey == NSLeftArrowFunctionKey  || unicodeKey == 'a'){
		[ glView moveLeft:false];
	}else if(unicodeKey == NSDownArrowFunctionKey  || unicodeKey == 's'){
		[ glView moveDown:false];
	}else if(unicodeKey == NSUpArrowFunctionKey  || unicodeKey == 'w'){
		[ glView moveUp:false];
	}else if(unicodeKey == 'q'){
		[glView rotateScene:false direction:-1];
	}else if(unicodeKey == 'e'){
		[glView rotateScene:false direction:1];
	}
}

- (void) mouseMoved:(NSEvent *)theEvent {
	[glView	rotateFromMouse:[theEvent deltaX] deltaY:[theEvent deltaY]];
}

//CGWarpMouseCursorPosition
@end
