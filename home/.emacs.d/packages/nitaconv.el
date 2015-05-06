;; -*- Emacs-Lisp -*-
;; 
;; nitamoji converter using nitaconv command.
;; Copyright (c) 2012 Kotaro Sonoda
;; All rights reserved.
;; 
;; $Id:$
;; 

;; This code is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY.  No author or distributor
;; accepts responsibility to anyone for the consequences of using it
;; or for whether it serves any particular purpose or works at all,
;; unless he says so in writing.  Refer to the GNU Emacs General Public
;; License for full details.

;; Everyone is granted permission to copy, modify and redistribute
;; this code, but only under the conditions described in the
;; GNU Emacs General Public License.   A copy of this license is
;; supposed to have been given to you along with GNU Emacs so you
;; can know your rights and responsibilities.  It should be in a
;; file named COPYING.  Among other things, the copyright notice
;; and this notice must be preserved on all copies.

;; usage:
;; add the following lines to your ~/.emacs.
;;(autoload 'nitaconv-at-point "nitaconv" nil t)
;;(global-set-key "\C-cN" 'nitaconv-at-point)

(setq nitaconv-replace-regexp-list nil)

(defun nitaconv-string (str)
  "Run \"nitaconv\" for STR and returrn its output."
  (interactive "s")
  (let ((buf (get-buffer-create " *Nitaconv*"))
	(cmd "nkf -eW| /home/kotaro/bin/nitaconv | nkf -Ew"))
    (save-excursion
      ;; prepare output buffer
      (set-buffer buf)
      (erase-buffer)
      (insert str)
      ;; run kingtr and format its output
      (shell-command-on-region (point-min) (point-max) cmd t t)
      ;; tweak kingtr output
      (let ((lst nitaconv-replace-regexp-list)
	    elem)
	(while lst
	  (goto-char (point-min))
	  (while (re-search-forward (nth 0 (car lst)) nil t)
	    (replace-match (nth 1 (car lst)) 'fixedcase))
	  (setq lst (cdr lst))))
      ;; format output
      (fill-region (point-min) (point-max))
      (buffer-string))))

(defun nitaconv-region (start end)
  "Run \"nitaconv\" for the region specified by START and END."
  (interactive "r")
  (let ((str (buffer-substring start end)))
    (let ((buf (get-buffer-create "*Nitaconv*"))
	  (out (nitaconv-string str)))
      (save-excursion
	(set-buffer buf)
	(erase-buffer)
	(insert out)
	(delete-other-windows)
	(split-window nil (truncate (* (window-height) 0.5)))
	(set-window-buffer (next-window) buf)))))
