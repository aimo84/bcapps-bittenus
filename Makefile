all: phrases.txt /home/user/bin/bc-scanf-tests bclib.py

/home/user/bin/bc-scanf-tests: bc-scanf-tests.c Makefile
	gcc -o /home/user/bin/bc-scanf-tests bc-scanf-tests.c -lm

# this just makes it easier to fgrep -vf
# can't get egrep -v '^
phrases.txt: bots.txt Makefile
	egrep -v '^#' bots.txt | egrep '[a-z0-9_]' > phrases.txt

# hideous kludge to get python "working"

bclib.py: bclib.by
	bython -c bclib.by
