;; Python Mode Enhancements
(use-package python
  :ensure nil
  :hook ((python-mode . eglot-ensure)
         (python-mode . pyvenv-mode))
  :config
  (setq python-shell-interpreter "ipython"
        python-shell-interpreter-args "-i --simple-prompt"))

;; Virtual Environment
(use-package pyvenv
  :ensure t
  :config
  (setq pyvenv-workon ".venv") ; Optional default
  (pyvenv-tracking-mode 1))

;; LSP Support with Eglot
(use-package eglot
  :ensure t
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode) . ("pylsp"))))

;; Black Formatter
(use-package blacken
  :ensure t
  :hook (python-mode . blacken-mode))

;; Testing
(use-package python-pytest
  :ensure t
  :after python
  :bind (:map python-mode-map
              ("C-c t" . python-pytest-dispatch)))
