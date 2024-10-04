; Org Stuff
;; Ascii Line Wrapping on Export
(setq org-ascii-text-width 250)

;;Toggle Indents
(setq org-adapt-indentation t)
(add-hook 'org-mode-hook 'org-indent-mode)

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
