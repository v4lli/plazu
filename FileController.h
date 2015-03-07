#import <Foundation/Foundation.h>
#import "gpx-api.h"

@interface FileController : NSObject

- (NSString*)openDialog;
- (BOOL)processGpx:(NSString *)file;

@property NSMutableArray* foundWaypoints;
@property NSMutableArray* foundTrk;

@end
