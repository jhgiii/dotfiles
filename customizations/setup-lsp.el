;;LSP Config -- Using Eglot
(require 'project)
(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))
(add-hook 'project-find-functions #'project-find-go-module)

(require 'company)
(require 'yasnippet)

(require 'go-ts-mode)
(require 'eglot)
(add-hook 'go-ts-mode-hook 'eglot-ensure)

(defun eglot-format-buffer-on-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
(add-hook 'go-ts-mode-hook #'eglot-format-buffer-on-save)

;;gopls customization
(setq-default eglot-workspace-configuration
              '((:gopls .
                        ((staticcheck . t) 
                         (matcher . "CaseSensitive")))))
