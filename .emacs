(when (equal system-type 'darwin)
  (setq insert-directory-program "/usr/local/opt/coreutils/libexec/gnubin/ls"))
(setenv "PATH" (concat (getenv "PATH") ":/Users/dt232719/workspace/bin"))



;; ivy

(ivy-mode)
(setq ivy-use-virtual-buffers t)
(setq enable-recursive-minibuffers t)
;; enable this if you want `swiper' to use it
;; (setq search-default-mode #'char-fold-to-regexp)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> o") 'counsel-describe-symbol)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)


(require 'ivy-posframe)
;; Different command can use different display function.
(setq ivy-posframe-height-alist '((swiper . 10)
                                  (t      . 10)))

(setq ivy-posframe-display-functions-alist
      '((swiper          . ivy-display-function-fallback)
        (complete-symbol . ivy-posframe-display-at-point)
        (counsel-M-x     . ivy-posframe-display-at-window-bottom-left)
	(magit-status    .  ivy-posgrame-display-at-frame-center)
        (t               . ivy-posframe-display)))
(ivy-posframe-mode 1)

;; Define the init file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Define and initialise package repositories

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Archives from which to fetch.
(setq package-archives
      (append '(("melpa" . "http://melpa.org/packages/"))
              package-archives))


;;Set Exec PATH
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
						    ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

;; use-package to simplify the config file
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure 't)

;; Disable Startup Menu
(setq inhibit-startup-message t)

;; Theme
;;(use-package toleuven-theme
;;  :config (load-theme 'leuven-theme t))

;; Open dired in same buffer
(put 'dired-find-alternate-file 'disabled nil)

;; Sort Dired buffers
(setq dired-listing-switches "-agho --group-directories-first")

;; Copy and move files netween dired buffers
(setq dired-dwim-target t)

;; Only y/n answers
(defalias 'yes-or-no-p 'y-or-n-p)

;; Move deleted files to trash
(setq delete-by-moving-to-trash t)

;; Keep folders clean (create new directory when not yet existing)
(make-directory (expand-file-name "backups/" user-emacs-directory) t)
(setq backup-directory-alist `(("." . ,(expand-file-name "backups/" user-emacs-directory))))
;;Go Config
(use-package go-mode
  :mode "\\.go\\'"
  :config
  (defun my/go-mode-setup ()
    "Basic Go mode setup."
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'my/go-mode-setup))


;;LSP Config
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-mode lsp-deferred)
  :hook ((python-mode go-mode) . lsp-deferred)
  :config
  (setq lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil)
  ;; for filling args placeholders upon function completion candidate selection
  ;; lsp-enable-snippet and company-lsp-enable-snippet should be nil with
  ;; yas-minor-mode is enabled: https://emacs.stackexchange.com/q/53104
  (lsp-modeline-code-actions-mode)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-to-list 'lsp-file-watch-ignored "\\.vscode\\'"))


;;Font
(set-frame-font "Source Code Pro 18")

;;Override SVG Errors
;; overriding image.el function image-type-available-p
(defun image-type-available-p (type)
  "Return t if image type TYPE is available.
Image types are symbols like `xbm' or `jpeg'."
  (if (eq 'svg type)
      nil
    (and (fboundp 'init-image-library)
         (init-image-library type))))
(setq image-types (cons 'svg image-types))


;;Evil
(require 'evil)
  (evil-mode 1)
(evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle)
(add-hook 'vterm-mode-hook 'evil-emacs-state)
;;Start Treemacs by on Startup
(add-hook 'emacs-startup-hook 'treemacs)

;;Set Frame Size on Startup
(if (window-system)
    (set-frame-size (selected-frame) 256 60))

;; Packages
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

;; Org Stuff
;; Ascii Line Wrapping on Export
(setq org-ascii-text-width 250)
;; Screenshot Pasting
(use-package org-download
    :after org
    :defer nil
    :custom
    (org-download-method 'directory)
    (org-download-image-dir "images")
    (org-download-heading-lvl nil)
    (org-download-timestamp "%Y%m%d-%H%M%S_")
    (org-image-actual-width 1200)
    (org-download-screenshot-method "/usr/local/bin/pngpaste %s")
    :bind
    ("C-M-y" . org-download-screenshot)
    :config
    (require 'org-download))

;;Toggle Indents
(setq org-adapt-indentation t)
(add-hook 'org-mode-hook 'org-indent-mode)

;; increase header font size and weight
;; (custom-set-faces
;;   '(org-level-1 ((t (:height 1.3 :weight bold))))
;;   '(org-level-2 ((t (:height 1.2 :weight bold))))
;;  '(org-level-3 ((t (:height 1.1 :weight bold)))))

;; hide asterisks in headers
;;(use-package org-bullets
;;  :ensure t
;;  :config
;;  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;;  (setq org-bullets-bullet-list '("\u200b")))

;; change list markers from hyphens to squares
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "▪"))))))

;; increase line spacing
(setq-default line-spacing 0.5)
;; Org-temp for <s TAB insertion of code blocks
(require 'org-tempo)

;; org-agenda
(setq org-agenda-files (list "~/org/tickets.org"
                             "~/org/projects.org"
			     "~/Projects/na-upgrade/na-upgrade.org"
			     "~/personal.org"))



;; org-agenda: shortcuts
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
;;Popper
(use-package popper
  :ensure t ; or :straight t
  :bind (("C-`"   . popper-toggle-latest)
         ("M-`"   . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
	  "\\*Org Agenda\\*"
          help-mode
	  vterm-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1))                ; For echo area hints
(setq popper-reference-buffers
      (append popper-reference-buffers
              '("^\\*eshell.*\\*$" eshell-mode ;eshell as a popup
                "^\\*shell.*\\*$"  shell-mode  ;shell as a popup
                "^\\*term.*\\*$"   term-mode   ;term as a popup
                "^\\*vterm.*\\*$"  vterm-mode  ;vterm as a popup
                )))

;; Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode))
  :init (setq markdown-command "/usr/local/bin/multimarkdown"))
