;;Go Language-specific configuraiton

(require 'company)
(company-mode 1)

(add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode))

(require 'yasnippet)
(yas-global-mode 1)

(require 'flycheck)
(global-flycheck-mode 1)

(defun go-run ()
  (make-local-variable 'compile-command)
  (setq compile-command "go run .")
  (define-key go-run (kbd "C-c C-c") #'compile))
(add-hook 'go-ts-mode-hook (lambda () (define-key go-ts-mode-map (kbd "C-c C-c") 'go-run)))
(add-hook 'go-ts-mode-hook #'go-run)
