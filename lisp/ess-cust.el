;;; ess-cust.el --- Customize variables for ESS

;; Copyright (C) 1997--2005 A.J. Rossini, Rich M. Heiberger, Martin
;;	Maechler, Kurt Hornik, Rodney Sparapani, and Stephen Eglen.

;; Original Author: A.J. Rossini <rossini@u.washington.edu>
;; Created: 05 June 2000
;; Maintainers: ESS-core <ESS-core@stat.math.ethz.ch>

;; Keywords: editing and process modes.

;; This file is part of ESS

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
;;
;; In short: you may use this code any way you like, as long as you
;; don't charge more than a distribution fee for it, do distribute the
;; source with any binaries, remove this notice, or hold anyone liable
;; for its results.

;;; Code:

;; Stolen from w3-cus.el (via Per Abrahamsen's advice on the widgets page).
;; This code provides compatibility with non-customized Emacsen.
(eval-and-compile
  (condition-case ()
      (require 'custom)
    (error nil))
  (if (and (featurep 'custom) (fboundp 'custom-declare-variable))
      nil ;; We've got what we needed
    ;; We have the old custom-library, hack around it!
    (defmacro defgroup (&rest args)
      nil)
    (defmacro defface (var values doc &rest args)
       (` (make-face (, var))))
    (defmacro defcustom (var value doc &rest args)
      (` (defvar (, var) (, value) (, doc))))))

;; Customization Groups

(defgroup ess nil
  "ESS: Emacs Speaks Statistics."
  :group 'local)

(defgroup ess-edit nil
  "ESS: editing behavior, including coments/indentation."
  :group 'ess
  :prefix "ess-")

(defgroup ess-proc nil
  "ESS: process control."
  :group 'ess
  :prefix "ess-")

(defgroup ess-command nil
  "ESS: Commands for various things."
  :group 'ess
  :prefix "ess-")

(defgroup ess-help nil
  "ESS: help functions."
  :group 'ess
  :prefix "ess-")

(defgroup ess-hooks nil
  "ESS: hooks for customization."
  :group 'ess
  :prefix "ess-")

(defgroup ess-S nil
  "ESS: S Languages."
  :group 'ess
  :prefix "ess-")

(defgroup ess-origS nil
  "ESS: Original S Dialect from Bell Labs/AT&T."
  :group 'ess-S
  :prefix "ess-")

(defgroup ess-SPLUS nil
  "ESS: S-PLUS Dialect of S."
  :group 'ess-S
  :prefix "ess-")

(defgroup ess-R nil
  "ESS: R Dialect of S."
  :group 'ess-S
  :prefix "ess-")

(defgroup ess-sas nil
  "ESS: SAS."
  :group 'ess
  :prefix "ess-")

(defgroup ess-Stata nil
  "ESS: Stata."
  :group 'ess
  :prefix "ess-")

(defgroup ess-XLS nil
  "ESS: XLispStat."
  :group 'ess
  :prefix "ess-")

(defgroup ess-OMG nil
  "ESS: Omegahat."
  :group 'ess
  :prefix "ess-")

(defgroup ess-mouse nil ;; FIXME: this is not used yet <--> ./ess-mous.el
  "ESS: Mouse."
  :group 'ess
  :prefix "ess-")

;; Variables (not user-changeable)

(defvar ess-version "5.2.6"
  "Version of ESS currently loaded.")

(defvar no-doc
  "This function is part of ESS, but has not yet been loaded.
Full documentation will be available after autoloading the function."
  "Documentation for autoload functions.")


 ; User changeable variables

;;; Common user changeable variable are described and documented in
;;; ess-site.el.  Please check there first!
;;;=====================================================
;;; In general: Variables with document strings starting with a * are
;;; the ones you can generally change safely, and may have to upon
;;; occasion.

;;*;; Options and Initialization

;; Menus and pulldowns.

(defcustom ess-funcmenu-use-p (fboundp 'func-menu)
  "If t, funcmenu is present."
  :group 'ess
  :type  'boolean)

(defcustom ess-speedbar-use-p (fboundp 'speedbar)
  "If t, speedbar is present."
  :group 'ess
  :type  'boolean)

(defcustom ess-imenu-use-p (fboundp 'imenu)
  "Use imenu facility if it exists.
This value can be overridden by mode-specific variables, such
as `ess-imenu-use-S'."
  :group 'ess
  :type  'boolean)

;;

(defcustom ess-ask-for-ess-directory t
  "*If non-nil, the process directory will be requested each time S is run."
  :group 'ess
  :type 'boolean)

(defcustom ess-ask-about-transfile nil
  "*If non-nil, asks about a transcript file before running ESS."
  :group 'ess
  :type 'boolean)

(defcustom ess-language nil
  "*Prefix of all ESS processes, and defines the dialect in use.
Currently acceptable values are `S',  `XLS', `SAS'.
Can be changed, e.g., to `R'.  Use `setq-default' if setting it in
.emacs (also see ess-site.el)."
  :group 'ess
  :type '(choice (const :tag "Initial" :value "Initial")
		 (const :tag "S"       :value "S")
		 (const :tag "XLS"     :value "XLS")
		 (const :tag "SAS"     :value "SAS")
		 (const :tag "R"       :value "R")))

(make-variable-buffer-local 'ess-language)
(setq-default ess-language "Initial")

(defvar ess-dialect nil
  "String version of the dialect being run for the inferior process.
This, plus `ess-language', should be able to determine the exact
version of the statistical package being executed in the particular
buffer.

Current values could include:
for `ess-dialect' = S3, S4, Sp3, Sp4, Sp5, Sp6, R, XLS, SAS, STA

Used to adjust for changes in versions of the program.")

(make-variable-buffer-local 'ess-dialect)
;;(setq-default ess-dialect "Initial-dialect")
(setq-default ess-dialect nil)
;;; SJE -- why use "Initial-dialect"?  If we use nil, it matches "None"
;;; in the custom choice.

;; (defcustom ess-etc-directory
;;   (expand-file-name (concat ess-lisp-directory "/../etc/"))
;;   "*Location of the ESS etc/ directory.
;; The ESS etc directory stores various auxillary files that are useful
;; for ESS, such as icons."
;;   :group 'ess
;;   :type 'directory)

(defcustom ess-directory-function nil
  "*Function to return the directory that ESS is run from.
If nil or if the function returns nil then you get `ess-directory'."
  :group 'ess
  :type '(choice (const nil) function))

(defcustom ess-setup-directory-function nil
  "*Function to setup the directory that ESS is run from.
This function can be called to set environment variables or to create
a workspace."
  :group 'ess
  :type '(choice (const nil) function))

(defcustom ess-directory nil
  "*The directory ESS is run from.  It must end in a slash.
Provided as a default if `ess-ask-for-ess-directory' is non-nil.
A nil value means use the current buffer's default directory.
Buffer-local: in process buffers, this contains the directory ESS was
run from."
  :group 'ess
  :type '(choice (const nil) directory))

(defcustom ess-history-directory nil
  "*Directory to pick up `ess-history-file' from.
If this is nil, the history file is relative to `ess-directory'."
  :group 'ess
  :type '(choice (const nil) directory))

(defcustom ess-history-file nil
  "*File to pick up history from.
If this is a relative file name, it is relative to `ess-history-directory'."
  :group 'ess
  :type '(choice (const nil) file))

(defcustom ess-plain-first-buffername t
  "*No fancy process buffname for the first process of each type (novice mode)."
  :group 'ess
  :type 'boolean)

(defcustom ess-S-assign " <- "
  "*String to be used for left assignment in all S dialects.
 Used by \\[ess-smart-underscore]."
  :group 'ess-S
  :type 'string)

;;*;; Variables concerning editing behaviour

(defcustom ess-filenames-map t
  "Declares if the filenames in an attached directory are the same
as objects in that directory (when t). This is not true for DOS and
other OS's with limited filename lengths.  Even if this is set
incorrectly, the right things will probably still happen, however."
  :group 'ess-edit
  :type 'boolean)

;;; SJE -- this is set in ess-site.el to be "always", so I changed
;;; value t to be "always", so that ess-site.el does not need editing.
;;; However, this is a bit messy, and would be nicer if ess-site.el
;;; value was t rather than "always".
(defcustom ess-keep-dump-files 'ask
  "*Variable controlling whether to delete dump files after a successful load.
If nil: always delete.  If `ask', confirm to delete.  If `check', confirm
to delete, except for files created with ess-dump-object-into-edit-buffer.
Anything else, never delete.  This variable only affects the behaviour
of `ess-load-file'.  Dump files are never deleted if an error occurs
during the load. "
  :group 'ess-edit
  :type '(choice (const :tag "Check" :value  'check)
		 (const :tag "Ask"   :value  'ask)
		 (const :tag "Always keep"   :value "always")
		 (const :tag "Always delete"   :value nil)
		 ))


(defcustom ess-delete-dump-files nil
  "*If non-nil, delete dump files after they are created.  This
applies to dump files created with `ess-dump-object-into-edit-buffer',
only.

Boolean flag which determines what to do with the dump files
generated by \\[ess-dump-object-into-edit-buffer], as follows:

	If nil: dump files are deleted after each use, and so appear
only transiently. The one exception to this is when a loading error
occurs, in which case the file is retained until the error is
corrected and the file re-loaded.

	If non-nil: dump files are not deleted, and backups are kept
as usual.  This provides a simple method for keeping an archive of S
functions in text-file form.

Auto-save is always enabled in dump-file buffers to enable recovery
from crashes.

This is useful to prevent sources file being created for objects
you don't actually modify.  Once the buffer is modified and saved
however, the file is not subsequently unless `ess-keep-dump-files' is
nil, and the file is successfully loaded back into S."
  :group 'ess-edit
  :type 'boolean)

;;; From ess-mode:

(defcustom ess-mode-silently-save t
  "*If non-nil, automatically save ESS source buffers before loading."
  :group 'ess-edit
  :type 'boolean)

;;*;; Variables controlling editing

;;;*;;; Edit buffer processing
(defcustom ess-function-template " <- function( )\n{\n\n}\n"
  "If non-nil, function template used when editing nonexistent objects.

The edit buffer will contain the object name in quotes, followed by
this string. Point will be placed after the first parenthesis or
bracket."
  :group 'ess-edit
  :type 'string)

;;; By K.Shibayama 5.14.1992
;;; Setting any of the following variables in your .emacs is equivalent
;;; to modifying the DEFAULT style.

;;;*;;; Indentation parameters

(defcustom ess-auto-newline nil
  "*Non-nil means automatically newline before and after braces
inserted in S code."
  :type 'boolean
  :group 'ess-edit)

(defcustom ess-tab-always-indent t
  "*Non-nil means TAB in S mode should always reindent the current line,
regardless of where in the line point is when the TAB command is used."
  :type 'boolean
  :group 'ess-edit)

(defcustom ess-indent-level 2
  "*Indentation of S statements with respect to containing block."
  :type 'integer
  :group 'ess-edit)

(defcustom ess-brace-imaginary-offset 0
  "*Imagined indentation of an open brace following a statement."
  :type 'integer
  :group 'ess-edit)

(defcustom ess-brace-offset 0
  "*Extra indentation for open braces.
Compares with other text in same context."
  :type 'integer
  :group 'ess-edit)

(defcustom ess-continued-statement-offset 2
  "*Extra indent for lines not starting new statements."
  :type 'integer
  :group 'ess-edit)

(defcustom ess-continued-brace-offset 0
  "*Extra indent for substatements that start with open-braces.
This is in addition to ess-continued-statement-offset."
  :type 'integer
  :group 'ess-edit)

(defcustom ess-arg-function-offset 2
  "*Extra indent for internal substatements of function `foo' that called
in `arg=foo(...)' form.
If not number, the statements are indented at open-parenthesis following foo."
  :type 'integer
  :group 'ess-edit)

;;added rmh 2Nov97 at request of Terry Therneau
(defcustom ess-close-brace-offset 0
  "*Extra indentation for closing braces."
  :type 'integer
  :group 'ess-edit)

;;added rmh 2Nov97 at request of Terry Therneau
(defcustom ess-fancy-comments t
  "*Non-nil means distiguish between #, ##, and ### for indentation."
  :type 'boolean
  :group 'ess-edit)


;; PeterDalgaard, 1Apr97 :
;;The default ess-else-offset should be 0, not 2 IMHO (try looking at
;;the ls() function, for instance).  Was 2.
(defcustom ess-else-offset 0
  "*Extra indent for `else' lines."
  :type 'integer
  :group 'ess-edit)

(defcustom ess-expression-offset 4
  "*Extra indent for internal substatements of `expression' that specified
in `obj <- expression(...)' form.
If not number, the statements are indented at open-parenthesis following
`expression'."
  :type 'integer
  :group 'ess-edit)

;;;*;;; Editing styles

;;; **FIXME**  The following NEEDS to be customized.
;; SJE: I disagree; this variable should not be customized; individual vars,
;; such as ess-indent-level are already customizable.
(defvar ess-default-style-list
  (list 'DEFAULT
	(cons 'ess-indent-level ess-indent-level)
	(cons 'ess-continued-statement-offset ess-continued-statement-offset)
	(cons 'ess-brace-offset ess-brace-offset)
	(cons 'ess-expression-offset ess-expression-offset)
	(cons 'ess-else-offset ess-else-offset)
	(cons 'ess-brace-imaginary-offset ess-brace-imaginary-offset)
	(cons 'ess-continued-brace-offset ess-continued-brace-offset)
	(cons 'ess-arg-function-offset ess-arg-function-offset)
	(cons 'ess-close-brace-offset ess-close-brace-offset))
  "Default style constructed from initial values of indentation variables.")

(defvar ess-style-alist
  (cons ess-default-style-list
	'((GNU (ess-indent-level . 2)
	       (ess-continued-statement-offset . 2)
	       (ess-brace-offset . 0)
	       (ess-arg-function-offset . 4)
	       (ess-expression-offset . 2)
	       (ess-else-offset . 0)
	       (ess-close-brace-offset . 0))
	  (BSD (ess-indent-level . 8)
	       (ess-continued-statement-offset . 8)
	       (ess-brace-offset . -8)
	       (ess-arg-function-offset . 0)
	       (ess-expression-offset . 8)
	       (ess-else-offset . 0)
	       (ess-close-brace-offset . 0))
	  (K&R (ess-indent-level . 5)
	       (ess-continued-statement-offset . 5)
	       (ess-brace-offset . -5)
	       (ess-arg-function-offset . 0)
	       (ess-expression-offset . 5)
	       (ess-else-offset . 0)
	       (ess-close-brace-offset . 0))
	  (C++ (ess-indent-level . 4)
	       (ess-continued-statement-offset . 4)
	       (ess-brace-offset . -4)
	       (ess-arg-function-offset . 0)
	       (ess-expression-offset . 4)
	       (ess-else-offset . 0)
	       (ess-close-brace-offset . 0))
	  ;; R added ajr 17Feb04 to match "common R" use
	  (RRR (ess-indent-level . 4)
	       (ess-continued-statement-offset . 4)
	       (ess-brace-offset . 0)
	       (ess-arg-function-offset . 4)
	       (ess-expression-offset . 4)
	       (ess-else-offset . 0)
	       (ess-close-brace-offset . 0))
	  ;; CLB added rmh 2Nov97 at request of Terry Therneau
	  (CLB (ess-indent-level . 2)
	       (ess-continued-statement-offset . 4)
	       (ess-brace-offset . 0)
	       (ess-arg-function-offset . 0)
	       (ess-expression-offset . 4)
	       (ess-else-offset . 0)
	       (ess-close-brace-offset . 2))))
  "Predefined formatting styles for ESS code.
Values for all groups, except DEFAULT, are fixed.
To change the value of variables in the DEFAULT group, change
the corresponding variables, e.g. `ess-indent-level'.
The default style in use is controlled by `ess-default-style'.")

(defcustom ess-default-style 'DEFAULT
  "*The default value of `ess-style'.
See the variable `ess-style-alist' for how these groups (DEFAULT,
GNU, BSD, ...) map onto different settings for variables."
  :type '(choice (const DEFAULT)
		 (const GNU)
		 (const BSD)
		 (const K&R)
		 (const C++)
		 (const :tag "Common R" :value 'RRR)
		 (const CLB))
  :group 'ess-edit)

(defvar ess-style ess-default-style
  "*The buffer specific ESS indentation style.")

;;*;; Variables controlling behaviour of dump files

(defcustom ess-source-directory "/tmp/"
  "*Directory in which to place dump files.
This can be a string (an absolute directory name ending in a slash) or
a lambda expression of no arguments which will return a suitable string
value.  The lambda expression is evaluated with the process buffer as the
current buffer.

Possible value:

 '(lambda () (file-name-as-directory
	      (expand-file-name (concat (car ess-search-list) \"/.Src\"))))

This always dumps to a sub-directory (\".Src\") of the current ess
working directory (i.e. first elt of search list)."
  :group 'ess-edit
  :type 'directory)


(defcustom ess-dump-filename-template-proto (concat (user-login-name) ".%s.S")
  "*Prototype template for filenames of dumped objects.
The ending `S' is replaced by the current \\[ess-suffix], to give
\\[ess-dump-filename-template] when an inferior ESS process starts.

By default, gives filenames like `user.foofun.S', so as not to clash with
other users if you are using a shared directory. Other alternatives:
\"%s.S\" ; Don't bother uniquifying if using your own directory(ies)
\"dumpdir\"; Always dump to a specific filename. This makes it impossible
         to edit more than one object at a time, though.
(make-temp-name \"scr.\") ; Another way to uniquify"
  ;; MM: The last 3-4 lines above suck (I don't understand them) -- FIXME --

  :group 'ess-edit
  :type 'string)


;;*;; Hooks

(defcustom ess-mode-hook nil
  "*Hook for customizing ESS each time it is entered."
  :group 'ess-hooks
  :type 'hook)

(defcustom ess-mode-load-hook nil
  "*Hook to call when ess.el is loaded."
  :group 'ess-hooks
  :type 'hook)

(defcustom ess-pre-run-hook nil
  "*Hook to call before starting up ESS.
Good for setting up your directory."
  :group 'ess-hooks
  :type 'hook)

(defcustom ess-post-run-hook nil
  "*Hook to call just after the ESS process starts up.
Good for evaluating ESS code."
  :group 'ess-hooks
  :type 'hook)

(defcustom inferior-ess-mode-hook nil
  "*Hook for customizing inferior ESS mode.  Called after
`inferior-ess-mode' is entered and variables have been initialised."
  :group 'ess-hooks
  :type 'hook)

;;; make it possible to save an inferior-ess-mode buffer without losing
;;; the connection to the running ESS process.
(put 'inferior-ess-mode 'mode-class 'special)
;; FIXME AJR: Should the above be there?  I don't think so!
;;	 MM : the functionality should be, right? Move statement to ./ess.el ?
;;       AJR: No, we should move the statement to ./ess-inf.el

(defcustom ess-help-mode-hook nil
  "Functions to call when entering `ess-help-mode'. "
  :group 'ess-hooks
  :type 'hook)

(defcustom ess-send-input-hook nil
  "Hook called just before line input is sent to the process."
  :group 'ess-hooks
  :type 'hook)

(defcustom ess-transcript-mode-hook nil
  "Hook for customizing ESS transcript mode."
  :group 'ess-hooks
  :type 'hook)

 ; System variables

(defcustom ess-local-process-name nil
  "The name of the ESS process associated with the current buffer."
  :group 'ess
  :type '(choice (const nil) string))

(make-variable-buffer-local 'ess-local-process-name)


(defcustom ess-kermit-command "gkermit -T"
    "*Kermit command invoked by `ess-kermit-get' and `ess-kermit-send'."
    :group 'ess
    :type  'string
)

(defcustom ess-kermit-prefix "#"
    "*String files must begin with to use kermit file transfer."
    :group 'ess
    :type  'string
)

(defcustom ess-kermit-remote-directory "."
    "*Buffer local variable that designates remote directory of file."
    :group 'ess
    :type  'string
)

(make-variable-buffer-local 'ess-kermit-remote-directory)

;;*;; Regular expressions

;; FIXME : This is just for the S dialects;  need to define this for others,
;; -----
;;  {however  "XLS-mode" should just use standard lisp "beginning of function"}

(defcustom ess-R-function-pattern
  (concat
   "\\(\\(" ; EITHER
   "\\s\"" ; quote
   "\\(\\sw\\|\\s_\\)+\\(<-\\)?" ; symbol (replacement?)
   "\\s\"" ; quote
   "\\)\\|\\(" ; OR
   "\\(^\\|[ ]\\)" ; beginning of name
   "\\(\\sw\\|\\s_\\)+" ; symbol
   "\\)\\)" ; END EITHER OR
   "\\s-*\\(<-\\|=\\)" ; whitespace, assign, whitespace/nl
   "\\(\\(\\s-\\|\n\\)*\\s<.*\\s>\\)*" ; whitespace, comment
   "\\(\\s-\\|\n\\)*function\\s-*(" ; whitespace, function keyword, parenthesis
   )
  "The regular expression for matching the beginning of an R function."
  :group 'ess
  :type 'regexp)

(defcustom ess-S-function-pattern
  ;; the same as "R" - but allowing "_" in assign
  (concat
   "\\(\\(" ; EITHER
   "\\s\"" ; quote
   "\\(\\sw\\|\\s_\\)+\\(<-\\)?" ; symbol (replacement?)
   "\\s\"" ; quote
   "\\)\\|\\(" ; OR
;;   "\\<\\(\\sw\\|\\s_\\)+" ; symbol
;;   "[0-9a-zA-Z0-9$.]+" ; symbol
   "\\(^\\|[ ]\\)" ; beginning of name
   "\\(\\sw\\|\\s_\\)+" ; symbol
   "\\)\\)" ; END EITHER OR
   "\\s-*\\(<-\\|_\\|=\\)" ; whitespace, assign, whitespace/nl
   "\\(\\(\\s-\\|\n\\)*\\s<.*\\s>\\)*" ; whitespace, comment
   "\\(\\s-\\|\n\\)*function\\s-*(" ; whitespace, function keyword, parenthesis
   )
  "The regular expression for matching the beginning of an S function."
  :group 'ess
  :type 'regexp)


;; Fixme: the following is just for S dialects :
(defcustom ess-dumped-missing-re
  "\\(<-\nDumped\n\\'\\)\\|\\(<-\\(\\s \\|\n\\)*\\'\\)"
  "If a dumped object's buffer matches this re, then it is replaced
by `ess-function-template'."
  :group 'ess
  :type 'regexp)

(defcustom ess-dump-error-re
  (if (string= ess-language "S") "\nDumped\n\\'"
    "[Ee]rror")
  "Regexp used to detect an error when loading a file."
  :group 'ess
  :type 'regexp)

;;;; This is tested for S dialects (actually only for R) -- be careful with it!
(defvar ess-help-arg-regexp "\\(['\"]?\\)\\([^,=)'\"]*\\)\\1"
  "Reg(ular) Ex(pression) of help(.) arguments.  MUST: 2nd \\(.\\) = arg.")

 ; ess-inf: variables for inferior-ess.

;;*;; System dependent variables

;; If you need to change the *-program-name variables, do so in
;; ess-site.el.  Do NOT make the changes here!!
;; Keep a copy of your revised ess-site.el to use as a starting point
;; for upgrades of ESS.

(defcustom inferior-ess-own-frame nil
  "*Non-nil means that inferior ESS buffers should start in their own frame.
The parameters of this frame are stored in `inferior-ess-frame-alist'."
  :group 'ess-proc
  :type 'boolean)

(defcustom inferior-ess-frame-alist default-frame-alist
  "*Alist of frame parameters used to create new frames for iESS buffers.
This defaults to `default-frame-alist' and is used only when
the variable `inferior-ess-own-frame' is non-nil."
  :group 'ess-proc
  :type 'alist)

(defcustom inferior-ess-same-window t
  "*Non-nil indicates new inferior ESS process appears in current window.
Otherwise, the new inferior ESS buffer is shown in another window in the
current frame.  This variable is ignored if `inferior-ess-own-frame' is
non-nil."
  :group 'ess-proc
  :type 'boolean)

(defcustom inferior-R-program-name
  (if ess-microsoft-p "Rterm"  "R")
  "*Program name for invoking an inferior ESS with \\[R]."
  :group 'ess-R
  :type 'string)

(defcustom inferior-R-args ""
  "*String of arguments used when starting R.
These arguments are currently not passed to other versions of R that have
been created using the variable `ess-r-versions'."
  :group 'ess-R
  :type 'string)

(defcustom inferior-R-objects-command "objects(pos=%d, all.names=TRUE)\n"
  "Format string for R command to get a list of objects at position %d.
Used in e.g., \\[ess-execute-objects] or \\[ess-display-help-on-object]."
  :group 'ess-command
  :type 'string)

(defcustom ess-r-versions '( "R-1" "R-2")
  "*List of partial strings for versions of R to access within ESS.
Each string specifies the start of a filename.  If a filename
beginning with one of these strings is found on `exec-path', a M-x
command for that version of R is made available.  For example, if the
file \"R-1.8.1\" is found and this variable includes the string
\"R-1\", a function called `M-x R-1.8.1' will be available to run that
version of R.
If duplicate versions of the same program are found (which happens if
the same path is listed on `exec-path' more than once), they are
ignored by calling `ess-uniq-list'."
  :group 'ess-R
  :type '(repeat string))


(defcustom ess-rterm-versions nil
"*Construct ess-rterm-versions.  If you have versions of R in
locations other than in ../../rw*/bin/Rterm.exe, relative to the
directory in the `exec-path' variable containing your default location
of Rterm, you will need to redefine this variable with a
`custom-set-variables' statement in your site-start.el or .emacs
file."
  :group 'ess-R
  :type '(repeat string))

(defcustom ess-SHOME-versions
  '("c:/progra~1/Insightful/splus62"
    "c:/progra~1/Insightful/splus61"
    "c:/progra~1/MathSoft/splus6"
    "c:/progra~1/spls45se"
    "c:/progra~1/Insightful/splus62netclient"
    "c:/progra~1/Insightful/splus62net/server"
    "c:/progra~1/Insightful/splus61netclient"
    "c:/progra~1/Insightful/splus61net/server"
    "c:/progra~1/Insightful/splus6se"
    "c:/progra~1/Insightful/splus61se"
    "c:/progra~1/Insightful/splus62se"
    "c:/progra~1/Insightful/splus70"
    "c:/progra~1/Insightful/splus71")
  "*List of possible values of the environment variable SHOME for recent
releases of S-Plus.  These are the default locations for several
current and recent releases of S-Plus.  If any of these pathnames
correspond to a directory on your machine, running the function
`ess-sqpe-versions-create' will create a function, for example, `M-x
splus62', that will start the corresponding version Sqpe inside an
emacs buffer in iESS[S] mode.  If you have versions of S-Plus in
locations other than these default values, redefine this variable with
a `custom-set-variables' statement in your site-start.el or .emacs
file.  The list of functions actually created appears in the *ESS*
buffer and should appear in the \"ESS / Start Process / Other\"
menu."
  :group 'ess-S
  :type '(repeat string))

(defcustom inferior-S3-program-name "/disk05/s/S"
  "*Program name for invoking an inferior ESS with S3()."
  :group 'ess-S
  :type 'string)

(defcustom inferior-S+3-program-name "Splus"
  "*Program name for invoking an inferior ESS with S+3()."
  :group 'ess-S
  :type 'string)

(defcustom inferior-S+4-program-name "c:/progra~1/spls45se/cmd/Splus.exe"
  "*Program name for invoking an external GUI S+4.
The default value is correct for a default installation of
S-Plus 4.5 Student Edition and with bash as the shell.
For any other version or location, change this value in ess-site.el or
site-start.el.  Use the 8.3 version of the pathname.
Use double backslashes if you use the msdos shell."
  :group 'ess-S
  :type 'string)

(defcustom inferior-S+4-print-command "S_PRINT_COMMAND=gnuclientw.exe"
  "*Destination of print icon in S+4 Commands window."
  :group 'ess-S
  :type 'string)

(defcustom inferior-S+4-editor-pager-command
  "options(editor='gnuclient.exe', pager='gnuclientw.exe')"
  "*Programs called by the editor() and pager() functions
in S+4 Commands window and in Sqpe+4 buffer."
  :group 'ess-S
  :type 'string)

(defcustom inferior-Sqpe+4-program-name "c:/progra~1/spls45se/cmd/Sqpe.exe"
  "*Program name for invoking an inferior ESS with Sqpe+4()."
  :group 'ess-S
  :type 'string)

;;; SJE - avoid mismatch by changing default nil to ""
(defcustom inferior-Sqpe+4-SHOME-name
  (if ess-microsoft-p "c:/progra~1/spls45se" "")
  "*SHOME name for invoking an inferior ESS with Sqpe+4().
The default value is correct for a default installation of
S-Plus 4.5 Student Edition.  For any other version or location,
change this value in ess-site.el or site-start.el.  Use the 8.3
version of the pathname."
  :group 'ess-S
  :type 'string)
;;(if ess-microsoft-p
;;    (let* ((SHOME (getenv "SHOME"))
;;	   (PATH (getenv "PATH"))
;;	   (split-PATH (split-string PATH ";")) ;; Unix uses ":"
;;	   (num 0)
;;	   pathname)
;;      (if (not SHOME)
;;	  (while (< num (length split-PATH))
;;	    (setq pathname (concat (nth num split-PATH) "/Sqpe.exe"))
;;	    (if (not (file-exists-p pathname))
;;		(setq num (1+ num))
;;	      (progn
;;		(setq num (length split-PATH))
;;		(setq SHOME (expand-file-name (concat pathname "/../..")))))))
;;      (setq-default inferior-Sqpe+4-SHOME-name SHOME)))


(defcustom inferior-S-elsewhere-program-name "sh"
  "*Program name for invoking an inferior ESS with S on a different computer."
  :group 'ess-proc
  :type 'string)

(defcustom inferior-ESS-elsewhere-program-name "sh"
  "*Program name for invoking an inferior ESS with program on a
different computer."
  :group 'ess-proc
  :type 'string)

(defcustom inferior-S4-program-name "S4"
  "*Program name for invoking an inferior ESS with S4()."
  :group 'ess-S
  :type 'string)

(defcustom inferior-S+5-program-name "Splus5"
  "*Program name for invoking an inferior ESS with S+5()."
  :group 'ess-S
  :type 'string)

(if ess-microsoft-p
    (defcustom inferior-S+6-program-name
      "c:/progra~1/insigh~1/splus6/cmd/Splus.exe"
      "*Program name for invoking an external GUI S+6 for Windows.
The default value is correct for a default installation of
S-Plus 6.0.3 Release 2 and with bash as the shell.
For any other version or location, change this value in ess-site.el or
site-start.el.  Use the 8.3 version of the pathname.
Use double backslashes if you use the msdos shell."
      :group 'ess-S
      :type 'string)
  (defcustom inferior-S+6-program-name "Splus6"
    "*Program name for invoking an inferior ESS with S+6() for Unix."
    :group 'ess-S
    :type 'string))

(defcustom inferior-Splus-args ""
  "*String of arguments used when starting S.
These arguments are currently passed only to S+6."
  :group 'ess-S
  :type 'string)

(defcustom inferior-Splus-objects-command "objects(where=%d)\n"
  "Format string for R command to get a list of objects at position %d.
Used in e.g., \\[ess-execute-objects] or \\[ess-display-help-on-object]."
  :group 'ess-command
  :type 'string)

(defcustom inferior-S+6-print-command "S_PRINT_COMMAND=gnuclientw.exe"
  "*Destination of print icon in S+6 for Windows Commands window."
  :group 'ess-S
  :type 'string)

(defcustom inferior-S+6-editor-pager-command
  "options(editor='gnuclient.exe', pager='gnuclientw.exe')"
  "*Programs called by the editor() and pager() functions
in S+6 for Windows Commands window and in Sqpe+6 for Windows buffer."
  :group 'ess-S
  :type 'string)

(defcustom inferior-Sqpe+6-program-name
  "c:/progra~1/insigh~1/splus6/cmd/Sqpe.exe"
  "*Program name for invoking an inferior ESS with Sqpe+6() for Windows."
  :group 'ess-S
  :type 'string)

;;; SJE - avoid mismatch by changing default nil to ""
(defcustom inferior-Sqpe+6-SHOME-name
  (if ess-microsoft-p "c:/progra~1/insigh~1/splus6" "")
  "*SHOME name for invoking an inferior ESS with Sqpe+6() for Windows.
The default value is correct for a default installation of
S-Plus 6.0.3 Release 2.  For any other version or location,
change this value in ess-site.el or site-start.el.  Use the 8.3
version of the pathname."
  :group 'ess-S
  :type 'string)
;;(if ess-microsoft-p
;;    (let* ((SHOME (getenv "SHOME"))
;;	   (PATH (getenv "PATH"))
;;	   (split-PATH (split-string PATH ";")) ;; Unix uses ":"
;;	   (num 0)
;;	   pathname)
;;      (if (not SHOME)
;;	  (while (< num (length split-PATH))
;;	    (setq pathname (concat (nth num split-PATH) "/Sqpe.exe"))
;;	    (if (not (file-exists-p pathname))
;;		(setq num (1+ num))
;;	      (progn
;;		(setq num (length split-PATH))
;;		(setq SHOME (expand-file-name (concat pathname "/../..")))))))
;;      (setq-default inferior-Sqpe+6-SHOME-name SHOME)))

(defcustom ess-S-quit-kill-buffers-p nil
  "Controls whether S buffers should also be killed once a process is killed.
This is used only when an iESS process is killed using C-c C-q.
Possible values:
nil - do not kill any S buffers associated with the process.
t - kill S buffers associated with the process.
ask - ask the user whether the S buffers should be killed."
  :group 'ess-S
  :type '(choice (const nil) (const t) (const ask)))

(defcustom inferior-XLS-program-name "xlispstat"
  "*Program name for invoking an inferior ESS with \\[XLS]."
  :group 'ess-XLS
  :type 'string)

(defcustom inferior-VST-program-name "vista"
  "*Program name for invoking an inferior ESS with \\[ViSta]."
  :group 'ess-XLS
  :type 'string)

(defcustom inferior-ARC-program-name "arc"
  "*Program name for invoking an inferior ESS with \\[ARC]."
  :group 'ess-XLS
  :type 'string)

(defcustom inferior-SAS-program-name "sas"
  "*Program name for invoking an inferior ESS with SAS()."
  :group 'ess-sas
  :type 'string)

(defcustom inferior-STA-program-name "env"
  "*Program name for invoking an inferior ESS with stata().
This is NOT Stata, because we need to call stata with TERM=emacs in
order for it to work right.  And Emacs is too smart for it."
  :group 'ess-Stata
  :type 'string)

(defcustom inferior-OMG-program-name "omegahat"
  "*Program name for invoking an inferior ESS with omegahat()."
  :group 'ess-OMG
  :type 'string)


;;;;; names for setting the pager and editor options of the
;;;;; inferior-ess-process
;;;
;;; S-editor and S-pager,
;;; R-editor and R-pager,
;;; ess-editor and ess-pager,
;;; and inferior-ess-language-start
;;; apply in principle to the 15 files essd[s-]*.el
;;; Several of the files (essd-sp4.el and essd-sp6w.el) have more
;;; than one *-customize-alist.
;;; These variables are currently used only with the S language files for
;;; S S-Plus R.

(defcustom R-editor
  (if ess-microsoft-p "gnuclient.exe"
    (if (equal system-type 'Apple-Macintosh) nil
      (if (featurep 'xemacs) "gnuclient -q" "emacsclient"))) ;; unix
  "*Editor called by R process with 'edit()' command."
  :group 'ess
  :type 'string)

(defcustom R-pager 'nil	; Usually nil is correct as ESS and page() cooperate.
  "*Pager called by R process with 'page()' command."
  :group 'ess
  :type '(choice (const nil) string))

(defcustom S-editor
  (if ess-microsoft-p "gnuclient.exe"
    (if (equal system-type 'Apple-Macintosh) nil
      (if (featurep 'xemacs) "gnuclient -q" "emacsclient"))) ;; unix
  "*Editor called by S process with 'edit()' command."
  :group 'ess
  :type 'string)

(defcustom S-pager
  (if ess-microsoft-p "gnuclientw.exe"
    (if (equal system-type 'Apple-Macintosh) nil
      (if (featurep 'xemacs) "gnuclient -q" "emacsclient")))
  "*Pager called by S process with 'page()' command."
  ;; Change made to provide a better help(function) experience with
  ;; S+6 and xemacs
  ;; gnuclient -q will open a buffer with an HTML help file
  ;; you can view it with M-x browse-url-of-buffer
  :group 'ess
  :type 'string)

(defvar ess-editor nil
  "*Editor by which the process sends information to an emacs buffer
for editing and then to be returned to the process.")

(defvar ess-pager nil
  "*Pager by which the process sends information to an emacs buffer.")

(defvar inferior-ess-language-start nil
  "*Initialization commands sent to the ESS process.")

(make-variable-buffer-local 'ess-editor)
(make-variable-buffer-local 'ess-pager)
(make-variable-buffer-local 'inferior-ess-language-start)



;;;;; names for communication using MS-Windows 9x/NT ddeclient mechanism

(defcustom inferior-ess-ddeclient nil
  "*ddeclient is the intermediary between emacs and the stat program."
  :group 'ess-proc
  :type 'string)

(make-variable-buffer-local 'inferior-ess-ddeclient)

(defcustom inferior-ess-client-name nil
  "*Name of ESS program ddeclient talks to."
  :group 'ess-proc
  :type 'string)

(make-variable-buffer-local 'inferior-ess-client-name)

(defcustom inferior-ess-client-command nil
  "*ddeclient command sent to the ESS program."
  :group 'ess-proc
  :type '(choice (const nil) string))

(make-variable-buffer-local 'inferior-ess-client-command)

;;;;; user settable defaults
(defvar inferior-S-program-name  inferior-S+3-program-name
  "*Program name for invoking an inferior ESS with S().")
;;- (setq inferior-S-program
;;-       (cond ((string= S-proc-prefix "S") "Splus")
;;- 	    ((string= S-proc-prefix "R") "R")
;;- 	    (t "S")
;;- 	    ))
;;(make-local-variable 'inferior-S-program)

(defvar inferior-ess-program nil ;inferior-S-program-name
  "*Default program name for invoking inferior-ess().
The other variables ...-program-name should be changed, for the
corresponding program.")

(make-variable-buffer-local 'inferior-ess-program)
(setq-default inferior-ess-program inferior-S-program-name)


(defvar inferior-ess-start-args ""
  "String of arguments passed to the ESS process.
If you wish to pass arguments to a process, see e.g. `inferior-R-args'.")

(defcustom inferior-ess-start-file nil
  "*File dumped into process, if non-nil."
  :group 'ess-proc
  :type '(choice (const nil) file))

(defcustom inferior-ess-pager "cat"
  "*Pager to use for reporting help files and similar things."
  :group 'ess-proc
  :type 'string)

(defcustom inferior-ess-primary-prompt "[a-zA-Z0-9() ]*> ?"
  "Regular expression used by `ess-mode' to detect the primary prompt.
Do not anchor to bol with `^'.")

(make-variable-buffer-local 'inferior-ess-primary-prompt)
(setq-default inferior-ess-primary-prompt "[a-zA-Z0-9() ]*> ?")

(defcustom inferior-ess-secondary-prompt "+ ?"
  "Regular expression used by ess-mode to detect the secondary prompt.
(This is issued by S to continue an incomplete expression). Do not
anchor to bol with `^'.")

(make-variable-buffer-local 'inferior-ess-secondary-prompt)
(setq-default inferior-ess-secondary-prompt "+ ?")

;;*;; Variables controlling interaction with the ESS process

(defcustom ess-execute-in-process-buffer nil
  "*If non-nil, the ess-execute- commands output to the process buffer.
Otherwise, they get their own temporary buffer."
  :group 'ess-proc
  :type 'boolean)

(defcustom ess-eval-empty nil
  "*If non-nil, `ess-eval-line-and-step' and `ess-eval-linewise'
will send empty lines to the ESS process."
  :group 'ess-proc
  :type 'boolean)

(defcustom ess-eval-visibly-p t
  "*If non-nil, the ess-eval- commands display the text to be evaluated
in the process buffer."
  :group 'ess-proc
  :type 'boolean)

(defcustom ess-synchronize-evals nil
  "*If t, then all evaluations will synchronize with the ESS process. This
means ess-mode will wait for S to dent a prompt before sending the next
line of code. This allows users of Emacs version 18.57 or less to
evaluate large regions of code without causing an error.  Users of newer
Emacsen usually do not want this feature, since it locks up use
of Emacs until the code has been successfully evaluated."
  :group 'ess-proc
  :type 'boolean)

(defcustom ess-eval-visibly-at-end t
  "*If non-nil, the ess-eval- commands display the results of evaluation
  at the bottom of the process buffer."
  :group 'ess-proc
  :type 'boolean)

 ; System variables

;;*;; Variables relating to multiple processes

(defcustom ess-current-process-name nil
  "Name of the current S process."
  :group 'ess-proc
  :type '(choice (const nil) string))

;; defconst ess-local-process-name now done in S.el

(defcustom ess-process-name-list nil
  "Alist of active ESS processes.")

;;*;; Inferior ESS commands

(defcustom inferior-ess-load-command "source(\"%s\")\n"
  "Format-string for building the ess command to load a file.

This format string should use %s to substitute a file name and should
result in an ESS expression that will command the inferior ESS to load
that file."
  :group 'ess-command
  :type 'string)

(defcustom inferior-ess-dump-command "dump(\"%s\",file=\"%s\")\n"
  "Format-string for building the ess command to dump an object into a file.

Use first %s to substitute an object name
Use second %s to substitute the dump file name."
  :group 'ess-command
  :type 'string)

(defcustom inferior-ess-help-command "help(\"%s\")\n"
  "Format-string for building the ESS command to ask for help on an object.

This format string should use %s to substitute an object name."
  :group 'ess-command
  :type 'string)

(make-variable-buffer-local 'inferior-ess-help-command)
(setq-default inferior-ess-help-command "help(\"%s\")\n")

(defcustom inferior-ess-exit-command "q()\n"
  "Format-string for building the ess command to exit.

This format string should use %s to substitute an object name."
  :group 'ess-command
  :type 'string)

(make-variable-buffer-local 'inferior-ess-exit-command)
(setq-default inferior-ess-exit-command "q()\n")

(defvar inferior-ess-search-list-command nil
  "`ess-language' command that prints out the search list;
i.e. the list of directories and (recursive) objects that `ess-language' uses
when it searches for objects.

Really set in <ess-lang>-customize-alist in ess[dl]-*.el")
;; and hence made buffer-local via that scheme...

(defcustom inferior-ess-names-command "names(%s)\n"
  "Format string for ESS command to extract names from an object.

%s is replaced by the object name -- usually a list or data frame."
  :group 'ess-command
  :type 'string)

(defcustom inferior-ess-get-prompt-command "options()$prompt\n"
  "Command to find the value of the current S prompt."
  :group 'ess-command
  :type 'string)

(defvar ess-cmd-delay nil
  "*Set to a positive number if ESS will include delays proportional to
`ess-cmd-delay'  in some places. These delays are introduced to
prevent timeouts in certain processes, such as completion.")
(make-variable-buffer-local 'ess-cmd-delay)

(defcustom ess-R-cmd-delay nil
  "used to initialize `ess-cmd-delay'."
  :group 'ess-command
  :type '(choice (const nil) number))

(defcustom ess-S+-cmd-delay 1.0
  "used to initialize `ess-cmd-delay'."
  :group 'ess-command
  :type '(choice (const nil) number))

;;*;; Regular expressions

(defvar inferior-ess-prompt nil
  "The regular expression inferior ess mode uses for recognizing prompts.
 Constructed at run time from `inferior-ess-primary-prompt' and
`inferior-ess-secondary-prompt' within `inferior-ess-mode'.")

(make-variable-buffer-local 'inferior-ess-prompt)

(defvar ess-change-sp-regexp ""
  "The regexp for matching the S/R/.. commands that change the search path.")
(make-variable-buffer-local 'ess-change-sp-regexp)

(defcustom ess-S+-change-sp-regexp
  "\\(attach(\\([^)]\\|$\\)\\|detach(\\|collection(\\|library(\\|module(\\|source(\\)"
  "The regexp for matching the S-plus commands that change the search path."
  :group 'ess-proc
  :type 'regexp)

(defcustom ess-S-change-sp-regexp
  "\\(attach(\\([^)]\\|$\\)\\|detach(\\|library(\\|source(\\)"
  "The regexp for matching the S commands that change the search path."
  :group 'ess-proc
  :type 'regexp)

(defcustom ess-R-change-sp-regexp
  "\\(attach(\\([^)]\\|$\\)\\|detach(\\|library(\\|require(\\|source(\\)"
  "The regexp for matching the R commands that change the search path."
  :group 'ess-proc
  :type 'regexp)


;;*;; Process-dependent variables

(defvar ess-search-list nil
  "Cache of list of directories and objects to search for ESS objects.")

(make-variable-buffer-local 'ess-search-list)

(defvar ess-sl-modtime-alist nil
  "Alist of modification times for all ess directories accessed this
session.")

(make-variable-buffer-local 'ess-sl-modtime-alist)

(defvar ess-sp-change nil
  "This symbol flags a change in the ess search path.")

(make-variable-buffer-local 'ess-sp-change)

(defvar ess-prev-load-dir/file nil
  "This symbol saves the (directory . file) pair used in the last
`ess-load-file' command.  Used for determining the default in the next one.")

(make-variable-buffer-local 'ess-prev-load-dir/file)

(defvar ess-object-list nil
  ;; This is a list of the currently known object names.  It is
  ;; current only for one command entry; it exists under the
  ;; assumption that the list of objects doesn't change while entering
  ;; a command.
  "Cache of object names")

(make-variable-buffer-local 'ess-object-list)

;;*;; Miscellaneous system variables

(defvar ess-temp-point nil
 "Variable used to retain a buffer position past let or let*.")

(defvar ess-mode-map nil
  "Keymap for `ess-mode'.")

(defvar ess-eval-map nil
  "Keymap for ess-eval functions.")

(defvar inferior-ess-mode-map nil
  "Keymap for `inferior-ess' mode.")

(defvar ess-mode-minibuffer-map nil)

;; SJE: Wed 29 Dec 2004 - following 3 ess-object* variables can be removed
;; soon if no-one needs the completion code.
(defvar ess-object-name-db-file "ess-namedb"
  "File containing definitions for `ess-object-name-db'.")

(defvar ess-object-name-db-file-loaded '()
  "List of programs whose name-db file has been loaded.")

(defvar ess-object-name-db nil
  "Alist of lists of object names, with directory names as keys.
The file ess-namedb.el is loaded (if it exists) to define this variable.
See also function `ess-create-object-name-db'.")

(make-variable-buffer-local 'ess-object-name-db)
(setq-default ess-object-name-db nil)

(defcustom ess-S-loop-timeout 2000000
  "Integer specifying how many loops ess-mode will wait for the prompt
before signaling an error. Will be set to `ess-loop-timeout' in the S dialects'
alists.  Increase this, if you have a fast(er) machine."
  :group 'ess-proc
  :type 'integer)

(defcustom ess-XLS-loop-timeout 50000
  "Integer specifying how many loops ess-mode will wait for the prompt
before signaling an error. Will be set to `ess-loop-timeout' in the XLispStat
dialects' alists.  Increase this, if you have a fast(er) machine."
  :group 'ess-proc
  :type 'integer)

;; NOTA BENE: Other languages/dialect currently set `ess-loop-timeout'
;;            **directly** in their essd-*.el alist !!

;;;*;;; Font-lock support

;;; for programming, transcript, and inferior process modes.

(defcustom inferior-ess-font-lock-input t
  "*If non-nil, input is syntactically font-locked.
If nil, input is in the `font-lock-variable-name-face'."
  :group 'ess
  :type 'boolean)

(defvar ess-R-mode-font-lock-keywords
  '(("<<-\\|<-\\|->" ; 2004-01: dropped "_" -- TODO later: for function-name
     . font-lock-reference-face)	; assign
    ("\\<\\(TRUE\\|FALSE\\|NA\\|NULL\\|Inf\\|NaN\\)\\>" ; no T|F
     . font-lock-type-face)
    ("\\<\\(library\\|require\\|attach\\|detach\\|source\\)\\>"
     . font-lock-reference-face)
    ("\\<\\(while\\|for\\|in\\|repeat\\|if\\|else\\|switch\\|break\\|next\\|return\\|stop\\|warning\\|message\\|function\\)\\>"
     . font-lock-keyword-face)
    ("\\s\"?\\(\\(\\sw\\|\\s_\\)+\\(<-\\)?\\)\\s\"?\\s-*\\(<-\\)\\(\\s-\\|\n\\)*function"
     1 font-lock-function-name-face t)
    )
  "Font-lock patterns used in `R-mode' buffers.")

(defvar ess-S-mode-font-lock-keywords
  '(("<<-\\|<-\\|->" . font-lock-reference-face)	; assign
    ("\\<\\(T\\|F\\|TRUE\\|FALSE\\|NA\\|NULL\\|Inf\\|NaN\\)\\>" ; + T|F
     . font-lock-type-face)
    ("\\<\\(library\\|module\\|attach\\|detach\\|source\\)\\>"; s/require/module
     . font-lock-reference-face)
    ("\\<\\(while\\|for\\|in\\|repeat\\|if\\|else\\|switch\\|break\\|next\\|return\\|stop\\|warning\\|message\\|function\\)\\>"
     . font-lock-keyword-face) ; +  "_"  and "="
    ("\\s\"?\\(\\(\\sw\\|\\s_\\)+\\(<-\\)?\\)\\s\"?\\s-*\\(<-\\|_\\|=\\)\\(\\s-\\|\n\\)*function"
     1 font-lock-function-name-face t)
    )
  "Font-lock patterns used in `S-mode' buffers.")


;; FIXME:
;; This should be split in  R and S versions too (at least because 'T' and 'F':
(defvar inferior-ess-font-lock-keywords
  '(("<<-\\|<-\\|->"
     . font-lock-reference-face)		; assign
    ("^\\*\\*\\*.*\\*\\*\\*\\s *$"
     . font-lock-comment-face) ; ess-mode msg
    ("\\[,?[1-9][0-9]*,?\\]"
     . font-lock-reference-face)	; Vector/matrix labels
    ("\\<\\(TRUE\\|FALSE\\|T\\|F\\|NA\\|NULL\\|Inf\\|NaN\\)\\>"
     . font-lock-type-face) ; keywords
    ("\\<\\(library\\|attach\\|detach\\|source\\)\\>"
     . font-lock-reference-face) ; modify search list or source new definitions
    ("^Syntax error:"
     . font-lock-reference-face);inferior-ess problems or errors
    ("^Error:"
     . font-lock-reference-face)
    ("^Error in"
     . font-lock-reference-face)
    ("^Dumped"
     . font-lock-reference-face)
    ("^Warning messages:"
     . font-lock-reference-face)
    ("#"
     . font-lock-comment-face) ; comment
    ("^[^#]*#\\(.*$\\)"
     (1 font-lock-comment-face keep t)) ; comments
    ("\\s\"?\\(\\(\\sw\\|\\s_\\)+\\)\\s\"?\\s-*\\(<-\\|_\\)\\(\\s-\\|\n\\)*function"
     1 font-lock-function-name-face t) ; function name
    ("\\<\\(while\\|for\\|in\\|repeat\\|if\\|else\\|switch\\|break\\|next\\|return\\|stop\\|warning\\|message\\|function\\)\\>"
     . font-lock-keyword-face) ; keywords
    )
  "Font-lock patterns used in inferior-ess-mode buffers.")

;; add-to-list() places keywords in front of the previous keywords
;; input and prompt must appear in inferior-ess-font-lock-keywords
;; in the order  prompt error, hence they appear here in the reverse
;; order.

(if (not inferior-ess-font-lock-input)
    (add-to-list 'inferior-ess-font-lock-keywords
		 '("^[a-zA-Z0-9 ]*[>+]\\(.*$\\)"
		   (1 font-lock-variable-name-face keep t));don't font-lock input
		 ))
(add-to-list 'inferior-ess-font-lock-keywords
	     '("^[a-zA-Z0-9 ]*[>+]" . font-lock-keyword-face))	; prompt

(defvar ess-trans-font-lock-keywords
 inferior-ess-font-lock-keywords
 "Font-lock patterns used in `ess-transcript-mode' buffers.")

;;
;;(defvar ess-mode-font-lock-keywords
;; '(("\\s\"?\\(\\(\\sw\\|\\s_\\)+\\)\\s\"?\\s-*\\(<-\\|_\\)\\(\\s-\\|\n\\)*function" 1 font-lock-function-name-face t)
;;   ("<<?-\\|_" . font-lock-reference-face)
;;   ("\\<\\(TRUE\\|FALSE\\|T\\|F\\|NA\\|NULL\\|Inf\\|NaN\\)\\>" . font-lock-type-face)
;;   ("\\<\\(library\\|attach\\|detach\\|source\\)\\>" . font-lock-reference-face)
;;   "\\<\\(while\\|for\\|in\\|repeat\\|if\\|else\\|switch\\|break\\|next\\|return\\|stop\\|warning\\|function\\)\\>")
;; "Font-lock patterns used in ess-mode bufffers.")
;;
;;(defvar essd-S-inferior-font-lock-keywords
;; '(("^[a-zA-Z0-9 ]*[>+]" . font-lock-keyword-face)	; prompt
;;   ("^[a-zA-Z0-9 ]*[>+]\\(.*$\\)"
;;    (1 font-lock-variable-name-face keep t)) ; input
;;   ("<-\\|_" . font-lock-reference-face)		; assign
;;   ("^\\*\\*\\\*.*\\*\\*\\*\\s *$" . font-lock-comment-face) ; ess-mode msg
;;   ("\\[,?[1-9][0-9]*,?\\]" . font-lock-reference-face)	; Vector/matrix labels
;;   ("^Syntax error:" . font-lock-reference-face) ; error message
;;   ("^Error:" . font-lock-reference-face) ; error message
;;   ("^Error in" . font-lock-reference-face) ; error message
;;   ("^Dumped" . font-lock-reference-face) ; error message
;;   ("^Warning:" . font-lock-reference-face) ; warning message
;;   ("\\<\\(TRUE\\|FALSE\\|T\\|F\\|NA\\|NULL\\|Inf\\|NaN\\)\\>"
;;    . font-lock-type-face)) ; keywords
;; "Font-lock patterns for dialects of S, used in highlighting process
;; buffers and transcripts.")
;;
;;(defvar inferior-ess-font-lock-keywords
;;  essd-S-inferior-font-lock-keywords
;; "Font-lock patterns used in inferior-ess-mode buffers.")
;;
;;(defvar ess-trans-font-lock-keywords
;;  essd-S-inferior-font-lock-keywords
;; "Font-lock patterns used in ess-transcript-mode buffers.")


;;;*;;; ess-help variables

 ; ess-help-mode
;; This will never need to be loaded independently of any of the other
;; modules, but they can all call it so we may as well put it here.

;;*;; Variables relating to ess-help-mode

(defcustom ess-help-own-frame nil
  "*Controls whether ESS help buffers should start in a different frame.

Possible values are:
   nil: Display help in current frame.
  'one: All help buffers are shown in one dedicated frame.
     t: Each help buffer gets its own frame.

The parameters of this frame are stored in `ess-help-frame-alist'.
See also `inferior-ess-own-frame'."
  :group 'ess-help
  :type '(choice (const nil) (const one) (const t)))

(defcustom ess-help-frame-alist special-display-frame-alist
  "*Alist of frame parameters used to create help frames.
This defaults to `special-display-frame-alist' and is used only when
the variable `ess-help-own-frame' is non-nil."
  :group 'ess-help
  :type 'alist)


 ; User changeable variables
;;;=====================================================
;;; Users note: Variables with document strings starting
;;; with a * are the ones you can generally change safely, and
;;; may have to upon occasion.

(defcustom ess-help-kill-bogus-buffers nil
  "*If non-nil, kill ESS help buffers immediately if they are \"bogus\"."
  :group 'ess-help
  :type 'boolean)

(defvar ess-help-form 'separate-buffer
  "*Place to show help.   NOT IMPLEMENTED YET.
Choices are `separate-buffer', `s-process', `www'.  The latter uses
`browse-url' to find the location.")

;; WWW Help NOT included yet.  Be patient.
(defvar ess-help-w3-url-prefix "http://pyrite.cfas.washington.edu/ESS/R/"
  "*Head URL for finding function help.")

(defvar ess-help-w3-url-funs "funs/"
  "Place to find functions.")


 ; System variables
;;;=====================================================
;;; Users note: You will rarely have to change these
;;; variables.

;;*;; Variables relating to ess-help-mode

;;-- ess-help-S-.. and  ess-help-R-.. : in  essl-s.el (are used in ess-inf).

(defvar ess-help-sec-keys-alist nil
  "Alist of (key . string) pairs for use in section searching.")

(defvar ess-help-sec-regex nil
  "Reg(ular) Ex(pression) of section headers in help file")

(make-variable-buffer-local 'ess-help-sec-keys-alist)
(make-variable-buffer-local 'ess-help-sec-regex)


 ; ess-mode: editing S source

;;; This syntax table is required by ess-mode.el, ess-inf.el and
;;; ess-trans.el, so we provide it here.
(defvar ess-mode-syntax-table nil "Syntax table for `ess-mode'.")
(make-variable-buffer-local 'ess-mode-syntax-table)


 ; Buffer local customization stuff

(defvar ess-source-modes '(ess-mode)
  "A list of modes used to determine if a buffer contains ess source code.")
;;; If a file is loaded into a buffer that is in one of these major modes, it
;;; is considered an ess source file.  The function ess-load-file uses this to
;;; determine defaults.

(defcustom ess-error-buffer-name "*ESS-errors*"
  "Name of buffer to keep process error messages in.
Created for each process."
  :group 'ess-proc
  :type 'string)

(defcustom ess-verbose nil
  "if non-nil, write more information to `ess-dribble-buffer' than usual."
  :group 'ess-proc
  :type 'boolean)

(defvar ess-dribble-buffer (generate-new-buffer "*ESS*")
  "Buffer for temporary use for setting default variable values.
Used for recording status of the program, mainly for debugging.")

(defvar ess-customize-alist nil
  "Variable settings to use for proper behavior.
Not buffer local!")

(defvar ess-local-customize-alist nil
  "Buffer local settings for proper behavior.
Used to store the values for passing on to newly created buffers.")

(make-variable-buffer-local 'ess-local-customize-alist)

(defvar ess-mode-editing-alist nil
  "Variable settings for ess-mode.")

(defvar ess-transcript-minor-mode nil
  "Non-nil if using `ess-transcript-mode' as a minor mode of some other mode.")

(make-variable-buffer-local 'ess-transcript-minor-mode)

(defvar ess-listing-minor-mode nil
  "Non-nil if using ess-listing-minor-mode.")

(make-variable-buffer-local 'ess-listing-minor-mode)

(provide 'ess-cust)

 ; Local variables section

;;; This file is automatically placed in Outline minor mode.
;;; The file is structured as follows:
;;; Chapters:     ^L ;
;;; Sections:    ;;*;;
;;; Subsections: ;;;*;;;
;;; Components:  defuns, defvars, defconsts
;;;              Random code beginning with a ;;;;* comment

;;; Local variables:
;;; mode: emacs-lisp
;;; mode: outline-minor
;;; outline-regexp: "\^L\\|\\`;\\|;;\\*\\|;;;\\*\\|(def[cvu]\\|(setq\\|;;;;\\*"
;;; End:

;;; ess-cust.el ends here
