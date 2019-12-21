
# # web browser

I tested many console webrowsers - w3m, lynx, links and elinks, and  
definietly *w3m* has the best browsing experience for me. I really enjoy  
using it - has vi key bindings, webpage rendering is intuitive, it can be  
configured to show pictures, play videos or to download websites and  
torrents.  

Default settings in w3m are alright, just one thing bothered me - the color  
of the links. By default it's blue and it's not that well visible in the  
console. I change it to green, replacing it with image link color like that:
```
anchor_color 	blue -> green
image_color 	green -> blue
```

Default image viewer `w3mimgdisplay` works great and I didn't have a need to  
change it. It doesn't display gif images though and it doesn't allow for  
zooming the image, but you can define other applications to handle that.  
File `~/.w3m/mailcap` contains information on how to handle different media  
types. Put these lines there:
```
image/gif; mpv -vo drm '%s'
image/*; fim -a '%s'
video/*; mpv -vo drm '%s'
audio/*; mpv '%s'
```
Now when you encounter a gif or image (to check the type press <u> when  
cursor is over a link to see the url) you can press <shift>+<i> to open the  
link with appropriate program.

There's also another way to open links in external programs - via  
'external browsers'. This allows for adding many functionalities. There are  
however only 10 slots for these. Each defined 'external browser' can be  
invoked by pressing <ext browser number><esc><M> (in that order, note case in  
m). The main external browser can be invoked without the number.  

To download a webpage under the link you can use this 'external browser':  
`wget -p -k -E -e robots=off`  

To play a video (e.g. from youtube):  
`mpv --vo drm`  

To view more information on youtube video (description, comments etc.):  
`mpsyt url`  

To add a magnet link to transmission  torrent client download list:
`transmission-remote -n user1:password1 -a "$0"`  

To create a torrent file from a magnet link in rtorrent watch location:  
`sh -c 'echo "d10:magnet-uri${#0}:${0}e" > /tmp/watch_dir/magnetlink_$RANDOM$RANDOM$RANDOM.torrent'`  

It's also useful to make aliases (and functions) for your shell to  
convieniently use search engines directly from shell. Like this:  
```
alias w3m='w3m -B'		# start w3m on bookmark page
w3d() { command w3m duckduckgo.com/lite/?kd=-1\&kp=-2\&kl=us-en\&q="$*"; }
w3y() { command w3m invidio.us/results?search_query="$*"; }
w3yy() { command w3m youtube.com/results?search_query="$*"; }
```
You can now use `$ w3d atari 65xe` to quickly find search engine results, or  
`$ w3y 56k modem sounds` to see youtube videos relevant for your phrase.  

-------------------------------------------------------------------------------

# # search engines


The only one that works flawlessly with w3m is duckduckgo. Others are working  
more or less ok, so it's still ok to type for example '!s your query' in ddg  
(that's for startpage, recommended) to search other search engines. 


-------------------------------------------------------------------------------

# # youtube 

Above you could see how to use youtube from w3m web browser.

From the command line you can use youtube-dl to download the videos and watch  
them with mpv.  
```
$ youtube-dl invidio.us/watch?v=vPzDTfIb0DU
$ mpv --vo drm Faith\ No\ More\ -\ Easy\ \(Official\ Music\ Video\)-vPzDTfIb0DU.mkv
```

You can also play youtube videos directly from mpv (don't forget "https://"):  
```
$ mpv --vo drm  https://invidio.us/watch?v=vPzDTfIb0DU
```

And you can just listen to music without downloading the videos, which is way  
faster obviously:  
```
$ youtube-dl -x invidio.us/watch?v=vPzDTfIb0DU
$ mpv Faith\ No\ More\ -\ Easy\ \(Official\ Music\ Video\)-vPzDTfIb0DU.opus
$ mpv --no-video https://invidio.us/watch?v=vPzDTfIb0DU
```

To see comments and descriptions you can use mpsyt like this:
```
$ mpsyt
> /faith no more	# search for phrase
> c 3			# comments for search result number 3
> n			# next page of comments
> i 3			# info and description of the video
> 3			# play video
> help			# show other commands
```

Invidio.us has all youtube videos without all the unnecessary javascript  
(this doesn't matter for w3m though) and is rendered way better by w3m than  
original youtube site.


-------------------------------------------------------------------------------

# # hacker news, reddit

Hacker news works great in w3m without any customizations. You can't create  
an account though as verification is required via google's javascript. You  
can send an e-mail with an request for an account though. All other things  
work just great, apart from folding the comment threads. Oh, and downvoted  
comments are not greyed out, so you need to think for yourself to determine  
if the comment is low quality. Oh, and searching doesn't work, but you can  
uses duckduckgo for that with `site:ycombinator.com tptacek` as an example.

Reddit works ok in w3m to view posts. You just have to redirect all http  
requests to old.reddit.com. To do that create a file `~/.w3m/siteconf` with  
these lines:  
```
url "https://www.reddit.com/"
substitute_url "https://old.reddit.com/"
```
Didn't test creating an account, logging in or posting comments, but chances  
are that this doesn't work in w3m. You can also try to use programs that show  
reddit conent in terminal, like [rtv alternatives][40].

[40]:https://github.com/michael-lazar/rtv/blob/master/ALTERNATIVES.md


-------------------------------------------------------------------------------

# # last.fm

mpsyt has an interface to last.fm. Didn't use it yet, but here's some  
information from mpsyt:

```
pylast needs to be installed for Last.fm support. See  
https://github.com/pylast/pylast.

	Use set to set your Last.fm login credenditals, e.g.  
	set lastfm_username jane_doe.
	Similarly, you also have to provide an API key and it's corresponding  
	secret.
	An API key can be retrieved from  
	https://www.last.fm/api/account/create.
```
