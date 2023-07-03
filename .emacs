(setenv "PATH" (concat (getenv "PATH") ":/Users/jim/workspace/bin"))
;; Define the init file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; Define and initialise package repositories
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
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

;; Keyboard-centric user interface
(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; Theme
(use-package light-soap-theme
  :config (load-theme 'light-soap t))

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
  :hook ((rust-mode python-mode go-mode) . lsp-deferred)
  :config
  (setq lsp-prefer-flymake nil
        lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil
        lsp-rust-server 'rust-analyzer)
  ;; for filling args placeholders upon function completion candidate selection
  ;; lsp-enable-snippet and company-lsp-enable-snippet should be nil with
  ;; yas-minor-mode is enabled: https://emacs.stackexchange.com/q/53104
  (lsp-modeline-code-actions-mode)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-to-list 'lsp-file-watch-ignored "\\.vscode\\'"))


;;Font
(set-frame-font "Monaco 14" nil t)

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
