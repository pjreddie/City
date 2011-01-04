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
	NSRect mainDisplayRect = [[NSScreen mainScreen] frame];
	NSWindow *fullScreenWindow = [[NSWindow alloc] initWithContentRect:mainDisplayRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES];

	[fullScreenWindow setLevel:NSMainMenuWindowLevel+1];
	
	NSOpenGLPixelFormatAttribute attrs[] =
	{
		NSOpenGLPFADoubleBuffer,
		0
	};
	NSOpenGLPixelFormat* pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
	
	NSRect viewRect = NSMakeRect(0.0, 0.0, mainDisplayRect.size.width, mainDisplayRect.size.height);
	glView = [[MyOpenGLView alloc] initWithFrame:viewRect pixelFormat: pixelFormat];
	[fullScreenWindow setContentView: glView];
	[fullScreenWindow makeKeyAndOrderFront:self];
	[ fullScreenWindow makeFirstResponder:self ];
	if(glView != nil){
		[glView initializeGL];
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
	NSTimeInterval timeInterval = 0.005;
	
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
		[ glView drawRect:[ glView frame ] ];
} 

- (void) keyDown:(NSEvent *)theEvent
{
	unichar unicodeKey;
	
	unicodeKey = [ [ theEvent characters ] characterAtIndex:0 ];
	switch( unicodeKey )
	{
		case NSRightArrowFunctionKey:
			[ glView moveRight:true];
			break;
			
		case NSLeftArrowFunctionKey:
			[ glView moveLeft:true];
			break;
			
		case NSDownArrowFunctionKey:
			[ glView moveDown:true];
			break;
			
		case NSUpArrowFunctionKey:
			[ glView moveUp:true];
			break;
	}
}
- (void) keyUp:(NSEvent *)theEvent
{
	unichar unicodeKey;
	
	unicodeKey = [ [ theEvent characters ] characterAtIndex:0 ];
	switch( unicodeKey )
	{
		case NSRightArrowFunctionKey:
			[ glView moveRight:false];
			break;
			
		case NSLeftArrowFunctionKey:
			[ glView moveLeft:false];
			break;
			
		case NSDownArrowFunctionKey:
			[ glView moveDown:false];
			break;
			
		case NSUpArrowFunctionKey:
			[ glView moveUp:false];
			break;
	}
}


@end
