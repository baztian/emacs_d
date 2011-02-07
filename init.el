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
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)

;; pymacs
(setenv "PYTHONPATH" (concat (getenv "HOME") "/.emacs.d/Pymacs-0.23"))
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(eval-after-load "pymacs"
  '(progn
     (add-to-list 'pymacs-load-path "~/.emacs.d/python-mode-1.0")
     (add-to-list 'pymacs-load-path "~/.emacs.d/rope/ropemacs-0.6")
     (add-to-list 'pymacs-load-path "~/.emacs.d/rope/rope-0.9.3")))


(require 'pycomplete)

;; rope refactoring
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)


;; flymake with pyflakes
;; (when (load "flymake" t)
;;        (defun flymake-pyflakes-init ()
;;          (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                             'flymake-create-temp-inplace))
;;             (local-file (file-relative-name
;;                          temp-file
;;                          (file-name-directory buffer-file-name))))
;;            (list "pyflakes" (list local-file))))

;;        (add-to-list 'flymake-allowed-file-name-masks
;;                 '("\\.py\\'" flymake-pyflakes-init)))

;;  (add-hook 'find-file-hook 'flymake-find-file-hook)

(when (load "flymake" t)
  (defun flymake-pylint-init (&optional trigger-type)
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name)))
	   (options (when trigger-type (list "--trigger-type" trigger-type))))
      (list "~/.emacs.d/flymake/pyflymake.py" (append options (list local-file)))))

  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-pylint-init)))


;; flymake with pylint
;; (when (load "flymake" t)
;;   (defun flymake-pylint-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                        'flymake-create-temp-inplace))
;;        (local-file (file-relative-name
;;                     temp-file
;;                     (file-name-directory buffer-file-name))))
;;       (list "epylint" (list local-file))))

;;   (add-to-list 'flymake-allowed-file-name-masks
;;            '("\\.py\\'" flymake-pylint-init)))


;; ipython
;; If you happen to get garbage instead of colored prompts as described
;; in the previous section, you may need to set also in your .emacs file:
(setq ansi-color-for-comint-mode t) 

;; (require 'ipython)

;; bicycle repair
;; (pymacs-load "bikeemacs" "brm-")
;; (brm-init)

;; pylint
(load-library "pylint")

;; http://paste.lisp.org/display/76342
;; change to a virtualenv from within a interactive python environment
(defun insert-virtualenv-load-line (virtualenv-dir)
  (interactive "DVirtualenv directory: ")
  (let ((activate-file (expand-file-name (concat virtualenv-dir "./bin/activate_this.py"))))
    (if (file-exists-p activate-file)
        (insert
         (concat "execfile('" activate-file
                 "', dict(__file__='" activate-file "'))"))
      (error "No ./bin/activate_this.py in that virtualenv (maybe update virtualenv?)"))))

;; inspired by
;; http://travisjeffery.com/post/53595318/integrating-nose-python-with-emacs

(defun python-nosetests ()
  "Runs nosetests command on current file."
  (interactive)
  (let (;(eshell-buffer-name "foobar")
        (python-bin-dir '~/Sources/dbxoverEnv/bin)
        (directory (substring (buffer-file-name) 0
                              (- (length (buffer-file-name))
                                 (+ 1 (length (buffer-name))))))
        (file (file-name-sans-extension (buffer-name))))
    ;; (compile (format "%s/python %s/nosetests --pdb -w%s %s"
    (compile (format "%s/python %s/nosetests -w%s %s"
                            python-bin-dir python-bin-dir directory file)
                    )))

(add-hook 'python-mode-hook (lambda ()
(local-set-key "\C-c\C-q" 'python-nosetests)))


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
