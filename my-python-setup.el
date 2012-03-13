(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
				   interpreter-mode-alist))
;; pymacs
(setenv "PYTHONPATH" (concat (expand-file-name "~/.emacs.d/Pymacs-0.23")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-pylint")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-pep8")))
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

(autoload 'pylookup-lookup "pylookup")
(autoload 'pylookup-update "pylookup")
(setq pylookup-program "~/.emacs.d/pylookup/pylookup.py")
(setq pylookup-db-file "~/.emacs.d/pylookup/pylookup.db")
(global-set-key "\C-ch" 'pylookup-lookup)

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

(setq flymakeroot (expand-file-name "~/.emacs.d/flymake/"))
(when (load "flymake" t)
(defun flymake-pylint-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "python"
          (list "-m" "pylint.lint" "-f" "parseable" local-file))))

   (add-to-list 'flymake-allowed-file-name-masks
                '("\\.py\\'" flymake-pylint-init)))

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

(require 'python-pep8)
(require 'python-pylint)
