
(use-package anaconda-mode)

(use-package pyenv-mode
  :ensure t
  :config
  (defun projectile-pyenv-mode-set ()
    "Set pyenv version matching project name."
    (let ((project (projectile-project-name)))
      (if (member project (pyenv-mode-versions))
          (pyenv-mode-set project)
        (pyenv-mode-unset))))

  (add-hook 'projectile-switch-project-hook 'projectile-pyenv-mode-set)
  (add-hook 'python-mode-hook 'pyenv-mode))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))

(use-package pyenv-mode-auto
  :ensure t)
;; (add-hook 'python-mode-hook
;;           (lambda ()
;; 			(anaconda-mode t)
;;             (set (make-local-variable 'company-backends)
;; 				 '((company-anaconda company-dabbrev-code company-capf) company-dabbrev))
;; 			(pyenv-mode t)))

(provide 'setup-python)
