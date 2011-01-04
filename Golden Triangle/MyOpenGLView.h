//
//  MyOpenGLView.h
//  Golden Triangle
//
//  Created by Alex Bullard on 11/12/10.
//  Copyright 2010 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MyOpenGLView : NSOpenGLView {
	bool movingLeft;
	bool movingRight;
	bool movingUp;
	bool movingDown;
}

- (void) moveLeft:(bool)move;
- (void) moveRight:(bool)move;
- (void) moveUp:(bool)move;
- (void) moveDown:(bool)move;
- (void) drawRect: (NSRect) bounds;
@end
