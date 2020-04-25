
******** lnxcons

This is a repository containing content of the linuxconsole.net webpage.
The only dependency is ksh shell, but will probably work with other shells
as well.

You can easily repurpose it to create another site like this one. The only
non-transferable file is the deploy.sh script.


**** building the site

./build.sh


**** directory structure

- build
Location of the compiled site ready to be placed on www server.

- txt
Text files containing actual content of the site.

Every file appearing in this location will automatically be included
in the build. When adding a new top page be sure to add a link to it in
./assets/links.index.html.

- assests
HTML snippets, favicon, robots.txt, font, links etc.

- files
Various files included as links.

- benchmarks

Some benchmarks I am or will be working on.
