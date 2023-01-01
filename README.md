
## Generate custom sitemap.xml

> written in Nim, latest linux binary available in root of repo

This project was primarily written as part of a [Nim tutorial](https://abhishekkr.github.io/blog.html#/blogs/2023-01-01-nim-generate-sitemap.md); also to help generating sitemap.xml file for my site [abhishekkr.github.io](https://abhishekkr.github.io/blog.html).
This has blogs page which renders content directly from Markdown files present and the specific blog links are a combination of hash string with same base blog link. Making it hard for search engines to identify different pages.

### HowTo Use

* to show help

```
$ nim c -r src/mysitemap.nim --help
```

* to generate full sitemap with dynamic/markdown links

```
$ nim c -r src/mysitemap.nim --site='https://abhishekkr.github.io' --site-path='.' --md-url='/blog.html#/blogs' --md-path=./blogs
```

* to generate sitemap without dynamic/markdown links

```
$ nim c -r src/mysitemap.nim --site='https://abhishekkr.github.io' --site-path='.' --skipmd
```

* using current dir as site path, for sitemap without dynamic/markdown links

```
$ nim c -r src/mysitemap.nim --site='https://abhishekkr.github.io' --skipmd
```

---
