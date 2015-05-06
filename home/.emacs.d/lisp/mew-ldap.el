;; mew-ldap.el -- LDAP support for Mew addrbook.

;; Copyright (C) 2000 Shun-ichi GOTO

;; Author: Shun-ichi GOTO <gotoh@taiyo.co.jp>,
;;         Shun-ichi TAHARA (田原 俊一) <jado@flowernet.gr.jp>
;; Created: Fri Jun 09 22:42:54 2000
;; Version: $Revision: 1.35 $
;; Keywords: mail, mew, ldap

;;; Commentary:

;;; はじめに ---------------------------------------------------------

;; 本パッケージはMewでのdraft modeでのアドレス補完の際に、LDAPサーバへ
;; の問い合わせとその結果の利用ができるようにするためのパッケージです。
;; 以下に詳細を述べるが、簡単に利用するためには次節の「インストール」
;; および「使用方法」を参照して下さい。


;;; インストール -----------------------------------------------------

;; まずldapsearch プログラムを入手します。これは必須です。

;; UNIX環境であれば、OpenLDAPをインストールすることでそのクライアント
;; プログラムとしてldapsearchが利用可能になります。Win32環境であれば、
;; Netscapeから提供されている Netscape Directory SDK にldapsearch.exe 
;; が含まれています。これらは以下のアドレスから入手可能です。

;; OpenLDAP                http://www.openldap.org/
;; ミシガン大学のLDAP      http://www.umich.edu/~dirsvcs/ldap/ldap.html
;; Netscape Directory SDK  http://developer.netscape.com/tech/directory/

;; また、Lotus Note 5 にもldapsearch.exeが付属しているので、Lotus
;; Notes 5 clientをインストールしている人はこれが利用できるはず(けど未
;; テスト)。Lotus Notes サーバは適切に設定することでLDAPサーバとして利
;; 用可能になります。

;; そのほか、未確認ですがMicrosoft Exchange ServerもまたLDAPサーバとな
;; りますので、そのクライアントプログラムとしてldapsearch.exe相当が用
;; 意されているかもしれません。

;; Emacsに対する設定は以下のように行います。
;; 基本的には本パッケージをロードし、LDAPサーバ名を指定するだけです。

;; ~/.mew に以下のような記述を加えます。
;; (load "mew-ldap")
;; (setq mew-ldap-server "ldap-server.host.domain")
;; (define-key mew-draft-header-map "\C-i" 'mew-ldap-header-comp)
;; (define-key mew-header-mode-map "\C-i" 'mew-ldap-header-comp)

;; またLDAPへの問い合わせを常に行いたい場合は(setq mew-ldap-use t) と
;; いう記述も加えましょう。デフォルトではこの値はnilです。(mew-ldap.el
;; 1.19 からの変更)

;; Mewのアドレス補完は前方一致で行なわれるため、デフォルトではLDAP検索
;; についても前方一致で行なわれます。以下の設定により、LDAP検索を部分
;; 一致検索にすることができます。
;;
;; (setq mew-ldap-use-substring-search t)

;; UTF-8の使用できる環境(Emacs-20.6 + mule-ucsなど)では、以下の設定に
;; より、ローカル言語(例えば日本語)の名前(cn)を利用できます。
;; (setq mew-ldap-use-local-lang-value t)
;; この値のデフォルトはnilです。

;; その他、場合によっては mew-ldap-search-base を指定する必要があるか
;; も知れません。これは使用しているLDAPサーバのデータの検索基点を指定
;; するもので、検索範囲を狭めたい場合などに使用します。筆者のテスト環
;; 境のLDAPサーバ(Notes 4.5)はこのあたりがあいまいでもうまくいっていま
;; すが、インターネット上のディレクトリサービス(Netscape や Bigfootな
;; ど)では、適切に設定する必要があるかもしれません。


;;; 使用方法 ---------------------------------------------------------

;; 使い型は基本的にはMew のdraft mode での補完/展開操作と一緒です。違
;; いは先の設定によるTAB キーの機能です。補完の際に単にTABキーを使うと
;; Mew の持つ通常の機能で補完が行なわれ、LDAP検索は行なわれませんが、
;; C-u プリフィックスをつけて C-u TAB とする事によりLDAP検索の結果を加
;; えた補完が行えます。一度検索した結果はキャッシュに入り再利用される
;; ので、続いてプリフィックス無しでTAB キーによる補完を行なっても、補
;; 完文字列が前回の検索のサブセットとなるような場合は高速な動作が期待
;; できます。

;; 例えば筆者の環境では、アドレス部分に "go" と入力してC-u TAB を実行
;; すると、以下のような候補が現れます。
;;
;; Possible completions are:
;; gotoh/Shunichi_Goto		   Goto/Shunichi_Goto
;; Goto/Norikazu_Goto		   gotoh/IMASY
;; gotoh/TAIYO			   gotoh
;; gotonya
;;
;; これはldapsearch を使用した検索が行なわれ結果とMew のアドレス帳に登
;; 録されている情報の両方からの候補です。そして候補として"goto"までが
;; 最大一致するため、アドレス欄には"goto" までが補完された状態となりま
;; す。
;;
;; そこで続けて"/"と入力し、"gotoh/" の状態で、今度はプリフィックス無
;; しでTABを打つと以下のように2つに絞り込まれます。この時LDAP検索は行
;; なわれていません。先の検索結果を再利用しています。
;;
;; Possible completions are:
;; Goto/Shunichi_Goto		   Goto/Norikazu_Goto
;;
;; 更に"s" と続けてからTABを打つと候補は1つとなり、アドレス欄は
;; "Goto/Shunichi_Goto" に補完され、候補ウィンドウは消えます。
;; "Goto/Shunichi_Goto" という文字列はMew のアドレス帳のエイリアス名と
;; 同等です。したがってもう一度TABを押すと "gotoh@taiyo.co.jp" と、実
;; アドレスに展開されます。
;;
;; またさらにM-TAB を押すと、LDAP から得たユーザ名情報も付加して、
;; "Shunichi Goto <gotoh@taiyo.co.jp>" に展開されます。
;;
;; 結局、C-u TAB によって明示的にLDAP検索を行なわせる、ということ以外
;; は通常のMew での補完/展開動作と同一です。簡単でしょ。


;;; 制限 -------------------------------------------------------------

;; * 現バージョンでは、英語以外の言語(日本語等)での検索はサポートして
;;   いません。

;; * 本パッケージはldapsearch という外部プログラムに頼っているため、こ
;;   のプログラムのバージョンなどにより、うまく動作しないことがあるか
;;   もしれません。テストはサーバとしてNotes 4.5 (on WinNT 4.0 Server)、
;;   クライアントは UNIX環境ではOpenLDAPのldapsearchを、Win32環境では
;;   Netscape Directory SDKのldapsearch.exeを使用しました。

;; * 現バージョンでは認証無しでの接続しかサポートしていません(TODO)。

;; 以上、お楽しみあれ。


;;; 詳細 =============================================================

;;; LDAPデータとMewのアドレスデータの整合 ----------------------------

;; Mewのアドレス補完は何段階かに分かれている。第一段階は入力された部分
;; 文字列をalias文字列として補完するう。aliasとして完全一致した場合は
;; これをアドレス(群)に置き換える。その後、C-M-TAB操作によりname+addr 
;; の形式に展開する。これらを踏まえた上で、LDAPから得たデータをMewの枠
;; 組みに入れるすべを考える。まず最初にaliasに相当する物を用意する必要
;; があるが、LDAPのデータには適当な属性はない。aliasは一意であるという
;; 意味ではdnがあげられるが、このdnの内容は以下のようなものであり、そ
;; のままalias 文字列としては冗長であり使用するわけにはいかない。

;; dn: CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=Lisper,O=Programmers Inc.

;; また、補完は名字、名前、メールアドレスなどに対して行えることが望ま
;; しい。そこで、LDAPに対して検索対象となる属性を複数定義できるように
;; し、QUERYの結果を拾う際にマッチした属性の値を使用する。ただしこれだ
;; けでは、一意性を保てない(たとえばsnにGotoを持つユーザが多数マッチし
;; てしまう)ため、それらを区別するためにcnの情報を付加して区別できるよ
;; うにする。たとえば"miy"で検索した場合の結果として、snではTarou
;; Miyoshi <tmiyoshi@domain>さんと Kenta Miyajima <kmiyajima@domain>が
;; マッチ、mailでMiyoko Yamada <miyoko@domain> と Yasuo Mikawa
;; <miya@domain> がマッチしたとする。これらの結果に対してcnを付け加え
;; ることでalias 相当を作るとこうなる。

;; Miyajima/Kenta_Miyajima
;; Miyoshi/Tarou_Miyoshi
;; Miyoko_Yamada
;; miya/Yasuo_Miyata

;; 少し付け加えると、上記の例では少し特殊な処理が施されている。という
;; のはMewのaliasとして１語になるためには「空白/タブは使用できない」、
;; 「"@" を含むことはできない」という条件があるため、それらを考慮した
;; ものとなっている。たとえば"/"に続くfull-name(cn)はFirst-name と
;; Last-name を区切る空白が"_"に置き換わっている。また、
;; miya/Yasuo_Miyata は本来はmiya@domain/Yasuo_Miyata となるところを、
;; メールアドレスのドメイン部分を取り除いていある。もうひとつ、
;; Miyoko_Yamadaはcnそのものにマッチしたが、そのままだと
;; Miyoko_Yamada/Miyoko_Yamadaとなり、同じ言葉が連なるため、後続のcnの
;; 付加は省略した。

;; 上記の例ではほぼ一意性が保てているが、同姓同名の人間がいる場合には
;; 一意性は簡単に崩れる。そのためcnを付加するのではなく、dnの各要素を
;; 付加することとする。しかし、dnの全要素を単純に付加したのでは冗長な
;; 長いalias名となってしまうため、候補に上がったものの中で一意性が確保
;; できる最小の長さを求めながらdnの要素を順次付加していくこととする。
;; 具体的な例を以下にあげる。以下は３つのセクション(職場/所属)にいる同
;; 姓同名のShunichi Gotoさんのdnである。

;; dn: CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=Lisper,O=Programmers Inc.
;; dn: CN=Shun-ichi GOTO,OU=MUE,OU=Emacs,OU=Lisper,O=Programmers Inc.
;; dn: CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=User,O=Programmers Inc.

;; dnは(通常)組織構造をあらわしているため、これらを左の要素から一意性
;; を保ちながら順に付加していくと、次のような結果を得る。

;; Shun-ichi GOTO/Mew/Emacs/Lisper
;; Shun-ichi GOTO/MUE
;; Shun-ichi GOTO/Mew/Emacs/User

;; このような、dnから一意性のある文字列を作成する処理は、ハッシュを用いた
;; mew-ldap-register-uniq-dn 関数にて行っている。
;; 上記結果は以下のテストコードにて確認した。

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

;; なお、mew-ldap-use-substring-searchをセットして部分一致検索による補
;; 完を使用している場合、aliasの先頭に来るのはマッチした属性そのもので
;; はなく、その属性の中の検索文字列にマッチした部分より後ろの部分のみ
;; となる。これによって、前方一致固定であるMew本体の補完機構でも補完可
;; 能なaliasのエントリを生成できる。

;; 上記がデフォルトの動作であるが、[Rev 1.9] において、付加するdn 情報
;; の量を指定できるような機能追加を行なった。 これは、会社組織全体のよ
;; うな大きな名前空間では、フルネームを見ただけでは目的の個人かどうか
;; が判断しにくいケースで、常に部署名なども付加したい要望に答えるため
;; のものである。具体的にはmew-ldap-alias-dn-level 変数によって、付加
;; したいdn 情報の量(レベル)を指定する。デフォルトはnil であり、最小を
;; 意味する。実際には上で述べた動作が行なわれる。t は常にすべての情報
;; を付加する。1以上の整数を指定した場合は常に付加する最低の数を意味し、
;; これでuniq とならない場合は上記説明と同様の動作により拡張される。現
;; 実装ではnil を指定した場合は1を指定した場合と等しい。
;; 具体的な例を以下に示す。

;; (setq mew-ldap-alias-dn-level 3) と指定した場合、以下のdn は
;; dn: CN=Shun-ichi GOTO,OU=Mew,OU=Emacs,OU=Lisper,O=Programmers Inc.
;; 次のようになる。(uniqness のたのめ付加が存在しない場合の例)
;;  nil => Goto/Shun-ichi_GOTO
;;    1 => Goto/Shun-ichi_GOTO
;;    2 => Goto/Shun-ichi_GOTO/Mew
;;    3 => Goto/Shun-ichi_GOTO/Mew/Emacs
;;    4 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper
;;    5 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper/Programmers_Inc_
;;    6 => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper/Programmers_Inc_
;;    t => Goto/Shun-ichi_GOTO/Mew/Emacs/Lisper/Programmers_Inc_

;; 別の方法:

;; 何かしらの理由で dn を構成する情報が利用しにくいケースがある。例え
;; ば、dn がcn だけで構成され、その値が社員番号であるような場合、値は 
;; "CN=12345" となる。これをalias に利用すると、

;; goto/12345
;; goto/12346

;; といったように、一意性は保てるがユーザが区別しにくいものとなってし
;; まう。このような場合のために mew-ldap-alternative-dn-type-list とい
;; う変数を利用できる。これはデフォルトはnil であり、nil の場合は先に
;; 説明したような通常動作であるが、これにアトリビュート文字列のリスト
;; を与える事で、一意な文字列を作成するのにdn の構成要素の代わりに任意
;; のアトリビュートの値を利用する事が出来る。例えば以下のように設定し
;; た場合は sn, givenname, cn を利用する。

;; (setq mew-ldap-alternative-dn-type-list '("sn" "givenname" "cn"))


;;; キャッシュ -------------------------------------------------------

;; LDAPによる検索それ自体は高速ではあるが、本パッケージは外部プログラ
;; ムの起動により実現しているため、アドレス補完の目的においてはやはり
;; 少々時間がかかり、ストレスも感じる。そこで、1つのアドレス補完を完成
;; させる際には補完元文字列は前回のものと等しいか、あるいはそれに文字
;; を追加たもので行われることが多いことに着目し、LDAPの検索結果をキャッ
;; シュすることとする。たとえば "ab" で検索した結果は "abc"で検索した
;; 結果を内包していることは確実なので、"ab"の検索結果を再利用すること
;; で、"abc"の検索のための問い合わせ(コマンド起動)を省くことができる。も
;; ちろん、そのためには結果をそのまま再利用するのではなく、elisp上での
;; 絞り込み処理が行われる。このキャッシュ処理は変数mew-ldap-cache-use
;; にて制御する。デフォルトはtであり、キャッシュを利用する。

;; キャッシュされたデータはmew-ldap-search-cacheに保持され、その際の問
;; い合わせ文字列(たとえば"ab")と結果情報のconsである。次の補完処理時
;; に、キャッシュされた補完文字列が新しい補完文字列の先頭から一致して
;; いる場合はキャッシュを利用し、そうでない場合はキャッシュを破棄する。
;; 先の例で、"ab"での補完結果を保持したとして、次の"abc"の補完ではキャッ
;; シュを利用するが、"de"の補完ではキャッシュは破棄され新規に検索が行
;; われる。

;;; 一致結果の保持 ---------------------------------------------------

;; また、alias補完の結果として完全一致した場合は次の補完動作ではアドレ
;; スへの展開動作、そしてアドレスは名称つき表記への展開動作がありえる。
;; これはalias補完動作と連続で行われるとは限らないため、情報がキャッシュ
;; から消えてしまうと後の動作が行えない。そのためaliasが完全一致(sole
;; completion)した場合はその情報を別途保持しておくこととする。考え方と
;; してはmew-addrbook-alistに追加するのに等しいのだが、実際には別変数
;; mew-ldap-hit-cacheに保持し、補完動作時にmew-addrbook-alistに対して
;; 保持しているリストを合成して処理することにより実現する。

;;; ローカル言語表記(早い話が日本語名)の使用 -------------------------

;; cn は一般にフルネームであるため、Mewのaddrbookの４番目のエントリ
;; (name)として使用できる。cn:は通常英語表記であるが、ローカライズされ
;; た環境においては英語表記のほかにローカル言語表記(日本語名など)のも
;; のも存在する。nameエントリとしてどちらの表記を使用するかはオプショ
;; ン変数mew-ldap-use-local-lang-valueにて指定する。これがnon-nilであ
;; り、LDAPデータベースにローカル言語表記が存在し、utf-8 charset が使
;; 用できる環境の場合にのみ、ローカル言語表記が使用される。それ以外の
;; 場合は英語表記を利用する。


;;; TODO

;; * alias 展開後のキャッシングとaddress 展開の整合問題
;;   一度hit-cache に入ったalias が一意であるとは限らない事による問題。

;; * 認証のサポート

;; * XEmacs LDAP feature support

;; * 一意性とは別に意味として、補完の際に部署名を知りたいと思う。フル
;; ネームは知らないけど、部署はわかる、というケースがあるから。

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
