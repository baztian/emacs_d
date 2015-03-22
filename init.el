
(server-start)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Library Paths
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d")
(progn (cd "~/.emacs.d") (normal-top-level-add-subdirs-to-load-path))
(cd "~")
(when (file-exists-p "/usr/share/emacs/site-lisp/site-gentoo.el")
  (load "/usr/share/emacs/site-lisp/site-gentoo"))

;; add ~/.emacs.d/bin to PATH
(setenv "PATH" (concat (expand-file-name "~/.emacs.d/bin")
                       path-separator
                       (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/.emacs.d/bin"))

;; Requisites: Emacs >= 24
(require 'package)
(package-initialize)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/"))

(when (not package-archive-contents)
  (package-refresh-contents))
;; (package-refresh-contents)

(defun install-if-needed (package)
  (unless (package-installed-p package)
    (package-install package)))

;; make more packages available with the package installer
(setq to-install
      '(magit yasnippet auto-complete autopair find-file-in-repository flycheck))

(mapc 'install-if-needed to-install)


;; Ask for confirmation before quitting Emacs
(add-hook 'kill-emacs-query-functions
          (lambda () (y-or-n-p "Do you really want to exit Emacs? "))
          'append)

;; Sets coding system priority and default input method
(set-default buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)
(set-default default-buffer-file-coding-system 'utf-8-unix)
(set-language-environment 'German)

;; Fuzzy check indent format (tabs or spaces) of current buffer. and set indent-tabs-mode and format code automatically.
(require 'fuzzy-format)
(setq fuzzy-format-default-indent-tabs-mode nil)
(global-fuzzy-format-mode t)

;; highlight matching parentheses
(show-paren-mode t)

;; Indentation for HTML files
(setq sgml-basic-offset 4)

;;Configuration for hunspell dictionaries
(setq ispell-dictionary-base-alist
  '(
        ("de_DE"
         "[a-zäöüßA-ZÄÖÜ]" "[^a-zäöüßA-ZÄÖÜ]" "[']" nil
         ("-d" "de_DE") nil utf-8)
        ("en_US"
         "[a-zA-Z]" "[^a-zA-Z]" "[']" nil
         ("-d" "en_US") nil utf-8)
;;        ("en_GB"
;;         "[a-zA-Z]" "[^a-zA-Z]" "[']" nil
;;         ("-d" "en_GB") nil utf-8)
    )
)
(setq-default ispell-program-name "hunspell")

;; Show offscreen matching parentheses in minibuffer. In GNU Emacs
;; 23.2, this information shows up when show-paren-mode is enabled,
;; but then only directly after typing a closing paren. If you use the
;; above code, the information will show up every time the point is
;; placed behind a closing paren.
;; (http://www.emacswiki.org/emacs/ShowParenMode)
(defadvice show-paren-function
  (after show-matching-paren-offscreen activate)
  "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
  (interactive)
  (if (not (minibuffer-prompt))
      (let ((matching-text nil))
        ;; Only call `blink-matching-open' if the character before point
        ;; is a close parentheses type character. Otherwise, there's not
        ;; really any point, and `blink-matching-open' would just echo
        ;; "Mismatched parentheses", which gets really annoying.
        (if (char-equal (char-syntax (char-before (point))) ?\))
            (setq matching-text (blink-matching-open)))
        (if (not (null matching-text))
            (message matching-text)))))


;; mouse wheel
(autoload 'mwheel-install "mwheel" "Enable mouse wheel support.") (mwheel-install)

(setq inhibit-startup-message t)

;Show column numbers
(column-number-mode 1)

(if (functionp 'tool-bar-mode) (tool-bar-mode -1))

;;TRAMP should default to ssh
(setq tramp-default-method "ssh")
(require 'tramp)

;;Allow fetching files from HTTP servers
(url-handler-mode)

;; "Interactively Do Things"
(ido-mode t)

;; use shift to move around windows
(windmove-default-keybindings 'shift)

;; subversion backend for vc
(add-to-list 'vc-handled-backends 'SVN)

;; Disable vc-bzr
;; Because of https://bugs.launchpad.net/bzr/+bug/673637
(eval-after-load 'vc-bzr
  (setq vc-handled-backends (delq 'Bzr vc-handled-backends)))

;; autocomplete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/autocomplete/ac-dict")
(ac-config-default)

;; dvc
(defvar bzr-executable "bzr")
(load-file "~/.emacs.d/dvc/dvc-load.el")

(require 'magit)
(global-set-key "\C-xg" 'magit-status)

(require 'auto-complete)
(require 'autopair)
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(global-set-key [f7] 'find-file-in-repository)

; auto-complete mode extra settings
(setq
 ac-auto-start 2
 ac-override-local-map nil
 ac-use-menu-map t
 ac-candidate-limit 20)

;; ;; Python mode settings
;; (load-library "my-python-setup")
(autoload 'python-mode "my-python-setup" "Python editing mode." t)

(require 'elemental)
(global-set-key (kbd "C-(") 'elem/backward-one)
(global-set-key (kbd "C-)") 'elem/forward)
(global-set-key (kbd "C-*") 'elem/transpose)

;; yasnippet
;; Develop and keep personal snippets under ~/emacs.d/snippets.
;; See 'yas/root-directory where the snippets are being searched for.
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)

;;NXML mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-library "my-nxml")

(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags 
  '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
    (js-mode  "<script.*?>" "</script>")
    (css-mode "<style.*?>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5"))
(multi-web-global-mode 1)

;; mmm-mode
;; (require 'mmm-mode)
;; (setq mmm-global-mode 'maybe)
;; (add-to-list 'mmm-mode-ext-classes-alist
;;          '(html-mode nil html-js))
;; (add-to-list 'mmm-mode-ext-classes-alist
;;          '(html-mode nil embedded-css))

;; kid-nxml-mode
;; (mmm-add-mode-ext-class nil "\\.kid?\\'" 'html-kid)
;; (mmm-add-mode-ext-class nil "\\.kid?\\'" 'html-css)
;; (mmm-add-classes
;;  '((html-kid
;;     :submode python-mode
;;     :front "<\\?python"
;;     :back "?>")
;;    (html-css
;;     :submode css-mode
;;     :front "type=\"text/css\">"
;;     :back "</style>")))
(add-to-list 'auto-mode-alist '("\\.kid?\\'" . nxml-mode))

;;;   rst.el -- ReStructuredText Support for Emacs
;; (require 'rst)
;; (add-hook 'text-mode-hook 'rst-text-mode-bindings)
(add-to-list 'auto-mode-alist '("\\.txt\\'" . rst-mode))

(defun tail-open (filename)
  "Opens a file in auto-revert-tail-mode"
  (interactive "fFilename: ")
  (find-file filename)
  (auto-revert-tail-mode)
  (goto-char (point-max))
  )

;;; Stefan Monnier <foo at acm.org>. It is the opposite of fill-paragraph    
(defun unfill-paragraph ()
  "Takes a multi-line paragraph and makes it into a single line of text."
  (interactive)
  (let ((fill-column (point-max)))
    (fill-paragraph nil)))

;; Handy key definition
(define-key global-map "\M-Q" 'unfill-paragraph)


;; pretty print xml
;; http://stackoverflow.com/a/14589619
(defun cheeso-pretty-print-xml-region (begin end)
  "Pretty format XML markup in region. You need to have nxml-mode
http://www.emacswiki.org/cgi-bin/wiki/NxmlMode installed to do
this.  The function inserts linebreaks to separate tags that have
nothing but whitespace between them.  It then indents the markup
by using nxml's indentation rules."
  (interactive "r")
  (save-excursion
    (nxml-mode)
    ;; split <foo><bar> or </foo><bar>, but not <foo></foo>
    (goto-char begin)
    (while (search-forward-regexp ">[ \t]*<[^/]" end t)
      (backward-char 2) (insert "\n") (incf end))
    ;; split <foo/></foo> and </foo></foo>
    (goto-char begin)
    (while (search-forward-regexp "<.*?/.*?>[ \t]*<" end t)
      (backward-char) (insert "\n") (incf end))
    ;; put xml namespace decls on newline
    (goto-char begin)
    (while (search-forward-regexp "\\(<\\([a-zA-Z][-:A-Za-z0-9]*\\)\\|['\"]\\) \\(xmlns[=:]\\)" end t)
      (goto-char (match-end 0))
      (backward-char 6) (insert "\n") (incf end))
    (indent-region begin end nil)
    (normal-mode))
  (message "All indented!"))

;;;;;;;;;;;;
;;; Key defs
;;;;;;;;;;;;

;F1: goto-line
(define-key global-map [f1] 'goto-line)

;F2: cvs-examine
(define-key global-map [f2] 'cvs-examine)

(setq sandboxroot "d:/sandboxes/")
(setq fiprjdir (concat "sb_si_rating/"))
;C-S-f1 Toggle between project roots
(define-key global-map [C-S-f1]
  (lambda()
    (interactive)
    (if (equal fiprjdir "sb_si_rating/")
        (setq fiprjdir "sb_si_rating_ntueb/")
        (setq fiprjdir "sb_si_rating/")
    )
    (message (concat "fiprjdir = " fiprjdir))
))

;C-F1: open serverlog.log
(define-key global-map [C-f1]
  (lambda()
    (interactive)
    (tail-open (concat sandboxroot fiprjdir "classes/log/serverlog.log"))
    (rename-buffer (concat fiprjdir "serverlog.log"))
    ;; (make-local-variable 'coding)
    ;; (make-variable-buffer-local 'coding)
    ;; (setq coding 'dos)
    ;;(set-variable 'coding 'dos t)
    (set-variable 'paragraph-start '"[RL][ci][RL]c\ " t)
    ))

;C-F2: open client.log
(define-key global-map [C-f2]
  (lambda()
    (interactive)
    (tail-open (concat sandboxroot fiprjdir "classes/log/client.log"))
    (rename-buffer (concat fiprjdir "client.log"))
    ;; (make-local-variable 'coding)
    ;; (make-variable-buffer-local 'coding)
    ;; (setq coding 'dos)
    ;;(set-variable 'coding 'dos t)
    (set-variable 'paragraph-start '"[0-9][0-9][0-9][0-9]-" t)
    ))

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(global-font-lock-mode t nil (font-lock))
 '(python-pep8-command "python -m pep8")
 '(python-pylint-command "python -m pylint.lint"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
