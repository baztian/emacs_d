(server-start)

(require 'cl)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Library Paths
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/lisp")
(progn (cd "~/.emacs.d") (normal-top-level-add-subdirs-to-load-path))
(cd "~")

;; add ~/.emacs.d/bin to PATH
(setenv "PATH" (concat (expand-file-name "~/.emacs.d/bin")
                       path-separator
                       (getenv "PATH")))
(add-to-list 'exec-path (expand-file-name "~/.emacs.d/bin"))

;; make more packages available with the package installer
;; Requisites: Emacs >= 24
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(setq url-http-attempt-keepalives nil)

(defvar prelude-packages
  '(yasnippet auto-complete autopair elpy find-file-in-repository
              flycheck fuzzy-format material-theme vlf)
  "A list of packages to ensure are installed at launch.")
(if (not (version< emacs-version "24.4"))
    (add-to-list 'prelude-packages 'magit))

(defun prelude-packages-installed-p ()
  (loop for p in prelude-packages
	   when (not (package-installed-p p)) do (return nil)
	   finally (return t)))

(unless (prelude-packages-installed-p)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  (dolist (package prelude-packages)
    (unless (package-installed-p package)
      (package-install package)))
  )

;; Ask for confirmation before quitting Emacs
(add-hook 'kill-emacs-query-functions
          (lambda () (y-or-n-p "Do you really want to exit Emacs? "))
          'append)

;; Sets coding system priority and default input method
(prefer-coding-system 'utf-8-unix)
(set-default buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(set-default default-buffer-file-coding-system 'utf-8-unix)
(set-language-environment 'utf-8)

(load-theme 'material-light t)

;; have vlf offered as choice when opening large files
(require 'vlf-setup)

;; https://github.com/yoshiki/yaml-mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

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

;; dvc
(defvar bzr-executable "bzr")
(load-file "~/.emacs.d/dvc/dvc-load.el")

(if (not (version< emacs-version "24.4"))
  (progn
    (require 'magit)
    (global-set-key "\C-xg" 'magit-status)))

(require 'autopair)
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(global-set-key [f7] 'find-file-in-repository)

;; (add-to-list 'ac-dictionary-directories "~/.emacs.d/dict")
(require 'auto-complete-config)
(ac-config-default)
; auto-complete mode extra settings
(setq
 ac-use-menu-map t
 ac-candidate-limit 20)
;; Enable yasnippet auto-completion globally (see
;; https://github.com/auto-complete/auto-complete/issues/357)
(setq-default ac-sources (push 'ac-source-yasnippet ac-sources))

;; ;; Python mode settings
;; (autoload 'python-mode "my-python-setup" "Python editing mode." t)

;; TODO use my-python-setup for elpy
(setenv "PYTHONPATH" (concat (expand-file-name "~/.emacs.d/Pymacs")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-jedi")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-pylint")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-epc")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-pep8")))

(elpy-enable)

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

;; Load custom stuff
(when (file-exists-p "~/.emacs_custom.el")
  (load "~/.emacs_custom"))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("5dc0ae2d193460de979a463b907b4b2c6d2c9c4657b2e9e66b8898d2592e3de5" default)))
 '(global-font-lock-mode t nil (font-lock))
 '(package-selected-packages
   (quote
    (yasnippet python-mode magit json-mode jedi fuzzy-format flycheck find-file-in-repository autopair))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
