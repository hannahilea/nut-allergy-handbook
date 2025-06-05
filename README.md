# Nut map 

[View site](nut-map.hannahilea.com)

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
Google Sheet -> outer: is downloaded by

outer: {
  code: script
  code: {
    download csv: csv of entries
    download csv -> format map
    download csv -> format site
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
outer.code.convert to KML -> Google Map: upload
outer.code.site generate -> Github: git push
Github -> Site: served by GitHub Pages
Google Map -> Site: embedded via iFrame


Site: nut-map.hannahilea.com
Site.shape: cloud

github: {
  shape: image
  icon: https://icons.terrastruct.com/dev/github.svg
}
```
