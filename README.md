Not all components of the dissertation are easily buildable by some TeX GUIs; specifically, the biber-based bibliography and the nomenclature. The included makefile is configured to use `latexmk` to produce PDFs with Synctex enabled, which will repeat generation until all components have stabilized and automatically calls `biber` as necessary, but to properly build the nomenclature the following contents need to be added to your `.latexmkrc` file:

    # Custom dependency and function for nomencl package (thanks to https://tex.stackexchange.com/a/105978)
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

    # Extra files for latexmk to clean up
    $clean_ext='bbl loa lol nav nlo nls snm vrb run.xml synctex(busy) glstex'

A similar addition to `.latexmkrc` is likely necessary if you wish to utilize the `glossaries` package, as that also requires executing an external program. It may be integrated automatically the same way `biber` is but I have not checked to see if it actually is.
