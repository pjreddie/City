//
//  Golden_TriangleAppDelegate.h
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "MyOpenGLView.h"


@interface Golden_TriangleAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
