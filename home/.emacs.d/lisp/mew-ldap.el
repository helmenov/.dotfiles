;; mew-ldap.el -- LDAP support for Mew addrbook.

;; Copyright (C) 2000 Shun-ichi GOTO

;; Author: Shun-ichi GOTO <gotoh@taiyo.co.jp>,
;;         Shun-ichi TAHARA ($BED86(B $B=S0l(B) <jado@flowernet.gr.jp>
;; Created: Fri Jun 09 22:42:54 2000
;; Version: $Revision: 1.35 $
;; Keywords: mail, mew, ldap

;;; Commentary:

;;; $B$O$8$a$K(B ---------------------------------------------------------

;; $BK\%Q%C%1!<%8$O(BMew$B$G$N(Bdraft mode$B$G$N%"%I%l%9Jd40$N:]$K!"(BLDAP$B%5!<%P$X(B
;; $B$NLd$$9g$o$;$H$=$N7k2L$NMxMQ$,$G$-$k$h$&$K$9$k$?$a$N%Q%C%1!<%8$G$9!#(B
;; $B0J2<$K>\:Y$r=R$Y$k$,!"4JC1$KMxMQ$9$k$?$a$K$O<!@a$N!V%$%s%9%H!<%k!W(B
;; $B$*$h$S!V;HMQJ}K!!W$r;2>H$7$F2<$5$$!#(B


;;; $B%$%s%9%H!<%k(B -----------------------------------------------------

;; $B$^$:(Bldapsearch $B%W%m%0%i%`$rF~<j$7$^$9!#$3$l$OI,?\$G$9!#(B

;; UNIX$B4D6-$G$"$l$P!"(BOpenLDAP$B$r%$%s%9%H!<%k$9$k$3$H$G$=$N%/%i%$%"%s%H(B
;; $B%W%m%0%i%`$H$7$F(Bldapsearch$B$,MxMQ2DG=$K$J$j$^$9!#(BWin32$B4D6-$G$"$l$P!"(B
;; Netscape$B$+$iDs6!$5$l$F$$$k(B Netscape Directory SDK $B$K(Bldapsearch.exe 
;; $B$,4^$^$l$F$$$^$9!#$3$l$i$O0J2<$N%"%I%l%9$+$iF~<j2DG=$G$9!#(B

;; OpenLDAP                http://www.openldap.org/
;; $B%_%7%,%sBg3X$N(BLDAP      http://www.umich.edu/~dirsvcs/ldap/ldap.html
;; Netscape Directory SDK  http://developer.netscape.com/tech/directory/

;; $B$^$?!"(BLotus Note 5 $B$K$b(Bldapsearch.exe$B$,IUB0$7$F$$$k$N$G!"(BLotus
;; Notes 5 client$B$r%$%s%9%H!<%k$7$F$$$k?M$O$3$l$,MxMQ$G$-$k$O$:(B($B$1$IL$(B
;; $B%F%9%H(B)$B!#(BLotus Notes $B%5!<%P$OE,@Z$K@_Dj$9$k$3$H$G(BLDAP$B%5!<%P$H$7$FMx(B
;; $BMQ2DG=$K$J$j$^$9!#(B

;; $B$=$N$[$+!"L$3NG'$G$9$,(BMicrosoft Exchange Server$B$b$^$?(BLDAP$B%5!<%P$H$J(B
;; $B$j$^$9$N$G!"$=$N%/%i%$%"%s%H%W%m%0%i%`$H$7$F(Bldapsearch.exe$BAjEv$,MQ(B
;; $B0U$5$l$F$$$k$+$b$7$l$^$;$s!#(B

;; Emacs$B$KBP$9$k@_Dj$O0J2<$N$h$&$K9T$$$^$9!#(B
;; $B4pK\E*$K$OK\%Q%C%1!<%8$r%m!<%I$7!"(BLDAP$B%5!<%PL>$r;XDj$9$k$@$1$G$9!#(B

;; ~/.mew $B$K0J2<$N$h$&$J5-=R$r2C$($^$9!#(B
;; (load "mew-ldap")
;; (setq mew-ldap-server "ldap-server.host.domain")
;; (define-key mew-draft-header-map "\C-i" 'mew-ldap-header-comp)
;; (define-key mew-header-mode-map "\C-i" 'mew-ldap-header-comp)

;; $B$^$?(BLDAP$B$X$NLd$$9g$o$;$r>o$K9T$$$?$$>l9g$O(B(setq mew-ldap-use t) $B$H(B
;; $B$$$&5-=R$b2C$($^$7$g$&!#%G%U%)%k%H$G$O$3$NCM$O(Bnil$B$G$9!#(B(mew-ldap.el
;; 1.19 $B$+$i$NJQ99(B)

;; Mew$B$N%"%I%l%9Jd40$OA0J}0lCW$G9T$J$o$l$k$?$a!"%G%U%)%k%H$G$O(BLDAP$B8!:w(B
;; $B$K$D$$$F$bA0J}0lCW$G9T$J$o$l$^$9!#0J2<$N@_Dj$K$h$j!"(BLDAP$B8!:w$rItJ,(B
;; $B0lCW8!:w$K$9$k$3$H$,$G$-$^$9!#(B
;;
;; (setq mew-ldap-use-substring-search t)

;; UTF-8$B$N;HMQ$G$-$k4D6-(B(Emacs-20.6 + mule-ucs$B$J$I(B)$B$G$O!"0J2<$N@_Dj$K(B
;; $B$h$j!"%m!<%+%k8@8l(B($BNc$($PF|K\8l(B)$B$NL>A0(B(cn)$B$rMxMQ$G$-$^$9!#(B
;; (setq mew-ldap-use-local-lang-value t)
;; $B$3$NCM$N%G%U%)%k%H$O(Bnil$B$G$9!#(B

;; $B$=$NB>!">l9g$K$h$C$F$O(B mew-ldap-search-base $B$r;XDj$9$kI,MW$,$"$k$+(B
;; $B$bCN$l$^$;$s!#$3$l$O;HMQ$7$F$$$k(BLDAP$B%5!<%P$N%G!<%?$N8!:w4pE@$r;XDj(B
;; $B$9$k$b$N$G!"8!:wHO0O$r69$a$?$$>l9g$J$I$K;HMQ$7$^$9!#I.<T$N%F%9%H4D(B
;; $B6-$N(BLDAP$B%5!<%P(B(Notes 4.5)$B$O$3$N$"$?$j$,$"$$$^$$$G$b$&$^$/$$$C$F$$$^(B
;; $B$9$,!"%$%s%?!<%M%C%H>e$N%G%#%l%/%H%j%5!<%S%9(B(Netscape $B$d(B Bigfoot$B$J(B
;; $B$I(B)$B$G$O!"E,@Z$K@_Dj$9$kI,MW$,$"$k$+$b$7$l$^$;$s!#(B


;;; $B;HMQJ}K!(B ---------------------------------------------------------

;; $B;H$$7?$O4pK\E*$K$O(BMew $B$N(Bdraft mode $B$G$NJd40(B/$BE83+A`:n$H0l=o$G$9!#0c(B
;; $B$$$O@h$N@_Dj$K$h$k(BTAB $B%-!<$N5!G=$G$9!#Jd40$N:]$KC1$K(BTAB$B%-!<$r;H$&$H(B
;; Mew $B$N;}$DDL>o$N5!G=$GJd40$,9T$J$o$l!"(BLDAP$B8!:w$O9T$J$o$l$^$;$s$,!"(B
;; C-u $B%W%j%U%#%C%/%9$r$D$1$F(B C-u TAB $B$H$9$k;v$K$h$j(BLDAP$B8!:w$N7k2L$r2C(B
;; $B$($?Jd40$,9T$($^$9!#0lEY8!:w$7$?7k2L$O%-%c%C%7%e$KF~$j:FMxMQ$5$l$k(B
;; $B$N$G!"B3$$$F%W%j%U%#%C%/%9L5$7$G(BTAB $B%-!<$K$h$kJd40$r9T$J$C$F$b!"Jd(B
;; $B40J8;zNs$,A02s$N8!:w$N%5%V%;%C%H$H$J$k$h$&$J>l9g$O9bB.$JF0:n$,4|BT(B
;; $B$G$-$^$9!#(B

;; $BNc$($PI.<T$N4D6-$G$O!"%"%I%l%9ItJ,$K(B "go" $B$HF~NO$7$F(BC-u TAB $B$r<B9T(B
;; $B$9$k$H!"0J2<$N$h$&$J8uJd$,8=$l$^$9!#(B
;;
;; Possible completions are:
;; gotoh/Shunichi_Goto		   Goto/Shunichi_Goto
;; Goto/Norikazu_Goto		   gotoh/IMASY
;; gotoh/TAIYO			   gotoh
;; gotonya
;;
;; $B$3$l$O(Bldapsearch $B$r;HMQ$7$?8!:w$,9T$J$o$l7k2L$H(BMew $B$N%"%I%l%9D"$KEP(B
;; $BO?$5$l$F$$$k>pJs$NN>J}$+$i$N8uJd$G$9!#$=$7$F8uJd$H$7$F(B"goto"$B$^$G$,(B
;; $B:GBg0lCW$9$k$?$a!"%"%I%l%9Ms$K$O(B"goto" $B$^$G$,Jd40$5$l$?>uBV$H$J$j$^(B
;; $B$9!#(B
;;
;; $B$=$3$GB3$1$F(B"/"$B$HF~NO$7!"(B"gotoh/" $B$N>uBV$G!":#EY$O%W%j%U%#%C%/%9L5(B
;; $B$7$G(BTAB$B$rBG$D$H0J2<$N$h$&$K(B2$B$D$K9J$j9~$^$l$^$9!#$3$N;~(BLDAP$B8!:w$O9T(B
;; $B$J$o$l$F$$$^$;$s!#@h$N8!:w7k2L$r:FMxMQ$7$F$$$^$9!#(B
;;
;; Possible completions are:
;; Goto/Shunichi_Goto		   Goto/Norikazu_Goto
;;
;; $B99$K(B"s" $B$HB3$1$F$+$i(BTAB$B$rBG$D$H8uJd$O(B1$B$D$H$J$j!"%"%I%l%9Ms$O(B
;; "Goto/Shunichi_Goto" $B$KJd40$5$l!"8uJd%&%#%s%I%&$O>C$($^$9!#(B
;; "Goto/Shunichi_Goto" $B$H$$$&J8;zNs$O(BMew $B$N%"%I%l%9D"$N%(%$%j%"%9L>$H(B
;; $BF1Ey$G$9!#$7$?$,$C$F$b$&0lEY(BTAB$B$r2!$9$H(B "gotoh@taiyo.co.jp" $B$H!"<B(B
;; $B%"%I%l%9$KE83+$5$l$^$9!#(B
;;
;; $B$^$?$5$i$K(BM-TAB $B$r2!$9$H!"(BLDAP $B$+$iF@$?%f!<%6L>>pJs$bIU2C$7$F!"(B
;; "Shunichi Goto <gotoh@taiyo.co.jp>" $B$KE83+$5$l$^$9!#(B
;;
;; $B7k6I!"(BC-u TAB $B$K$h$C$FL@<(E*$K(BLDAP$B8!:w$r9T$J$o$;$k!"$H$$$&$3$H0J30(B
;; $B$ODL>o$N(BMew $B$G$NJd40(B/$BE83+F0:n$HF10l$G$9!#4JC1$G$7$g!#(B


;;; $B@)8B(B -------------------------------------------------------------

;; * $B8=%P!<%8%g%s$G$O!"1Q8l0J30$N8@8l(B($BF|K\8lEy(B)$B$G$N8!:w$O%5%]!<%H$7$F(B
;;   $B$$$^$;$s!#(B

;; * $BK\%Q%C%1!<%8$O(Bldapsearch $B$H$$$&30It%W%m%0%i%`$KMj$C$F$$$k$?$a!"$3(B
;;   $B$N%W%m%0%i%`$N%P!<%8%g%s$J$I$K$h$j!"$&$^$/F0:n$7$J$$$3$H$,$"$k$+(B
;;   $B$b$7$l$^$;$s!#%F%9%H$O%5!<%P$H$7$F(BNotes 4.5 (on WinNT 4.0 Server)$B!"(B
;;   $B%/%i%$%"%s%H$O(B UNIX$B4D6-$G$O(BOpenLDAP$B$N(Bldapsearch$B$r!"(BWin32$B4D6-$G$O(B
;;   Netscape Directory SDK$B$N(Bldapsearch.exe$B$r;HMQ$7$^$7$?!#(B

;; * $B8=%P!<%8%g%s$G$OG'>ZL5$7$G$N@\B3$7$+%5%]!<%H$7$F$$$^$;$s(B(TODO)$B!#(B

;; $B0J>e!"$*3Z$7$_$"$l!#(B


;;; $B>\:Y(B =============================================================

;;; LDAP$B%G!<%?$H(BMew$B$N%"%I%l%9%G!<%?$N@09g(B ----------------------------

;; Mew$B$N%"%I%l%9Jd40$O2?CJ3,$+$KJ,$+$l$F$$$k!#Bh0lCJ3,$OF~NO$5$l$?ItJ,(B
;; $BJ8;zNs$r(Balias$BJ8;zNs$H$7$FJd40$9$k$&!#(Balias$B$H$7$F40A40lCW$7$?>l9g$O(B
;; $B$3$l$r%"%I%l%9(B($B72(B)$B$KCV$-49$($k!#$=$N8e!"(BC-M-TAB$BA`:n$K$h$j(Bname+addr 
;; $B$N7A<0$KE83+$9$k!#$3$l$i$rF'$^$($?>e$G!"(BLDAP$B$+$iF@$?%G!<%?$r(BMew$B$NOH(B
;; $BAH$_$KF~$l$k$9$Y$r9M$($k!#$^$::G=i$K(Balias$B$KAjEv$9$kJ*$rMQ0U$9$kI,MW(B
;; $B$,$"$k$,!"(BLDAP$B$N%G!<%?$K$OE,Ev$JB0@-$O$J$$!#(Balias$B$O0l0U$G$"$k$H$$$&(B
;; $B0UL#$G$O(Bdn$B$,$"$2$i$l$k$,!"$3$N(Bdn$B$NFbMF$O0J2<$N$h$&$J$b$N$G$"$j!"$=(B
;; $B$N$^$^(Balias $BJ8;zNs$H$7$F$O>iD9$G$"$j;HMQ$9$k$o$1$K$O$$$+$J$$!#(B

;; dn: CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=Lisper,O=Programmers Inc.

;; $B$^$?!"Jd40$OL>;z!"L>A0!"%a!<%k%"%I%l%9$J$I$KBP$7$F9T$($k$3$H$,K>$^(B
;; $B$7$$!#$=$3$G!"(BLDAP$B$KBP$7$F8!:wBP>]$H$J$kB0@-$rJ#?tDj5A$G$-$k$h$&$K(B
;; $B$7!"(BQUERY$B$N7k2L$r=&$&:]$K%^%C%A$7$?B0@-$NCM$r;HMQ$9$k!#$?$@$7$3$l$@(B
;; $B$1$G$O!"0l0U@-$rJ]$F$J$$(B($B$?$H$($P(Bsn$B$K(BGoto$B$r;}$D%f!<%6$,B??t%^%C%A$7(B
;; $B$F$7$^$&(B)$B$?$a!"$=$l$i$r6hJL$9$k$?$a$K(Bcn$B$N>pJs$rIU2C$7$F6hJL$G$-$k$h(B
;; $B$&$K$9$k!#$?$H$($P(B"miy"$B$G8!:w$7$?>l9g$N7k2L$H$7$F!"(Bsn$B$G$O(BTarou
;; Miyoshi <tmiyoshi@domain>$B$5$s$H(B Kenta Miyajima <kmiyajima@domain>$B$,(B
;; $B%^%C%A!"(Bmail$B$G(BMiyoko Yamada <miyoko@domain> $B$H(B Yasuo Mikawa
;; <miya@domain> $B$,%^%C%A$7$?$H$9$k!#$3$l$i$N7k2L$KBP$7$F(Bcn$B$rIU$12C$((B
;; $B$k$3$H$G(Balias $BAjEv$r:n$k$H$3$&$J$k!#(B

;; Miyajima/Kenta_Miyajima
;; Miyoshi/Tarou_Miyoshi
;; Miyoko_Yamada
;; miya/Yasuo_Miyata

;; $B>/$7IU$12C$($k$H!">e5-$NNc$G$O>/$7FC<l$J=hM}$,;\$5$l$F$$$k!#$H$$$&(B
;; $B$N$O(BMew$B$N(Balias$B$H$7$F#18l$K$J$k$?$a$K$O!V6uGr(B/$B%?%V$O;HMQ$G$-$J$$!W!"(B
;; $B!V(B"@" $B$r4^$`$3$H$O$G$-$J$$!W$H$$$&>r7o$,$"$k$?$a!"$=$l$i$r9MN8$7$?(B
;; $B$b$N$H$J$C$F$$$k!#$?$H$($P(B"/"$B$KB3$/(Bfull-name(cn)$B$O(BFirst-name $B$H(B
;; Last-name $B$r6h@Z$k6uGr$,(B"_"$B$KCV$-49$o$C$F$$$k!#$^$?!"(B
;; miya/Yasuo_Miyata $B$OK\Mh$O(Bmiya@domain/Yasuo_Miyata $B$H$J$k$H$3$m$r!"(B
;; $B%a!<%k%"%I%l%9$N%I%a%$%sItJ,$r<h$j=|$$$F$$$"$k!#$b$&$R$H$D!"(B
;; Miyoko_Yamada$B$O(Bcn$B$=$N$b$N$K%^%C%A$7$?$,!"$=$N$^$^$@$H(B
;; Miyoko_Yamada/Miyoko_Yamada$B$H$J$j!"F1$88@MU$,O"$J$k$?$a!"8eB3$N(Bcn$B$N(B
;; $BIU2C$O>JN,$7$?!#(B

;; $B>e5-$NNc$G$O$[$\0l0U@-$,J]$F$F$$$k$,!"F1@+F1L>$N?M4V$,$$$k>l9g$K$O(B
;; $B0l0U@-$O4JC1$KJx$l$k!#$=$N$?$a(Bcn$B$rIU2C$9$k$N$G$O$J$/!"(Bdn$B$N3FMWAG$r(B
;; $BIU2C$9$k$3$H$H$9$k!#$7$+$7!"(Bdn$B$NA4MWAG$rC1=c$KIU2C$7$?$N$G$O>iD9$J(B
;; $BD9$$(Balias$BL>$H$J$C$F$7$^$&$?$a!"8uJd$K>e$,$C$?$b$N$NCf$G0l0U@-$,3NJ](B
;; $B$G$-$k:G>.$ND9$5$r5a$a$J$,$i(Bdn$B$NMWAG$r=g<!IU2C$7$F$$$/$3$H$H$9$k!#(B
;; $B6qBNE*$JNc$r0J2<$K$"$2$k!#0J2<$O#3$D$N%;%/%7%g%s(B($B?&>l(B/$B=jB0(B)$B$K$$$kF1(B
;; $B@+F1L>$N(BShunichi Goto$B$5$s$N(Bdn$B$G$"$k!#(B

;; dn: CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=Lisper,O=Programmers Inc.
;; dn: CN=Shun-ichi GOTO,OU=MUE,OU=Emacs,OU=Lisper,O=Programmers Inc.
;; dn: CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=User,O=Programmers Inc.

;; dn$B$O(B($BDL>o(B)$BAH?%9=B$$r$"$i$o$7$F$$$k$?$a!"$3$l$i$r:8$NMWAG$+$i0l0U@-(B
;; $B$rJ]$A$J$,$i=g$KIU2C$7$F$$$/$H!"<!$N$h$&$J7k2L$rF@$k!#(B

;; Shun-ichi GOTO/Mew/Emacs/Lisper
;; Shun-ichi GOTO/MUE
;; Shun-ichi GOTO/Mew/Emacs/User

;; $B$3$N$h$&$J!"(Bdn$B$+$i0l0U@-$N$"$kJ8;zNs$r:n@.$9$k=hM}$O!"%O%C%7%e$rMQ$$$?(B
;; mew-ldap-register-uniq-dn $B4X?t$K$F9T$C$F$$$k!#(B
;; $B>e5-7k2L$O0J2<$N%F%9%H%3!<%I$K$F3NG'$7$?!#(B

;; (let ((hash (make-vector 11 0))
;;       (dnl '(
;; 	     "CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=Lisper,O=Programmers Inc."
;; 	     "CN=Shun-ichi GOTO,OU=MUE,OU=Emacs,OU=Lisper,O=Programmers Inc."
;; 	     "CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=User,O=Programmers Inc."
;; 	     ))
;;       result)
;;     (while dnl
;;       (mew-ldap-register-uniq-dn hash (car dnl))
;;       (setq dnl (cdr dnl)))
;;     (mapatoms '(lambda (x)
;; 		 (if (and x (boundp x) (stringp (symbol-value x)))
;; 		     (setq result (cons (cons (symbol-name x)
;; 					      (symbol-value x))
;; 					result))))
;; 	      hash)
;;     (pp result (current-buffer)))

;; $B$J$*!"(Bmew-ldap-use-substring-search$B$r%;%C%H$7$FItJ,0lCW8!:w$K$h$kJd(B
;; $B40$r;HMQ$7$F$$$k>l9g!"(Balias$B$N@hF,$KMh$k$N$O%^%C%A$7$?B0@-$=$N$b$N$G(B
;; $B$O$J$/!"$=$NB0@-$NCf$N8!:wJ8;zNs$K%^%C%A$7$?ItJ,$h$j8e$m$NItJ,$N$_(B
;; $B$H$J$k!#$3$l$K$h$C$F!"A0J}0lCW8GDj$G$"$k(BMew$BK\BN$NJd405!9=$G$bJd402D(B
;; $BG=$J(Balias$B$N%(%s%H%j$r@8@.$G$-$k!#(B

;; $B>e5-$,%G%U%)%k%H$NF0:n$G$"$k$,!"(B[Rev 1.9] $B$K$*$$$F!"IU2C$9$k(Bdn $B>pJs(B
;; $B$NNL$r;XDj$G$-$k$h$&$J5!G=DI2C$r9T$J$C$?!#(B $B$3$l$O!"2q<RAH?%A4BN$N$h(B
;; $B$&$JBg$-$JL>A06u4V$G$O!"%U%k%M!<%`$r8+$?$@$1$G$OL\E*$N8D?M$+$I$&$+(B
;; $B$,H=CG$7$K$/$$%1!<%9$G!">o$KIt=pL>$J$I$bIU2C$7$?$$MWK>$KEz$($k$?$a(B
;; $B$N$b$N$G$"$k!#6qBNE*$K$O(Bmew-ldap-alias-dn-level $BJQ?t$K$h$C$F!"IU2C(B
;; $B$7$?$$(Bdn $B>pJs$NNL(B($B%l%Y%k(B)$B$r;XDj$9$k!#%G%U%)%k%H$O(Bnil $B$G$"$j!":G>.$r(B
;; $B0UL#$9$k!#<B:]$K$O>e$G=R$Y$?F0:n$,9T$J$o$l$k!#(Bt $B$O>o$K$9$Y$F$N>pJs(B
;; $B$rIU2C$9$k!#(B1$B0J>e$N@0?t$r;XDj$7$?>l9g$O>o$KIU2C$9$k:GDc$N?t$r0UL#$7!"(B
;; $B$3$l$G(Buniq $B$H$J$i$J$$>l9g$O>e5-@bL@$HF1MM$NF0:n$K$h$j3HD%$5$l$k!#8=(B
;; $B<BAu$G$O(Bnil $B$r;XDj$7$?>l9g$O(B1$B$r;XDj$7$?>l9g$HEy$7$$!#(B
;; $B6qBNE*$JNc$r0J2<$K<($9!#(B

;; (setq mew-ldap-alias-dn-level 3) $B$H;XDj$7$?>l9g!"0J2<$N(Bdn $B$O(B
;; dn: CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=Lisper,O=Programmers Inc.
;; $B<!$N$h$&$K$J$k!#(B(uniqness $B$N$?$N$aIU2C$,B8:_$7$J$$>l9g$NNc(B)
;;  nil => Goto/Shun-ichi_GOTO
;;    1 => Goto/Shun-ichi_GOTO
;;    2 => Goto/Shun-ichi_GOTO/Mew
;;    3 => Goto/Shun-ichi_GOTO/Mew/Emacs
;;    4 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper
;;    5 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper/Programmers_Inc_
;;    6 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper/Programmers_Inc_
;;    t => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper/Programmers_Inc_

;; $BJL$NJ}K!(B:

;; $B2?$+$7$i$NM}M3$G(B dn $B$r9=@.$9$k>pJs$,MxMQ$7$K$/$$%1!<%9$,$"$k!#Nc$((B
;; $B$P!"(Bdn $B$,(Bcn $B$@$1$G9=@.$5$l!"$=$NCM$,<R0wHV9f$G$"$k$h$&$J>l9g!"CM$O(B 
;; "CN=12345" $B$H$J$k!#$3$l$r(Balias $B$KMxMQ$9$k$H!"(B

;; goto/12345
;; goto/12346

;; $B$H$$$C$?$h$&$K!"0l0U@-$OJ]$F$k$,%f!<%6$,6hJL$7$K$/$$$b$N$H$J$C$F$7(B
;; $B$^$&!#$3$N$h$&$J>l9g$N$?$a$K(B mew-ldap-alternative-dn-type-list $B$H$$(B
;; $B$&JQ?t$rMxMQ$G$-$k!#$3$l$O%G%U%)%k%H$O(Bnil $B$G$"$j!"(Bnil $B$N>l9g$O@h$K(B
;; $B@bL@$7$?$h$&$JDL>oF0:n$G$"$k$,!"$3$l$K%"%H%j%S%e!<%HJ8;zNs$N%j%9%H(B
;; $B$rM?$($k;v$G!"0l0U$JJ8;zNs$r:n@.$9$k$N$K(Bdn $B$N9=@.MWAG$NBe$o$j$KG$0U(B
;; $B$N%"%H%j%S%e!<%H$NCM$rMxMQ$9$k;v$,=PMh$k!#Nc$($P0J2<$N$h$&$K@_Dj$7(B
;; $B$?>l9g$O(B sn, givenname, cn $B$rMxMQ$9$k!#(B

;; (setq mew-ldap-alternative-dn-type-list '("sn" "givenname" "cn"))


;;; $B%-%c%C%7%e(B -------------------------------------------------------

;; LDAP$B$K$h$k8!:w$=$l<+BN$O9bB.$G$O$"$k$,!"K\%Q%C%1!<%8$O30It%W%m%0%i(B
;; $B%`$N5/F0$K$h$j<B8=$7$F$$$k$?$a!"%"%I%l%9Jd40$NL\E*$K$*$$$F$O$d$O$j(B
;; $B>/!9;~4V$,$+$+$j!"%9%H%l%9$b46$8$k!#$=$3$G!"(B1$B$D$N%"%I%l%9Jd40$r40@.(B
;; $B$5$;$k:]$K$OJd4085J8;zNs$OA02s$N$b$N$HEy$7$$$+!"$"$k$$$O$=$l$KJ8;z(B
;; $B$rDI2C$?$b$N$G9T$o$l$k$3$H$,B?$$$3$H$KCeL\$7!"(BLDAP$B$N8!:w7k2L$r%-%c%C(B
;; $B%7%e$9$k$3$H$H$9$k!#$?$H$($P(B "ab" $B$G8!:w$7$?7k2L$O(B "abc"$B$G8!:w$7$?(B
;; $B7k2L$rFbJq$7$F$$$k$3$H$O3N<B$J$N$G!"(B"ab"$B$N8!:w7k2L$r:FMxMQ$9$k$3$H(B
;; $B$G!"(B"abc"$B$N8!:w$N$?$a$NLd$$9g$o$;(B($B%3%^%s%I5/F0(B)$B$r>J$/$3$H$,$G$-$k!#$b(B
;; $B$A$m$s!"$=$N$?$a$K$O7k2L$r$=$N$^$^:FMxMQ$9$k$N$G$O$J$/!"(Belisp$B>e$G$N(B
;; $B9J$j9~$_=hM}$,9T$o$l$k!#$3$N%-%c%C%7%e=hM}$OJQ?t(Bmew-ldap-cache-use
;; $B$K$F@)8f$9$k!#%G%U%)%k%H$O(Bt$B$G$"$j!"%-%c%C%7%e$rMxMQ$9$k!#(B

;; $B%-%c%C%7%e$5$l$?%G!<%?$O(Bmew-ldap-search-cache$B$KJ];}$5$l!"$=$N:]$NLd(B
;; $B$$9g$o$;J8;zNs(B($B$?$H$($P(B"ab")$B$H7k2L>pJs$N(Bcons$B$G$"$k!#<!$NJd40=hM};~(B
;; $B$K!"%-%c%C%7%e$5$l$?Jd40J8;zNs$,?7$7$$Jd40J8;zNs$N@hF,$+$i0lCW$7$F(B
;; $B$$$k>l9g$O%-%c%C%7%e$rMxMQ$7!"$=$&$G$J$$>l9g$O%-%c%C%7%e$rGK4~$9$k!#(B
;; $B@h$NNc$G!"(B"ab"$B$G$NJd407k2L$rJ];}$7$?$H$7$F!"<!$N(B"abc"$B$NJd40$G$O%-%c%C(B
;; $B%7%e$rMxMQ$9$k$,!"(B"de"$B$NJd40$G$O%-%c%C%7%e$OGK4~$5$l?75,$K8!:w$,9T(B
;; $B$o$l$k!#(B

;;; $B0lCW7k2L$NJ];}(B ---------------------------------------------------

;; $B$^$?!"(Balias$BJd40$N7k2L$H$7$F40A40lCW$7$?>l9g$O<!$NJd40F0:n$G$O%"%I%l(B
;; $B%9$X$NE83+F0:n!"$=$7$F%"%I%l%9$OL>>N$D$-I=5-$X$NE83+F0:n$,$"$j$($k!#(B
;; $B$3$l$O(Balias$BJd40F0:n$HO"B3$G9T$o$l$k$H$O8B$i$J$$$?$a!">pJs$,%-%c%C%7%e(B
;; $B$+$i>C$($F$7$^$&$H8e$NF0:n$,9T$($J$$!#$=$N$?$a(Balias$B$,40A40lCW(B(sole
;; completion)$B$7$?>l9g$O$=$N>pJs$rJLESJ];}$7$F$*$/$3$H$H$9$k!#9M$(J}$H(B
;; $B$7$F$O(Bmew-addrbook-alist$B$KDI2C$9$k$N$KEy$7$$$N$@$,!"<B:]$K$OJLJQ?t(B
;; mew-ldap-hit-cache$B$KJ];}$7!"Jd40F0:n;~$K(Bmew-addrbook-alist$B$KBP$7$F(B
;; $BJ];}$7$F$$$k%j%9%H$r9g@.$7$F=hM}$9$k$3$H$K$h$j<B8=$9$k!#(B

;;; $B%m!<%+%k8@8lI=5-(B($BAa$$OC$,F|K\8lL>(B)$B$N;HMQ(B -------------------------

;; cn $B$O0lHL$K%U%k%M!<%`$G$"$k$?$a!"(BMew$B$N(Baddrbook$B$N#4HVL\$N%(%s%H%j(B
;; (name)$B$H$7$F;HMQ$G$-$k!#(Bcn:$B$ODL>o1Q8lI=5-$G$"$k$,!"%m!<%+%i%$%:$5$l(B
;; $B$?4D6-$K$*$$$F$O1Q8lI=5-$N$[$+$K%m!<%+%k8@8lI=5-(B($BF|K\8lL>$J$I(B)$B$N$b(B
;; $B$N$bB8:_$9$k!#(Bname$B%(%s%H%j$H$7$F$I$A$i$NI=5-$r;HMQ$9$k$+$O%*%W%7%g(B
;; $B%sJQ?t(Bmew-ldap-use-local-lang-value$B$K$F;XDj$9$k!#$3$l$,(Bnon-nil$B$G$"(B
;; $B$j!"(BLDAP$B%G!<%?%Y!<%9$K%m!<%+%k8@8lI=5-$,B8:_$7!"(Butf-8 charset $B$,;H(B
;; $BMQ$G$-$k4D6-$N>l9g$K$N$_!"%m!<%+%k8@8lI=5-$,;HMQ$5$l$k!#$=$l0J30$N(B
;; $B>l9g$O1Q8lI=5-$rMxMQ$9$k!#(B


;;; TODO

;; * alias $BE83+8e$N%-%c%C%7%s%0$H(Baddress $BE83+$N@09gLdBj(B
;;   $B0lEY(Bhit-cache $B$KF~$C$?(Balias $B$,0l0U$G$"$k$H$O8B$i$J$$;v$K$h$kLdBj!#(B

;; * $BG'>Z$N%5%]!<%H(B

;; * XEmacs LDAP feature support

;; * $B0l0U@-$H$OJL$K0UL#$H$7$F!"Jd40$N:]$KIt=pL>$rCN$j$?$$$H;W$&!#%U%k(B
;; $B%M!<%`$OCN$i$J$$$1$I!"It=p$O$o$+$k!"$H$$$&%1!<%9$,$"$k$+$i!#(B

;;; Code:

(require 'mew-func)

(if (not (fboundp 'mew-match-string))
    (defalias 'mew-match-string 'mew-match))

(defvar mew-ldap-use nil
  "*Search address completion cadidates from LDAP server.
If nil, do not use LDAP access except do command `mew-ldap-header-comp'
with prefix C-u. It means FORCE to use LDAP.
LDAP search result is used when this variable is nil.")

(defvar mew-ldap-server nil
  "*Hostname or address of LDAP server.
If you wanna use not standard port, append colon ':' 
followed by port number.")

(defvar mew-ldap-use-substring-search nil
  "*If this value is non nil, complete address with substring search.")

(defvar mew-ldap-use-local-lang-value nil
  "*If this value is non nil, use encoded value if exist.
This direction is NOT effects for alias name making.
This feature requres utf-8 charset implementation.
See mule-ucs or utf-2000 for more information.")

(defvar mew-ldap-local-lang-charset "utf-8"
  "*MIME charset name for your local encoding.
If your site uses Shift_JIS encoded string, you can specify
\"Shift_JIS\" to this variable.")

(defvar mew-ldap-search-base "c=us"
  "*Base scope to search.
Usually this is country (c=country-code) or company (o=company-name).
Try and decide your favorite scope suit for your use.")

(defvar mew-ldap-alias-dn-level nil
  "*Level of dn data to make alias postfix.
Valid value is nil, t, 1 or larger integer.

If this value nil, minimum alias postfix is made depends on uniqness
with other candidates. In this implementation, it's same to 1.  If t,
always append all dn data. If number, always append spcified level of
data but maybe appended more uniqness.  If invalid value, treat as
nil.

For example, following dn data is exsist, alias of each level is shown
bellow.

Match: Goto
dn: CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=Lisper,O=Programmers Inc.
  nil => Goto/Shun-ichi_GOTO
    1 => Goto/Shun-ichi_GOTO
    2 => Goto/Shun-ichi_GOTO/Mew
    3 => Goto/Shun-ichi_GOTO/Mew/Emacs
    4 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper
    5 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper/Programmers_Inc_
    6 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper/Programmers_Inc_
    t => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper/Programmers_Inc_

If level 3 is required for uniqness with other candidates,
  nil => Goto/Shun-ichi_GOTO/Mew/Emacs    ... appended more
    1 => Goto/Shun-ichi_GOTO/Mew/Emacs    ... appended more
    2 => Goto/Shun-ichi_GOTO/Mew/Emacs    ... appended more
    3 => Goto/Shun-ichi_GOTO/Mew/Emacs
    4 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper
    (so on...)
")

(defvar mew-ldap-alternative-dn-type-list nil
  "*List of attribute type to build identity string instead of dn.
Usually this value is nil and simply use dn as uniq identity string.
But with some reason, dn string is not good for visible completion
string, you can use this.
Value is list of attribute type name string.
For example, if you set this value like '(\"cn\" \"sn\" \"givenname\"),
uniq string is made as \"CN=Shunichi Goto,SN=Goto,GIVENNAME=Shunichi\".
And you can use completion string like:
 \"gotoh/Shunichi_Goto/Goto/Shunichi\"")

(defconst mew-ldap-program "ldapsearch"
  "*Program name to make query to LDAP.
It should be ldapsearch come with OpenLDAP and compatibles.  If you
are Win32 environment, you can get it from Netscape Directory SDK or
Lotus Notes 5.")

(defvar mew-ldap-program-arguments (if (memq window-system '(w32 win32))
				       'netscape ;; or 'notes
				     'openldap)
  "*List of argument to invoke ldapsearch.
Value is list of arguments or symbol.
If symbol, use value of variable named as mew-ldap-program-argument-for-xxx.
See `mew-ldap-program-arguments-for-openldap' and
`mew-ldap-program-arguments-for-netscape' and 
`mew-ldap-program-arguments-for-notes'
Argument list contains string or symbol string is placed as-is,
and symbol is expanded some value.
You can use following symbols:
  server ....... LDAP server name
  port ......... LDAP server port
  base ......... Search base filter
Note that search fileter and attributes will be added automaticaly.
You cannot specify them in this list.")

(defconst mew-ldap-program-arguments-for-openldap
  '( "-L"					; force LDIFF output
     "-h" server
     "-p" port
     "-b" base))

(defconst mew-ldap-program-arguments-for-netscape
  '( "-h" server
     "-p" port
     "-b" base))

(defconst mew-ldap-program-arguments-for-notes
  '( "-L"					; force LDIFF output
     "-h" server
     "-p" port
     "-b" base))

(defvar mew-ldap-ignore-addrbook nil
  "*Do not merge AddrBook entries for completion.")

(defvar mew-ldap-use-cache t
  "*Cache previous search result and use for subset searching.
For example, if assume last searching is done for the word \"goto\" and
got 4 entries, then next search for the word \"gotoh\" uses cached
result without invoking ldapsearch command because \"gotoh\" is
subset of \"goto\".")

(defvar mew-ldapheader-comp-hook nil
  "Hook called after completion.")

(defvar mew-ldap-make-filter-objectclass "inetOrgPerson"
  "*This variable specifys the value of 'objectClass'.
The default is \"inetOrgPerson\".  If your LDAP server is MS Exchange,
you may need to change it to \"person\", \"organizationalPerson\", and so on. ")

;; internal variables and constants

(defvar mew-ldap-debug nil
  "*Debug option to view ldapsearch output and faked addbook entries.
ldapsearch output is in buffer named \" *mew-ldap-output*\",
and faked addrbook entries are printed in \" *mew-ldap-addrbook*\".
")

(defvar mew-ldap-debug-with-dummy-output nil
  "*Use dummy string without invoking ldapsearch.
If this value is string, use it as output string.
Otherwise use hard-coded string written by author for test.")

(defconst mew-ldap-buffer-addrbook " *mew-ldap-addrbook*")
(defconst mew-ldap-buffer-output " *mew-ldap-output*")

(defconst mew-ldap-alias-sep "/"
  "Separator to make alias.
Be carefully to change this value.")

(defconst mew-ldap-search-attribute-type-list
  '("sn" "mail" "cn")
  "List of LDAP attribute type to search with. 
Note that ldapsearch program is executed for each element of this value.
So specifying many is not good for speed.
By default, search with mail address (mail) and first name (sn : sir-name)
and full-name (cn : canonical name).
All results are merged (OR operation).")

(defconst mew-ldap-unknown-attr-str "unknown")


;; cache
(defvar mew-ldap-search-cache nil
  "Cache of search result (for internal use).
Car is string to complete in last query, and cdr is list of faked
mew-addrbook-alist.")

(defun mew-ldap-header-comp (force)
  "Alternative of `mew-draft-header-comp' command.
If FORCE is t (with prefix), override `mew-ldap-use' as t 
and force invoking ldapsearch."
  (interactive "P")
  (let* ((mew-ldap-use (or force
			   mew-ldap-use)))
    (mew-draft-header-comp)
    (run-hooks 'mew-ldapheader-comp-hook)))


;; advices of mew's functions
(defadvice mew-complete (around ldap 
			(WORD ALIST MSG EXPAND-CHAR &optional TRY ALL GET HIT)
			activate)
  (if (or (not (eq ALIST mew-addrbook-alist))
	  (if (or mew-ldap-server
		  mew-ldap-debug-with-dummy-output)
	      nil
	    (message "You must specify LDAP server name")
	    (sit-for 1)
	    t))
      ad-do-it
    ;; with LDAP
    (let ((completion-ignore-case t)
	  alist wd entry ent)
      ;; call function although mew-ldap-use is nil or not,
      ;; and the function invoke ldapsearch only when t.
      (setq alist (mew-ldap-make-address-completion-alist WORD))
      ;; call original with faked or as-is 
      (setq ALIST (mew-ldap-addrbook-merge 
		   alist 
		   (and (not mew-ldap-ignore-addrbook)
			mew-addrbook-alist)))		; fake!
      ad-do-it
      (setq wd (mew-delete-backward-char))
      (insert wd))))

(defadvice mew-addrbook-name-get (around ldap activate)
  "prepending LDAP search result entries."
  (let* ((cache (and mew-ldap-use-cache (cdr mew-ldap-search-cache)))
	 (mew-addrbook-alist (append cache mew-addrbook-alist))
	 (mew-addrbook-orig-alist (append cache mew-addrbook-orig-alist)))
    ad-do-it))


;; functions

(defun mew-ldap-cache-purge ()
  "Purge cached entries searched by LDAP."
  (interactive)
  (setq mew-ldap-search-cache nil))

(defun mew-ldap-encoded-p (type)
  "Return t if TYPE indicates value is encoded."
  (string-match "::$" type))

(defun mew-ldap-get-value (type entry)
  ""
  (cdr (or (and mew-ldap-use-local-lang-value
		(assoc (concat type "::") entry))
	   (assoc (concat type ":") entry))))

(defun mew-ldap-addrbook-merge (&rest addrbook-list-list)
  "Merge some addrbook-list to be uniq."
  (let (result alist)
    (while addrbook-list-list
      (setq alist (car addrbook-list-list)
	    addrbook-list-list (cdr addrbook-list-list))
      (while alist
	(if (not (mew-addrbook-alias-hit (car (car alist)) result))
	    (setq result (cons (car alist) result)))
	(setq alist (cdr alist))))
    (nreverse result)))

(defun mew-ldap-get-matched-values (word type-list entry)
  "Correct matching WORD with value of TYPE-LIST in ENTRY.
Returns matched uniq string list."
  (let ((regexp (if mew-ldap-use-substring-search
		    word
		  (concat "^" word)))
	type value result)
    ;; collect matching value
    (while entry
      (setq type (car (car entry))
	    value (cdr (car entry))
	    entry (cdr entry))
      (if (string-match "::?$" type)
	  (setq type (substring type 0 (match-beginning 0))))
      (if (and (member type type-list)
	       (string-match regexp value)
	       (not (member value result)))
	  (setq result (cons value result))))
    result))

(defun mew-ldap-suit-for-alias (str)
  "Change STR suit for alias.
Replace space/tab in STR into '_' char.
And remove domain part of mail addr."
  (let ((regexp (concat "[" mew-address-separator "]+")))
    (while (string-match regexp str)
      (setq str (concat (substring str 0 (match-beginning 0))
			"_"
			(substring str (match-end 0)))))
    (if (string-match "@[^/@]+" str)
	(setq str (concat (substring str 0 (match-beginning 0))
			  (substring str (match-end 0)))))
    str))

(defun mew-ldap-make-address-completion-alist (word)
  "Make addrbook-alist for WORD to use with searching ldap or using cache.
If WORD contains one in last search, use chached data.
Otherwise, do query with ldapsearch program.
As result, merge them with mew-addrbook-alist and return it.
"
  (let ((case-fold-search t)
	from-cache alist wd)
    ;; check cache
    (if (and mew-ldap-use-cache
	     mew-ldap-search-cache
	     (string-match (concat "^" 
				   (regexp-quote (car mew-ldap-search-cache)))
			   word))
	(setq from-cache t			; use cache
	      alist (cdr mew-ldap-search-cache))
      ;; do query
      (if mew-ldap-use
	  (progn
	    (message "Searching with LDAP...")
	    (if (string-match (concat "^\\([^" mew-ldap-alias-sep "]*\\)"
				      mew-ldap-alias-sep
				      "\\(.*\\)")
			      word)
		(setq wd (or (mew-match-string 1 word)
			     (mew-match-string 2 word)
			     word))
	      (setq wd word))
	    (setq alist (mew-ldap-make-addrbook-alist wd (mew-ldap-search wd))
		  mew-ldap-search-cache (cons word alist))
	    (message "Searching with LDAP...done"))))
    (if mew-ldap-debug
	(save-excursion
	  (set-buffer (get-buffer-create mew-ldap-buffer-addrbook))
	  (erase-buffer)
	  (if from-cache
	      (insert ";; cached data without invoking " mew-ldap-program)
	    (insert ";; " mew-ldap-program " is invoked\n"))
	  (pp alist (current-buffer))))
    (let ((addrbook-alist (and (not mew-ldap-ignore-addrbook)
			       mew-addrbook-alist))
	  uniq)
      (if (null alist)
	  addrbook-alist
	;; merging, remove entries already in addrbook then prepend
	;; then prepend rest of search result entries and return. 
	(while alist
	  (if (not (mew-addrbook-alias-hit (car (car alist)) addrbook-alist))
	      (setq uniq (cons (car alist) uniq)))
	  (setq alist (cdr alist)))
	(append uniq addrbook-alist)))))


(defun mew-ldap-register-uniq-dn (hash dn &optional str dn-list)
  ""
  (let (sym dnsym value level)
    (setq dnsym (intern (upcase dn) hash))
    (if (and (null str) (boundp dnsym))
	()					; already processed
      ;; make dn-list in fisrt time
      (if (null dn-list)
	  (let ((case-fold-search t))
	    (setq dn-list (mapcar '(lambda (str)
				     (if (string-match "[a-z]+= *\\(.*\\)" str)
					 (mew-match-string 1 str)))
				  (mew-split dn ?,)))))
      ;; prepare candidate for uniq str
      (if str 
	  (setq str (concat str mew-ldap-alias-sep (car dn-list))
		dn-list (cdr dn-list))
	;; first entry, pre-build with given level
	(cond 
	 ((null mew-ldap-alias-dn-level) (setq level 1))
	 ((eq t mew-ldap-alias-dn-level) (setq level 1000)) ; xxx, big enough
	 ((numberp mew-ldap-alias-dn-level)
	  (if (< 0 mew-ldap-alias-dn-level)
	      (setq level  mew-ldap-alias-dn-level)
	    (setq level 1)))
	 (t
	  (setq level 1)))
	(while (and (< 0 level) dn-list)
	  (if (null str)
	      (setq str (car dn-list))
	    (setq str (concat str mew-ldap-alias-sep (car dn-list))))
	  (setq level (1- level)
		dn-list (cdr dn-list))))
      (setq sym (intern (upcase str) hash))
      (if (not (boundp sym))
	  ;; good
	  (progn (set sym (list dn str dn-list))
		 (set dnsym str))
	;; conflict
	(if (not (eq (setq value (symbol-value sym)) t))
	    ;; move away deeper
	    (progn (set sym t)
		   (apply (function mew-ldap-register-uniq-dn) hash value)))
	(mew-ldap-register-uniq-dn hash dn str dn-list)))))
	  

(defun mew-ldap-make-alternative-dn (attr-list)
  "Make alternative dn string from ATTR-LIST.
How to build is to be specified in `mew-ldap-alternative-dn-type-list'
which is list of attribute type.
Get each attribute value and join like dn format.
"
  (mapconcat (lambda (type)
	       (format "%s=%s" (upcase type)
		       (or (mew-ldap-get-value type attr-list)
			   mew-ldap-unknown-attr-str)))
	     mew-ldap-alternative-dn-type-list
	     ","))
   

(defun mew-ldap-make-addrbook-alist (word entries)
  "Make addrbook format alist using WORD with ENTRIES.  

ENTRIES is ldap search result which contains list of person data
entry and entry is alist of ldap type and value.  This function
check which value is matched to WORD, and make alias that value and
other information (dn). This function also fill information for
addrbook format data like mail-address and full-name.

Conversion mapping rule is following:

AddrBook      LDAP
----------   ------------
alias     <=  matched/cn
mailaddr  <=> mail
nick-name    (none)
full-name <=> cn
"
  (let ((hash (make-vector 127 0))
	result elist ent match mail name sym alias dn dnstr)
    ;; first, register dn to make uniq alias string
    (setq elist entries)
    (while elist
      (mew-ldap-register-uniq-dn
       hash
       (if mew-ldap-alternative-dn-type-list
	   (mew-ldap-make-alternative-dn (car elist))
	 (mew-ldap-get-value "dn" (car elist))))
      (setq elist (cdr elist)))
    
    (while entries
      (setq ent (car entries)
	    entries (cdr entries)
	    values  (mew-ldap-get-matched-values
		     word mew-ldap-search-attribute-type-list ent)
	    mail    (mew-ldap-get-value "mail" ent)
	    name    (mew-ldap-get-value "cn" ent)
	    dn      (if mew-ldap-alternative-dn-type-list
			(mew-ldap-make-alternative-dn ent)
		      (mew-ldap-get-value "dn" ent))
	    dnstr   (mew-ldap-suit-for-alias
		     (symbol-value (intern-soft (upcase dn) hash))))
      ;; make multiple alias candidates from one person
      (while (and mail values)
	(setq match (mew-ldap-suit-for-alias (car values))
	      values (cdr values))
	(if (string-match (concat "^" (regexp-quote word)) dnstr)
	    (setq alias dnstr)
	  (string-match (concat "\\(" (regexp-quote word) ".*\\)") match)
	  (setq alias (concat (mew-match-string 1 match) mew-ldap-alias-sep dnstr)))
	(setq sym (intern (concat mew-ldap-alias-sep (downcase alias)) hash))
	(if (boundp sym)
	    ()					; already exist
	  (set sym (list alias (list mail) nil name))
	  (setq result (cons (symbol-value sym) result)))))
    result))


(defun mew-ldap-make-filter (pat type-list)
  "Make RFC1558 quiery filter for PAT from ATTR-LIST.
Each are \"OR\" combination, and PAT is beginning-match."
  (let ((regexp (if mew-ldap-use-substring-search "(%s=*%s*)" "(%s=%s*)")))
    (concat "(&"
	    "(objectclass=" mew-ldap-make-filter-objectclass ")"
	    "(|"
	    (mapconcat 
	     '(lambda (x) (format regexp x pat)) ; fixed format
	     type-list
	     "")
	    "))")))

(defun mew-ldap-search (pat)
  "Make addrbook entry list querying to ldap with PAT.
Result format is list of personal information.
Personal information is list attributes.
Attribute is list whoes car is attribute name
and rest are values. Values may be multiple for single attribute.
For example:
 ( ...
   ((\"dn\" \"CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=Lisper,O=Programmers Inc.\")
    (\"mail\" \"gotoh@taiyo.co.jp\")
    (\"cn\" \"Shun-ichi GOTO\" \"JAPANESE-NAME\")
    (\"shortname\" \"gotoh\"))
   ...)
"
  ;; Note that this functions depends on ldapsearch and its output.
  (let ((tmp (get-buffer-create mew-ldap-buffer-output))
	(hash (make-vector 127 0))
	sym arg-list entry result attr-list must-list dn)
    ;; check server name
    (if (not (stringp mew-ldap-server))
	(error "You must specify LDAP server."))
    ;; prepare argument list 
    (if (not (symbolp mew-ldap-program-arguments))
	(setq arg-list mew-ldap-program-arguments)
      (setq sym (intern-soft 
		 (concat "mew-ldap-program-arguments-for-"
			 (symbol-name mew-ldap-program-arguments))))
      (if (or (null sym) (not (boundp sym)))
	  (error "Invalid symbol of mew-ldap-program-arguments")
	(setq arg-list (symbol-value sym))))
    (if (or (null arg-list) (not (listp arg-list)))
	(error "mew-ldap-program-arguments is not list or valid symbol."))
    ;; expand argument list
    (let (server port base)		; local symbols
      (if (string-match "^\\([^:]+\\):\\([0-9]+\\)$" mew-ldap-server)
	  (setq server (mew-match-string 1 mew-ldap-server)
		port   (mew-match-string 2 mew-ldap-server))
	(setq server mew-ldap-server
	      port   "389"))
      (if (not (stringp mew-ldap-search-base))
	  (error "mew-ldap-search-base is not string"))
      (setq base mew-ldap-search-base)
      (setq arg-list
	    (mapcar '(lambda (x) (if (symbolp x) (symbol-value x) x))
		    arg-list)))
    ;; do query
    (save-excursion
      (set-buffer tmp)
      (erase-buffer)
      ;; invoke ldapsearch program to query
      (if mew-ldap-debug-with-dummy-output
	  (mew-ldap-insert-dummy-output)
	(setq attr-list mew-ldap-search-attribute-type-list
	      must-list (append '("mail" "cn")
				mew-ldap-alternative-dn-type-list))
	(while must-list 
	  (if (not (member (car must-list) attr-list))
	      (setq attr-list (cons (car must-list) attr-list)))
	  (setq must-list (cdr must-list)))
	(apply (function call-process)
	       mew-ldap-program
	       nil tmp t
	       (append arg-list
		       (list (mew-ldap-make-filter
			      pat mew-ldap-search-attribute-type-list))
		       attr-list)))
      ;; parse result as uniq
      (goto-char (point-min))
      (while (setq entry (mew-ldap-get-entry))
	(setq dn (mew-ldap-get-value "dn" entry)
	      sym (intern dn hash))
	(if (not (boundp sym))
	    (set sym entry)))
      (mapatoms '(lambda (x)
		   (if (and x (symbol-value x))
		       (setq result (cons (symbol-value x) result))))
		hash)
      (if (not mew-ldap-debug)
	  (kill-buffer tmp)))
    (nreverse result)))


(defun mew-ldap-get-entry-1 ( &optional allow-dn )
  "Get one attribute considering folding.
XXX, Unfolding may not be correct..."
  (let ((case-fold-search t)
	(regexp "^\\(\\([a-z]+\\)\\(;[-a-z]+\\)*::?\\) *\\(.*\\)$")
	tag value)
    ;; skip
    (while (and (not (eobp))
		(not (looking-at regexp)))
      (forward-line 1))
    (if (or (eobp)
	    (and (not allow-dn)
		 (string= (match-string 2) "dn")))
	()
      (setq tag (match-string 1)
	    value (match-string 4))
      (forward-line 1)
      (while (looking-at "^ +\\(.*\\)$")
	(setq value (concat value (match-string 1)))
	(forward-line 1))
      (cons tag value))))

(eval-when-compile
  (if (fboundp 'mew-base64-decode-string)
      (defalias 'mew-ldap-decode-base64-string 'mew-base64-decode-string)
    (defalias 'mew-ldap-decode-base64-string 'mew-header-decode-base64)))

(defun mew-ldap-get-entry ()
  "Get one entry from buffer of ldapsearch output.
Result is a alist of (TYPE . VALUE) in order of occurence or nil if no
more data. If `mew-ldap-use-local-lang-value' is non nil, VALUE is
decoded here.  If nil, encoded attribute is ignored and not appear in
result."
  (let (result decode attr type value)
    ;; entry must begin with DN attribute
    (if (not (re-search-forward "^dn:" nil t))
	()					; no more entry
      (beginning-of-line)
      (setq attr (mew-ldap-get-entry-1 'allow-dn) ; get dn
	    decode (if (and mew-mule-p
			    mew-ldap-use-local-lang-value ; request to decode
			    (mew-charset-to-cs (or mew-ldap-local-lang-charset
						   "utf-8")))
		       t nil))
      ;; We assume that value is not folded (option -T is required)
      (while attr
	(setq type (downcase (car attr))
	      value (cdr attr))
	(if (or (and (not decode) (mew-ldap-encoded-p type))
		(assoc type result)		; accept only first one
		(string= "ldap_search:" type))	; ldapsearch notification
	    ()					; ignore this attribute
	  (if (mew-ldap-encoded-p type)
	      (setq value (mew-header-sanity-check-string
			   (mew-cs-decode-string
			    (mew-ldap-decode-base64-string value)
			    (mew-charset-to-cs (or mew-ldap-local-lang-charset
						   "utf-8"))))))
	  (setq result (cons (cons type value) result)))
	(setq attr (mew-ldap-get-entry-1))))
    (nreverse result)))


;; for debug

(defun mew-ldap-insert-dummy-output ()
  (insert "
dn: CN=Tarou Miyoshi,OU=test,O=ldap
mail: tmiyoshi@domain
sn: Miyoshi
cn: Tarou Miyoshi
cn:: 5LiJ5aW9IOWkqumDjg==

dn: CN=Kenta Miyajima,OU=test,O=ldap
mail: kmiyajima@domain
sn: Miyajima
cn: Kenta Miyajima
cn: 5a6u5bO2ICDlgaXlpKo=

dn: CN=Miyoko Yamada,OU=test,O=ldap
mail: miyoko@domain
sn: Yamada
cn: Miyoko Yamada
cn:: 5bGx55SwIOe+juS7o+WtkA==

dn: CN=Miyoko Yamada,OU=test2,O=ldap
mail: mmiyoko@domain
sn: Yamada
cn: Miyoko Yamada
cn:: 5bGx55SwIOS4ieS7o+WtkA==

dn: CN=Yasuo Mikawa,OU=test,O=ldap
mail: miya@domain
sn: Mikawa
cn: Yasuo Mikawa
cn:: 5LiJ5rKzIOW6t+Wkqw==

dn: CN=Shunichi Goto,OU=RD,OU=Gihon,O=Taiyo
mail: ShunichiGoto@taiyo.co.jp
sn: Goto
cn: Shunichi Goto
cn:: 5b6M6Jek
 IOS/iuS4gA==

ldap_search: No such object
dn: CN=Nanashino Goto,OU=RD,OU=Eihon,O=Taiyo
mail: gotoh2@taiyo.co.jp
sn: Goto
cn: Nanashino Goto
cn:: 5ZCN54Sh44GX44Gu5b6M6Jek

ldap_search: No such object
dn: CN=Nanashino Goto,OU=NOT-RD,OU=Eihon,O=Taiyo
mail: gotoh3@taiyo.co.jp
sn: Goto
cn: Nanashino Goto
cn:: 5ZCN54Sh44GX44Gu5b6M6Jek

ldap_search: No such object
dn: CN=Nanashino Goto,OU=NOT-RD,OU=DOKKA,O=Taiyo
mail: gotoh4@taiyo.co.jp
sn: Goto
cn: Nanashino Goto
cn:: 5ZCN54Sh44GX44Gu5b6M6Jek

dn: cn=\"yoshitsugu mito\" , ou=\"SHINOHARA Section\" , ou=\"3rd SI Department\" , o
 u=\"Niigata Branch Division\" , o=\"NEC Soft\" , l=\"IJ\" , gn=\"NEC Group\" , c=\"JP\"
cn:: 5rC05oi4IOWYieWXow==
cn;lang-en: yoshitsugu mito
cn;lang-ja:: 5rC05oi4IOWYieWXow==
cn;lang-ja;phonetic:: 44G/44GoIOOCiOOBl+OBpOOBkA==

ldap_search: No such object
"))

;;;
(provide 'mew-ldap)

;; Local Variables:
;; comment-column: 48
;; End:

;; mew-ldap.el ends here
