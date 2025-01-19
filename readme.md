<h3>Description</h3>

Bash script for Linux

Uses feh to set the wallpaper

Uses sunrise-sunset.org's free API to find the times for sunrise and sunrise-sunset

Included in the folder is a set of screenshots of Minecraft's infamous pack.png image, rendered in 1.21 with shaders.

<h3>Usage</h3>

In order to use it you need to set it to run occasionally in your crontab, I have mine set as the following:

>30 * * * * /home/alex/DynamicWallpaper/wallpaper.sh
>0 * * * * /home/alex/DynamicWallpaper/wallpaper.sh

This updates the wallpaper every 30 minutes.

<h3>Limitations</h3>
Everything is hardcoded into the script: latitude and longitude, directory of wallpaper photos, number of photos, etc. I'll probably fix this and add a separate config file at some point, though it works as is.

Due to its use of feh, this script also only really works for X11 users having either a minimal desktop environment or no desktop environment at all. I use it combination with the i3 window manager, which works quite well.
