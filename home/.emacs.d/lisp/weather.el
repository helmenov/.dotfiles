;;; weather.el --- Weather Report -*- coding: iso-2022-3-compatible -*-

;; Copyright (C) 1999-2003 Kenichi OKADA <okada@opaopa.org>

;; Author: Kenichi OKADA <okada@opaopa.org>
;;	Yuuichi Teranishi <teranisi@gohome.org>

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

;; from http://www.imoc.co.jp/week.htm
;; changed to http://www.imocwx.com/week.htm (200511)
;;
;; usage:
;;
;; (weather-from-http "京都府南部")
;; (weather-from-http "京都府南部" t)
;; (weather-from-http "兵庫県南部")
;; (weather-from-http '("京都府南部" "京都府"))

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

(product-provide 'weather-version
  (product-define "Weather" nil '(0 32)))

(defvar weather-insert-user-agent nil)

(defvar weather-server "www.imocwx.com")
(defvar weather-port 80)
(defvar weather-coding-system (static-if (boundp 'MULE) '*sjis* 'shift_jis))

;; for proxy.
(defvar weather-proxy-server nil)
(defvar weather-proxy-port 3128)

(defvar weather-debug nil)
(defvar weather-timeout 20)
(defvar weather-cache nil)

(defvar weather-fetch-confirm nil)
(defvar weather-sleep nil)
(defvar weather-sleep-time 1800)
(defvar weather-ignore-error nil)
(defvar weather-allow-old t)

(defvar weather-where nil
  "* Default place for `weather-from-http'")

(defvar weather-message-1 "明日の")
(defvar weather-message-1a "今日の")
(defvar weather-message-2 "は")
(defvar weather-message-3 "です")
(defvar weather-message-where nil)

(defvar weather-replace (find-coding-system 'iso-2022-jp-3))
(defvar weather-replace-alist
  '(("晴" . "☀")
    ("曇" . "☁")
    ("雨" . "☂")
    ("雪" . "☃")))

(defvar weather-template nil)
(defvar weather-template-alist
  '(("/week/week_0.htm" . ("宗谷" "網走" "北見" "紋別" "上川" "留萌" "釧路" "根室" "十勝" "石狩" "空知" "後志" "胆振" "日高" "渡島" "桧山"))
    ("/week/week_1.htm" . ("青森" "岩手" "秋田" "宮城" "山形" "福島"))
    ("/week/week_2.htm" . ("東京" "栃木" "群馬" "埼玉" "伊豆諸島" "千葉" "神奈川" "茨城"))
    ("/week/week_3.htm" . ("新潟" "富山" "石川" "福井" "長野" "山梨" "静岡" "岐阜" "愛知"))
    ("/week/week_4.htm" . ("三重" "滋賀" "京都" "大阪" "奈良" "和歌山" "兵庫"))
    ("/week/week_5.htm" . ("岡山" "広島" "鳥取" "島根" "山口" "香川" "徳島" "愛媛" "高知"))
    ("/week/week_6.htm" . ("福岡" "佐賀" "長崎" "厳原" "大分" "熊本" "宮崎" "鹿児島" "名瀬" "那覇" "南大東島" "宮古島" "石垣島"))))

(defun weather-server ()
  (or weather-proxy-server
      weather-server))

(defun weather-port ()
  (or (and weather-proxy-server
	   weather-proxy-port)
      weather-port))

(defun weather-template (where)
  (let ((talist weather-template-alist)
	result places contained)
    (while (and where talist (not result))
      (setq places (cdr (car talist)))
      (if (progn
	    (setq contained nil)
	    (while (and places (not contained))
	      (if (string-match (car places) where)
		  (setq contained t)
		(setq places (cdr places))))
	    contained)
	  (setq result (car (car talist)))
	(setq talist (cdr talist))))
    result))

(defun weather-replace (text)
  (let ((repl weather-replace-alist))
    (while repl
      (setq text (weather-replace-in-string text
					    (car (car repl))
					    (cdr (car repl))))
      (setq repl (cdr repl)))
    text))

(defmacro weather-match-string (pos string)
  "Substring POSth matched string."
  (` (substring (, string) (match-beginning (, pos)) (match-end (, pos)))))

(defun weather-valid-date ()
  (let (date hour)
    (setq date (string-to-number (format-time-string "%j" (current-time))))
    (setq hour (string-to-number (format-time-string "%k" (current-time))))
    (cond ((>= hour 17)
	   (cons date 17))
	  ((>= hour 11)
	   (cons date 11))
	  (t
	   (cons (- date 1) 17)))))

(defsubst weather-current-time ()
  (let* ((curtime (current-time))
	 (curtime (+ (* (nth 0 curtime)
			(float 65536)) (nth 1 curtime))))
    curtime))

(defsubst weather-fix-date (date)
  (let ((cur-date
	 (string-to-number (format-time-string "%e" (current-time)))))
    (+ (- date cur-date)
     (string-to-number (format-time-string "%j" (current-time))))))

(defsubst weather-today ()
  (> 11 (string-to-number (format-time-string "%k" (current-time)))))

(defun weather-read-cache (where)
  (if weather-allow-old
      (weather-read-cache-subr-2 where)
    (weather-read-cache-subr-1 where)))

(defun weather-read-cache-subr-1 (where)
  (let (alist ali)
    (catch 'done
      (setq alist weather-cache)
      (while (setq ali (car alist))
	(if (>=
	     (+ (* (caar ali) 100) (cdar ali))
	     (+ (* (car (weather-valid-date)) 100) (cdr (weather-valid-date))))
	    (throw 'done (cdr (assoc where ali)))
	  (setq alist (cdr alist))))
      nil)))

(defun weather-read-cache-subr-2 (where)
  (let ((latest (car weather-cache))
	(alist (cdr weather-cache))
	ali)
    (while (setq ali (car alist))
      (if (>=
	   (+ (* (caar ali) 100) (cdar ali))
	   (+ (* (caar latest) 100) (cdar latest)))
	  (setq latest ali))
      (setq alist (cdr alist)))
    (cdr (assoc where latest))))

(defun weather-set-cache (where date val)
  (let (alist)
    (unless (and (setq alist (assoc date weather-cache))
		 (assoc where alist))
      (if alist
	  (setcdr alist (append (cdr alist) (list (cons where val))))
	(setq weather-cache
	      (append
	       weather-cache
	       (list
		(list date (cons where val)))))))))

(defun weather-compose (where val)
  (format "%s%s%s%s%s"
	  (if (weather-today)
	      weather-message-1a
	      weather-message-1)
	  (or weather-message-where
	      where)
	  weather-message-2
	  (weather-remove-regexp-in-string
	   "[　 ]" val)
	  weather-message-3))

(defun weather-sleep (&optional msg)
  (interactive)
  (if (y-or-n-p (format "Weather: %s Sleep %d seconds? "
			(or msg "Cannot connect.")
			weather-sleep-time))
      (progn
	(setq weather-sleep (+ (weather-current-time)
			       weather-sleep-time))
	(message "Weather: Connection sleeping")))
  (if (null weather-ignore-error)
      (ding)))

(defun weather-sleep-p ()
  (and weather-sleep
       (> weather-sleep (weather-current-time))))

(defun weather-force-fetch-from-http (where &optional interactive)
  (if (and (null (weather-sleep-p))
	   (or (null interactive)
	       (null weather-fetch-confirm)
	       (y-or-n-p "Weather: Cache miss. Fetch from http? ")))
      (catch 'done
	(let (buf connection ret-val date)
	  (save-excursion
	    (setq buf (generate-new-buffer "*Weather report*"))
	    (unwind-protect
		(setq connection
		      (as-binary-process
		       (open-network-stream "*Weather from http*"
					    buf
					    (weather-server)
					    (weather-port))))
	      (if (null connection)
		  (progn
		    (if (and buf (null weather-debug))
			(kill-buffer buf))
		    (weather-sleep)
		    (throw 'done nil))))
	    (unwind-protect
		(progn
		  (process-send-string
		   connection
		   (format "GET http://%s:%s%s HTTP/1.0\r\n"
			   weather-server
			   (number-to-string weather-port)
			   (or (weather-template where)
			       weather-template
			       (error "No such place \"%s\". See weather.el."
				      where))))
		  (process-send-string
		   connection
		   (format "Host: %s:%s\r\n"
			   weather-server
			   (number-to-string weather-port)))
		  (if weather-insert-user-agent
		      (process-send-string
		       connection
		       (format "User-Agent: %s\r\n"
			       (weather-version))))
		  (process-send-string
		   connection "\r\n")
		  (set-buffer buf)
		  (setq buffer-read-only nil)
		  (setq case-fold-search t)
		  (goto-char (point-min))
		  (while (not (search-forward "</body>" nil t))
		    (unwind-protect
			(setq ret-val
			      (accept-process-output connection weather-timeout))
		      (if (null ret-val)
			  (progn
			    (if (and buf (null weather-debug))
				(kill-buffer buf))
			    (if connection (delete-process connection))
			    (weather-sleep)
			    (throw 'done nil))))
		    (goto-char (point-min)))
		  (decode-coding-region (point-min)(point-max)
					weather-coding-system)
		  (goto-char (point-min))
		  (setq date
			(if (re-search-forward
			     "週間天気予報[^0-9]*[ 0-9]+月\\([ 0-9]+\\)日\\([ 0-9]+\\)時" nil t)
			    (cons (weather-fix-date
				   (string-to-number (match-string 1)))
				  (string-to-number (match-string 2)))
			  (error "Weather: 発表時間を見付けられません．")))
		  (while (re-search-forward
			  "<TH VALIGN=\"?TOP\"? ALIGN=\"?LEFT\"?>\\([^<]+\\)</TH>" nil t)
		    (setq ret-val (match-string 1))
		    (re-search-forward "<TH VALIGN=\"?TOP\"? ALIGN=\"?CENTER\"?>" nil t)
		    (re-search-forward "\\(<FONT COLOR=[^>]*>\\)?\\([^<]*\\)"
				       nil t)
		    (weather-set-cache ret-val date
				       (match-string 2))))
	      (if (and buf (null weather-debug)) (kill-buffer buf))
	      (if connection (delete-process connection))))))))

(defun weather-from-http (&optional where offline)
  "* If WHERE is nil, the default value `weather-where' instead.
If OFFLINE is nil, don't fetch weather, only use cache. "
  (interactive (if (or current-prefix-arg
		       (null weather-where))
		   (list (read-from-minibuffer "Where: "
					       weather-where))))
  (let* ((where (or where weather-where))
	 (ret-val
	  (if (and where (listp where))
	     (weather-from-http-list where offline)
	   (weather-from-http-subr where offline))))
    (if (and (null ret-val)
	     (null offline)
	     (null (weather-sleep-p)))
	(weather-sleep "Cannot get valid information."))
    (if (interactive-p)
	(message ret-val)
      ret-val)))

(defun weather-from-http-subr (where &optional offline)
  (let (ret-val)
    (setq ret-val
	  (or (weather-read-cache where)
	      (and (null offline)
		   (progn
		     (weather-force-fetch-from-http where t)
		     (weather-read-cache where)))))
    (if ret-val
	(progn
	  (or (null weather-replace)
	      (setq ret-val (weather-replace ret-val))
	      (error "Weather: fail replace char."))
	  (weather-compose where ret-val)))))

(defun weather-from-http-list (where-list &optional offline)
  (catch 'done
    (let (where wlist ret)
      ;; for cache
      (setq wlist where-list)
      (while (setq where (car wlist))
	(if (setq ret (weather-from-http-subr where t))
	    (throw 'done ret))
	(setq wlist (cdr wlist)))
      (if offline
	  (throw 'done nil))
      (if (null (weather-sleep-p))
	  (progn
	    (setq wlist where-list)
	    (while (setq where (car wlist))
	      (if (setq ret (weather-from-http-subr where))
		  (throw 'done ret))
	      (setq wlist (cdr wlist))))
	(throw 'done nil)))))

(defun weather-replace-in-string (str regexp newtext &optional literal)
  "Replaces all matches in STR for REGEXP with NEWTEXT string,
 and returns the new string.
Optional LITERAL non-nil means do a literal replacement.
Otherwise treat \\ in NEWTEXT string as special:
  \\& means substitute original matched text,
  \\N means substitute match for \(...\) number N,
  \\\\ means insert one \\."
  (let ((rtn-str "")
	(start 0)
	(special)
	match prev-start)
    (while (setq match (string-match regexp str start))
      (setq prev-start start
	    start (match-end 0)
	    rtn-str
	    (concat
	      rtn-str
	      (substring str prev-start match)
	      (cond (literal newtext)
		    (t (mapconcat
			(function
			 (lambda (c)
			   (if special
			       (progn
				 (setq special nil)
				 (cond ((eq c ?\\) "\\")
				       ((eq c ?&)
					(weather-match-string 0 str))
				       ((and (>= c ?0) (<= c ?9))
					(if (> c (+ ?0 (length
							(match-data))))
					; Invalid match num
					    (error "Invalid match num: %c" c)
					  (setq c (- c ?0))
					  (weather-match-string c str)))
				       (t (char-to-string c))))
			     (if (eq c ?\\) (progn (setq special t) nil)
			       (char-to-string c)))))
			newtext ""))))))
    (concat rtn-str (substring str start))))

(defun weather-remove-regexp-in-string (regexp string)
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

(defun weather-narrow-to-header ()
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

(defun weather-replace-header (&optional where offline)
  (interactive (list (read-from-minibuffer "Where: "
					   weather-where)))
  (let* ((weather-message-where
	  (and (null (interactive-p))
	       weather-message-where))
	 (weather (weather-from-http where offline)))
    (if weather
	(save-excursion
	  (save-restriction
	    (weather-narrow-to-header)
	    (goto-char (point-min))
	    (while (re-search-forward "^X-Weather:.*$" nil t)
	      (delete-region (1- (match-beginning 0)) (match-end 0)))
	    (goto-char (point-max))
	    (insert "X-Weather: " weather "\n"))))))

(defun weather-insert-header (&optional where offline)
  (interactive (if (or current-prefix-arg
		       (null weather-where))
		   (list (read-from-minibuffer "Where: "
					       weather-where))))
  (let ((weather (weather-from-http where offline)))
    (if weather
	(save-excursion
	  (save-restriction
	    (weather-narrow-to-header)
	    (goto-char (point-max))
	    (insert "X-Weather: " weather "\n"))))))

(defconst weather-environment-version
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

(defun weather-version ()
  "Print Weather version."
  (interactive)
  (let ((product-info
	 (concat (product-string-1 "Weather" t)
		 " " weather-environment-version)))
    (if (interactive-p)
	(message "%s" product-info)
      product-info)))

(provide 'weather)

;;; weather.el ends here
