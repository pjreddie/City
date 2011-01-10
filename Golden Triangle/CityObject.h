/* Abstract class encasing all objects drawn in the city
 *
 */

#import <Cocoa/Cocoa.h>
#import "CityPoint.h"
#import "BoundingPolygon.h"
#import "CityMath.h"

@interface CityObject : NSObject {
	NSMutableArray * polygonList;
}

-(CityObject *) init;
-(CityObject *) initWithPolygons:(NSArray *)poly;
-(NSArray *) polygons;
-(void) addPolygon:(BoundingPolygon *)polygon;
-(void) dealloc;

@end
