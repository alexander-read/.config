% Semantics & Pragmatics style file.
% Kai von Fintel, Christopher Potts, and Chung-chieh Shan

\NeedsTeXFormat{LaTeX2e}[1994/06/01]
\ProvidesClass{sp}[2015/01/04 v.3.0 Class for Semantics & Pragmatics]

%====================================================================
%===================== release notes ================================

% 2015-01-02: v3.0, include expex option and footnote exx formatting

%======================= Outlinen ====================================
%====================================================================

% OUTLINE OF THIS CLASS FILE
%   option declarations
%   required packages
%   metadata
%   page dimensions
%   title
%   running headers
%   frontmatter
%   sectioning
%   footnotes
%   bibliography
%   backmatter
%   other environments
%   useful macros

%=====================================================================
%======================== option declarations ========================

% font selection
\newcount\@fontenum
% example-numbering packages
\newif\if@expex
\newif\if@linguex
% production settings
\newif\if@final

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\newcommand{\@sizeoption@err}{\ClassError{sp}
  {Cannot use size option \CurrentOption}
  {The S&P style requires (and automatically loads) 12pt text}}

\DeclareOption{11pt}{\@sizeoption@err}
\DeclareOption{11pt}{\@sizeoption@err}

% mutually exclusive font selection
\DeclareOption{cm}{\@fontenum=0}
\DeclareOption{times}{\@fontenum=1}
\DeclareOption{lucida}{\@fontenum=2}
\DeclareOption{lucidaot}{\@fontenum=3}
% example-numbering packages
\DeclareOption{expex}{\@expextrue}
\DeclareOption{linguex}{\@linguextrue}
% production settings
\DeclareOption{final}{\@finaltrue}

\ExecuteOptions{cm}
\ProcessOptions\relax
\LoadClass[12pt,twoside,openright]{article}

% amsmath must be loaded before unicode-math; might as well load it here
\RequirePackage[leqno,tbtags]{amsmath}

\RequirePackage{ifxetex}
% if 1) lucida is requested, and 2) lucimatx can't be found, and 3) we're using XeTeX,
% fall back to lucidaot with a warning
\ifnum \@fontenum = 2
  \IfFileExists{lucimatx.sty}{}{
    \ifxetex
      \ClassWarning{sp.cls}{Lucida requested but cannot find font; trying LucidaOT}
      \@fontenum=3
    \fi
  }
\fi

% Load fonts as indicated by \@fontenum setting.
\ifcase \@fontenum % 0 = cm
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage[scaled=0.8]{beramono}
\or % 2 = lucida
  \RequirePackage[romanfamily=bright-osf,scale=0.9,stdmathdigits=true]{lucimatx}
  \let\llbracket\ldbrack
  \let\rrbracket\rdbrack
  \DeclareTextCommand{\textbullet}{\encodingdefault}{\UseTextSymbol{OMS}\textbullet} % the default is tiny
  \DeclareMathSymbol{\nLeftrightarrow}{\mathrel}{arrows}{105} % the default, 103, is too short
\or % 3 = lucidaot
  \RequirePackage{fontspec}
  \RequirePackage{unicode-math}
  \defaultfontfeatures{Ligatures=TeX,Scale=0.94}
  % load Lucida font files from local directory if possible
  \IfFileExists{./fonts/LucidaBrightOT.otf}{
    \ClassInfo{sp.cls}{Loading LucidaOT files from local directory (./fonts/)}
    \defaultfontfeatures+{Path=./fonts/,Extension=.otf}
    % pre-configure the fonts for loading via their canonical / system name
    % by specifying the filenames for each Upright/Bold/Italic/BoldItalic variant
    \defaultfontfeatures[Lucida Bright OT]{
      UprightFont=LucidaBrightOT,
      BoldFont=LucidaBrightOT-Demi,
      ItalicFont=LucidaBrightOT-Italic,
      BoldItalicFont=LucidaBrightOT-DemiItalic}
    \defaultfontfeatures[Lucida Sans OT]{
      UprightFont=LucidaSansOT,
      BoldFont=LucidaSansOT-Demi,
      ItalicFont=LucidaSansOT-Italic,
      BoldItalicFont=LucidaSansOT-DemiItalic}
    \defaultfontfeatures[Lucida Sans Typewriter OT]{
      UprightFont=LucidaSansTypewriterOT-Bold,
      BoldFont=LucidaSansTypewriterOT-Bold,
      ItalicFont=LucidaSansTypewriterOT-Oblique,
      BoldItalicFont=LucidaSansTypewriterOT-BoldOblique}
    % there is no such pre-configuration implemented in unicode-math,
    % so \setmathfont must be called distinctly in each branch
    \setmathfont{LucidaBrightMathOT}
    \setmathfont{LucidaBrightMathOT-Demi}[version=bold]
  }{
    \ClassInfo{sp.cls}{Loading LucidaOT fonts from system}
    \setmathfont{Lucida Bright Math OT}
  }
  % load fonts using their canonical / system names
  \setmainfont{Lucida Bright OT}[Numbers=OldStyle]
  \setsansfont{Lucida Sans OT}
  \setmonofont{Lucida Sans Typewriter OT}
  % shim several math commands to approximate definitions in lucimatx.sty
  \def\llbracket{\symbol{"27E6}} % MATHEMATICAL LEFT WHITE SQUARE BRACKET
  \def\rrbracket{\symbol{"27E7}} % MATHEMATICAL RIGHT WHITE SQUARE BRACKET
  \def\leadsto{\symbol{"21DD}} % RIGHTWARDS SQUIGGLE ARROW
  \def\Join{\symbol{"22C8}} % BOWTIE
  \def\Box{\symbol{"25A1}} % WHITE SQUARE
  \def\Diamond{\symbol{"25C7}} % WHITE DIAMOND
  \def\ulcorner{\symbol{"23A1}} % LEFT SQUARE BRACKET UPPER CORNER
  \def\urcorner{\symbol{"23A4}} % RIGHT SQUARE BRACKET UPPER CORNER
\fi
\ifnum \@fontenum < 2
  % load shims for non-Lucida fonts (0 = cm and 1 = times)
  \IfFileExists{stmaryrd.sty}{\RequirePackage{stmaryrd}}{
    \ClassWarning{sp.cls}{stmaryrd required but not available; double brackets may be rendered incorrectly}
    \newcommand{\llbracket}{\ensuremath{\left [\!\left [}}
    \newcommand{\rrbracket}{\ensuremath{\right ]\!\right ]}}
  }
  \RequirePackage{textcomp}
  \RequirePackage{amssymb}
\else
  % load extras for Lucida fonts (2 = lucida and 3 = lucidaot)
  \linespread{1.05}
\fi

% Strong widow and orphan control

\clubpenalty10000
\widowpenalty10000

% French Spacing

\frenchspacing

%=====================================================================
%========================= required packages =========================
  \PassOptionsToPackage{dvipsnames,table,usenames}{xcolor}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[cal=cm, calscaled=.98]{mathalfa}
  \RequirePackage{appendix}
  \RequirePackage[normalem]{ulem}
  \renewcommand{\ULthickness}{1pt}
  \renewcommand{\ULdepth}{8pt}
  \renewcommand\refname{References.}
  \RequirePackage{setspace}
  %\onehalfspacing
  \DeclareUnicodeCharacter{2011}{\mbox{-}\nobreak\hskip\z@}
  \providecommand{\sv}[1]{\ensuremath{\llbracket{#1}\rrbracket}}
  \providecommand{\altsv}[1]{\ensuremath{\big\{\!\!\!\big\{{#1}\big\}\!\!\!\big\}}}
  \newcommand{\den}[2][]{\ensuremath{\llbracket \text{#2}\rrbracket^{#1}}}
  \newcommand{\tuple}[1]{\ensuremath{\left \langle #1 \right \rangle }}
  \newcommand{\type}[2]{\ensuremath{({#1} \to {#2})}}
  \newcommand\qquote[1]{\ulcorner#1\urcorner}
  \newcommand{\ltgt}[1]{\mathbin{<\mspace{-7mu}#1\mspace{-7mu}>}}
  \newcommand{\fmap}{\ltgt{\$}}
  \newcommand{\apply}{\circledast}
  \newcommand{\sect}{\begin{center}${\ast}\,{\ast}\,{\ast}$\end{center}}
  \DeclareSymbolFont{greekletters}{OML}{cmr}{m}{it}
  \DeclareMathSymbol{\varrho}{\mathalpha}{greekletters}{"25}
  \DeclareMathSymbol{\varsigma}{\mathalpha}{greekletters}{"26}
  \DeclareMathSymbol{\varphi}{\mathalpha}{greekletters}{"27}
  \RequirePackage[shortlabels]{enumitem}
  \RequirePackage[ddmmyyyy]{datetime}
  \RequirePackage{scrextend}
  \deffootnote{0em}{1.6em}{\thefootnotemark\enskip}
  \RequirePackage[splitrule]{footmisc}
  \RequirePackage{amsthm}
  \RequirePackage{fancyhdr}
  \RequirePackage{array}
  \RequirePackage{tikz}
  \RequirePackage{tikz-qtree,tikz-qtree-compat}
  \usetikzlibrary{fit}
  \tikzset{every tree node/.style={align=center, anchor=north}}
  \addtolength\abovecaptionskip{-18pt}
  \usetikzlibrary{arrows,positioning, patterns, shapes,fit,calc}
  \tikzset{
  box1/.style={draw=black, thick, rectangle,rounded corners, minimum height=2cm, minimum width=7cm}, box2/.style={draw=black, thick, rectangle, rounded corners, minimum height=2cm, minimum width=2.5cm}, box3/.style={draw=black, thick, rectangle, rounded corners, minimum height=4.2cm, minimum width=2.5cm}, modal/.style={>=stealth’,shorten >=1pt,shorten <=1pt,auto,node distance=1.5cm, semithick},
world/.style={circle,draw,minimum size=0.5cm,fill=gray!15}, point/.style={circle,draw,inner sep=0.5mm,fill=black},
reflexive above/.style={->,loop,looseness=7,in=120,out=60},
reflexive below/.style={->,loop,looseness=7,in=240,out=300},
reflexive left/.style={->,loop,looseness=7,in=150,out=210},
reflexive right/.style={->,loop,looseness=7,in=30,out=330}
}
\newcommand\round[2]{\par
    \noindent\begin{tikzpicture}%
        \node[draw = #1, fill = #1,rectangle,
              minimum size = 2.4mm,text = white,text width = 0.7cm](char){#2};
    \end{tikzpicture}%
}%
  \RequirePackage[euler]{textgreek}
  \RequirePackage{mathtools}
  \RequirePackage[framemethod=TikZ]{mdframed} % noteboxes, boxes, etc.
  \RequirePackage{titlesec, blindtext, color}
  \definecolor{gray78}{gray}{0.4}
  \newcommand{\hsp}{\hspace{8pt}}
  \newcommand\sqtag{\stepcounter{equation}\tag*{[\theequation]}}

\RequirePackage{xspace}
% microtype handles punctuation at the right margin. We want it for
% the final product, but it's okay if authors lack it.
\IfFileExists{microtype.sty}{%
  \RequirePackage[final,protrusion={true,compatibility}]{microtype}
}{}
\RequirePackage[hyphens]{url}

  \RequirePackage[round]{natbib}
  \setlength{\bibsep}{1pt}
  \setlength{\bibhang}{0.25in}
  \bibliographystyle{phil_review}
  \setcitestyle{notesep={: }}
  \newcommand{\posscitet}[1]{\citeauthor{#1}'s (\citeyear{#1})}
  \newcommand{\possciteauthor}[1]{\citeauthor{#1}'s}
  \newcommand{\pgposscitet}[2]{\citeauthor{#1}'s (\citeyear{#1}:~#2)}
  \newcommand{\secposscitet}[2]{\citeauthor{#1}'s (\citeyear{#1}:~$\S$#2)}
  \newcommand{\pgcitealt}[2]{\citealt{#1}:~#2}
  \newcommand{\seccitealt}[2]{\citealt{#1}:~$\S$#2}
  \newcommand{\pgcitep}[2]{(\citealt{#1}:~#2)}
  \newcommand{\seccitep}[2]{(\citealt{#1}:~$\S$#2)}
  \newcommand{\pgcitet}[2]{\citeauthor{#1} (\citeyear{#1}:~#2)}
  \newcommand{\seccitet}[2]{\citeauthor{#1} (\citeyear{#1}:~$\S$#2)}
  
\RequirePackage{verbatim,color}
\RequirePackage{listings}
\definecolor{functions}{HTML}{384770}      	%POLAR
\definecolor{typeclasses}{HTML}{A84F58}       	%PINK
\definecolor{types}{HTML}{A93A45}             	%RUBY
\definecolor{keywords}{HTML}{97A60B}          	%LIME
\definecolor{variables}{HTML}{4D0000}            	%BROWN
\definecolor{valueconstructor}{HTML}{2D6326} 	%GREEN
\definecolor{mathoperators}{HTML}{0707C0}	%GALAXY
\definecolor{prog}{HTML}{234491}
\definecolor{polar}{HTML}{2E3440}
\definecolor{mypurple}{HTML}{8000FF}
\definecolor{backcolour}{HTML}{FFFFFF}
\lstdefinelanguage{Haskell}{
  basicstyle=\ttfamily,
  sensitive=true,
  mathescape=true,
  stringstyle=\color{mybrown},
  escapebegin=\color{mathoperators},
  showstringspaces=false,
  commentstyle=\ttfamily,
  numberstyle=\tiny,
  showspaces=false,
  texcl=true,
  tabsize=4,
  escapeinside={(@}{@)},
	breaklines=true,
	showtabs=false,
	emph=
	{[1]
FilePath,IOError,abs,add,addVectors,all,allprimes,and,any,ap,area,bmiTell,calcBmis,ceiling,chr,compare,concat,concatMap,const,cos,curry,cycle,cylinder,describeList,digitToInt,div,divMod,drop,dropWhile,doubler,either,elem,error,even,exp,exponent,f,factorial,factors,fail,fibonacci,fibSequence,filter,find,flatten,flip,floor,fmap,foldl,foldl1,foldr,foldr1,foo,fromDouble,fromEnum,fromInt,fromInteger,fromIntegral,fromRational,fst,g,gcd,getChar,h,hailstone,hanoi,head,id,inRange,index,init,initials,intListLength,intToDigit,interact,ioError,iterate,last,lcm,length,len,lex,lucky,map,mapM,mapM_,max,maxBound,maximum,maybe,min,mod,myCompare,negate,not,notElem,null,nums,occurs,odd,or,ord,otherwise,pairUp,palindrome,pi,pred,prime,primes,print,product,pure,putChar,putStr,putStrLn,quot,quotRem,range,range2,rangeSize,read,readFile,readFloat,readIO,readInt,readList,readLitChar,readLn,repeat,replicate,return,reverse,round,safediv,safehead,safeTail,scalarProduct,scanl,scanl1,scanr,scanr1,seq,sequence,sequence_,show,showChar,showInt,showList,showLitChar,showParen,showSigned,showString,shows,showsPrec,sieve,significand,signum,sin,sinh,snd,span,splitAt,sqrt,subtract,succ,sum,sumPair,sumtorial,tail,take,takeWhile,tan,tanh,tell,thrd,toEnum,toInt,toInteger,toLower,toRational,toUpper,transpose,tree1,truncate,twice,uncurry,undefined,until,unzip,unzip3,userError,words,writeFile,zapp,zip,zip3,zipWith,zipWith3,listArray,doParse,quot,rem,div,mod,elem,notElem,seq,nat2Int,int2Nat
	},emphstyle={[1]\color{functions}},
  emph=
	{[2]
  Bool,Char,Double,Either,Float,IO,Integer,Int,Maybe,Ordering,Rational,Ratio,ReadS,ShowS,String,
  Peg,Move,Nat,List,Tree,Shape,Assoc,Pos,Trans
	},emphstyle={[2]\color{types}\textbf},
	emph=
	{[3]
	case,class,data,deriving,do,else,if,import,in,infixl,infixr,instance,let,
	module,of,primitive,then,type,newtype,where,family,instance
	},emphstyle={[3]\color{keywords}\textbf},
	emph=
	{[4]
	a,as,b,bs,c,cs,d,k,m,n,ns,nss,p,ps,t,u,v,w,x,xs,xss,y,ys,yss,z,zs,zss
	},emphstyle={[4]\color{variables}},
	emph=
	{[5]
	EQ,GT,LT,Show,Eq,Ord,Num,Integral,RealFloat,Read,Monad,Functor,Foldable
	},emphstyle={[5]\color{typeclasses}\textbf},
  emph=
  {[6]
	Nil,Cons,Zero,Succ,Leaf,Node,Just,Nothing,True,False,Circle,Rectangle
	},emphstyle={[6]\color{valueconstructor}},
  literate={::}{{{\color{mypurple}::}}}2 {==}{{{\color{mypurple}==}}}2 {>}{{{\color{mypurple}>}}}2 {<}{{{\color{mypurple}<}}}2 {>=}{{{\color{mypurple}>=}}}2 {<=}{{{\color{mypurple}<=}}}2 {/=}{{{\color{mypurple}/=}}}2 {+}{{{\color{mypurple}+}}}2 {*}{{{\color{mypurple}*}}}2 {<*>}{{{\color{mypurple}<*>}}}2 {[}{{{\color{polar}[}}}1 {]}{{{\color{polar}]}}}1
  }
\lstset{language=Haskell}

\RequirePackage[usenames,dvipsnames,table]{xcolor}
\definecolor{slinkcolor}{HTML}{123693}
\definecolor{dml}{HTML}{173A66}
\definecolor{library}{HTML}{551257}
\definecolor{amaranth}{rgb}{0.9, 0.17, 0.31}
\definecolor{razzmatazz}{rgb}{0.89, 0.15, 0.42}
\RequirePackage[colorlinks,breaklinks,
                linkcolor=dml,
                urlcolor=dml,
                citecolor=slinkcolor,
                filecolor=slinkcolor,
                plainpages=false,
                pdfpagelabels,
                bookmarks=false,
                pdfstartview=FitH]{hyperref}

%=====================================================================
%============================= metadata ==============================

\def\@pdfauthor{\relax}
\newcommand{\pdfauthor}[1]{\gdef\@pdfauthor{#1}}
\def\@pdftitle{\relax}
\newcommand{\pdftitle}[1]{\gdef\@pdftitle{#1}}
\def\@pdfkeywords{\relax}
\newcommand{\pdfkeywords}[1]{\gdef\@pdfkeywords{#1}}

\hypersetup{pdfauthor=\@pdfauthor,
            pdftitle=\@pdftitle,
            pdfkeywords=\@pdfkeywords}

\def\@spvolume{}
\newcommand{\spvolume}[1]{\gdef\@spvolume{#1}}

\def\@sparticle{}
\newcommand{\sparticle}[1]{\gdef\@sparticle{#1}}

\def\@spyear{}
\newcommand{\spyear}[1]{\gdef\@spyear{#1}}

\def\@spdoi{10.3765/sp.\@spvolume.\@sparticle}

\def\@splastpage{}
\newcommand{\splastpage}[1]{\gdef\@splastpage{#1}}

\def\@copyrightowner{\@shortauthor}
\newcommand{\copyrightowner}[1]{\gdef\@copyrightowner{#1}}

%=====================================================================
%========================== page dimensions ==========================

 %Vertical.
\paperheight=11in
\topmargin=0in     %
\headheight=0.3in  % head: 1.5in (margin + head + sep = .5; latex adds 1in)
\headsep=0.3in     %
\topskip=0.1in     % included in the textheight
\textheight=8in    % text is 8in
\footskip=0.5in    % foot: 1.5in (.5 + 1.0in leftover)
\parskip=0pt

 %Horizontal.
\paperwidth=8.5in
\textwidth=6.5in
\oddsidemargin=0.02in  % 1.5in due to LaTeX's calculations
\evensidemargin=0.14in % 1.5in due to LaTeX's calculations
\raggedbottom % constant spacing in the text; cost is a ragged bottom
\parindent=0.25in
\leftmargini=0.5in
\@ifundefined{mathindent}{}{\mathindent=0.5in\relax}%

% Tell dvips about our paper.
\special{papersize=8.5in,11in}
%=====================================================================
%============================== title ================================

% Formats individual <name--institute> pairs inside \author.
\newcommand{\spauthor}[1]{%
  \begin{minipage}[t]{16pc}\centering #1\end{minipage}\hspace{.5pc plus1pc}%
  \ignorespaces
}

\renewcommand*{\title}[2][]{\gdef\@shorttitle{#1}\gdef\@title{#2}}
\renewcommand*{\author}[2][]{\gdef\@shortauthor{#1}\gdef\@author{#2}}

% Adapted from JMLR.
\renewcommand{\maketitle}{%
  \par
  \begingroup
  \renewcommand{\thefootnote}{\fnsymbol{footnote}}
  \@maketitle\@thanks
  \setcounter{footnote}{0}
  \endgroup
  \let\maketitle\relax \let\@maketitle\relax
  \gdef\@thanks{}
  \let\thanks\relax%
}

% From salt.cls.
\newskip\onelineskip
\onelineskip=\baselineskip
\advance\onelineskip by0pt plus 4pt minus 2pt

\def\@maketitle{%
  \vbox{\hsize\textwidth%
    \linewidth\hsize%
    \centering
    \vskip\onelineskip
    \Large{\@title}\@@par
    \normalsize
    \def\institute{\textit}%
    \newcommand{\AND}{\ignorespaces}%
    \let\par\@empty
    \@author
    \lineskiplimit\onelineskip
    \lineskip\onelineskip
    \@@par
  }%
  \global\everypar{\everypar{}\vskip 3.5ex}
}

%=====================================================================
%========================== running headers ==========================

\pagestyle{fancy}
\fancyhead{}
\renewcommand{\headrulewidth}{0pt}
\fancyfoot[R]{\fontsize{10}{13}\texttt{\today}}
\fancyfoot[C]{\thepage}

%=====================================================================
%=========================== final typeset ===========================


\if@final
  % load global variables into metadata
  \RequirePackage{sp-hyperxmp}
  \thispagestyle{spfirstheadings}
\else
  \thispagestyle{empty}
\fi


%=====================================================================
%=========================== frontmatter =============================

% The spacing specs (arg 2 of \list) are the same for the mshistory,
% abstract, and keywords environments, except that the abstract is
% indented somewhat.

% Single parameter determines the left and right margin size.
\newcommand{\frontmatterspacing}[1]{%
  \small
  \topsep 10\p@ \@plus4\p@   \@minus6\p@ % from size12.clo
  \advance\topsep by3.5ex plus -1ex minus -.2ex
  \setlength{\listparindent}{0em}
  \setlength{\itemindent}{0em}
  \setlength{\leftmargin}{#1}
  \setlength{\rightmargin}{\leftmargin}
  \setlength{\parskip}{0em}
}

\newenvironment{mshistory}%
{\list{}{\frontmatterspacing{0em}}%
\item\relax}%
{\endlist}

% \ignorespacesandpars inspired by http://tex.stackexchange.com/a/179034/3642
\def\ignorespacesandpars{%
  \@ifnextchar\par{\expandafter\ignorespacesandpars\@gobble}{\ignorespaces}}

\renewenvironment{abstract}%
{\list{}{\frontmatterspacing{0.25in}}%
\item\relax\textbf{\abstractname}~~\ignorespacesandpars}%
{\endlist}

\newenvironment{keywords}%
{\list{}{\frontmatterspacing{0em}}%
\item\relax\textbf{Keywords:}}%
{\endlist}

%=====================================================================
%============================ sectioning =============================
 	
\titleformat{\section}[hang]{\bfseries\family}{\thesection\hsp\textcolor{gray78}{|}\hsp}{0pt}{\bfseries\family}

\titleformat{\subsection}[hang]{\bfseries}{\thesubsection\hsp\textcolor{gray78}{|}\hsp}{0pt}{\bfseries}

\titleformat{\subsubsection}[hang]{\bfseries}{\thesubsubsection\hsp\textcolor{gray78}{|}\hsp}{0pt}{\bfseries}

% General formatting --- for punctuating section headings.

\renewcommand{\@seccntformat}[1]{\@nameuse{the#1}\hspace{1em}}

%=====================================================================
%============================ footnotes ==============================

\renewcommand{\@makefntext}[1]{%
  \parindent=0.25in
  \noindent \hbox to \z@{\hss{\@thefnmark} \hfil}#1}

%=================
