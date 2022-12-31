import std/xmltree
import std/os

proc url(link, priorityVal: string): XmlNode =
    var loc = newElement("loc")
    loc.add newText(link)

    var lastmod = newElement("lastmod")
    lastmod.add newText("2022-12-31T11:38:06+00:00")

    var priority = newElement("priority")
    priority.add newText(priorityVal)

    var url = newElement("url")
    url.add loc
    url.add lastmod
    url.add priority
    result = url


proc main(rootURL, dynamicPath, mdPath, rootPath: string) =
    var urls = newSeq[XmlNode]()
    var path, name, ext: string
    let allowedExtensions = @[".html", ".htm"]
    for f in walkDirRec(rootPath, {pcFile}, {pcDir}, true, true):
      (path, name, ext) = splitFile(f)
      if ext in allowedExtensions:
          var link = rootURL/"/"/f
          echo("adding path: ", link)
          urls.add(url(link, "1.00"))
    let att = {
        "xmlns": "http://www.sitemaps.org/schemas/sitemap/0.9",
        "xmlns:xsi": "http://www.w3.org/2001/XMLSchema-instance",
        "xsi:schemaLocation": "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
    }.toXMLAttributes
    let sitemap = newXmlTree("urlset", urls, att)
    echo($sitemap)


when isMainModule:
    if paramCount() < 3:
      quit("wrong usage; e.g. mysitemap 'https://abhishekkr.github.io' '/blog.html#/' ./blogs [$PWD]")
    let rootURL = paramStr(1)
    let dynamicPath = paramStr(2)
    let mdPath = paramStr(3)
    var optRoot = "."
    if paramCount() == 4:
        optRoot = paramStr(4)
    main(rootURL, dynamicPath, mdPath, optRoot)
