(setenv "PYTHONPATH" (concat (expand-file-name "~/.emacs.d/Pymacs-0.23")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-jedi")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-pylint")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-epc")
                             path-separator
                             (expand-file-name "~/.emacs.d/python-pep8")))

(mapc 'install-if-needed '(python-mode jedi))

(require 'python-mode)
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(setq py-electric-colon-active t)
(add-hook 'python-mode-hook 'autopair-mode)
(add-hook 'python-mode-hook 'yas-minor-mode)

;; ;; Jedi settings
(require 'jedi)
;; It's also required to run "pip install --user jedi" and "pip
;; install --user epc" to get the Python side of the library work
;; correctly.
;; With the same interpreter you're using.

;; if you need to change your python intepreter, if you want to change it
;; (setq jedi:server-command
;;       '("python2" "/home/andrea/.emacs.d/elpa/jedi-0.1.2/jediepcserver.py"))

(add-hook 'python-mode-hook
	  (lambda ()
	    (jedi:setup)
	    (jedi:ac-setup)
            (local-set-key "\C-cd" 'jedi:show-doc)
            (local-set-key (kbd "M-SPC") 'jedi:complete)
            (local-set-key (kbd "M-.") 'jedi:goto-definition)))


(add-hook 'python-mode-hook 'auto-complete-mode)

;; pymacs
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
(eval-after-load "pymacs"
  '(progn
     (add-to-list 'pymacs-load-path "~/.emacs.d/rope/ropemacs-0.6")
     (add-to-list 'pymacs-load-path "~/.emacs.d/rope/rope-0.9.3")))

(autoload 'pylookup-lookup "pylookup")
(autoload 'pylookup-update "pylookup")
(setq pylookup-program "~/.emacs.d/pylookup/pylookup.py")
(setq pylookup-db-file "~/.emacs.d/pylookup/pylookup.db")
(global-set-key "\C-ch" 'pylookup-lookup)

;; rope refactoring
(setq ropemacs-enable-shortcuts 'nil)
(setq ropemacs-enable-autoimport t)
(pymacs-load "ropemacs" "rope-")

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

;; (add-hook 'python-mode-hook (lambda ()
;;                               (local-set-key "\C-c\C-q" 'python-nosetests)))

(require 'python-pep8)
;; Bind RET to newline-and-indent
(add-hook 'python-mode-hook
          '(lambda ()
             (define-key  python-mode-map "\C-m" 'newline-and-indent)))
