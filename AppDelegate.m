#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // 1. Create the master View Controller
    self.mapView = [[MapController alloc] initWithNibName:@"MapController" bundle:nil];

    // 2. Add the view controller to the Window's content view
    [self.window.contentView addSubview:self.mapView.view];
    self.mapView.view.frame = ((NSView*)self.window.contentView).bounds;

    self.filehandler = [[FileController alloc] init];
    gMap = self.mapView.MapView;
}

- (void)alertInvalidFile:(NSString*)filename
{
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"File not recognized"];
    NSString *errorText = [NSString stringWithFormat:@"Plazu was not able to interpret the track file '%@'.\nThe file may be damaged or may contain invalid XML data.", [filename lastPathComponent]];
    [alert setInformativeText:errorText];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:_window completionHandler:nil];
}

- (IBAction)openFileManually:(id)sender;
{
    NSString* error = [self.filehandler openDialog];
    if(error != nil)
	[self alertInvalidFile:error];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    if(![self.filehandler processGpx:filename]) {
	[self alertInvalidFile:filename];
	return NO;
    }

    [self.mapView drawWaypoints:self.filehandler.foundWaypoints];
    [self.mapView drawTrk:self.filehandler.foundTrk];
    //[self.mapView centerMe];

    return YES;
}

@end
