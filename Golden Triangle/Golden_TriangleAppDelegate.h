//
//  Golden_TriangleAppDelegate.h
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CityGLView.h"

@interface Golden_TriangleAppDelegate : NSResponder {
    //NSWindow *window;
	//NSWindow *fullScreenWindow;

	NSTimer *renderTimer;
	CityGLView *glView;
	//NSRect mainDisplayRect;
	//NSRect viewRect;
	//NSRect viewFullRect;
	//NSOpenGLPixelFormat* pixelFormat;
}


@property (assign) IBOutlet NSWindow *window;
- (void) keyDown:(NSEvent *)theEvent;
- (void) keyUp:(NSEvent *)theEvent;
- (void) mouseMoved:(NSEvent *)theEvent;
@end
