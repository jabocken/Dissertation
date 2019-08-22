% VTthesis.cls - Provides a class for theses and dissertations
% Copyright (C) 2016,2017 Alan M. Lattimer
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%
% Please see the GNU General Public License: <http://www.gnu.org/licenses/>.
%
%-------------------------------------------------------------------------
% Revision Information
%   v1.0 Adapted Thesis class written by Erich L. Foster, 10 April 2012
%   v1.1 Modifications by Alan Lattimer, 1/29/16
%   v1.2 Fixed TOC problems, Alan Lattimer, 3/24/16
%   v1.2 Fixed missing package problems, Alan Lattimer, 4/5/16
%   v1.4 Added the ability to change the institution, 8/16/16
%   v1.5 Added a flag to prevent page skips after the front matter, 5/2/17
%   v1.6 Added List of Abbreviations, Carrie Cross, 9/8/17
%   v1.7 Fixed excess whitespace problems, Carrie Cross & LianTze Lim, 9/20/17
%   v1.8 Modified date-setting macro, Carrie Cross, 10/5/17
%	v1.9 Changed the LaTex rendering engine, Carrie Cross & Robert Browder, 	     4/27/18
%	v2.0 Updated instructions, Carrie Cross & Robert Browder, 4/30/18
%-------------------------------------------------------------------------

%%% IDENTIFICATION --------------------------------------------------------
\NeedsTeXFormat{LaTeX2e}[01/01/10]
\ProvidesClass{VTthesis}[2017/05/02 v1.5 Virginia Tech Proposal and Thesis Class]
\RequirePackage{etoolbox}
%Declaration of options
\newbool{@proposal}
\boolfalse{@proposal}
\newbool{@prelim}
\boolfalse{@prelim}
\newbool{@dbl}
\boolfalse{@dbl}
\newbool{@dft}
\boolfalse{@dft}
\newbool{@pgskip}
\boolfalse{@pgskip}

\DeclareOption{proposal}{\booltrue{@proposal}}
\DeclareOption{prelim}{\booltrue{@prelim}}
\DeclareOption{doublespace}{\booltrue{@dbl}}
\DeclareOption{draft}{\booltrue{@dft}}
\DeclareOption{pageskip}{\booltrue{@pgskip}}  % Skips blank pages.
%%% EXECUTION OF OPTIONS -------------------------------------------------
%% default to:
\ExecuteOptions{}

\ProcessOptions

%%% PACKAGE LOADING -------------------------------------------------------
%% based on standard book class
\LoadClass[12pt,letterpaper,\ifbool{@pgskip}{openany}{}]{book}

%% AMSLaTeX math environments and symbols
\RequirePackage{amsmath,amsthm,amssymb,amsfonts}
\RequirePackage[normalem]{ulem}
\RequirePackage{enumerate}
\RequirePackage[numbers,sort&compress]{natbib}
\RequirePackage{paralist}
\RequirePackage[titletoc,page]{appendix}

%% Proper chapter spacing in List of Algorithms (courtesy of https://tex.stackexchange.com/a/88563; no longer needed as now all the others are narrow)
%\patchcmd{\@chapter}% <cmd>
%  {\chaptermark{#1}}% <search>
%  {\chaptermark{#1}%
%    \addtocontents{loa}{\protect\addvspace{10\p@}}}% replace
%{}{}% <success><failure>

\RequirePackage[nottoc]{tocbibind}

\RequirePackage{fontspec}
\setmainfont{Latin Modern Roman}[SmallCapsFont={* Caps}]

%package required for nomenclature entry
\RequirePackage[intoc]{nomencl}
\makenomenclature

% Official format doesn't look as good as in book form but that can always be changed
\setlength{\textwidth}{6.5in}
\setlength{\textheight}{8.5in}
\setlength{\evensidemargin}{0in}
\setlength{\oddsidemargin}{0in}
\setlength{\topmargin}{0in}

\RequirePackage[parfill]{parskip} % for proper parskip that doensn't mess with non-paragraphs, plus extra parfill

% double space option
\RequirePackage{setspace}
\ifbool{@dbl}\doublespace{}

% Improvements over makeidx; allows multiple indices and doesn't require running makeindex externally, though it must come before hyperref for usage with it
\RequirePackage{imakeidx}

% links for references
\RequirePackage[final,colorlinks=true,allcolors=blue]{hyperref}

% For including pdf images:
%\RequirePackage[final]{graphicx}

% Code formatting
\RequirePackage{listings}

\RequirePackage{algorithm} % For algorithm float
\RequirePackage{algpseudocode} % algorithmicx pseudocode (needs to come before cleveref)

% Fix for tocbibind from algorithms package docs (the \let is the important part, rest is standard)
\renewcommand\listofalgorithms{\begingroup
  \tocfile\listalgorithmname{loa}
\endgroup}
\let\l@algorithm\l@figure

% Similar fix for listings
\renewcommand\lstlistlistingname{List of Listings}
\renewcommand\lstlistoflistings{\begingroup
  \tocfile\lstlistlistingname{lol}
\endgroup}

% Bit of work needed to get stuff not added to the TOC automatically into the TOC
\newcommand\addtocfix[2]{
  \clearpage\phantomsection % Getting hyperref to link to the right page
  \addcontentsline{toc}{chapter}{#1}
  #2
}

% So algorithm numbering matches other floats (doesn't work with acmart class, but that doesn't use chapters anyway)
\renewcommand\thealgorithm{\arabic{chapter}.\arabic{algorithm}}
% Fix for hyperref with algorithmicx (from http://tex.stackexchange.com/a/156404/87320)
\renewcommand\theHALG@line{\thealgorithm.\arabic{ALG@line}}

\RequirePackage[capitalize]{cleveref} % Better auto-reference-typing than \autoref{} (needs to go before \newtheorem environments but after listings)

% Misc Packages
\RequirePackage{booktabs}
\RequirePackage[mathscr]{eucal}
\RequirePackage{tikz}
\usetikzlibrary{shapes,arrows}

% Useful package for subfigures
\RequirePackage[hypcap]{subcaption}

% Place a Draft Watermark, if a draft document
\ifbool{@dft}{
  % \cofeAm{0.7}{0.75}{2}{0}{0}
  \RequirePackage[firstpage]{draftwatermark}
  \SetWatermarkScale{1} %Smaller numbers decrease the size of the text. Originally set to 6.
  \SetWatermarkLightness{0.7}
}

% Define Theorems and such
\newtheorem{proposition}{Proposition}[chapter]
\newtheorem{theorem}[proposition]{Theorem}
\newtheorem{lemma}[proposition]{Lemma}
\newtheorem{corollary}[proposition]{Corollary}
\newtheorem{conjecture}[proposition]{Conjecture}

% Define style for definitions, etc.
\theoremstyle{definition}
\newtheorem{example}[proposition]{Example}
\newtheorem{definition}[proposition]{Definition}
\newtheorem{remark}[proposition]{Remark}
%\newtheorem{algorithm}[proposition]{Algorithm}

\lstset{ % command to set programming language parameter(s)
  frame=single,
  showstringspaces=false,
  showlines=false, %get rid of trailing white lines
  emptylines=1, %allow blank line
  breaklines=true, %get rid of overflow lines and enter \n
  numbers=left, %line number
  numberstyle=\scriptsize, %make line numbers small
  stepnumber=1, %line number every line
  numbersep=5pt,
  tabsize=2, %set tabs to two spaces
  basicstyle=\ttfamily, % typewriter type for code
  keywordstyle=\bfseries, % green keywords
%  keepspaces, % So literate mappings don't gobble the following space
  literate= % For Isabelle notation
    {\\<times>}{$\times$}1
    {\\<open>}{\guilsinglleft}1
    {\\<close>}{\guilsinglright}1
    {\\<sigma>}{$\sigma$}1
    {\\<triangleq>}{$\triangleq$}1
    {\\<and>}{$\wedge$}1
    {\\<forall>}{$\forall$}1
    {\\<langle>}{$\langle$}1
    {\\<rangle>}{$\rangle$}1
    {\\<^sub>0}{$_0$}1
    {\\<longrightarrow>}{$\longrightarrow$}2
%    
    {P_123e}{${P_\mathtt{123e}}$}3
    {P_1246}{${P_\mathtt{1246}}$}3
}

% \author,\title are defined in book; here are the rest of the front matter defining macros:
\def\@degree{Doctor of Philosophy}
\def\@program{Mathematics}
\def\@institution{Virginia Polytechnic Institute and State University}
\def\@instaddress{Blacksburg, Virginia}
\def\@submitdate{\the\day \space \ifcase\the\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space \number\the\year}

\def\type#1{\gdef\@type{#1}}
\def\degree#1{\gdef\@degree{#1}}
\def\program#1{\gdef\@program{#1}}
\def\institution#1{\gdef\@institution{#1}}
\def\instaddress#1{\gdef\@instaddress{#1}}
\def\submitdate#1{\gdef\@submitdate{#1}}

\ifnum\month>9
    \@tempcnta=\year
    %\To advance the date by one year:
    %\advance\@tempcnta by 1
    \edef\@copyrightyear{\number\the\@tempcnta}
\else
    \def\@copyrightyear{\number\the\year}
\fi

%committee information
\newbool{@1st}
\boolfalse{@1st}
\newbool{@2nd}
\boolfalse{@2nd}
\newbool{@3rd}
\boolfalse{@3rd}
\newbool{@4th}
\boolfalse{@4th}
\newbool{@5th}
\boolfalse{@5th}
\newbool{@coad}
\boolfalse{@coad}
\def\@principaladvisor{}
\def\@coadvisor{}
\def\@firstreader{}
\def\@secondreader{}
\def\@thirdreader{}
\def\@fourthreader{}
\def\@fifthreader{}
\def\principaladvisor#1{\gdef\@principaladvisor{#1}}
\def\coadvisor#1{\booltrue{@coad} \gdef\@coadvisor{#1}}
\def\firstreader#1{\booltrue{@1st} \gdef\@firstreader{#1}}
\def\secondreader#1{\booltrue{@2nd} \gdef\@secondreader{#1}}
\def\thirdreader#1{\booltrue{@3rd} \gdef\@thirdreader{#1}}
\def\fourthreader#1{\booltrue{@4th} \gdef\@fourthreader{#1}}
\def\fifthreader#1{\booltrue{@5th} \gdef\@fifthreader{#1}}

%abstract, acknowledgements, dedication, and keywords setup
\def\@abstract{}
\def\@abstractgenaud{}
\def\@acknowledge{}
\def\@dedication{}
\def\@keywords{}
\newbool{@key}
\boolfalse{@key}
\newbool{@abs}
\boolfalse{@abs}
\newbool{@gaa}
\boolfalse{@gaa}
\newbool{@ack}
\boolfalse{@ack}
\newbool{@ded}
\boolfalse{@ded}
\def\abstract#1{\booltrue{@abs} \gdef\@abstract{#1}}
\def\abstractgenaud#1{\booltrue{@gaa} \gdef\@abstractgenaud{#1}}
\def\acknowledge#1{\booltrue{@ack} \gdef\@acknowledge{#1}}
\def\dedication#1{\booltrue{@ded} \gdef\@dedication{#1}}
\def\keywords#1{\booltrue{@key} \gdef\@keywords{#1}}

\newcommand\@vtcopyright{Copyright \@copyrightyear, \@author}

%% Set up the header and footer
\RequirePackage{fancyhdr}
\setlength\headheight{15pt}

% initial setup (trying to update the defaults on fancy itself didn't work, oh well))
\pagestyle{fancy}
\renewcommand\headrulewidth{0.0pt}

% Helpers
\newcommand*\fancydraft[1]{%
  \renewcommand\headrulewidth{0.0pt}%
  \ifbool{@dft}
    {#1[C]{\textbf{DRAFT}}}
    {#1[C]{}}}
\renewcommand\chaptermark[1]{\markboth{\chaptername\ \thechapter.\ #1}{}}
\renewcommand\sectionmark[1]{\markright{\thesection.\ #1}}

%%Revised frontmatter, mainmatter, and backmatter with nice formatting and nopgskip support
\fancypagestyle{front}{
  \fancyhf{}
  \fancydraft\fancyhead
  \fancyfoot[C]\thepage
}
\fancypagestyle{main}{
  \fancyhf{}
  \fancyhead[LE,RO]\thepage
  \fancyhead[RE]{\sc\leftmark}
  \fancyhead[LO]{\sc\rightmark}
  \fancydraft\fancyhead
}

\renewcommand\frontmatter{%
  \ifbool{@pgskip}\clearpage\cleardoublepage
  \@mainmatterfalse
  \pagenumbering{roman}%
  \pagestyle{front}%
}
\renewcommand\mainmatter{%
  \ifbool{@pgskip}\clearpage\cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}%
  \pagestyle{main}%
}
% probably good to use this in restricted environments, which I'm doing anyway because of the appendix
\apptocmd\backmatter{\let\MakeUppercase=\relax}{}{}

\newenvironment{frontpage}[1]{%
  \clearpage\thispagestyle{empty}%
  \addcontentsline{toc}{chapter}{#1}%
  \center%
}{\endcenter}
\newcommand\frontpagesimple[3]{\begin{frontpage}{#1}%
    {\Large \@title}
    \vfill
    \@author
    \vfill
    #2
  \end{frontpage}%
  #3
}

%Set up title page, abstract page, dedication page, and acknowledgement page
\def\titlepage{%
  \ifbool{@pgskip}{}\cleardoublepage%
  \newpage
  \thispagestyle{empty}%
  \setcounter{page}\@ne%
  \addcontentsline{toc}{chapter}{Title}%
  \begin{center}%
    {\Large \@title}
    \vfill
    \@author
    \vfill
    \ifbool{@proposal}{Thesis proposal for}
      {\ifbool{@prelim}
        {Preliminary Exam}
        {Dissertation submitted to the Faculty of the \\
          \@institution \\
          in partial fulfillment of the requirements for the degree of}%
      }
    \vfill
    \@degree \\
    in \\
    \@program
    \vfill
    \@principaladvisor, \ifbool{@coad}{Co-c}{C}hair \\
    \ifbool{@coad}{\@coadvisor, Co-chair\\}{}
    \ifbool{@1st}{\@firstreader\\}{}
    \ifbool{@2nd}{\@secondreader\\}{}
    \ifbool{@3rd}{\@thirdreader\\}{}
    \ifbool{@4th}{\@fourthreader\\}{}
    \ifbool{@5th}{\@fifthreader\\}{}
    \vfill
    \@submitdate \\
    \@instaddress
    \ifbool{@key}{\vfill
      Keywords: \@keywords}{}

    \@vtcopyright
  \end{center}
  \newpage%
  \if@twoside
    \ifbool{@pgskip}{\setcounter{page}\@ne}{}
  \else
    \setcounter{page}\@ne
  \fi
}

\def\dedpage{%
  \chapter{Dedication}
  \vspace*\fill
  \begin{center}%
    \emph\@dedication%
  \end{center}
  \vspace*\fill
}

%This is where the main magic happens
\renewcommand\maketitle{%
  \titlepage
  \ifbool{@abs}{\frontpagesimple{Abstract}{(ABSTRACT)}{\vfill\@abstract}}{}
  \ifbool{@gaa}{
    \frontpagesimple{General Audience Abstract}
    {(GENERAL AUDIENCE ABSTRACT)}
    {\vfill\@abstractgenaud}
  }{}
  \ifbool{@ded}\dedpage{}
  \ifbool{@ack}{\chapter{Acknowledgments}\@acknowledge}{}
}

% dunno if actually needed
%%%%%\patchcmd{\@makechapterhead}{\vspace*{50\p@}}{}{}{}  %% for numbered chapters \chapter{...}
%%%%%\patchcmd{\@makeschapterhead}{\vspace*{50\p@}}{}{}{} %% for unnumbered chapters \chapter*{...}
