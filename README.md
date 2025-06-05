# Nut free mapper! 

For keeping track of the current state of nut-allergy-friendliness of the restaurants we've spent time looking into. 

- [View site: https://nut-free-mapper.hannahilea.com](https://nut-free-mapper.hannahilea.com) - Not yet valid! TODO
- [Submit new map entry](TODO) - Not yet valid! TODO
- [Edit existing map entries](TODO-link-to-google-form) - Not yet valid! TODO
- [Manually trigger rebuild](TODO) - Not yet valid! TODO
- [View map directly](TODO) - Not yet valid! TODO


```d2 layout=dagre
vars: {
  d2-config: {
    sketch: true
  }
}


People1! -> Google Form: submits
People2! -> Google Form: submits
People3! -> Google Form: submits
People1!.style.multiple: true
People1!.shape: person
People1!: ""
People2!.style.multiple: true
People2!.shape: person
People2!: ""
People3!.style.multiple: true
People3!.shape: person
People3!: ""


Google Form -> Google Sheet: saves to
Google Form.shape: page
Google Sheet -> outer: is downloaded by
Google Sheet.shape: cylinder

outer: {
  code: script
  code.shape: rectangle
  code: {
    csv: csv of entries
    csv -> format map
    csv -> format site
    format site -> site generate
    format map -> convert to KML

    format map: format entries for map
    format map.style.multiple: true
    format site: format entries for site
    format site.style.multiple: true
    site generate: generate static site
  }
}

outer: ""
outer.code.convert to KML -> Google Maps: upload
outer.code.site generate -> Github: git push
Github -> Site: served by GitHub Pages
Google Maps -> Site: embedded via iFrame
Google Maps.shape: cloud

Site: nut-free-mapper.hannahilea.com
Site.shape: page

github: {
  shape: image
  icon: https://icons.terrastruct.com/dev/github.svg
}
```

## Punch list
- [x] create map shell: https://www.google.com/maps/d/u/0/edit?mid=1ByVtx0dsYJ8E_suvTlCRM363DHYZ6Io&ll=42.38269187688064%2C-71.09720596296654&z=15
- [ ] google form
- [ ] script skeleton
- [ ] generate static site from script
- [ ] embed map in static site
- [ ] fill in script:
  - [ ] download sheet csv 
  - [ ] parse entries for website
  - [ ] pull entries into website
  - [ ] parse entries for map
  - [ ] format entries as map format (KML??)
- [ ] figure out map upload; may be manual to start?
- [ ] add big ol' faq/disclaimer about role of this info
- [ ] add license
- [ ] change visibility of site to public
- [ ] set up github pages for site (not possible until public)

### Feature creep future:
- Run script via GHA instead of manually
- Add filtering to table
- Multiple tables for various restaurant categories (safety, type, stars, etc)
- Handle different geographies (filters/pages/whatever)
- Template for contacting restaurants
- Figure out privacy issues of delayed updating of site, private version of site while traveling, etc
- Support multiple entries for the same venue (e.g. timestamped dates for updated menus, updated queries, etc)
- "hall of fame" for places that actively promote allergen friendliness AND that have moved from non-friendly to friendly

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
