;Evil
(require 'evil)
  (evil-mode 1)
(evil-define-key 'normal org-mode-map (kbd "<tab>") #'org-cycle)
(add-hook 'vterm-mode-hook 'evil-emacs-state)

