# plazu
Plazu is a simple GPS Exchange Format (.gpx) viewer for OS X. It uses the
Apple Maps API introduced in Mac OS 10.9. Plazu can currently display tracks
and waypoints and their associated labels.

<img src="https://github.com/v4lli/plazu/raw/master/Images.xcassets/AppIcon.appiconset/gpxview.png" alt="Plazu logo" width="100px">

## MapKit Restrictions
Sadly, Apple doesn't allow developers without a payed Mac Developer Account
to use their MapKit API (or rather the actual map data). The app can be
compiled and executed but no map is shown without a valid entitlement. :(

## Missing Features
Plazu's purpose was mainly to teach me about Object-C and Mac development
in general. Don't expect anything else in terms of code quality or
functionality!

Some features I would work on next if I wasn't too cheap to pay the $100
to renew my Mac Developer Membership:

* Automatically zoom in on the area containing the plotted track
* Track smoothing (i.e. don't just plot and connect waypoints)
* Performance and efficiency improvements
* UI/UX improvements
* Allow to import, store and label .gpx files

## License
See LICENSE. Plazu also contains gpx-{reader,api}.m by Bryce Groff, see the
copyright headers in those files. It may also contain code snippets from all
over the web.
