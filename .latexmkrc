# for extra bibliography, lists and stuff
$clean_ext='bbl loa lol loe glg glstex nav nlo nls snm vrb run.xml synctex(busy)';

# Custom dependency and function for nomencl package
add_cus_dep('nlo', 'nls', 0, 'makenlo2nls');

sub makenlo2nls {
	system("makeindex -s nomencl.ist -o \"$_[0].nls\" \"$_[0].nlo\"");
}

# Custom dependency and function for glossaries via bib2gls (thanks to https://tex.stackexchange.com/a/401979)
add_cus_dep('aux', 'glstex', 0, 'run_bib2gls');

sub run_bib2gls {
  if ( $silent ) {
    my $ret = system "bib2gls --silent --group '$_[0]'";
  } else {
    my $ret = system "bib2gls --group '$_[0]'";
  };
  my ($base, $path) = fileparse( $_[0] );
  if ($path && -e "$base.glstex") {
    rename "$base.glstex", "$path$base.glstex";
  }
  # Analyze log file.
  local *LOG;
  $LOG = "$_[0].glg";
  if (!$ret && -e $LOG) {
    open LOG, "<$LOG";
    while (<LOG>) {
      if (/^Reading (.*\.bib)\s$/) {
        rdb_ensure_file( $rule, $1 );
      }
    }
    close LOG;
  }
  return $ret;
}
