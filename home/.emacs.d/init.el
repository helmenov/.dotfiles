;;; ロードパス
;; ロードパスの追加
(setq load-path (append
		 '("~/.emacs.d/lisp")
		 '("/usr/local/share/emacs/site-lisp/ess-12.04-4/lisp")
		 '("/usr/local/share/emacs/site-lisp/mew")
		 '("/usr/local/share/emacs/site-lisp/yatex")
		 '("/usr/local/share/emacs/site-lisp/w3m")
		 '("/usr/share/emacs/site-lisp/a2ps")
		 load-path))

(set-language-environment 'Japanese)
(prefer-coding-system 'iso-2022-jp)
(prefer-coding-system 'shift_jis)
(prefer-coding-system 'utf-8)
(prefer-coding-system 'euc-jp)
;;(set-terminal-coding-system 'utf-8)
;;(setq file-name-coding-system 'utf-8)
;;(set-clipboard-coding-system 'utf-8)
(cond ((boundp 'buffer-file-coding-system)
       (setq buffer-file-coding-system 'utf-8))
      (t
       (setq default-buffer-file-coding-system 'utf-8)))

;;(setq coding-system-for-read 'utf-8-unix)
(set-default-coding-systems 'utf-8)
;;(set-keyboard-coding-system 'utf-8)
;;(set-buffer-file-coding-system 'euc-jp)
;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-command "platex")
 '(safe-local-variable-values (quote ((code . euc-jp) (code . utf-8)))))

;;(add-to-list 'package-archives
;;  '("melpa" . "http://melpa.milkbox.net/packages/") t)

;;====================================
;;; 折り返し表示ON/OFF
;;====================================
(defun toggle-truncate-lines ()
  "折り返し表示をトグル動作します."
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))

(global-set-key "\C-c\C-l" 'toggle-truncate-lines) ; 折り返し表示ON/OFF


;(setq visual-line-fringe-indicators '(t t))
;(global-visual-line-mode)

(load "~/.emacs.d/lisp/font.el")
;; == at last ==
;;;; 
;; 標準Elispの設定
(load "~/.emacs.d/config/builtins")

;; 非標準Elispの設定
(load "~/.emacs.d/config/packages")

;; 個別の設定があったら読み込む
;; 2012-02-15
(condition-case err
    (load "~/.emacs.d/config/local")
  (error))
(epa-file-disable)
(autoload 'alpaca-after-find-file "alpaca" nil t)
(add-hook 'find-file-hooks 'alpaca-after-find-file)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;(load ".emacs-mozc")
