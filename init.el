;;; -*- Mode: Emacs-Lisp -*-

(when (locate-library "latin-unity") ;; exists only in XEmacs
  (require 'latin-unity))
(when (locate-library "latin-euro-input") ;; exists only in XEmacs
  (require 'latin-euro-input))

(defun revert-all-c++-buffers ()
  "Reread all buffers that contain c++ code."
  (interactive)
  (let ((list (buffer-list))
        buffer)
    (save-excursion
      (while list
        (setq buffer (car list))
        (setq list (cdr list))
        (set-buffer buffer)
        (and (eq major-mode 'c++-mode)
             (revert-buffer nil t))
        ))))

(defun revert-all-c-buffers ()
  "Reread all buffers that contain c code."
  (interactive)
  (let ((list (buffer-list))
        buffer)
    (save-excursion
      (while list
        (setq buffer (car list))
        (setq list (cdr list))
        (set-buffer buffer)
        (and (eq major-mode 'c-mode)
             (revert-buffer nil t))
        ))))

(defun agulbra-according-to-mode-tab (arg)
  "Do the right thing about tabs in any mode"
  (interactive "*P")
  (cond
   ((and (not (looking-at "[A-Za-z0-9]"))
         (save-excursion
           (forward-char -1)
           (looking-at "[A-Za-z0-9:>_\\-\\&\\.(){}\\*\\+/]")))
         (dabbrev-expand arg))
   (t
    (indent-according-to-mode)
    )))


;; Tastatur
(global-unset-key "\C-x\C-c")
(global-set-key "\C-xw" 'what-line)

(define-key global-map '(shift tab) 'self-insert-command)

;; mupad
(autoload 'mupad-mode "mupad-mode" "MuPAD editing mode" t)
(setq auto-mode-alist (append '(("\\.mu$" . mupad-mode)) auto-mode-alist))

;; C++
(add-hook 'c-mode-common-hook '(lambda nil 
				 (abbrev-mode 1)
				 (auto-fill-mode 1)))

;; Lisp
(define-key emacs-lisp-mode-map "\C-m" 'newline-and-indent)
(define-key emacs-lisp-mode-map '(control C) 'compile-defun)
(define-key emacs-lisp-mode-map '(control E) 'eval-defun)

;; Wheel Mouse
(autoload 'mwheel-install "mwheel" "Enable mouse wheel support.")
(mwheel-install)

;; Sonstiges.
;; Eigene Ergaenzungen.
(setq load-path (append '("~/.xemacs") 
                        load-path))

;; Pfad im Titel
(setq frame-title-format "xemacs: %f (%m)")

(global-set-key [(control %)] 'match-paren)
(put 'match-paren 'pending-delete t)

(add-hook 'text-mode-hook (lambda () (auto-fill-mode)))

(quietly-read-abbrev-file)

(require 'tex-mode)
(define-key tex-mode-map "\C-i" 'dabbrev-expand)

(setq auto-mode-alist (cons '("README$" . text-mode) auto-mode-alist))

(autoload 'metafont-mode "meta-mode" "Metafont editing mode." t)
(autoload 'metapost-mode "meta-mode" "MetaPost editing mode." t)

(setq auto-mode-alist
      (append '(("\\.mf\\'" . metafont-mode)
                ("\\.mp\\'" . metapost-mode)) auto-mode-alist))

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex)   ; Emacs latex mode

(require 'tex-site)
(require 'python-mode)
(require 'cc-mode)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(defun lyx-c++-mode ()
  "C++ mode with adjusted defaults for use with LyX."
  (interactive)
  (c++-mode)
  (c-set-style "K&R")
  (setq c-basic-offset 8)
  (setq indent-tabs-mode t)
  (c-set-offset 'innamespace 0)
  (c-set-offset 'inextern-lang 0)
  (imenu-add-to-menubar "Index")
  (c-toggle-auto-state 0)
  )

(setq auto-mode-alist (cons '("~/tmp/lyx-devel/.*\\.[Ch]$" . lyx-c++-mode)
                       auto-mode-alist))


(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (setq c-basic-offset 8))

(setq auto-mode-alist (cons '("/usr/src/linux.*/.*\\.[ch]$" . linux-c-mode)
                       auto-mode-alist))

(defun ccarat-c-mode ()
  "C mode with adjusted defaults for use with ccarat."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (imenu-add-to-menubar "Index")
  (setq c-basic-offset 2))

(setq auto-mode-alist (cons '("~/fem/ccarat.*/.*\\.[ch]$" . ccarat-c-mode)
                       auto-mode-alist))

(defun boomerang-c++-mode ()
  "C++ mode with adjusted defaults for use with boomerang."
  (interactive)
  (c++-mode)
  (c-set-style "K&R")
  (setq c-basic-offset 4)
  (setq indent-tabs-mode t)
  (setq tab-width 4)
  )

(setq auto-mode-alist (cons '("~/fem/boomerang/trunk/boomerang.*/.*\\.[ch]p?p?$" . boomerang-c++-mode)
                       auto-mode-alist))

(add-to-list 'load-path "~/.xemacs/kde-emacs")
(require 'semantic)
(require 'kde-emacs)

(define-key c-mode-map [(f10)] 'kde-switch-cpp-h)
(define-key c-mode-map [(shift f9)] 'fume-list-functions)
(define-key c-mode-map [(f9)] 'fume-prompt-function-goto)
(define-key c-mode-map [(control c)(f)] 'fume-prompt-function-goto)
(define-key c-mode-map "\C-m" 'c-context-line-break)
(define-key c-mode-map "\C-i" 'agulbra-c++-tab)

(define-key c-mode-map "\ef" 'c-forward-into-nomenclature)
(define-key c-mode-map "\ed" 'agulbra-delete-into-nomenclature)
(define-key c-mode-map "\eb" 'c-backward-into-nomenclature)

(define-key c-mode-map "\(" 'insert-parens)
(define-key c-mode-map "\)" 'insert-parens2)
;;(define-key c-mode-map "\," 'insert-comma)
(define-key c-mode-map "\{" 'insert-curly-brace)


(defun kill-named-buffers (buffer-name-regexp)
  (interactive "sBuffer name regexp: ")
  (let ((list (buffer-list)) buffer)
    (while list
      (setq buffer (car list))
      (setq list (cdr list))
      ;;(message (buffer-file-name buffer))
      (if (and
           (stringp (buffer-file-name buffer))
           (string-match buffer-name-regexp (buffer-file-name buffer)))
          (progn 
            (kill-buffer buffer)
            )))))

(require 'gdbsrc)
(define-key gdbsrc-mode-map "t" 'gdbsrc-set-tbreak-continue)


(defun mpi-gdb (path cmd-file &optional corefile)
  ;;; a copy of the gdb function that supports gdb's -x switch
  (setq path (file-truename (expand-file-name path)))
  (let ((file (file-name-nondirectory path)))
    (switch-to-buffer (concat "*gdb-" file "*"))
    (setq default-directory (file-name-directory path))
    (or (bolp) (newline))
    (insert "Current directory is " default-directory "\n")
    (apply 'make-comint
	   (concat "gdb-" file)
	   (substitute-in-file-name gdb-command-name)
	   nil
           "-q"
	   "-fullname"
	   "-cd" default-directory
           "-x" cmd-file
	   file
	   (and corefile (list corefile)))
    (set-process-filter (get-buffer-process (current-buffer)) 'gdb-filter)
    (set-process-sentinel (get-buffer-process (current-buffer)) 'gdb-sentinel)
    ;; XEmacs change: turn on gdb mode after setting up the proc filters
    ;; for the benefit of shell-font.el
    (gdb-mode)
    (gdb-set-buffer))
  ;;(delete-file cmd-file)
  )

(require 'ffap)                      ; load the package
(ffap-bindings)                      ; do default key bindings

;; Function Menu
(require 'func-menu)
(define-key global-map 'f8 'function-menu)
(add-hook 'find-file-hooks 'fume-add-menubar-entry)
(define-key global-map "\C-cl" 'fume-list-functions)
(define-key global-map "\C-cg" 'fume-prompt-function-goto)


(setq inhibit-startup-message t)

(require 'python-mode)

(defun agulbra-python-tab (arg)
  "Do the right thing about tabs in python mode"
  (interactive "*P")
  (cond
   ((and (not (looking-at "[A-Za-z0-9]"))
         (save-excursion
           (forward-char -1)
           (looking-at "[A-Za-z0-9:>_\\-\\&\\.(){}\\*\\+/]")))
         (dabbrev-expand arg))
   (t
    ;;(save-excursion
    ;; (beginning-of-line)
    ;; (py-indent-line))
    (py-indent-line)
    )))

(put 'py-electric-colon 'pending-delete t)

(define-key py-mode-map "\C-i" 'agulbra-python-tab)

(defun py-delete-into-nomenclature (&optional arg)
  "Delete forward until the end of a nomenclature section or word.
With arg, to it arg times."
  (interactive "p")
  (save-excursion
    (let ((b (point-marker)))
      (py-forward-into-nomenclature arg)
      (delete-region b (point-marker)))))

(define-key py-mode-map "\ef" 'py-forward-into-nomenclature)
(define-key py-mode-map "\ed" 'py-delete-into-nomenclature)
(define-key py-mode-map "\eb" 'py-backward-into-nomenclature)

; Add cmake listfile names to the mode list.
(setq auto-mode-alist
          (append
           '(("CMakeLists\\.txt\\'" . cmake-mode))
           '(("\\.cmake\\'" . cmake-mode))
           auto-mode-alist))

(autoload 'cmake-mode "~/.xemacs/cmake-mode.el" t)

(require 'un-define)
(set-coding-priority-list '(utf-8))
(set-coding-category-system 'utf-8 'utf-8)
