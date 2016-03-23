#!/usr/bin/bash

echo "Bundling and releasing site as gzip archive onto projectarchit.sourceforge.net"
tar -cf tpa_site.tar htdocs cgi-bin sources
gzip tpa_site.tar
scp tpa_site.tar.gz munerot@projectarchit.sourceforge.net:/home/groups/p/pr/projectarchit

