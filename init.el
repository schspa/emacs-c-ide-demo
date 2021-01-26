(when (>= emacs-major-version 24)
  (require 'package)
  (setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
						   ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                           ("org" . "https://orgmode.org/elpa/")))
  (package-initialize))

;; cl - Common Lisp Extension
(require 'cl)

;; Add Packages
(defvar my/packages '(
		              ;; --- Auto-completion ---
		              company
		              ;; --- Better Editor ---
		              hungry-delete
		              swiper
		              counsel
		              smartparens
		              ;; --- Major Mode ---
		              js2-mode
		              ;; --- Minor Mode ---
		              nodejs-repl
		              exec-path-from-shell
		              ;; --- Themes ---
		              ;; solarized-theme
                      ;; smart-mode-line
                      validate
                      dracula-theme
					  android-mode
		              anaconda-mode
					  company-c-headers
                      quelpa
                      quelpa-use-package
					  ) "Default packages")

(setq package-selected-packages my/packages)

(defun my/packages-installed-p ()
  (loop for pkg in my/packages
	    when (not (package-installed-p pkg)) do (return nil)
	    finally (return t)))

(unless (my/packages-installed-p)
  (message "%s" "Refreshing package database...")
  (package-refresh-contents)
  (dolist (pkg my/packages)
    (when (not (package-installed-p pkg))
	  (package-install pkg))))

;; Map Alt key to Meta
(setq x-alt-keysym 'meta)
(setq mac-option-modifier 'hyper)
(setq mac-command-modifier 'meta)

;; Find Executable Path on OS X
(when (eq system-type 'darwin)
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq-default use-package-always-ensure t)

(setq quelpa-update-melpa-p nil)
(setq quelpa-self-upgrade-p nil)
(require 'quelpa)

(defvar my-cache-dir (concat user-emacs-directory ".cache")
  "My cache directory")

(require 'quelpa-use-package)
(quelpa-use-package-activate-advice)

(use-package el-get
  :ensure t
  :init
  (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
  :config
  (add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes"))

(setq custom-file "~/.emacs-custom.el")
(if (file-exists-p custom-file) (load custom-file))

(add-to-list 'load-path "~/.emacs.d/custom")

(require 'use-package)

(require 'server)
(let* ((server-dir (if server-use-tcp server-auth-dir server-socket-dir))
	   (server-file (expand-file-name server-name server-dir)))
  (message "server server-file: %s" server-file)
  (unless (file-exists-p server-file)
    (server-start)))

(require 'init-const)
(require 'setup-ui)
(require 'setup-modeline)
(require 'setup-general)
(require 'setup-ivy-counsel)
(require 'setup-projectile)
(require 'setup-prog)
(require 'setup-md)
(require 'setup-windows)
(require 'setup-abbrev)
(require 'setup-editing)
(require 'setup-lsp)
(require 'setup-c)
(require 'setup-python)
(require 'setup-bugreport)
(require 'setup-elisp)
(require 'setup-eaf)
(require 'setup-org)
(require 'setup-pdf)
(require 'setup-wsl)
(require 'setup-site)
(require 'setup-telegram)
(require 'setup-mail)
(require 'setup-vterm)
(put 'magit-clean 'disabled nil)
