
# # video and music

I use only one program for that actually - mpv. It has everything I need,  
including the ability to play streams. To play videos in the console you  
just need to provide `--vo drm` argument.  To play music you just need to  
provide a file or a directory as an argument.

Be sure for the user to be in `audio` and `video` groups.  

Great list of radio stations with streaming service can be found [here][00].
To play the radion you just need to type, e.g.:  
```
$ mpv http://lyd.nrk.no/nrk_radio_jazz_mp3_h.m3u
```

Another player for console is mplayer, but it has tearing issues when playing  
videos. I used this command:
```
$ mplayer -vo fbdev2 -fs -zoom -xy 1920 -quiet -msglevel all=-1
```
mpv takes over the whole screen when playing videos, but mplayer doesn't do  
that, so you'd have to hide your tmux status bar, beacuse it will be flashing  
with every change of text in it. To do that add a key binding in  
`~/.tmux.conf` by appending this line: `bind-key S set status`. Now you  
can toggle status bar by pressing <prefix><S>.

[00]:https://www.liveradio.ie/countries

-------------------------------------------------------------------------------

# # images

I use [fim][10] currently, but before that I used [fbi][11].

[10]:https://savannah.nongnu.org/projects/fbi-improved
[11]:https://www.kraxel.org/blog/linux/fbida

-------------------------------------------------------------------------------

# # PDFs, DJVUs and e-books

For PDFs on DJVUs I use [fbpdf][20] that also provides fbdjvu binary. It works  
good enough not to start xorg for working with PDFs.

For reading e-books in epub format I use w3m. If the ebook is text only I use  
einfo from [ebook-tools][21] like this:
```
einfo -pp book1.epub | \w3m -T text/html
```

If e-book contains pictures or is pretty long it's good to extarct it with  
unzip, locate the index file and open it with w3m. The index file location and  
name can be different for each e-book, but it's not hard to find usually.

I don't use calibre, but I have extracted one python script from there -  
`ebook-convert`. It's really useful to convert different types of e-books and  
also to dump them into PDF.

[20]:https://sourceforge.net/projects/ebook-tools/
[21]:https://github.com/aligrudi/fbpdf

-------------------------------------------------------------------------------

# # camera and QR codes scanning

To record video from camera ffmpeg with compiled in v4l2 support is great.  
`v4l2-ctl` command is available in `v4l-utils` package.

Check out these commands:
```
$ v4l2-ctl --list-devices			# list camera devices
$ v4l2-ctl --list-formats-ext			# list camera modes
$ v4l2-ctl -L					# list camera options
$ v4l2-ctl -c <option>=<value>			# change camera option
$ ffmpeg -f v4l2 -framerate 30 -video_size 640x480 \
	-i /dev/video0 output.mkv		# record video
$ ffmpeg -ar 44100 -ac 2 -f alsa -i hw:0 \
	-f v4l2 -framerate 30 -video_size 640x480 \
	-i /dev/video0 output.mkv 		# record audio and video
$ ffmpeg -thread_queue_size 1024 \
	-ar 44100 -ac 2 -f alsa -i hw:0 -thread_queue_size 1024 \
	-i /dev/video0 output.mkv 		# record a/v with big buffer
```

For reading QR codes I use zbar with compiled in v4l support:
```
zbarcam --nodisplay --prescale=1280x1024 /dev/video0
```
`--nodisplay` is necessary because by default zbarcam will try to open  
graphical window, which it cannot open, because Linux console. `--prescale` is  
useful to increase cam resolution to pick up QR code faster.

