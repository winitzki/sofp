$c=0;
while(<>) {
	while(<>) { last if (m/^\\begin\{lstlisting\}/); };
	$c += 1;
	$filename=sprintf("snippet%05d.scala", $c);
	printf "Code snippet %05d:\n", $c;
	print "```scala mdoc\n";
	while(<>) {
		last if (m/^\\end\{lstlisting\}/);
		s,^scala>,,;
		s,^ammonite@,,;
		s,^res[0-9]+,// res0,;
		s,//([^/]|/[^/])*,\n,;
		print;
	};
	print "```\n\n"; 
};
