#import <Cocoa/Cocoa.h>
#import <MapKit/MapKit.h>
#import "MapController.h"
#import "FileController.h"


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,strong) IBOutlet MapController *mapView;
@property (strong) FileController *filehandler;
- (void)alertInvalidFile:(NSString*)filename;
- (IBAction)openFileManually:(id)sender;

@end
