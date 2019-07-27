cat html/html.head.txt > build/index.html
cmark links/index.links.md >> build/index.html
echo '</div>' >> build/index.html
cmark content/index.md >> build/index.html
echo '</body>' >> build/index.html

