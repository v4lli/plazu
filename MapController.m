#import "MapController.h"
#import <MapKit/MapKit.h>

MKMapView *gMap = NULL;

@interface MapController ()

@end

@implementation MapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [gMap setDelegate:self];
    self.lowLat = self.lowLon = self.highLat = self.highLon = 0;
    return self;
}

- (void)drawWaypoints:(NSMutableArray *)foundWaypoints {
    int i;
    Waypoint *coord;
    MKPointAnnotation *annotation;
    CLLocationCoordinate2D annotationCoord;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [NSLocale currentLocale];
    [formatter setLocale:locale];

    for(i = 0; i < [foundWaypoints count]; i++) {
	annotation = [[MKPointAnnotation alloc] init];
	coord = [foundWaypoints objectAtIndex:i];

	annotationCoord.latitude = coord.lat;
	annotationCoord.longitude = coord.lon;
	annotation.coordinate = annotationCoord;
	
	annotation.title = coord.name;
	
	[formatter setDateFormat:[NSDateFormatter dateFormatFromTemplate:@"HH:mm:ss - DD.mm.YY" options:0 locale:locale]];
	[formatter setDateStyle:NSDateFormatterFullStyle];
	annotation.subtitle = [formatter stringFromDate:coord.time];
	
	[gMap addAnnotation:annotation];
    }
}

- (void)drawTrk:(NSMutableArray *)foundTrk {
    CLLocationCoordinate2D points[[foundTrk count]];
    MKGeodesicPolyline *geodesic;
    Waypoint *thisLoc;
    int i;

    for(i = 0; i < [foundTrk count]; i++) {
	thisLoc = [foundTrk objectAtIndex:i];
	points[i].latitude = thisLoc.lat;
	points[i].longitude = thisLoc.lon;

	if (self.highLat < thisLoc.lat)
	    self.highLat = thisLoc.lat;

	if (self.highLon < thisLoc.lon)
	    self.highLon = thisLoc.lon;

	if (self.lowLat > thisLoc.lat)
	    self.lowLat = thisLoc.lat;

	if (self.lowLon > thisLoc.lon)
	    self.lowLon = thisLoc.lon;
    }

    geodesic = [MKGeodesicPolyline polylineWithCoordinates:&points[0] count:[foundTrk count]-1];
    [gMap addOverlay:geodesic];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [NSColor colorWithCalibratedRed:(51/255.0f) green:(102/255.0f) blue:(204/255.0f) alpha:1.0f];
    renderer.lineWidth = 3.5;
    return renderer;
}

-(void)centerMe {
    // XXX Doesn't work yet, I think
    CLLocationCoordinate2D mapCenter, highCoord, lowCoord;
    MKCoordinateRegion region;

    mapCenter.latitude = (self.highLat+self.lowLat);
    mapCenter.longitude = (self.highLon+self.lowLon);
    //[gMap setCenterCoordinate:mapCenter animated:YES];

    highCoord.longitude = self.highLon;
    highCoord.latitude = self.highLat;
    lowCoord.longitude = self.lowLon;
    lowCoord.latitude = self.lowLat;

    MKMapPoint highPoint = MKMapPointForCoordinate(highCoord);
    MKMapPoint lowPoint = MKMapPointForCoordinate(lowCoord);
    NSLog(@"meters: %f", MKMetersBetweenMapPoints(highPoint, lowPoint));


    region = MKCoordinateRegionMakeWithDistance(
	mapCenter, MKMetersBetweenMapPoints(highPoint, lowPoint),
	MKMetersBetweenMapPoints(highPoint, lowPoint));

    [gMap setRegion:region animated:YES];
}


@end
