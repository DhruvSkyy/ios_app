# Website Directory iOS App

This SwiftUI-based iOS app displays a list of websites loaded from a remote JSON source. Each entry shows the website’s name, description, and icon. Users can open websites in Safari, search and filter entries, toggle between light and dark mode, and sort them alphabetically.

## Features

- Fetches and decodes website data from a hosted JSON file
- Displays name, description, and icon for each website
- Opens links directly in Safari
- Live search bar to filter websites by keyword
- Sorting toggle to view results alphabetically
- Light and dark mode support via toggle
- Fallback handling for missing or broken images

## SVG icon support

SwiftUI's built-in `AsyncImage` does not support `.svg` files. To address this, a custom `SVGImageView` was implemented using SVGKit. It loads, parses, and renders SVGs as `UIImage` objects that can be displayed in SwiftUI.

If an SVG fails to load due to a network issue or malformed structure, a fallback placeholder icon is shown. This prevents blank spaces or layout issues, and avoids crashes caused by rendering errors in CALayer.

Note: SVG support is functional but may exhibit bugs in some edge cases such as slow loads, malformed files, or CALayer render issues.
