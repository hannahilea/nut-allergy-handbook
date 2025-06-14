# WORK IN PROGRESS -- NOT YET LOVELY!

# Nut free mapper! 

Mapping the current state of nut-allergy-friendliness of various restaurants, coffee shops, and other venues. 

- View site: [https://nut-free-mapper.hannahilea.com](https://nut-free-mapper.hannahilea.com) - Not yet valid! TODO
- [Submit new map entry](TODO) - Not yet valid! TODO
- [Edit existing map entries](TODO-link-to-google-form) - Not yet valid! TODO
- [Manually trigger rebuild](TODO) - Not yet valid! TODO
- [View map directly](TODO) - Not yet valid! TODO

## (Aspirational) site generation workflow
![](./assets/workflow-plot.png)


## Punch list
- [x] create map shell: https://www.google.com/maps/d/u/0/edit?mid=1ByVtx0dsYJ8E_suvTlCRM363DHYZ6Io&ll=42.38269187688064%2C-71.09720596296654&z=15
- [x] google form
- [x] change visibility of site to public
- [x] set up github pages for site (not possible until public)
- [x] embed map in static site
- [x] generate static site from script
- [ ] add license
- [ ] end-to-end script skeleton (manual)
- [ ] fill in script:
  - [ ] download sheet csv 
  - [ ] parse entries for website
  - [ ] pull entries into website
  - [ ] parse entries for map
  - [ ] format entries as map format (KML??)
- [ ] figure out map upload; may be manual to start?
- [ ] add big ol' faq/disclaimer about role of this info
- [ ] add links to tools used (e.g. css, google maps, etc)


### Feature creep future:
- Run script via GHA instead of manually
- Add filtering to table
- Multiple tables for various restaurant categories (safety, type, stars, etc)
- Handle different geographies (filters/pages/whatever); Add location to table (city or zipcode etc)?
- Template for contacting restaurants
- Figure out privacy issues of delayed updating of site, private version of site while traveling, etc
- Support multiple entries for the same venue (e.g. timestamped dates for updated menus, updated queries, etc)
- "hall of fame" for places that actively promote allergen friendliness AND that have moved from non-friendly to friendly
- Add (separate) workflow that supports nicer realtime site investigation (interop with Google Maps directly, etc)
- Figure out how to add tags for venue type (cafe/food/etc)
- Add separate page (?) for chain restaurants?


## Fields for form 
- date contacted
- person contacting
- map link
- other (visible)
- other (private)
- safety class
- caveats 
- unsafe items

optional:
- link to menu

## Credits
- Thanks to [wescpy.blogspot.com](https://wescpy.blogspot.com/2016/07/exporting-google-sheet--as-csv.html) for the pointer to use the Google Drive API instead of the Google Sheets API
