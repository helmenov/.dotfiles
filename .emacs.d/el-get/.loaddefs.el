;;; .loaddefs.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/anything/anything"
;;;;;;  "anything/anything.el" "8c7ada170b5ace83d4fbb76e8baaa7b1")
;;; Generated autoloads from anything/anything.el

(autoload 'anything "../../.dotfiles/.emacs.d/el-get/anything/anything" "\
Main function to execute anything sources.

Keywords supported:
:sources :input :prompt :resume :preselect :buffer :keymap :default :history
Extra keywords are supported and can be added, see below.

When call interactively with no arguments deprecated `anything-sources'
will be used if non--nil.

PLIST is a list like (:key1 val1 :key2 val2 ...) or
\(&optional sources input prompt resume preselect buffer keymap default history).

Basic keywords are the following:

:sources

Temporary value of `anything-sources'.  It also accepts a
symbol, interpreted as a variable of an anything source.  It
also accepts an alist representing an anything source, which is
detected by (assq 'name ANY-SOURCES)

:input

Temporary value of `anything-pattern', ie. initial input of minibuffer.

:prompt

Prompt other than \"pattern: \".

:resume

If t, Resurrect previously instance of `anything'.  Skip the initialization.
If 'noresume, this instance of `anything' cannot be resumed.

:preselect

Initially selected candidate.  Specified by exact candidate or a regexp.

:buffer

`anything-buffer' instead of *anything*.

:keymap

`anything-map' for current `anything' session.

:default

A default argument that will be inserted in minibuffer with \\<minibuffer-local-map>\\[next-history-element].
When nil of not present `thing-at-point' will be used instead.

:history

By default all minibuffer input is pushed to `minibuffer-history',
if an argument HISTORY is provided, input will be pushed to HISTORY.
History element should be a symbol.

Of course, conventional arguments are supported, the two are same.

\(anything :sources sources :input input :prompt prompt :resume resume
           :preselect preselect :buffer buffer :keymap keymap :default default
           :history history)
\(anything sources input prompt resume preselect buffer keymap default history)

Other keywords are interpreted as local variables of this anything session.
The `anything-' prefix can be omitted.  For example,

\(anything :sources 'anything-c-source-buffers
           :buffer \"*buffers*\" :candidate-number-limit 10)

means starting anything session with `anything-c-source-buffers'
source in *buffers* buffer and set variable `anything-candidate-number-limit'
to 10 as session local variable.

\(fn &rest PLIST)" t nil)

(autoload 'anything-at-point "../../.dotfiles/.emacs.d/el-get/anything/anything" "\
Call anything with symbol at point as initial input.
ANY-SOURCES ANY-INPUT ANY-PROMPT ANY-RESUME ANY-PRESELECT and ANY-BUFFER
are same args as in `anything'.

\(fn &optional ANY-SOURCES ANY-INPUT ANY-PROMPT ANY-RESUME ANY-PRESELECT ANY-BUFFER)" t nil)

(autoload 'anything-other-buffer "../../.dotfiles/.emacs.d/el-get/anything/anything" "\
Simplified interface of `anything' with other `anything-buffer'.
Call `anything' with only ANY-SOURCES and ANY-BUFFER as args.

\(fn ANY-SOURCES ANY-BUFFER)" nil nil)

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/anything/anything-config"
;;;;;;  "anything/anything-config.el" "80d02b9bc86a1e9344308f1d8d916018")
;;; Generated autoloads from anything/anything-config.el

(autoload 'anything-configuration "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Customize `anything'.

\(fn)" t nil)

(defvar anything-command-map)

(autoload 'anything-c-buffer-help "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Help command for anything buffers.

\(fn)" t nil)

(autoload 'anything-ff-help "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Help command for `anything-find-files'.

\(fn)" t nil)

(autoload 'anything-read-file-name-help "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\


\(fn)" t nil)

(autoload 'anything-generic-file-help "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\


\(fn)" t nil)

(autoload 'anything-grep-help "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\


\(fn)" t nil)

(autoload 'anything-pdfgrep-help "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\


\(fn)" t nil)

(autoload 'anything-etags-help "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
The help function for etags.

\(fn)" t nil)

(autoload 'anything-test-sources "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
List all anything sources for test.
The output is sexps which are evaluated by \\[eval-last-sexp].

\(fn)" t nil)

(autoload 'anything-insert-buffer-name "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Insert buffer name.

\(fn)" t nil)

(autoload 'anything-mark-all "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Mark all visible unmarked candidates in current source.

\(fn)" t nil)

(autoload 'anything-unmark-all "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Unmark all candidates in all sources of current anything session.

\(fn)" t nil)

(autoload 'anything-toggle-all-marks "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Toggle all marks.
Mark all visible candidates of current source or unmark all candidates
visible or invisible in all sources of current anything session

\(fn)" t nil)

(autoload 'anything-buffer-diff-persistent "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Toggle diff buffer without quitting anything.

\(fn)" t nil)

(autoload 'anything-buffer-revert-persistent "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Revert buffer without quitting anything.

\(fn)" t nil)

(autoload 'anything-buffer-save-persistent "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Save buffer without quitting anything.

\(fn)" t nil)

(autoload 'anything-buffer-run-kill-buffers "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run kill buffer action from `anything-c-source-buffers-list'.

\(fn)" t nil)

(autoload 'anything-buffer-run-grep "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Grep action from `anything-c-source-buffers-list'.

\(fn)" t nil)

(autoload 'anything-buffer-run-zgrep "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Grep action from `anything-c-source-buffers-list'.

\(fn)" t nil)

(autoload 'anything-buffer-run-query-replace-regexp "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Query replace regexp action from `anything-c-source-buffers-list'.

\(fn)" t nil)

(autoload 'anything-buffer-run-query-replace "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Query replace action from `anything-c-source-buffers-list'.

\(fn)" t nil)

(autoload 'anything-buffer-switch-other-window "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run switch to other window action from `anything-c-source-buffers-list'.

\(fn)" t nil)

(autoload 'anything-buffer-switch-other-frame "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run switch to other frame action from `anything-c-source-buffers-list'.

\(fn)" t nil)

(autoload 'anything-buffer-switch-to-elscreen "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run switch to elscreen  action from `anything-c-source-buffers-list'.

\(fn)" t nil)

(autoload 'anything-buffer-run-ediff "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run ediff action from `anything-c-source-buffers-list'.

\(fn)" t nil)

(autoload 'anything-ff-run-toggle-auto-update "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\


\(fn)" t nil)

(autoload 'anything-ff-run-switch-to-history "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Switch to history action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-grep "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Grep action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-pdfgrep "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Pdfgrep action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-zgrep "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Grep action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-copy-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Copy file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-rename-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Rename file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-byte-compile-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Byte compile file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-load-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Load file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-eshell-command-on-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run eshell command on file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-ediff-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Ediff file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-ediff-merge-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Ediff merge file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-symlink-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Symlink file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-hardlink-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Hardlink file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-delete-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Delete file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-complete-fn-at-point "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run complete file name action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-switch-to-eshell "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run switch to eshell action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-switch-other-window "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run switch to other window action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-switch-other-frame "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run switch to other frame action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-open-file-externally "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run open file externally command action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-locate "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run locate action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-gnus-attach-files "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run gnus attach files command action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-etags "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Etags command action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-run-print-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run Print file action from `anything-c-source-find-files'.

\(fn)" t nil)

(autoload 'anything-ff-properties-persistent "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Show properties without quitting anything.

\(fn)" t nil)

(autoload 'anything-ff-persistent-delete "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Delete current candidate without quitting.

\(fn)" t nil)

(autoload 'anything-ff-run-kill-buffer-persistent "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Execute `anything-ff-kill-buffer-fname' whitout quitting.

\(fn)" t nil)

(defvar anything-dired-mode "Enable anything completion in Dired functions.\nBindings affected are C, R, S, H.\nThis is deprecated for Emacs24+ users, use `ac-mode' instead." "\
Non-nil if Anything-Dired mode is enabled.
See the command `anything-dired-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `anything-dired-mode'.")

(custom-autoload 'anything-dired-mode "../../.dotfiles/.emacs.d/el-get/anything/anything-config" nil)

(autoload 'anything-dired-mode "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Toggle Anything-Dired mode on or off.
With a prefix argument ARG, enable Anything-Dired mode if ARG is
positive, and disable it otherwise.  If called from Lisp, enable
the mode if ARG is omitted or nil, and toggle it if ARG is `toggle'.
\\{anything-dired-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'anything-c-goto-precedent-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Go to precedent file in anything grep/etags buffers.

\(fn)" t nil)

(autoload 'anything-c-goto-next-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Go to precedent file in anything grep/etags buffers.

\(fn)" t nil)

(autoload 'anything-c-grep-run-persistent-action "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run grep persistent action from `anything-do-grep-1'.

\(fn)" t nil)

(autoload 'anything-c-grep-run-default-action "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run grep default action from `anything-do-grep-1'.

\(fn)" t nil)

(autoload 'anything-c-grep-run-other-window-action "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run grep goto other window action from `anything-do-grep-1'.

\(fn)" t nil)

(autoload 'anything-c-grep-run-save-buffer "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run grep save results action from `anything-do-grep-1'.

\(fn)" t nil)

(autoload 'anything-yank-text-at-point "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Yank text at point in minibuffer.

\(fn)" t nil)

(autoload 'anything-c-bookmark-run-jump-other-window "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Jump to bookmark from keyboard.

\(fn)" t nil)

(autoload 'anything-c-bookmark-run-delete "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Delete bookmark from keyboard.

\(fn)" t nil)

(autoload 'anything-c-bmkext-run-edit "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Run `bmkext-edit-bookmark' from keyboard.

\(fn)" t nil)

(autoload 'anything-yaoddmuse-cache-pages "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Fetch the list of files on emacswiki and create cache file.
If load is non--nil load the file and feed `yaoddmuse-pages-hash'.

\(fn &optional LOAD)" t nil)

(defvar anything-completion-mode nil "\
Non-nil if Anything-Completion mode is enabled.
See the command `anything-completion-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `anything-completion-mode'.")

(custom-autoload 'anything-completion-mode "../../.dotfiles/.emacs.d/el-get/anything/anything-config" nil)

(autoload 'anything-completion-mode "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Toggle generic anything completion.

All functions in Emacs that use `completing-read'
or `read-file-name' and friends will use anything interface
when this mode is turned on.
However you can modify this behavior for functions of your choice
with `anything-completing-read-handlers-alist'.

Called with a positive arg, turn on unconditionally, with a
negative arg turn off.
You can turn it on with `ac-mode'.

Some crap emacs functions may not be supported,
e.g `ffap-alternate-file' and maybe others
You can add such functions to `anything-completing-read-handlers-alist'
with a nil value.

Note: This mode will work only partially on Emacs23.

\(fn &optional ARG)" t nil)

(autoload 'anything-lisp-completion-at-point "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Anything lisp symbol completion at point.

\(fn)" t nil)

(autoload 'anything-c-complete-file-name-at-point "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Complete file name at point.

\(fn)" t nil)

(autoload 'anything-lisp-completion-at-point-or-indent "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
First call indent and second call complete lisp symbol.
The second call should happen before `anything-lisp-completion-or-indent-delay',
after this delay, next call will indent again.
After completion, next call is always indent.
See that like click and double mouse click.
One hit indent, two quick hits maybe indent and complete.

\(fn ARG)" t nil)

(autoload 'anything-lisp-completion-or-file-name-at-point "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Complete lisp symbol or filename at point.
Filename completion happen if filename is started in
or between double quotes.

\(fn)" t nil)

(autoload 'anything-w32-shell-execute-open-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\


\(fn FILE)" t nil)

(autoload 'anything-c-call-interactively "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Execute CMD-OR-NAME as Emacs command.
It is added to `extended-command-history'.
`anything-current-prefix-arg' is used as the command's prefix argument.

\(fn CMD-OR-NAME)" nil nil)

(autoload 'anything-c-set-variable "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Set value to VAR interactively.

\(fn VAR)" t nil)

(autoload 'anything-c-reset-adaptative-history "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Delete all `anything-c-adaptive-history' and his file.
Useful when you have a old or corrupted `anything-c-adaptive-history-file'.

\(fn)" t nil)

(autoload 'anything-mini "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' lightweight version (buffer -> recentf).

\(fn)" t nil)

(autoload 'anything-for-files "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for opening files.
ffap -> recentf -> buffer -> bookmark -> file-cache -> files-in-current-dir -> locate.

\(fn)" t nil)

(autoload 'anything-recentf "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for `recentf'.

\(fn)" t nil)

(autoload 'anything-info-at-point "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for searching info at point.
With a prefix-arg insert symbol at point.

\(fn ARG)" t nil)

(autoload 'anything-show-kill-ring "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for `kill-ring'.
It is drop-in replacement of `yank-pop'.
You may bind this command to M-y.
First call open the kill-ring browser, next calls move to next line.

\(fn)" t nil)

(autoload 'anything-minibuffer-history "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for `minibuffer-history'.

\(fn)" t nil)

(autoload 'anything-gentoo "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for gentoo linux.

\(fn)" t nil)

(autoload 'anything-imenu "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for `imenu'.

\(fn)" t nil)

(autoload 'anything-google-suggest "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for google search with google suggest.

\(fn)" t nil)

(autoload 'anything-yahoo-suggest "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for Yahoo searching with Yahoo suggest.

\(fn)" t nil)

(autoload 'anything-for-buffers "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for buffers.

\(fn)" t nil)

(autoload 'anything-buffers-list "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to list buffers.
It is an enhanced version of `anything-for-buffers'.

\(fn)" t nil)

(autoload 'anything-bbdb "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for BBDB.

Needs BBDB.

http://bbdb.sourceforge.net/

\(fn)" t nil)

(autoload 'anything-locate "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for Locate.
Note: you can add locate options after entering pattern.
See 'man locate' for valid options.

You can specify a specific database with prefix argument ARG (C-u).
Many databases can be used: navigate and mark them.
See also `anything-locate-with-db'.

To create a user specific db, use
\"updatedb -l 0 -o db_path -U directory\".
Where db_path is a filename matched by
`anything-locate-db-file-regexp'.

\(fn ARG)" t nil)

(autoload 'anything-w3m-bookmarks "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for w3m bookmark.

Needs w3m and emacs-w3m.

http://w3m.sourceforge.net/
http://emacs-w3m.namazu.org/

\(fn)" t nil)

(autoload 'anything-firefox-bookmarks "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for firefox bookmark.
You will have to enable html bookmarks in firefox:
open about:config in firefox and double click on this line to enable value to true:

user_pref(\"browser.bookmarks.autoExportHTML\", false);

You should have now:

user_pref(\"browser.bookmarks.autoExportHTML\", true);

After closing firefox, you will be able to browse you bookmarks.

\(fn)" t nil)

(autoload 'anything-colors "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for color.

\(fn)" t nil)

(autoload 'anything-bookmarks "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for bookmarks.

\(fn)" t nil)

(autoload 'anything-c-pp-bookmarks "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for bookmarks (pretty-printed).

\(fn)" t nil)

(autoload 'anything-c-insert-latex-math "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for latex math symbols completion.

\(fn)" t nil)

(autoload 'anything-register "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for Emacs registers.

\(fn)" t nil)

(autoload 'anything-man-woman "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for Man and Woman pages.

\(fn)" t nil)

(autoload 'anything-org-keywords "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for org keywords.

\(fn)" t nil)

(autoload 'anything-emms "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for emms sources.

\(fn)" t nil)

(autoload 'anything-eev-anchors "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for eev anchors.

\(fn)" t nil)

(autoload 'anything-bm-list "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for visible bookmarks.

Needs bm.el

http://cvs.savannah.gnu.org/viewvc/*checkout*/bm/bm/bm.el

\(fn)" t nil)

(autoload 'anything-timers "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for timers.

\(fn)" t nil)

(autoload 'anything-list-emacs-process "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for emacs process.

\(fn)" t nil)

(autoload 'anything-occur "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured Anything for Occur source.
If region is active, search only in region,
otherwise search in whole buffer.

\(fn)" t nil)

(autoload 'anything-browse-code "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything to browse code.

\(fn)" t nil)

(autoload 'anything-org-headlines "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything to show org headlines.

\(fn)" t nil)

(autoload 'anything-regexp "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything to build regexps.
`query-replace-regexp' can be run from there against found regexp.

\(fn)" t nil)

(autoload 'anything-c-copy-files-async "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything to copy file list FLIST to DEST asynchronously.

\(fn)" t nil)

(autoload 'anything-find-files "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for anything implementation of `find-file'.
Called with a prefix arg show history if some.
Don't call it from programs, use `anything-find-files-1' instead.
This is the starting point for nearly all actions you can do on files.

\(fn ARG)" t nil)

(autoload 'anything-write-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' providing completion for `write-file'.

\(fn)" t nil)

(autoload 'anything-insert-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' providing completion for `insert-file'.

\(fn)" t nil)

(autoload 'anything-dired-rename-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to rename files from dired.

\(fn)" t nil)

(autoload 'anything-dired-copy-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to copy files from dired.

\(fn)" t nil)

(autoload 'anything-dired-symlink-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to symlink files from dired.

\(fn)" t nil)

(autoload 'anything-dired-hardlink-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to hardlink files from dired.

\(fn)" t nil)

(autoload 'anything-do-grep "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for grep.
Contrarily to Emacs `grep' no default directory is given, but
the full path of candidates in ONLY.
That allow to grep different files not only in `default-directory' but anywhere
by marking them (C-<SPACE>). If one or more directory is selected
grep will search in all files of these directories.
You can use also wildcard in the base name of candidate.
If a prefix arg is given use the -r option of grep.
The prefix arg can be passed before or after start.
See also `anything-do-grep-1'.

\(fn)" t nil)

(autoload 'anything-do-zgrep "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for zgrep.

\(fn)" t nil)

(autoload 'anything-do-pdfgrep "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for pdfgrep.

\(fn)" t nil)

(autoload 'anything-c-etags-select "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for etags.
Called with one prefix arg use symbol at point as initial input.
Called with two prefix arg reinitialize cache.
If tag file have been modified reinitialize cache.

\(fn ARG)" t nil)

(autoload 'anything-filelist "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to open files instantly.

See `anything-c-filelist-file-name' docstring for usage.

\(fn)" t nil)

(autoload 'anything-filelist+ "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to open files/buffers/bookmarks instantly.

This is a replacement for `anything-for-files'.
See `anything-c-filelist-file-name' docstring for usage.

\(fn)" t nil)

(autoload 'anything-M-x "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for Emacs commands.
It is `anything' replacement of regular `M-x' `execute-extended-command'.

\(fn)" t nil)

(autoload 'anything-manage-advice "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to disable/enable function advices.

\(fn)" t nil)

(autoload 'anything-bookmark-ext "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for bookmark-extensions sources.
Needs bookmark-ext.el:
<http://mercurial.intuxication.org/hg/emacs-bookmark-extension>.
Contain also `anything-c-source-google-suggest'.

\(fn)" t nil)

(autoload 'anything-simple-call-tree "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for simple-call-tree. List function relationships.

Needs simple-call-tree.el.
http://www.emacswiki.org/cgi-bin/wiki/download/simple-call-tree.el

\(fn)" t nil)

(autoload 'anything-mark-ring "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for `anything-c-source-mark-ring'.

\(fn)" t nil)

(autoload 'anything-global-mark-ring "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for `anything-c-source-global-mark-ring'.

\(fn)" t nil)

(autoload 'anything-all-mark-rings "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for `anything-c-source-global-mark-ring' and `anything-c-source-mark-ring'.

\(fn)" t nil)

(autoload 'anything-yaoddmuse-emacswiki-edit-or-view "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to edit or view EmacsWiki page.

Needs yaoddmuse.el.

http://www.emacswiki.org/emacs/download/yaoddmuse.el

\(fn)" t nil)

(autoload 'anything-yaoddmuse-emacswiki-post-library "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to post library to EmacsWiki.

Needs yaoddmuse.el.

http://www.emacswiki.org/emacs/download/yaoddmuse.el

\(fn)" t nil)

(autoload 'anything-eval-expression "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for `anything-c-source-evaluation-result'.

\(fn ARG)" t nil)

(autoload 'anything-eval-expression-with-eldoc "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for `anything-c-source-evaluation-result' with `eldoc' support. 

\(fn)" t nil)

(autoload 'anything-calcul-expression "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for `anything-c-source-calculation-result'.

\(fn)" t nil)

(autoload 'anything-surfraw "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to search PATTERN with search ENGINE.

\(fn PATTERN ENGINE)" t nil)

(autoload 'anything-call-source "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to call anything source.

\(fn)" t nil)

(autoload 'anything-execute-anything-command "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to execute preconfigured `anything'.

\(fn)" t nil)

(autoload 'anything-create "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to do many create actions from STRING.
See also `anything-create--actions'.

\(fn &optional STRING INITIAL-INPUT)" t nil)

(autoload 'anything-top "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' for top command.

\(fn)" t nil)

(autoload 'anything-select-xfont "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to select Xfont.

\(fn)" t nil)

(autoload 'anything-world-time "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to show world time.

\(fn)" t nil)

(autoload 'anything-apt "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' : frontend of APT package manager.
With a prefix arg reload cache.

\(fn ARG)" t nil)

(autoload 'anything-esh-pcomplete "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything to provide anything completion in eshell.

\(fn)" t nil)

(autoload 'anything-eshell-history "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for eshell history.

\(fn)" t nil)

(autoload 'anything-c-run-external-command "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to run External PROGRAM asyncronously from Emacs.
If program is already running exit with error.
You can set your own list of commands with
`anything-c-external-commands-list'.

\(fn PROGRAM)" t nil)

(autoload 'anything-ratpoison-commands "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to execute ratpoison commands.

\(fn)" t nil)

(autoload 'anything-ucs "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything for `ucs-names' math symbols.

\(fn)" t nil)

(autoload 'anything-c-apropos "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured anything to describe commands, functions, variables and faces.

\(fn)" t nil)

(autoload 'anything-xrandr-set "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\


\(fn)" t nil)

(autoload 'anything-ctags-current-file "../../.dotfiles/.emacs.d/el-get/anything/anything-config" "\
Preconfigured `anything' to list function/variable definitions.

Needs Exuberant Ctags.

http://ctags.sourceforge.net/

\(fn)" t nil)

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/anything/anything-match-plugin"
;;;;;;  "anything/anything-match-plugin.el" "7ba84ffc5269f719822c4db3f7681a71")
;;; Generated autoloads from anything/anything-match-plugin.el

(autoload 'anything-mp-toggle-match-plugin "../../.dotfiles/.emacs.d/el-get/anything/anything-match-plugin" "\
Turn on/off multiple regexp matching in anything.
i.e anything-match-plugin.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/el-get/el-get"
;;;;;;  "el-get/el-get.el" "0365c8b39ba4508971d8f28aa88b64f9")
;;; Generated autoloads from el-get/el-get.el

(autoload 'el-get-version "../../.dotfiles/.emacs.d/el-get/el-get/el-get" "\
Message the current el-get version

\(fn)" t nil)

(autoload 'el-get-update-all "../../.dotfiles/.emacs.d/el-get/el-get/el-get" "\
Performs update of all installed packages.

\(fn &optional NO-PROMPT)" t nil)

(autoload 'el-get-self-update "../../.dotfiles/.emacs.d/el-get/el-get/el-get" "\
Update el-get itself.  The standard recipe takes care of reloading the code.

\(fn)" t nil)

(autoload 'el-get-cd "../../.dotfiles/.emacs.d/el-get/el-get/el-get" "\
Open dired in the package directory.

\(fn PACKAGE)" t nil)

(autoload 'el-get-make-recipes "../../.dotfiles/.emacs.d/el-get/el-get/el-get" "\
Loop over `el-get-sources' and write a recipe file for each
entry which is not a symbol and is not already a known recipe.

\(fn &optional DIR)" t nil)

(autoload 'el-get-checksum "../../.dotfiles/.emacs.d/el-get/el-get/el-get" "\
Compute the checksum of the given package, and put it in the kill-ring

\(fn PACKAGE &optional PACKAGE-STATUS-ALIST)" t nil)

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/el-get/el-get-list-packages"
;;;;;;  "el-get/el-get-list-packages.el" "0017ef7cd7ec8bd66a6bf96c1f931d75")
;;; Generated autoloads from el-get/el-get-list-packages.el

(autoload 'el-get-list-packages "../../.dotfiles/.emacs.d/el-get/el-get/el-get-list-packages" "\
Display a list of packages.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/google-maps/google-maps"
;;;;;;  "google-maps/google-maps.el" "e93421b4ea6110eb4641c7ec4ae8524f")
;;; Generated autoloads from google-maps/google-maps.el

(autoload 'google-maps "../../.dotfiles/.emacs.d/el-get/google-maps/google-maps" "\
Run Google Maps on LOCATION.
If NO-GEOCODING is t, then does not try to geocode the address
and do not ask the user for a more precise location.

\(fn LOCATION &optional NO-GEOCODING)" t nil)

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/google-maps/google-maps-geocode"
;;;;;;  "google-maps/google-maps-geocode.el" "9343a9b12c15aa227c1f491d8c9783af")
;;; Generated autoloads from google-maps/google-maps-geocode.el

(autoload 'google-maps-geocode-replace-region "../../.dotfiles/.emacs.d/el-get/google-maps/google-maps-geocode" "\
Geocode region and replace it with a more accurate result.

\(fn BEG END)" t nil)

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/google-maps/google-maps-static"
;;;;;;  "google-maps/google-maps-static.el" "231b624de32b058113bd3a95a04eddde")
;;; Generated autoloads from google-maps/google-maps-static.el

(autoload 'google-maps-static-mode "../../.dotfiles/.emacs.d/el-get/google-maps/google-maps-static" "\
A major mode for Google Maps service

\(fn)" t nil)

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/google-maps/org-location-google-maps"
;;;;;;  "google-maps/org-location-google-maps.el" "d6b4e32a868ac419a8336415c06eeb50")
;;; Generated autoloads from google-maps/org-location-google-maps.el

(autoload 'org-location-google-maps "../../.dotfiles/.emacs.d/el-get/google-maps/org-location-google-maps" "\
Show Google Map for location of an Org entry in an org buffer.
If WITH-CURRENT-LOCATION prefix is set, add a marker with current
location.

\(fn &optional WITH-CURRENT-LOCATION)" t nil)

(autoload 'org-agenda-location-google-maps "../../.dotfiles/.emacs.d/el-get/google-maps/org-location-google-maps" "\
Show Google Map for location of an Org entry in an org-agenda buffer.

\(fn &optional WITH-CURRENT-LOCATION)" t nil)

(autoload 'org-address-google-geocode-set "../../.dotfiles/.emacs.d/el-get/google-maps/org-location-google-maps" "\
Set address property to LOCATION address for current entry using Google Geocoding API.

\(fn LOCATION)" t nil)

(autoload 'org-coordinates-google-geocode-set "../../.dotfiles/.emacs.d/el-get/google-maps/org-location-google-maps" "\
Set coordinates property to LOCATION coordinates for current entry using Google Geocoding API.

\(fn LOCATION)" t nil)

(autoload 'org-google-maps-key-bindings "../../.dotfiles/.emacs.d/el-get/google-maps/org-location-google-maps" "\


\(fn)" nil nil)

(autoload 'org-agenda-google-maps-key-bindings "../../.dotfiles/.emacs.d/el-get/google-maps/org-location-google-maps" "\


\(fn)" nil nil)
(eval-after-load "org" '(org-google-maps-key-bindings))
(eval-after-load "org-agenda" '(org-agenda-google-maps-key-bindings))

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/revive/revive"
;;;;;;  "revive/revive.el" "9b6b2272468de83298b8a8736c117b91")
;;; Generated autoloads from revive/revive.el

(autoload 'current-window-configuration-printable "../../.dotfiles/.emacs.d/el-get/revive/revive" "\
Return the printable current-window-configuration.
This configuration will be stored by restore-window-configuration.
Returned configurations are list of:
'(Screen-Width Screen-Height Edge-List Buffer-List)

Edge-List is a return value of revive:all-window-edges, list of all
window-edges whose first member is always of north west window.

Buffer-List is a list of buffer property list of all windows.  This
property lists are stored in order corresponding to Edge-List.  Buffer
property list is formed as
'((buffer-file-name) (buffer-name) (point) (window-start)).

\(fn)" nil nil)

(autoload 'restore-window-configuration "../../.dotfiles/.emacs.d/el-get/revive/revive" "\
Restore the window configuration.
Configuration CONFIG should be created by
current-window-configuration-printable.

\(fn CONFIG)" nil nil)

(autoload 'wipe "../../.dotfiles/.emacs.d/el-get/revive/revive" "\
Wipe Emacs.

\(fn)" t nil)

(autoload 'save-current-configuration "../../.dotfiles/.emacs.d/el-get/revive/revive" "\
Save current window/buffer configuration into configuration file.

\(fn &optional NUM)" t nil)

(autoload 'resume "../../.dotfiles/.emacs.d/el-get/revive/revive" "\
Resume window/buffer configuration.
Configuration should be saved by save-current-configuration.

\(fn &optional NUM)" t nil)

;;;***

;;;### (autoloads nil "../../.dotfiles/.emacs.d/el-get/twittering-mode/twittering-mode"
;;;;;;  "twittering-mode/twittering-mode.el" "203cec8255bee0cfaac24951cba63a4a")
;;; Generated autoloads from twittering-mode/twittering-mode.el

(autoload 'twit "../../.dotfiles/.emacs.d/el-get/twittering-mode/twittering-mode" "\
Start twittering-mode.

\(fn)" t nil)

;;;***

;;;### (autoloads nil "el-get/el-get" "../../../.emacs.d/el-get/el-get/el-get.el"
;;;;;;  "0365c8b39ba4508971d8f28aa88b64f9")
;;; Generated autoloads from ../../../.emacs.d/el-get/el-get/el-get.el

(autoload 'el-get-version "el-get/el-get" "\
Message the current el-get version

\(fn)" t nil)

(autoload 'el-get-update-all "el-get/el-get" "\
Performs update of all installed packages.

\(fn &optional NO-PROMPT)" t nil)

(autoload 'el-get-self-update "el-get/el-get" "\
Update el-get itself.  The standard recipe takes care of reloading the code.

\(fn)" t nil)

(autoload 'el-get-cd "el-get/el-get" "\
Open dired in the package directory.

\(fn PACKAGE)" t nil)

(autoload 'el-get-make-recipes "el-get/el-get" "\
Loop over `el-get-sources' and write a recipe file for each
entry which is not a symbol and is not already a known recipe.

\(fn &optional DIR)" t nil)

(autoload 'el-get-checksum "el-get/el-get" "\
Compute the checksum of the given package, and put it in the kill-ring

\(fn PACKAGE &optional PACKAGE-STATUS-ALIST)" t nil)

;;;***

;;;### (autoloads nil "el-get/el-get-list-packages" "../../../.emacs.d/el-get/el-get/el-get-list-packages.el"
;;;;;;  "0017ef7cd7ec8bd66a6bf96c1f931d75")
;;; Generated autoloads from ../../../.emacs.d/el-get/el-get/el-get-list-packages.el

(autoload 'el-get-list-packages "el-get/el-get-list-packages" "\
Display a list of packages.

\(fn)" t nil)

;;;***

;;;### (autoloads nil nil ("../../../.emacs.d/el-get/el-get/el-get-autoloads.el"
;;;;;;  "../../../.emacs.d/el-get/el-get/el-get-build.el" "../../../.emacs.d/el-get/el-get/el-get-byte-compile.el"
;;;;;;  "../../../.emacs.d/el-get/el-get/el-get-core.el" "../../../.emacs.d/el-get/el-get/el-get-custom.el"
;;;;;;  "../../../.emacs.d/el-get/el-get/el-get-dependencies.el"
;;;;;;  "../../../.emacs.d/el-get/el-get/el-get-install.el" "../../../.emacs.d/el-get/el-get/el-get-list-packages.el"
;;;;;;  "../../../.emacs.d/el-get/el-get/el-get-methods.el" "../../../.emacs.d/el-get/el-get/el-get-notify.el"
;;;;;;  "../../../.emacs.d/el-get/el-get/el-get-recipes.el" "../../../.emacs.d/el-get/el-get/el-get-status.el"
;;;;;;  "../../../.emacs.d/el-get/el-get/el-get.el" "anything/anything-config.el"
;;;;;;  "anything/anything-match-plugin.el" "anything/anything.el"
;;;;;;  "el-get/el-get-list-packages.el" "el-get/el-get.el" "google-maps/google-maps-geocode.el"
;;;;;;  "google-maps/google-maps-static.el" "google-maps/google-maps.el"
;;;;;;  "google-maps/org-location-google-maps.el" "google-weather/org-google-weather.el"
;;;;;;  "revive/revive.el" "twittering-mode/twittering-mode.el")
;;;;;;  (21723 24217 803913 508000))

;;;***

(provide '.loaddefs)
;; Local Variables:
;; version-control: never
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; .loaddefs.el ends here
