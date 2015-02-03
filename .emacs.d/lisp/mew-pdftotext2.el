(defvar mew-prog-application/pdf-pdftotext "pdfocr")
;(defvar mew-prog-application/pdf-pdftotext-arg '("-raw"))
(defvar mew-prog-application/pdf-pdftotext-arg '(""))

(defun mew-mime-application/pdf-pdftotext (cache begin end &optional params)
  (let ((file (mew-make-temp-name))
	(msgbuf (current-buffer))
	(orig mew-prog-application/pdf-pdftotext-arg)
	arg)
    (message "Displaying a PDF document...")
    (setq arg (list "-" file))
    (while orig
      (setq arg (cons (car orig) arg))
      (setq orig (cdr orig)))
    (setq arg (nreverse arg))
    (save-excursion
     (set-buffer cache)
     (mew-flet
      (write-region begin end file nil 'no-msg))
     (set-buffer msgbuf)
     (mew-elet
      (mew-frwlet
       'euc-jp mew-cs-dummy
       (apply (function call-process)
	      mew-prog-application/pdf-pdftotext nil t nil arg))
      ;; delete last page break
      (when (re-search-backward "\n" nil t)
	(delete-region (match-beginning 0)
		       (match-end 0)))))
    (when mew-break-pages
      (mew-message-narrow-to-page))
    (message "Displaying a PDF document...done")))
