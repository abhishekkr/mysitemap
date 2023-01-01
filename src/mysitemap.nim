import std/os
import std/parseopt
import std/strutils
import std/times
import std/xmltree

let topPriority = 1.0
var timeStamp = $(now())

proc url(link: string, priorityVal: float): XmlNode =
    var priorityStr = priorityVal.formatFloat(ffDecimal, 2)
    var loc = newElement("loc")
    loc.add newText(link)

    var lastmod = newElement("lastmod")
    lastmod.add newText(timeStamp)

    var priority = newElement("priority")
    priority.add newText(priorityStr)

    var url = newElement("url")
    url.add loc
    url.add lastmod
    url.add priority
    result = url


proc main(rootURL, rootPath, dynamicPath, mdPath, : string, skipmd: bool) =
    var urls = newSeq[XmlNode]()
    var path, name, ext: string
    let allowedExtensions = @[".html", ".htm"]
    let allowedSubdirs = @["", "blogs", "slides"]

    urls.add(url(rootURL, topPriority))

    var htmlPriority = topPriority - 0.05
    var curDir = rootPath
    for f in walkDirRec(rootPath, {pcFile}, {pcDir}, true, true):
        (path, name, ext) = splitFile(f)
        if not (path in allowedSubdirs):
            continue
        if ext in allowedExtensions:
            var link = rootURL/"/"/f
            echo("adding path: ", link)
            urls.add(url(link, htmlPriority))
        if curDir != path:
            htmlPriority = htmlPriority - 0.05
            curDir = path

    if not skipmd:
        let mdPriority = topPriority - 0.1
        for f in walkDir(mdPath, true, true):
            (path, name, ext) = splitFile(f.path)
            if ext == ".md":
                var link = rootURL/dynamicPath/f.path
                echo("adding path: ", link)
                urls.add(url(link, mdPriority))

    let att = {
        "xmlns": "http://www.sitemaps.org/schemas/sitemap/0.9",
        "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation": "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
    }.toXMLAttributes
    let sitemap = newXmlTree("urlset", urls, att)
    echo($sitemap)


when isMainModule:
    var p = initOptParser(longNoVal = @["help", "skipmd"])
    var help, skipmd: bool
    var site, sitePath, mdURL, mdPath: string
    for kind, key, val in p.getopt():
        case key:
            of "help":
                help = true
            of "skipmd":
                skipmd = true
            of "site":
                site = val
            of "site-path":
                sitePath = val
            of "md-url":
                mdURL = val
            of "md-path":
                mdPath = val
    if help:
        quit("e.g. mysitemap --site='https://abhishekkr.github.io'[--site-path='.'] [--skipmd] [--md-url='/blog.html#/blogs' --md-path=./blogs]")
    if skipmd:
      echo("--skipmd has been passed, so assuming no dynamic/markdown paths available")
    if sitePath == "":
        sitePath = "."
    main(site, sitePath, mdURL, mdPath, skipmd)
