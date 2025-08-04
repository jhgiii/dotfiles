(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package vertico-posframe
  :after vertico
  :ensure t
  :custom
  (vertico-posframe-parameters
   '((left-fringe . 8)
     (right-fringe . 8)))
  (vertico-posframe-poshandler #'posframe-poshandler-frame-center)
  :config
  (vertico-posframe-mode 1))


(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package consult
  :ensure t
  :bind
  (("C-s" . consult-line)                ;; Search in current buffer
   ("M-g g" . consult-goto-line)         ;; Go to line
   ("C-x b" . consult-buffer)            ;; Switch buffer
   ("C-c r" . consult-org-heading)       ;; Jump to org headings
   ("C-c f" . consult-find)              ;; Find file
   ("C-c g" . consult-ripgrep)           ;; Grep-like search
   ("M-y" . consult-yank-pop)))          ;; View kill ring

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)            ;; pick an action
   ("C-h B" . embark-bindings))    ;; describe keybindings
  :init
  (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :after (embark consult)
  :ensure t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(setq completion-cycle-threshold 3)
(setq tab-always-indent 'complete)


;; "When several buffers visit identically-named files,
;; Emacs must give the buffers distinct names. The usual method
;; for making buffer names unique adds ‘<2>’, ‘<3>’, etc. to the end
;; of the buffer names (all but one of them).
;; The forward naming method includes part of the file's directory
;; name at the beginning of the buffer name
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Uniquify.html
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; Turn on recent file mode so that you can more easily switch to
;; recently edited files when you first start emacs
(setq recentf-save-file (concat user-emacs-directory ".recentf"))
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 40)


;; Enhances M-x to allow easier execution of commands. Provides
;; a filterable list of possible commands in the minibuffer
;; http://www.emacswiki.org/emacs/Smex
(setq smex-save-file (concat user-emacs-directory ".smex-items"))
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)

;; projectile everywhere!
(projectile-global-mode)
