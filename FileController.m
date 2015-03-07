#import "FileController.h"
#import "MapController.h"


@implementation FileController

// This is what responds when you press CMD+O
- (NSString*)openDialog {
    int i;

    NSArray *fileTypesArray;
    fileTypesArray = [NSArray arrayWithObjects:@"gpx", @"xml", nil];

    // Create a File Open Dialog class
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:TRUE];

    // Display the dialog box.  If the OK pressed, process the files. If
    // processing fails, return and don't continue.
    if ([openDlg runModal] == NSOKButton) {
	NSArray *files = [openDlg URLs];
	for(i = 0; i < [files count]; i++)
	    if (![self processGpx:[[files objectAtIndex:i] path]])
		return [[files objectAtIndex:i] path];
    }
    return nil;
}


- (BOOL)processGpx:(NSString *)file {
    xmlDoc *doc = NULL;
    GPX *gpx = [GPX new];

    NSLog(@"Working on file '%@'", file);

    /* parse the file and get the DOM */
    doc = xmlReadFile([file UTF8String], NULL, 0);
    if (doc == NULL) {
	NSLog(@"%s: initial XML parsing failed (xmReadFile returned NULL)", __func__);
	return NO;
    }

    parse_gpx(xmlDocGetRootElement(doc), gpx);
    [self processTrkpkt:gpx];

    // Waypoints are simple, so if there are any, take them directly from the gpxlib
    NSLog(@"Number of waypoints found: %lu", (unsigned long)[gpx.waypoints count]);
    if ([gpx.waypoints count] > 0)
	self.foundWaypoints = gpx.waypoints;
    else
	self.foundWaypoints = nil;

    if ((self.foundTrk == nil && self.foundWaypoints == nil)
	|| (self.foundTrk != nil && [self.foundTrk count] < 2))
	return NO;

    return YES;
}

- (void)processTrkpkt:(GPX *)gpx {
    Trek *thisTrek;
    TrekSegment *thisTrekSeg;
    int i, j, total = 0;

    NSMutableArray* finalTrks = [NSMutableArray arrayWithObjects:nil];

    NSLog(@"Number of tracks found: %d", (int)[gpx.treks count]+1);
    for (i = 0; i < [gpx.treks count]; i++) {
	thisTrek = [gpx.treks objectAtIndex:i];
	NSLog(@"Number of segments in track #%d: %d", i+1, (int)[thisTrek.trekseg count]);
	for (j = 0; j < [thisTrek.trekseg count]; j++) {
	    thisTrekSeg = [thisTrek.trekseg objectAtIndex:j];
	    [finalTrks addObjectsFromArray:thisTrekSeg.trekpoints];
	    total++;
	}
    }

    if (total > 0)
	self.foundTrk = finalTrks;
    else
	self.foundTrk = nil;
}

@end
