; Org Stuff
(use-package org
  :ensure t
  :defer t
  :custom
  ;;Agenda
  (org-directory "~/org")
  (org-agenda-files '("~/org/inbox.org"
                           "~/org/projects.org"
                           "~/org/someday.org"
                           "~/org/waiting.org"))
  (org-log-done t)
  (org-use-fast-todo-selection t)

  :config
  (require 'org-tempo) ;; <s TAB code blocks
  (require 'ox-gfm nil t) ;; github format mardown export
  (setq org-done-file "~/org/done.org")
  (setq org-archive-location "~/org/done.org::datetree")
  (setq org-ascii-text-width 250)    ;; ascii line wrap on export  
  (setq org-adapt-indentation t) 
  (font-lock-add-keywords 'org-mode ;; Change dashes to boxes
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "▪"))))))
  (add-hook 'org-mode-hook 'org-indent-mode)  
  (setq org-capture-templates
      '(("p" "Project Task" entry
         (file+headline "~/org/projects.org" "Projects")
         "* TODO %?\n  %U\n")
        ("t" "Task" entry (file "~/org/inbox.org")
         "* TODO %?\n  %U\n  %a")
        ("m" "Meeting" entry (file "~/org/meetings.org")
         "* MEETING with %? :MEETING:\n%U")
        ("i" "Incident" entry (file "~/org/inbox.org")
         "* INCIDENT %?\n%U\n%a")
        ("w" "Waiting" entry (file "~/org/waiting.org")
         "* WAITING %? :WAITING:\n%U")))
  (setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "WAITING(w)" "|" "Review(r)" "DONE(d)" "CANCELLED(c)")))
  (setq org-refile-targets
        '(("~/org/projects.org" :maxlevel . 2)
          ("~/org/done.org" :maxlevel . 1)))
  (setq org-agenda-custom-commands
        '(("n" "Next Actions" tags-todo "+NEXT")
          ("w" "Waiting" todo "WAITING")
          ("p" "Projects" tags "+project")
          ("r" "Weekly Review tags +review"
           ((agenda "")
            (tags-todo "+inbox")
            (todo "NEXT")
            (todo "WAITING")
            (todo "SOMEDAY")))))
  (setq org-refile-use-outline-path 'file) ;; Show paths like: file.org/Project/Subtask
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-targets
        '(("~/org/projects.org" :maxlevel . 3)
          ("~/org/someday.org"  :maxlevel . 2)
          ("~/org/waiting.org"  :maxlevel . 2)))) ;; Show full flat list


(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map (kbd "C-c c") 'org-capture)
(define-key org-mode-map (kbd "C-c C-w") #'org-refile)
(define-key global-map (kbd "C-c r") #'consult-org-heading)

;;org-download
(use-package org-download
    :after org 
    :defer nil
    :custom
    (org-download-method 'directory)
    (org-download-image-dir "images")
    (org-download-heading-lvl nil)
    (org-download-timestamp "%Y%m%d-%H%M%S_")
    (org-image-actual-width 300)
    (org-download-screenshot-method "/usr/local/bin/pngpaste %s")
    :bind
    ("C-M-y" . org-download-screenshot)
    :config
    (require 'org-download))
