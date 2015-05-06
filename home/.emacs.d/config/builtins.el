;;== version check ==
;; diredから適切なバージョン管理システムの*-statusを起動
(defun dired-vc-status (&rest args)
  (interactive)
  (let ((path (find-path-in-parents (dired-current-directory)
                                    '(".svn" ".git"))))
    (cond ((null path)
           (message "not version controlled."))
          ((string-match-p "\\.svn$" path)
           (svn-status (file-name-directory path)))
          ((string-match-p "\\.git$" path)
           (magit-status (file-name-directory path))))))
;;(define-key dired-mode-map "V" 'dired-vc-status)

;; directoryの中にbase-names内のパスが含まれていたらその絶対パスを返す。
;; 含まれていなかったらdirectoryの親のディレクトリを再帰的に探す。
(defun find-path-in-parents (directory base-names)
  (or (find-if 'file-exists-p
               (mapcar (lambda (base-name)
                         (concat directory base-name))
                       base-names))
      (if (string= directory "/")
          nil
        (let ((parent-directory (substring directory 0 -1)))
          (find-path-in-parents parent-directory base-names)))))

;;== spell-chack ==
;;(setq ispell-program-name "/usr/bin/hunspell")
;(setq ispell-local-dictionary-alist
;  '((nil				; default (english.aff)
;     "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-B") nil iso-8859-1)
;    ("UK-xlg"				; english large version
;     "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-B" "-d" "UK-xlg") nil iso-8859-1)
;    ("US-xlg"				; american large version
;     "[A-Za-z]" "[^A-Za-z]" "[']" nil ("-B" "-d" "US-xlg") nil iso-8859-1)
;   )
;)

(eval-after-load "ispell"
  '(setq ispell-skip-region-alist (cons '("[^\000-\377]")
					ispell-skip-region-alist)))



;;== adding last ==
;; 個別の設定があったら読み込む
;; 2012-03-18
(condition-case err
    (load "config/builtins/local")
  (error))
