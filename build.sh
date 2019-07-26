cat html/html.head.txt > build/index.html
cmark index.links.md >> build/index.html
echo '</div>' >> build/index.html
cmark index.md >> build/index.html
echo '</body>' >> build/index.html

