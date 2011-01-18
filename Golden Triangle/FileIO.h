//
//  FileIO.h
//  Golden Triangle
//
//  Created by Alex Bullard on 1/17/11.
//  Copyright 2011 Middlebury College. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FileIO : NSObject {

}

+ (NSMutableArray *) getPolygonObjectFromFile:(NSString *)filename scaler:(double)scaler;

@end
