(use-package em-alias
  :config
  (eshell/alias "wcna" "ct ssh dt232719@wcna.ssnc-corp.cloud -p 8022")
  (eshell/alias "icna" "ct ssh dt232719@wcna.ssnc-corp.cloud -p 8022")  
  (eshell/alias "wcna-mgmt" "ct ssh dt232719@wcna.ssnc-corp.cloud")
  (eshell/alias "icna-mgmt" "xt ssh dt232719@icna.ssnc-corp.cloud")
  (eshell/alias "jump" "ct ssh dt232719@jump.ssnc-corp.cloud"))

(define-key eshell-mode-map (kbd "C-c C-k") 'eshell-interrupt-process)
