// AppticsHeatmap is iOS + Mac Catalyst only. This wrapper gates the binary
// xcframework so macOS/tvOS/watchOS targets in multi-platform apps can still
// depend on the main Apptics package without linking AppticsHeatmap.
enum AppticsHeatmapWrapperMarker {}
