;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Library Paths
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d")
(progn (cd "~/.emacs.d") (normal-top-level-add-subdirs-to-load-path))
(when (file-exists-p "/usr/share/emacs/site-lisp/site-gentoo.el")
  (load "/usr/share/emacs/site-lisp/site-gentoo"))

(server-start)

;; Sets coding system priority and default input method
(set-language-environment 'German)

;; space for tabs
(setq-default indent-tabs-mode nil)

;; mouse wheel
(autoload 'mwheel-install "mwheel" "Enable mouse wheel support.") (mwheel-install)

(setq inhibit-startup-message t)

;Show column numbers
(column-number-mode 1)

(tool-bar-mode -1)

;;TRAMP should default to ssh
(setq tramp-default-method "ssh")

;;Allow fetching files from HTTP servers
(url-handler-mode)

;; swbuff-y
(load-library "swbuff-y")

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
(defvar bzr-executable (if (eq system-type 'windows-nt) "bzr"))
(load-file "~/.emacs.d/dvc/dvc-load.el")

;; python-mode
(autoload 'python-mode "my-python-setup" "Python editing mode." t)

;;NXML mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(load-library "my-nxml")

;; mmm-mode
(setq mmm-global-mode 'maybe)

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

(defun tail-open (filename)
  "Opens a file in auto-revert-tail-mode"
  (interactive "fFilename: ")
  (find-file filename)
  (auto-revert-tail-mode)
  (goto-char (point-max))
  )

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
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(global-font-lock-mode t nil (font-lock)))
(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 )
