;;; setup-ui.el --- setup ui

;; Author: SH147NDT2F  schspa@SH147NDT2F
;; Keywords: UI
;; URL:

;; Copyright (C) 2019, SH147NDT2F, all rights reserved.
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
(menu-bar-mode 0)
(tool-bar-mode 0)

(if window-system (scroll-bar-mode 0))
(global-visual-line-mode t)
(global-hl-line-mode t)

(when (>= emacs-major-version 26)
  (global-display-line-numbers-mode t))

(defun hidden-dos-eol ()
  "Do not show ^M in files containing mixed UNIX and DOS line              endings."
  (interactive)
  (unless buffer-display-table
    (setq buffer-display-table (make-display-table)))
  (aset buffer-display-table ?\^M []))

(use-package all-the-icons
  :ensure t)

(use-package popwin
  :ensure t
  :init
  :config
  (popwin-mode 1))

;; auto adjust font according to screen dpi
;; frome https://emacs.stackexchange.com/questions/28390/quickly-adjusting-text-to-dpi-changes
(defun my-dpi ()
  (let* ((attrs (car (display-monitor-attributes-list)))
         (res (assoc 'mm-size attrs))
         (resx (cadr res))
         (size (cdr (assoc 'geometry attrs)))
         (sizex (car (nthcdr 2 size)))
         dpi)
    (catch 'exit
      ;; in terminal
      (unless resx
        (throw 'exit 10))
      ;; on big screen
      (when (> resx 1000)
        (throw 'exit 18))
      ;; DPI
      (/ (float sizex) resx))))

(defcustom schspa/font-size 4.5
  "font-size in mm."
  :group 'schspa
  :type 'float)

(defcustom schspa/font-size-fixed 15
  "font-size in fixed."
  :group 'schspa
  :type 'int)

(defun my-preferred-font-size ()
  (if (or sys/wslp sys/xprap) schspa/font-size-fixed
    (truncate (* schspa/font-size (my-dpi)))))

(defun setup-font ()
  ;; Fonts
  (when (display-graphic-p)
    ;; Set default font
    (catch 'loop
      (dolist (font '("Inconsolata for Powerline" "DejaVu Sans Mono" "Monaco" "SF Mono" "Hack" "Source Code Pro" "Fira Code"
                      "Menlo" "DejaVu Sans Mono" "Consolas"))
        (when (member font (font-family-list))
          (set-face-attribute 'default nil :font font :height (* (my-preferred-font-size) 10))
          (throw 'loop t))))

    ;; Specify font for all unicode characters
    (catch 'loop
      (dolist (font '("Inconsolata for Powerline" "DejaVu Sans Mono" "Symbola" "Apple Symbols" "Symbol"))
        (when (member font (font-family-list))
          (set-fontset-font t 'unicode font nil 'prepend)
          (throw 'loop t))))

    ;; Specify font for Chinese characters
    (catch 'loop
      (dolist (font '("Inconsolata for Powerline" "DejaVu Sans Mono" "Noto Sans Mono" "WenQuanYi Micro Hei" "Microsoft Yahei"))
        (when (member font (font-family-list))
          (set-fontset-font t '(#x4e00 . #x9fff) font)
          (throw 'loop t))))))

(use-package dracula-theme
  :ensure t)

(use-package ample-theme
  :ensure t
  :init
  (progn (load-theme 'ample t t)
         (load-theme 'ample-flat t t)
         (load-theme 'ample-light t t))
  :defer t
  :ensure t)

(if (daemonp)
    (add-hook 'after-make-frame-functions
              (lambda (frame)
                (select-frame frame)
                (if (display-graphic-p frame)
                    (progn
                      (load-theme 'dracula t)
                      (enable-theme 'dracula)
                      (setup-font)))))
  (if (display-graphic-p)
      (progn
        (enable-theme 'dracula)
        (setup-font))
    (enable-theme 'ample-flat)))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (setq dashboard-items '((recents . 10)
						  (projects . 5)
						  (bookmarks . 5)
						  (agenda . 5)
						  (registers . 5))))

(provide 'setup-ui)

;; Local Variables:
;; coding: utf-8
;; End:

;;; setup-ui.el ends here.
