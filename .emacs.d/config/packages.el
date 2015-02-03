;;=========================================================================
;;= bundle.el
;;=========================================================================
(add-to-list 'load-path "/home/kotaro/src/E/emacs-bundle/emacs-deferred/")
(load "/home/kotaro/src/E/emacs-bundle/bundle.el")

;;=========================================================================
;;= el-get
;;=========================================================================
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil t)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (end-of-buffer)
    (eval-print-last-sexp)))
;; レシピ置き場
(add-to-list 'el-get-recipe-path
             (concat (file-name-directory load-file-name) "/el-get/recipes"))
;; 追加のレシピ置き場
(add-to-list 'el-get-recipe-path
             "~/.emacs.d/config/el-get/local-recipes")

;; == el-get-ext : el-get拡張 ==
(load "~/.emacs.d/packages/2010-12-09-095707.el-get-ext.el")
;; ;; 初期化ファイルのワイルドカードを指定する
;;(setq el-get-init-files-pattern "~/emacs/init.d/[0-9]*.el")
;(setq el-get-sources (el-get:packages))
;(el-get)
(el-get 'sync)


;; == auto-install ==
(el-get 'sync '(auto-install))
;;(add-to-list 'load-path "~/.emacs.d/auto-install/auto-install/")
(require 'auto-install)
; wget を使わない場合
;(setq auto-install-use-wget nil)
; proxy 対応関数
(defun auto-install-network-available-p (host)
   (if auto-install-use-wget
       (eq (call-process auto-install-wget-command nil nil nil "-q" "--spider" host) 0)
     (let* ((proxy (cdr (assoc "http" url-proxy-services)))
 	   (host-port (if proxy (split-string proxy ":")))
 	   (host (or (car host-port) host))
 	   (port (or (cadr host-port) "80"))))
       (ignore-errors (ffap-machine-p host port))))
(setq auto-install-directory "~/.emacs.d/auto-install/")
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup)             ; 互換性確保

;; == el-get/twittering-mode ==
(setq twittering-allow-insecure-server-cert t)
(el-get 'sync '(twittering-mode))
(el-get 'sync '(revive))
;;(add-to-list 'load-path "~/.emacs.d/auto-install/twittering-mode/")
;;(add-to-list 'load-path "~/.emacs.d/packages/revive/")
(require 'twittering-mode)
(setq twittering-use-master-password t)
;(setq twittering-icon-mode t)             ;;アイコンを表示
(setq twittering-timer-interval 60)       ;;60秒ごとにタイムラインを更新する
(setq browse-url-browser-function 
      'browse-url-generic 
;;      'w3m-browse-url
)
(setq browse-url-generic-program "google-chrome");;リンクを開くウェブブラウザをGoogleChromeにする！！！

(setq twittering-tinyurl-service 
      'hane.jp
;;      'migre.me
)
(require 'revive)
(twittering-setup-revive)
(setq twittering-proxy-use t)
(setq twittering-proxy-server "127.0.0.1")
(setq twittering-proxy-port 8123)
(setq twittering-connection-type-order '(curl wget native))
(setq twittering-status-format "%i @%s / %S %p: \n %T\n [%@]%r %R %f%L\n")
(setq twittering-retweet-format " RT @%s: %t")
(add-hook 'twittering-new-tweets-hook (lambda ()
   (let ((n twittering-new-tweets-count))
     (start-process "twittering-notify" nil "notify-send"
                    "-i" "/usr/share/pixmaps/gnome-emacs.png"
                    "New tweets"
                    (format "You have %d new tweet%s"
                            n (if (> n 1) "s" ""))))))


;;== Anything.el ==
;;(add-to-list 'load-path "~/.emacs.d/auto-install/anything/")
(let ((original-browse-url-browser-function browse-url-browser-function))
  (el-get 'sync '(anything))
  (require 'anything-config)
  (anything-set-anything-command-map-prefix-key
   'anything-command-map-prefix-key "C-c C-<SPC>")
  (define-key global-map (kbd "C-x b") 'anything-for-files)
  (define-key global-map (kbd "C-x g") 'anything-imenu) ; experimental
  (define-key global-map (kbd "M-y") 'anything-show-kill-ring)
  (define-key anything-map (kbd "C-z") nil)
  (define-key anything-map (kbd "C-l") 'anything-execute-persistent-action)
  (define-key anything-map (kbd "C-o") nil)
  (define-key anything-map (kbd "C-M-n") 'anything-next-source)
  (define-key anything-map (kbd "C-M-p") 'anything-previous-source)
  (setq browse-url-browser-function original-browse-url-browser-function))

;; text-translator
(add-to-list 'load-path "~/.emacs.d/auto-install/text-translator")
(require 'text-translator-load)
;; グローバルキーの設定例
(global-set-key "\C-x\M-t" 'text-translator)
(global-set-key "\C-x\M-T" 'text-translator-all)
;; 自動選択に使用する関数を設定
(setq text-translator-auto-selection-func
      'text-translator-translate-by-auto-selection-enja)
;; グローバルキーを設定
(global-set-key "\C-xt" 'text-translator-translate-by-auto-selection)
;; popup
;(require 'text-translator-popup)
;(setq text-translator-display-function 'text-translator-popup-display)
;; pos-tip
(el-get 'sync '(pos-tip))
(require 'text-translator-pos-tip)
(setq text-translator-display-function 'text-translator-pos-tip-display)
(setq text-translator-proxy-server "localhost")
(setq text-translator-proxy-port   8123)
(setq text-translator-default-engine "excite.co.jp_enja")

(add-to-list 'load-path "~/.emacs.d/packages/google-contacts-mew")
(load "~/.emacs.d/packages/mew")

;;  (el-get 'sync 'cp5022x)
(add-to-list 'load-path "~/.emacs.d/packages/")
(require 'cp5022x)
  (define-coding-system-alias 'iso-2022-jp 'cp50220)
  (define-coding-system-alias 'euc-jp 'cp51932)


(load "~/.emacs.d/lisp/matlab-mode.el")

(add-hook 'skk-load-hook
	  (lambda ()
	    (require 'context-skk)))

(autoload 'nitaconv-region "nitaconv" nil t)
(global-set-key "\C-cN" 'nitaconv-region)

(require 'ess-site)

;; yatex-mode
;; // el-getに無いのでdpkgインストール
(setq auto-mode-alist
          (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
      (autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq latex-command "uplatex")
(setq bibtex-command "pbibtex")

;; auctex
;;(load-file "/home/kotaro/.emacs.d/packages/auctex_config.el")

;; w3m
(require 'w3m-load)

;; wordnik.el
;(require 'wordnik)
;(setq wordnik-api-key "1f6165e74d2c55eb3710005233401de9bba9c1c4b7ccdeab7"); from registration
;(define-key global-map (kbd "C-c ?") 'wordnik-lookup-word)

;; howm
(add-to-list 'load-path "/usr/share/emacs/site-lisp/howm/")
(setq howm-menu-lang 'ja)
(require 'howm-mode)
;; リンクを TAB で辿る
(eval-after-load "howm-mode"
  '(progn
     (define-key howm-mode-map [tab] 'action-lock-goto-next-link)
     (define-key howm-mode-map [(meta tab)] 'action-lock-goto-previous-link)))
;; 「最近のメモ」一覧時にタイトル表示
(setq howm-list-recent-title t)
;; 全メモ一覧時にタイトル表示
(setq howm-list-all-title t)
;; メニューを 2 時間キャッシュ
(setq howm-menu-expiry-hours 2)

;; howm の時は auto-fill で
(add-hook 'howm-mode-on-hook 'auto-fill-mode)

;; RET でファイルを開く際, 一覧バッファを消す
;; C-u RET なら残る
(setq howm-view-summary-persistent nil)

;; メニューの予定表の表示範囲
;; 10 日前から
(setq howm-menu-schedule-days-before 10)
;; 3 日後まで
(setq howm-menu-schedule-days 3)

;; howm のファイル名
;; 以下のスタイルのうちどれかを選んでください
;; で，不要な行は削除してください
;; 1 メモ 1 ファイル (デフォルト)
;;(setq howm-file-name-format "%Y/%m/%Y-%m-%d-%H%M%S.howm")
;; 1 日 1 ファイルであれば
(setq howm-file-name-format "%Y/%m/%Y-%m-%d.howm")

(setq howm-view-grep-parse-line
      "^\\(\\([a-zA-Z]:/\\)?[^:]*\\.howm\\):\\([0-9]*\\):\\(.*\\)$")
;; 検索しないファイルの正規表現
(setq
 howm-excluded-file-regexp
 "/\\.#\\|[~#]$\\|\\.bak$\\|/CVS/\\|\\.doc$\\|\\.pdf$\\|\\.ppt$\\|\\.xls$")

;; いちいち消すのも面倒なので
;; 内容が 0 ならファイルごと削除する
(if (not (memq 'delete-file-if-no-contents after-save-hook))
    (setq after-save-hook
          (cons 'delete-file-if-no-contents after-save-hook)))
(defun delete-file-if-no-contents ()
  (when (and
         (buffer-file-name (current-buffer))
         (string-match "\\.howm" (buffer-file-name (current-buffer)))
         (= (point-min) (point-max)))
    (delete-file
     (buffer-file-name (current-buffer)))))

;; http://howm.sourceforge.jp/cgi-bin/hiki/hiki.cgi?SaveAndKillBuffer
;; C-cC-c で保存してバッファをキルする
(defun my-save-and-kill-buffer ()
  (interactive)
  (when (and
         (buffer-file-name)
         (string-match "\\.howm"
                       (buffer-file-name)))
    (save-buffer)
    (kill-buffer nil)))
(eval-after-load "howm"
  '(progn
     (define-key howm-mode-map
       "\C-c\C-c" 'my-save-and-kill-buffer)))
(setq howm-keyword-file "~/howm/.howm-keys") ;; デフォルトは ~/.howm-keys
(setq howm-menu-reminder-separators
      '(
        (-1  . "━━━━━━━今日↓↑超過━━━━━━━")
        (0   . "━━━━━━━予定↓━━━━━━━")
        (3   . "━━━━━━━もっと先↓↑3日後まで━━━━━━━")
        (nil . "━━━━━━━todo↓━━━━━━━") ;予定とtodoの境
        ))
(setq dired-bind-jump nil)

(load-file "/home/kotaro/.emacs.d/.emacs.c-sig")

(load-file "/home/kotaro/.emacs.d/config/.emacs_bpe.el")

;; == at last ==
;; 個別の設定があったら読み込む
;; 2012-03-15
(condition-case err
    (load "config/packages/local")
  (error))
