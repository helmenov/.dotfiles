(require 'bpe)
(setq bpe:account "kotaro1976@gmail.com")
(setq bpe:blog-name "時間泥棒")
(setq bpe:no-ask t)
(define-key org-mode-map (kbd "C-c C-p") 'bpe:post-article)
(setq bpe:use-real-post-when-updating t)
(define-key org-mode-map (kbd "C-c C-i") 'bpe:insert-template)
;; For Japanese, default is $LANG environment variable.
(setq bpe:lang "ja_JP.UTF-8")
