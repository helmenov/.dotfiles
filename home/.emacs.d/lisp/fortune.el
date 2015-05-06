;;; fortune.el --- Fortune Report -*- coding: iso-2022-jp-2 -*-

;; Copyright (C) 2001-2008 Kenichi OKADA <okada@opaopa.org>

;; Author: Kenichi OKADA <okada@opaopa.org>

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; from http://fortune.yahoo.co.jp/12astro/index.html
;;
;; usage:
;;
;; (fortune-from-http "みずがめ座")
;; (fortune-from-http)
;; (fortune-from-http "うお座")
;;
;; (setq fortune-format '("今日の" seiza "は" ("総合運" . 1)))  ;; short version
;; (setq fortune-format '("今日の" seiza "は" ("総合運" . 3)))  ;; long version
;; (setq fortune-format '("今日の" seiza "は" ("恋愛運" . 1)))
;; (setq fortune-format '("今日の" seiza "は" ("金運" . 1)))
;; (setq fortune-format '("今日の" seiza "は" ("仕事運" . 1)))
;;
;; (setq fortune-format '("今日の" seiza "の運勢は" ("総合運" . 2) "です．"))
;; (setq fortune-format '("今日の" seiza "の運勢は" ("総合運" . 4) "です．"))
;; (setq fortune-format '("今日の" seiza "の運勢は" ("恋愛運" . 2) "です．"))
;; (setq fortune-format '("今日の" seiza "の運勢は" ("金運" . 2) "です．"))
;; (setq fortune-format '("今日の" seiza "の運勢は" ("仕事運" . 2) "です．"))
;;
;; (setq fortune-format '("今日の" seiza "のラッキーカラーは" ("カラー") "です．"))
;; (setq fortune-format '("今日の" seiza "のラッキーアイテムは" ("アイテム") "です．"))
;; その他 "アイテム" "カラー" "スポット" "ナンバー" "レジャー" "アルファベット" "グルメ" "方位"
;;
;; (setq fortune-format '(month "月" day "日の" seiza "の運勢は" ("総合運" . 2) "です．"))
;; (setq fortune-format '(month "月" day "日の" seiza "の運勢は" ("総合運" . 4) "です．"))
;; (setq fortune-format '(month "月" day "日の" seiza "の運勢は" ("総合運" . 3)))
;; year month day seiza が利用可能


;;; Code:

(require 'poe)
(require 'emu)
(require 'product)
(require 'apel-ver)
(require 'timezone)

;; compile warning

(eval-when-compile
  (defvar mule-version)
  (defvar nemacs-version)
  (defvar emacs-beta-version)
  (defvar emacs-patch-level)
  (defvar xemacs-codename)
  (defvar xemacs-betaname)
  (defvar utf-2000-version)
  (defun-maybe Meadow-version ()))

(product-provide 'fortune-version
  (product-define "Fortune" nil '(0 8)))

(defvar fortune-insert-user-agent nil)

(defvar fortune-server "fortune.yahoo.co.jp")
(defvar fortune-server-top "/12astro/")
(defvar fortune-port 80)
(defvar fortune-coding-system (static-if (boundp 'MULE) '*euc-japan* 'euc-japan))

;; for proxy.
(defvar fortune-proxy-server nil)
(defvar fortune-proxy-port 3128)

(defvar fortune-debug nil)
(defvar fortune-timeout 120)
(defvar fortune-cache nil)

(defvar fortune-fetch-confirm nil)
(defvar fortune-sleep nil)
(defvar fortune-sleep-time 1800)
(defvar fortune-ignore-error nil)

(defvar fortune-seiza "みずがめ座"
  "* Default place for `fortune-from-http'")

(defvar fortune-format
  '("今日の" seiza "は" ("恋愛運" . 1)))

(defvar fortune-url-alist
  '(("おひつじ座" . "aries.html")
    ("おうし座" . "taurus.html")
    ("ふたご座" . "gemini.html")
    ("かに座" . "cancer.html")
    ("しし座" . "leo.html")
    ("おとめ座" . "virgo.html")
    ("てんびん座" . "libra.html")
    ("さそり座" . "scorpio.html")
    ("いて座" . "sagittarius.html")
    ("やぎ座" . "capricorn.html")
    ("みずがめ座" . "aquarius.html")
    ("うお座" . "pisces.html")))

(defvar fortune-get-list
  '("恋愛運" "金運" "仕事運"))
(defvar fortune-get-list-2
  '("アイテム" "カラー" "スポット" "ナンバー" "レジャー" "アルファベット" "グルメ" "方位"))
(defvar fortune-get-list-3
  '("総合運"))

(defun fortune-server ()
  (or fortune-proxy-server
      fortune-server))

(defun fortune-port ()
  (or (and fortune-proxy-server
	   fortune-proxy-port)
      fortune-port))

(defsubst fortune-today ()
  (format-time-string "%Y%m%d" (current-time)))

(defsubst fortune-url (constellation)
  (format "%s/%s"
	  (fortune-today)
	  (or
	   (cdr (assoc constellation fortune-url-alist))
	   (error "%s: そんな星座はありません．" constellation))))

(defsubst fortune-current-time ()
  (let* ((curtime (current-time))
	 (curtime (+ (* (nth 0 curtime)
			(float 65536)) (nth 1 curtime))))
    curtime))

(defsubst fortune-read-cache (seiza)
  (assoc
   (fortune-url seiza)
   fortune-cache))

(defun fortune-set-cache (seiza item val)
  (let ((url (fortune-url seiza))
	alist)
    (if (and val
	     (null (and (setq alist (assoc url fortune-cache))
			(assoc item alist))))
	(if alist
	    (setcdr alist (append (cdr alist) (list (cons item val))))
	  (setq fortune-cache
		(append
		 fortune-cache
		 (list
		  (list url (cons item val)))))))))

(defun fortune-search-value (item)
  (let ((case-fold-search t)
	score comment)
    (save-excursion
      (and (re-search-forward (concat "alt=\"" item "\"") nil t)
	   (re-search-forward "alt=\"\\([0-9]*点中[0-9]*点\\)" nil t)
	   (setq score (match-string 1))
	   (re-search-forward "<p>\\([^<]*\\)" nil t)
	   (setq comment (match-string 1)))
	   (list comment score))))

(defun fortune-search-value-2 (item)
  (let ((case-fold-search t)
	comment)
    (save-excursion
      (and (re-search-forward (concat "alt=\"" item "\"" ) nil t)
	   (re-search-forward (concat "alt=\"" item "\">\\([^<]*\\)<") nil t)
	   (setq comment (match-string 1))
	   (list comment)))))

(defun fortune-search-value-3 (item)
  (let ((case-fold-search t)
	score score2 comment comment2)
    (save-excursion
      (and (re-search-forward (concat "alt=\"" item "\"") nil t)
	   (re-search-forward "alt=\"\\([0-9]*点中[0-9]*点\\)" nil t)
	   (setq score (match-string 1))
	   (re-search-forward "<p>\\([0-9]*点\\)</p>" nil t)
	   (setq score2 (match-string 1))
	   (re-search-forward "<dt>\\([^<]*\\)" nil t)
	   (setq comment (match-string 1)))
	   (re-search-forward "<dd>\\([^<]*\\)" nil t)
	   (setq comment2 (match-string 1))
	   (list comment score comment2 score2))))

(defun fortune-read-seiza ()
  (completing-read "星座: "
		   (mapcar (lambda (x) (list (car x))) fortune-url-alist)
		   nil t fortune-seiza))

(defun fortune-compose (seiza data)
  (mapconcat (function
	      (lambda (elt)
		(cond ((stringp elt) elt)
		      ((listp elt)
		       (nth
			(or (cdr elt) 1)
			(assoc (car elt) data)))
		      ((eq elt 'seiza)
		       seiza)
		      ((eq elt 'year)
		       (format-time-string "%Y" (current-time)))
		      ((eq elt 'month)
		       (format-time-string "%m" (current-time)))
		      ((eq elt 'day)
		       (format-time-string "%d" (current-time))))))
	     fortune-format ""))

(defun fortune-sleep (&optional msg)
  (interactive)
  (if (y-or-n-p (format "Fortune: %s Sleep %d seconds? "
			(or msg "Cannot connect.")
			fortune-sleep-time))
      (progn
	(setq fortune-sleep (+ (fortune-current-time)
			       fortune-sleep-time))
	(message "Fortune: Connection sleeping")))
  (if (null fortune-ignore-error)
      (ding)))

(defun fortune-sleep-p ()
  (and fortune-sleep
       (> fortune-sleep (fortune-current-time))))

(defun fortune-force-fetch-from-http (seiza &optional interactive)
  (if (and (null (fortune-sleep-p))
	   (or (null interactive)
	       (null fortune-fetch-confirm)
	       (y-or-n-p "Fortune: Cache miss. Fetch from http? ")))
      (catch 'done
	(let (buf connection ret-val get-list)
	  (save-excursion
	    (setq buf (generate-new-buffer "*Fortune report*"))
	    (unwind-protect
		(setq connection
		      (as-binary-process
		       (open-network-stream "*Fortune from http*"
					    buf
					    (fortune-server)
					    (fortune-port))))
	      (if (null connection)
		  (progn
		    (if (and buf (null fortune-debug)) (kill-buffer buf))
		    (fortune-sleep)
		    (throw 'done nil))))
	    (unwind-protect
		(progn
		  (process-send-string
		   connection
		   (format "GET http://%s:%s%s%s HTTP/1.0\r\n"
			   fortune-server
			   (number-to-string fortune-port)
			   fortune-server-top
			   (fortune-url seiza)))
		  (process-send-string
		   connection
		   (format "Host: %s:%s\r\n"
			   fortune-server
			   (number-to-string fortune-port)))
		  (if fortune-insert-user-agent
		      (process-send-string
		       connection
		       (format "User-Agent: %s\r\n"
			       (fortune-version))))
		  (process-send-string
		   connection "\r\n")
		  (set-buffer buf)
		  (setq buffer-read-only nil)
		  (setq case-fold-search t)
		  (goto-char (point-min))
		  (while (not (search-forward "</body>" nil t))
		    (unwind-protect
			(setq ret-val
			      (accept-process-output connection fortune-timeout))
		      (if (null ret-val)
			  (progn
			    (if (and buf (null fortune-debug))
				(kill-buffer buf))
			    (if connection (delete-process connection))
			    (fortune-sleep)
			    (throw 'done nil))))
		    (goto-char (point-min)))
		  (decode-coding-region (point-min)(point-max)
					fortune-coding-system)
		  (goto-char (point-min))
		  (setq get-list fortune-get-list)
		  (while (car get-list)
		    (fortune-set-cache seiza
				       (car get-list)
				       (fortune-search-value (car get-list)))
		    (setq get-list (cdr get-list)))
		  (setq get-list fortune-get-list-2)
		  (while (car get-list)
		    (fortune-set-cache seiza
				       (car get-list)
				       (fortune-search-value-2 (car get-list)))
		    (setq get-list (cdr get-list)))
		  (setq get-list fortune-get-list-3)
		  (while (car get-list)
		    (fortune-set-cache seiza
				       (car get-list)
				       (fortune-search-value-3 (car get-list)))
		    (setq get-list (cdr get-list))))
	      (if (and buf (null fortune-debug))
		  (kill-buffer buf))
	      (if connection (delete-process connection))))))))

(defun fortune-from-http (&optional seiza offline)
  "* If SEIZA is nil, the default value `fortune-seiza' instead.
If OFFLINE is nil, don't fetch fortune, only use cache. "
  (interactive (if (or current-prefix-arg
		       (null fortune-seiza))
		   (list (fortune-read-seiza))))
  (let ((ret-val
	 (fortune-from-http-subr seiza offline)))
    (if (and (null ret-val)
	     (null offline)
	     (null (fortune-sleep-p)))
	(fortune-sleep "Cannot get valid information."))
    (if (interactive-p)
	(message ret-val)
      ret-val)))

(defun fortune-from-http-subr (seiza &optional offline)
  (let ((seiza (or seiza fortune-seiza))
	ret-val)
    (setq ret-val
	  (or (fortune-read-cache seiza)
	      (and (null offline)
		   (progn
		     (fortune-force-fetch-from-http seiza t)
		     (fortune-read-cache seiza)))))
    (if ret-val
	    (fortune-compose seiza ret-val))))

(defun fortune-remove-regexp-in-string (regexp string)
  (cond ((not (string-match regexp string))
	 string)
	((let ((str nil)
	       (ostart 0)
	       (oend   (match-beginning 0))
	       (nstart (match-end 0)))
	   (setq str (concat str (substring string ostart oend)))
	   (while (string-match regexp string nstart)
	     (setq ostart nstart)
	     (setq oend   (match-beginning 0))
	     (setq nstart (match-end 0))
	     (setq str (concat str (substring string ostart oend))))
	   (concat str (substring string nstart))))))

(defun fortune-narrow-to-header ()
  "Narrow to the message header."
  (let (case-fold-search)
    (narrow-to-region
     (goto-char (point-min))
     (goto-char (if (re-search-forward
		     (format "^$\\|^%s$"
			     (regexp-quote mail-header-separator))
		     nil t)
		    (match-beginning 0)
		  (point-max))))))

(defun fortune-replace-header (&optional seiza offline)
  (interactive (list (fortune-read-seiza)))
  (let* ((fortune (fortune-from-http seiza offline))
	 case-fold-search)
    (if fortune
	(save-excursion
	  (save-restriction
	    (fortune-narrow-to-header)
	    (goto-char (point-min))
	    (while (re-search-forward "^X-Fortune:.*$" nil t)
	      (delete-region (1- (match-beginning 0)) (match-end 0)))
	    (goto-char (point-max))
	    (insert "X-Fortune: " fortune "\n"))))))

(defun fortune-insert-header (&optional seiza offline)
  (interactive (if (or current-prefix-arg
		       (null fortune-seiza))
		   (list (fortune-read-seiza))))
  (let ((fortune (fortune-from-http seiza offline)))
    (if fortune
	(save-excursion
	  (save-restriction
	    (fortune-narrow-to-header)
	    (goto-char (point-max))
	    (insert "X-Fortune: " fortune "\n"))))))

(defconst fortune-environment-version
  (concat
   (if (fboundp 'apel-version)
       (concat (apel-version) " ")
     nil)
   (if (featurep 'xemacs)
       (concat (cond
		((featurep 'utf-2000)
		 (concat "UTF-2000-MULE/" utf-2000-version))
		((featurep 'mule) "MULE"))
	       " XEmacs"
	       (if (string-match "^[0-9]+\\(\\.[0-9]+\\)" emacs-version)
		   (concat
		    "/"
		    (substring emacs-version 0 (match-end 0))
		    (cond ((and (boundp 'xemacs-betaname)
				xemacs-betaname)
			   ;; It does not exist in XEmacs
			   ;; versions prior to 20.3.
			   (concat " " xemacs-betaname))
			  ((and (boundp 'emacs-patch-level)
				emacs-patch-level)
			   ;; It does not exist in FSF Emacs or in
			   ;; XEmacs versions earlier than 21.1.1.
			   (format " (patch %d)" emacs-patch-level))
			  (t ""))
		    " (" xemacs-codename ") ("
		    system-configuration ")")
		 " (" emacs-version ")"))
     (let ((ver (if (string-match "\\.[0-9]+$" emacs-version)
		    (substring emacs-version 0 (match-beginning 0))
		  emacs-version)))
       (if (featurep 'mule)
	   (if (boundp 'enable-multibyte-characters)
	       (concat "Emacs/" ver
		       " (" system-configuration ")"
		       (if enable-multibyte-characters
			   (concat " MULE/" mule-version)
			 " (with unibyte mode)")
		       (if (featurep 'meadow)
			   (let ((mver (Meadow-version)))
			     (if (string-match "^Meadow-" mver)
				 (concat " Meadow/"
					 (substring mver
						    (match-end 0))))))
		       (if (boundp 'NEMACS)
			   (let ((nemacs-version
				  (condition-case ()
				      (eval '(nemacs-version))
				    (error ""))))
			     (when (string-match
				    "Nemacs version \\([^ ]*\\)"
				    nemacs-version)
			       (setq nemacs-version
				     (match-string 1 nemacs-version)))
			     (concat " NEmacs/" nemacs-version))))
	     (concat "MULE/" mule-version
		     " (based on Emacs " ver ")"))
	 (concat "Emacs/" ver " (" system-configuration ")"))))))

(defun fortune-version ()
  "Print Fortune version."
  (interactive)
  (let ((product-info
	 (concat (product-string-1 "Fortune" t)
		 " " fortune-environment-version)))
    (if (interactive-p)
	(message "%s" product-info)
      product-info)))

(provide 'fortune)

;;; fortune.el ends here
