# These are some things I like to bring up after starting X11, but
# don't feel should be part of .xinitrc or .Xprofile

# my preferred defaults

# TODO: these should be configurable without having to run these
# commands everytime; figure out how

# firefox
firefox&

# stickly digital xclock in lower right hand corner
# TODO: nanoseconds (%N doesn't work after -strftime)

xclock -norender -font -misc-fixed-bold-r-normal--14-130-75-75-c-70-iso8859-1 -padding 0 -digital -update 1 -strftime '%a %d %b %Y %H:%M:%S' -geometry 170x19+854+749 &

# pidgin
gaim -n &

# I run screen multiply (using "screen -m") and this brings up two
# xterms to run those screens in

# TODO: back when I ran rxvt instead, "-font x" yields an error but
# brings up the right font whereas not using "-font" brings up the
# "wrong" (for me font); figure out how to do this properly

xterm -geometry 80x53 +sb -bg gray45 -bd gray45 -T SCREEN -n SCREEN &
xterm -geometry 80x53 +sb -bg gray45 -bd gray45 -T "SCREEN II" -n "SCREEN II" &

# runs elinks in an extra wide rxvt to the right of the main fvwm screen

rxvt -geometry 165x52+1024+26 -font x -T ELINKS -n ELINKS -tn vt100 -e elinks &

# it's useful to have an extra wide screen just above the main fvwm screen
rxvt -geometry 165x52+0+2339 -font x -T WIDESCREEN -n WIDESCREEN &

# vidalia is dead :(