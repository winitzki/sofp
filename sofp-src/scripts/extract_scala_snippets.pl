$c=0;
while(<>) {
	while(<>) { last if (m/^\\begin\{lstlisting\}/); };
	$c += 1;
	$filename=sprintf("snippet%05d.scala", $c);
	printf "// Code snippet %05d:\n", $c;
	while(<>) {
		last if (m/^\\end\{lstlisting\}/);
		s,^(scala>|ammonite\@)\s+,,;
		s,^res[0-9]+\s*:\s*([^=]+[^=\s])\s*=\s*, .mustBe[$1] equal ,;
		s,^([0-9a-zA-Z_]+)\s*:\s*([^=]+[^=\s])\s*=\s*,$1 .mustBe[$2] equal ,;
		s,//([^/]|/[^/])*,\n,;
                s,^([a-zA-Z.0-9_]*Exception): (.*)$, .mustThrow[$1]("$2"),;
		print;
	};
	print "\n"; 
};
