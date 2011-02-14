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

;; dvc
;; (load-file "~/.emacs.d/dvc/dvc-load.el")

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

;S-F1: open server.log
(define-key global-map [S-f1]
  (lambda()
    (interactive)
    (tail-open "d:/sandboxes/sb_si_rating/classes/log/serverlog.log")
    ;; (find-file "d:/sandboxes/sb_si_rating/classes/log/serverlog.log")
    ;; (auto-revert-tail-mode)
    ;; (goto-char (point-max))
    ))

(custom-set-variables
  ;; custom-set-variables was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 '(global-font-lock-mode t nil (font-lock)))
(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 )
