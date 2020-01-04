
# lnxcons

This is a repository containing content of the linuxconsole.net webpage
together with tooling for compiling it.

The only dependency is cmark and POSIX compliant shell.

You can easily repurpose it to create another site like this one. The only
non-transferable file is the `deploy.sh` script.


# building the site

`./build.sh`


# directory structure

- build

Location of the compiled site ready to be placed on www server.

- content

Markdown and text files containing actual content of the site.

Every markdown file appearing in this location will automatically be included
in the build. When adding a new top page be sure to add a link to it in
`./links/index.links.md`.

- html

HTML snippets and css file attached to every page.

- links

Links to be included in each page. By default all pages have `back to main
page` link, except for the main page. If you want other links to be
automatically placed in a sub-page named <name> create a file `<name>.links.md`
in this directory.

- sitemap 

Tools to create, deploy and submit sitemap. To create a sitemap for your site
check `sitemap.sh` script. To notify google about new sitemap run
`ping_google.sh`.
