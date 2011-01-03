//
//  Golden_TriangleAppDelegate.m
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import "Golden_TriangleAppDelegate.h"

@implementation Golden_TriangleAppDelegate



@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	
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
	MyOpenGLView *fullScreenView = [[MyOpenGLView alloc] initWithFrame:viewRect pixelFormat: pixelFormat];
	[fullScreenWindow setContentView: fullScreenView];
	
	[fullScreenWindow makeKeyAndOrderFront:self];
	
}

@end
