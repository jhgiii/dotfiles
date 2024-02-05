; Org Stuff
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
;;(setq-default line-spacing 0.5)
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
