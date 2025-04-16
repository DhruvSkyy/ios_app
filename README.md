# Website Directory iOS App

This Swift-based iOS app displays a list of websites loaded from a remote JSON source. Each entry shows the website’s name, description, and icon. Users can open websites in Safari, search and filter entries, toggle between light and dark mode, and sort them alphabetically.

## Features

- Fetches and decodes website data from a hosted JSON file
- Displays name, description, and icon for each website
- Opens links directly in Safari
- Live search bar to filter websites by keyword
- Sorting toggle to view results alphabetically
- Light and dark mode support via toggle
- Fallback handling for missing or broken images

## SVG icon support

Swift's built-in `AsyncImage` does not support `.svg` files. To address this, a custom `SVGImageView` was implemented using SVGKit. It loads, parses, and renders SVGs as `UIImage` objects that can be displayed in Swift.

If an SVG fails to load due to a network issue or malformed structure, a fallback placeholder icon is shown. This prevents blank spaces or layout issues, and avoids crashes caused by rendering errors in CALayer.

Note: SVG support is functional but may exhibit bugs in some edge cases such as slow loads, malformed files, or CALayer render issues.

## Submission Notes

**How I approached the task**  
I started by making a simple template app that just displayed websites and played around with making a JSON request, so I wrote a struct for it. After that, I moved on to loading icons — this was definitely the hardest part because of the issues with SVG support. Once I got that working (mostly), I added more UI features like a search bar, light/dark mode toggle, sorting, and styled it with cards. I originally wanted something like the Spotify scrollable cards UI, but that didn’t work out and I ended up going with a design more like the iOS Settings app.  

**What I’m particularly proud of**  
I’m proud of getting light and dark mode working smoothly, and getting SVGs to render — it’s not perfect, but works in most cases. I am also quite new to testing especially with using mocking so getting that to work was nice. 

**What I would improve or add if I had more time**  
I’d write unit tests for the SVG loading part — right now, the tests only cover parsing the json and whether fetching the request works with mocking. I was also thinking of adding a feature to let users input their own websites alongside the ones fetched, and storing that in a database either locally or with the cloud.
