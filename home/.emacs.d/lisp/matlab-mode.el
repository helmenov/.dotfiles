(autoload 'matlab-mode  "matlab" "Enter Matlab mode." t)
(autoload 'matlab-shell "matlab" "Interactive Matlab mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode)  auto-mode-alist))
;;(setq load-path (cons "/home/kotaro/" load-path))
(add-hook 'matlab-mode-hook '(lambda ()
			       (turn-on-auto-fill)
			       (setq matlab-indent-level 3)
			       (setq matlab-indent-function t)
			       (setq fill-column 93)
			       (setq tab-width 3)
			       (auto-fill-mode nil)
			       (setq indent-tabs-mode t)))
(add-hook 'matlab-shell-mode-hook '(lambda () ))

(cond ((and window-system (= emacs-major-version 20))   ; Emacs20, Meadow
       (defface font-lock-comment-face             ; コメント文
	 '((((class grayscale) (background light)) (:foreground "DimGray" :bold t :italic t))
	   (((class grayscale) (background dark))  (:foreground "LightGray" :bold t :italic t))
	   (((class color) (background light)) (:foreground "green4"))    ; FireBrick
	   (((class color) (background dark)) (:foreground "OrangeRed"))
	   (t (:bold t :italic t))) "Font Lock mode face used to highlight comments."
	   :group 'font-lock-highlighting-faces)
       (defface font-lock-string-face              ; 引用文
	 '((((class grayscale) (background light)) (:foreground "DimGray" :italic t))
	   (((class grayscale) (background dark)) (:foreground "LightGray" :italic t))
	   (((class color) (background light)) (:foreground "tomato3"))   ; RosyBrown
	   (((class color) (background dark)) (:foreground "LightSalmon"))
	   (t (:italic t))) "Font Lock mode face used to highlight strings."
	   :group 'font-lock-highlighting-faces)
       (defface font-lock-keyword-face             ; if や end 等
	 '((((class grayscale) (background light)) (:foreground "LightGray" :bold t))
	   (((class grayscale) (background dark)) (:foreground "DimGray" :bold t))
	   (((class color) (background light)) (:foreground "blue"))      ; Purple
	   (((class color) (background dark)) (:foreground "Cyan"))
	   (t (:bold t))) "Font Lock mode face used to highlight keywords."
	   :group 'font-lock-highlighting-faces)
       (defface font-lock-type-face                ; Figure や Line , Surface 等
	 '((((class grayscale) (background light)) (:foreground "Gray90" :bold t))
	   (((class grayscale) (background dark)) (:foreground "DimGray" :bold t))
	   (((class color) (background light)) (:foreground "ForestGreen"))
	   (((class color) (background dark)) (:foreground "PaleGreen"))
	   (t (:bold t :underline t))) "Font Lock mode face used to highlight type and classes."
	   :group 'font-lock-highlighting-faces)
       (defface font-lock-function-name-face       ; function name 等
	 '((((class color) (background light)) (:foreground "Blue"))
	   (((class color) (background dark)) (:foreground "LightSkyBlue"))
	   (t (:inverse-video t :bold t)))
	 "Font Lock mode face used to highlight function names."
	 :group 'font-lock-highlighting-faces)
       (defface font-lock-variable-name-face       ; function の括弧内の変数等
	 '((((class grayscale) (background light))
	    (:foreground "Gray90" :bold t :italic t))
	   (((class grayscale) (background dark))
	    (:foreground "DimGray" :bold t :italic t))
	   (((class color) (background light)) (:foreground "DarkGoldenrod"))
	   (((class color) (background dark)) (:foreground "LightGoldenrod"))
	   (t (:bold t :italic t))) "Font Lock mode face used to highlight variable names."
	   :group 'font-lock-highlighting-faces)
       (global-font-lock-mode t))                       ; Font-Lock-Mode の導入
      ((and window-system (= emacs-major-version 19))   ; Emacs19, Mule for Win
       (font-lock-mode 1)
       (add-hook 'matlab-mode-hook '(lambda () (matlab-mode-hilit)))))
