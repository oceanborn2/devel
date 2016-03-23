#!/usr/bin/perl

require "cgi-lib.pl";

use XML::DOM;
my $parser = new XML::DOM::Parser;

print <<EOT;
content-type: text/html

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<TITLE>The Project Architect Frequently asked questions</TITLE>
<META NAME="description" CONTENT="TheProjectArchitect">
<META NAME="keywords" CONTENT="Frequently asked questions">
<META NAME="resource-type" CONTENT="document">
<META NAME="distribution" CONTENT="global">
<LINK HREF="projarch.css" REL="stylesheet"</LINK>
</HEAD>
<BODY>

<H1>Frequently asked questions page</H1>

EOT

    local $/=undef;
    my $data = <DATA>;
    my $doc = $parser->parsefile("../sources/faqs.xml");
    my $entries = $doc->getElementsByTagName('faqentry');
    my $n = $entries->getLength; 
    for (my $i = 0; $i < $n; $i++)
    {
        my $entry = $entries->item ($i);
	my $question = $entry->getAttribute('question');
	my $answer   = $entry->getAttribute('answer');
	print "<B>Question</B>: $question<br><B>Answer:</B>$answer<br><br>";
    }


print <<EOT
<P>
<A HREF="mailto:munerot@users.sourceforge.net">Mail a question to the developer</A>
</BODY>
</HTML>
EOT









