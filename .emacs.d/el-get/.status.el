((anything status "installed" recipe
	   (:name anything :website "http://www.emacswiki.org/emacs/Anything" :description "Open anything / QuickSilver-like candidate-selection framework" :type git :url "http://repo.or.cz/r/anything-config.git" :shallow nil :load-path
		  ("." "extensions" "contrib")
		  :features anything))
 (auto-install status "installed" recipe
	       (:name auto-install :description "Auto install elisp file" :type emacswiki))
 (cedet status "removed" recipe nil)
 (el-get status "installed" recipe
	 (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "4.stable" :pkgname "dimitri/el-get" :features el-get :info "." :load "el-get.el"))
 (emacs-w3m status "removed" recipe nil)
 (ess status "removed" recipe nil)
 (google-maps status "installed" recipe
	      (:name google-maps :description "Access Google Maps from Emacs" :type git :url "git://git.naquadah.org/google-maps.git" :features google-maps))
 (google-weather status "installed" recipe
		 (:name google-weather :description "Fetch Google Weather forecasts." :type git :url "git://git.naquadah.org/google-weather-el.git" :features
			(google-weather org-google-weather)))
 (json status "installed" recipe
       (:name json :description "JavaScript Object Notation parser / generator" :type http :url "http://edward.oconnor.cx/elisp/json.el" :features json))
 (popup status "installed" recipe
	(:name popup :website "https://github.com/m2ym/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :pkgname "m2ym/popup-el"))
 (pos-tip status "installed" recipe
	  (:name pos-tip :description "Show tooltip at point" :type emacswiki))
 (revive status "installed" recipe
	 (:name revive :description "Revive.el saves current editing status including the window splitting configuration, which can't be recovered by `desktop.el' nor by `saveconf.el', into a file and reconstructs that status correctly." :type http :url "http://www.gentei.org/~yuuji/software/revive.el" :features "revive"))
 (skype status "installed" recipe
	(:name skype :description "Skype UI for emacs users." :type github :pkgname "buzztaiki/emacs-skype" :features skype))
 (twittering-mode status "installed" recipe
		  (:name twittering-mode :description "Major mode for Twitter" :type github :pkgname "hayamiz/twittering-mode" :features twittering-mode :compile "twittering-mode.el")))
