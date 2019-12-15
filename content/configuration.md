# # font

Probably the choice of font is the most important one can make when living in  
the console. I've spent many hours testing different fonts and I have  
found the one that is perfect - [unifont][1].  

Of course this choice is highly subjective. I am perfectly aware of this and  
that's why every now and then I was questioning my choice, trying  
something different, just to be sure that someone else's subjective choice  
isn't better for me. I did that until I found this [page][2] containing  
a screenshot of a terminal with a font that was also on my personal computer.  
Since then I'm convinced I made the right choice.

Cool thing about unifont is that you can put whatever glyphs (meaning  
characters) you need there. This is important as you are limited with the  
amount of glyphs console can display to 512. So if you happen to often see  
question marks on white background instead of a character it means it would  
be a good idea to include that character in your console font. Check out the  
build instructions below.

[1]:https://en.wikipedia.org/wiki/Unifont_CSUR
[2]:https://en.wikipedia.org/wiki/Dennis_Ritchie

-------------------------------------------------------------------------------

# # building unifont

Steps to build unifont:

1. Download font source code and verify gpg signature.  
```
$ wget http://ftp.gnu.org/gnu/unifont/unifont-12.1.03/unifont-12.1.03.tar.gz
$ wget http://ftp.gnu.org/gnu/unifont/unifont-12.1.03/unifont-12.1.03.tar.gz.sig
$ wget ftp://ftp.gnu.org/gnu/gnu-keyring.gpg
$ gpg --keyring ./gnu-keyring.gpg --verify ./unifont-12.1.03.tar.gz.sig
```

2. Double check if the key from the last command is the same on gpg server.  
```
$ gpg --keyserver https://keys.gnupg.net --search-keys 95D2E9AB8740D8046387FD151A09227B1F435A33`
```

3. untar and cd  
```
$ tar xf unifont-12.1.03.tar.gz
$ cd unifont-12.1.03
```

4. Edit the charcter set.  

File `./font/psf/unifont-apl.txt` contains UTF-8 codes that are going to be  
compiled. If you want to add a character you need to comment out something   
from the existing table that you won't use and add the UTF-8 code for the  
symbol you'd like to see in the font. Order doesn't matter, but the number of  
uncommented codes should be 512.  

To see actual glyphs in this file you can use a little bit of shell script:  
```
#!/bin/mksh
set -euo pipefail

unifont='./font/psf/unifont-apl.txt'

list=$(grep -v '^#' $unifont | sort -u)

while read -r line; do

        unicode=$(echo "$line" | cut -d'#' -f1 | sed 's|U+|\\u|')
        desc=$(echo "$line" | cut -d'#' -f2)

        echo -nE "$unicode"
        echo -ne "\t" $unicode "\t" $desc "\n"

done <<< "$list"
```

Of course you'll need a font with these glyphs already compiled in to view  
them. It's actually best to do it in xorg environment, as there's usually  
pretty good support for UTF-8 charsets out of the box there.  

To find other UTF-8 codes look below.

5. Make sure you have standard build tools installed and bdf2psf:  
```
$ emerge -a app-text/bdf2psf 	||
$ apt install gcc make bdf2psf
```

On arch linux you need to get the bdf2psf from AUR:
```
$ pacman -S gcc make gawk sed file git fakeroot
$ git clone https://aur.archlinux.org/bdf2psf.git
$ cd bdf2psf && makepkg
$ pacman -U ./bdf2psf-*-any.pkg.tar.xz
```

6. Compile.
```
$ make bindir
$ cd font/
$ make psf
```

7. Check out your new font.  
```
$ setfont compiled/Unifont-APL8x16-12.1.03.psf.gz
```

-------------------------------------------------------------------------------

# # finding UTF-8 codes

I couldn't find a single UTF-8 table on my system large enough to include all  
glyphs I'd be interested to see, but I was able to compile one from a few  
sources.  

You can check the file `/usr/share/consoletrans/utflist` from kbd package:  
```
$ emerge -a sys-apps/kbd ||
$ pacman -S kbd
```
I couldn't find this file in debian in any package, but you can also get it    
from source:  
```
$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/legion/kbd.git
$ less ./kbd/docs/doc/utf/utflist
```

To supplement it you can use `/usr/share/X11/locale/en_US.UTF-8/Compose` or    
other UTF-8 files located there from libX11 package for a more complete code   
table:  
```
$ emerge -a x11-libs/libX11	||
$ pacman -S libx11		||
$ apt install libx11-data
```

Vim also has some pretty cool UTF-8 table:  
`/usr/share/vim/vim81/doc/digraph.txt`

