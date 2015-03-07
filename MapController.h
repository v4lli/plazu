#import <Cocoa/Cocoa.h>
#import <MapKit/MapKit.h>
#import "gpx-api.h"


extern MKMapView *gMap;

@interface MapController : NSViewController <MKMapViewDelegate>
-(void)drawWaypoints:(NSMutableArray *)foundWaypoints;
-(void)drawTrk:(NSMutableArray *)foundTrk;
-(void)centerMe;

@property float lowLat;
@property float highLat;
@property float lowLon;
@property float highLon;

@property (weak) IBOutlet MKMapView *MapView;
@property (nonatomic, retain) MKPolyline* polyline;

@end
