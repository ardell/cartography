@import <Foundation/CPObject.j>
@import "TerrainPalettePanel.j"
@import "MapView.j"

@implementation AppController : CPObject
{
  MapView _mapView;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
  // Elect for a Logger
  CPLogRegister(CPLogConsole);
  // Top-level window creation, full browser dimensions
  var theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
  // Extract the contentView of the top-level window
  var contentView = [theWindow contentView];
  // Set our background color
  [contentView setBackgroundColor:[CPColor grayColor]];
  // Make this window the front window
  [theWindow orderFront:self];
  
  // Create a TerrainPalettePanel
  [[[TerrainPalettePanel alloc] init] orderFront:nil];
    
  // Create a MapView with this MapModel as the main window
  _mapView = [[MapView alloc] init];
  
  // Configure our ScrollView (ourself) to view the map
  var mapScrollView = [[CPScrollView alloc] initWithFrame:[contentView frame]];
  [mapScrollView setDocumentView:_mapView];
  [mapScrollView setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
  [mapScrollView setAutohidesScrollers:YES];
  
  [contentView addSubview:mapScrollView];
  
  // Pull a MapModel from the database
  //var thisMapModel = [MapModel findById:4];
  // Set up our request to the terrain_types index action
  var request = [CPURLRequest requestWithURL:"/maps/4.json"];
  
  // Fire off the request! This object will handle the response.
  [CPURLConnection connectionWithRequest:request delegate:self];
  
  // TODO: Menubar for new, load, save Maps...
}

- (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)data
{
  // Parse the response JSON into a data object
  var thisMapModel = [[MapModel alloc] initWithMapModelJSONData:data];
  
  // Seed the CollectionView with the data object
  [_mapView setMapModel:thisMapModel];
}

- (void)connection:(CPURLConnection)aConnection didFailWithError:(CPError)anError
{
  CPLogConsole("Error!", "error", "Connection");
  CPLogConsole(anError, "error", "Connection");
}

@end
