/*
Copyright (c) 2012, Bryce Groff
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#import <Foundation/Foundation.h>

#import "gpx-reader.h"

#pragma mark Link

@interface Link : NSObject {
    NSURL    *href;
    NSString *text;
    NSString *type;
}

@property (retain) NSURL* href;
@property (retain) NSString* text;
@property (retain) NSString* type;

- (id) initWithHref: (NSURL*) href;
- (void) dumpLink;
@end

#pragma mark Email

@interface Email : NSObject {
    NSString *user;
    NSString *domain;
}

@property (retain) NSString* user;
@property (retain) NSString* domain;

- (id) initWithUserAndDomain: (NSString*)inUser :(NSString*)inDomain;
- (void) dumpEmail;
@end

#pragma mark Person

@interface Person : NSObject {
    NSString *name;
    Email    *email;
    Link     *link;
}
@property (retain) NSString* name;
@property (retain) Email* email;
@property (retain) Link* link;

- (void) dumpAuthor;
@end

#pragma mark Copyright

@interface Copyright : NSObject {
    NSString *author;
    NSString *year;
    NSURL    *license;
}
@property (retain) NSString* author;
@property (retain) NSString* year;
@property (retain) NSURL* license;

- (id) initWithValues: (NSString*)inAuthor :(NSString*)inYear :(NSURL*)inLicense;
- (void) dumpCopyright;
@end

#pragma mark Bounds

@interface Bounds : NSObject {
    float minlat;
    float minlon;
    float maxlat;
    float maxlon;
}
@property float minlat;
@property float minlon;
@property float maxlat;
@property float maxlon;
@end

#pragma mark Metadata

@interface Metadata : NSObject {
    NSString		*name;
    NSString		*desc;
    Person			*author;
    Copyright		*copyright;
    NSMutableArray	*link;
    NSDate			*time;
    NSString		*keywords;
	Bounds			*bounds;
    // extension
}
@property (retain) NSString* name;
@property (retain) NSString* desc;
@property (retain) Person* author;
@property (retain) Copyright* copyright;
@property (retain) NSMutableArray* link;
@property (retain) NSDate* time;
@property (retain) NSString* keywords;
@property (retain) Bounds* bounds;

- (void)addLink: (Link*)newLink;
- (void)dumpMetadata;
@end

#pragma mark PathHeader

// This object is a general object that
// waypoints, routes and treks extend.
// It is so that they do not need to redefine
// these fields over again. DO NOT use
// this class in your code.
@interface PathHeader : NSObject {
    NSString       *name;
    NSString       *cmt;
    NSString       *desc;
    NSString       *src;
    NSMutableArray *link;
    unsigned int   number;
    NSString       *type;
    // extension
}
@property (retain) NSString* name;
@property (retain) NSString* cmt;
@property (retain) NSString* desc;
@property (retain) NSString* src;
@property (retain) NSMutableArray* link;
@property unsigned int number;
@property (retain) NSString* type;

- (void)addLink: (Link*)newLink;
- (void)dumpPathHeader;
@end

#pragma mark Waypoint

@interface Waypoint : PathHeader {
    float          lat;
    float          lon;
    float          elev;
    NSDate         *time;
    float          magvar;
    float          geoidheight;
    NSString       *sym;
    NSString       *fix; // Must be one of: {'none'|'2d'|'3d'|'dgps'|'pps'}
    unsigned int   sat;
    float          hdop;
    float          vdop;
    float          pdop;
    float          ageofdgpsdata;
    unsigned int   dgpsid;
    // extensions;
}
@property float lat;
@property float lon;
@property float elev;
@property (retain) NSDate* time;
@property float geoidheight;
@property (retain) NSString* sym;
@property unsigned int sat;
@property float hdop;
@property float vdop;
@property float pdop;
@property float ageofdgpsdata;

- (BOOL)setMagvar:(float)inMagvar;
- (float)getMagvar;
- (BOOL)setFix:(NSString *)inFix;
- (NSString*)getFix;
- (BOOL)setDgpsid:(unsigned int)inDgpsid;
- (unsigned int)getDgpsid;

- (id)initWithValues: (float)inLat :(float)inLon;
- (void)dumpWaypoint;
@end

#pragma mark Route

@interface Route : PathHeader {
    NSMutableArray *rtept;
}

@property (retain) NSMutableArray* rtept;

- (void)addWaypoint:(Waypoint *)waypoint;
- (void)dumpRoute;
@end

#pragma mark TrekSegment

@interface TrekSegment : NSObject {
    NSMutableArray *trekpoints;
    // Extensions
}
@property (retain) NSMutableArray* trekpoints;
- (void)addWaypoint:(Waypoint *)waypoint;
- (void)dumpTrekSegment;
@end

#pragma mark Trek

@interface Trek : PathHeader {
    NSMutableArray *trkseg;
}

@property (retain) NSMutableArray* trekseg;

- (void)addTrekseg:(TrekSegment*)segment;
- (void)dumpTrek;
@end

#pragma mark GPX

@interface GPX : NSObject {
    NSString        *version;
    NSString        *creator;

    Metadata        *metadata;
    NSMutableArray  *waypoints;
    NSMutableArray  *routes;
    NSMutableArray  *treks;
}
@property (retain) Metadata* metadata;
@property (retain) NSMutableArray* waypoints;
@property (retain) NSMutableArray* routes;
@property (retain) NSMutableArray* treks;

- (void) addWaypoint:(Waypoint*) waypoint;
- (void) addRoute:(Route *) route;
- (void) addTrek:(Trek*) trek;
- (void) dumpGPX;
//- (NSString*) xmlString;
@end

