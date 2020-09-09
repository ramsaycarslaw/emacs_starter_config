;; ------------------------------------------------------------
;;                    Packages
;; ------------------------------------------------------------

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Not on SSL."))
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)


;; bootstarp use package which is responsible for managing all other package installs
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; ------------------------------------------------------------
;;                       Appearance
;; ------------------------------------------------------------

;;; emacs specific config 
(use-package emacs
  :init
  ;; set the font to be a nicer font
  (set-face-attribute 'default nil :font "Fira Code Retina 13")
  (set-frame-font "Fira Code Retina 13" nil t)

  ;; change the cursor to a bar
  (setq-default cursor-type 'bar)

  ;; remove borders
  (set-fringe-mode 0)

  ;; never type in yes or no only y or n
  (fset 'yes-or-no-p 'y-or-n-p)

  ;; complete brackets and so on
  (add-hook 'prog-mode-hook 'electric-pair-mode)

  ;; make hashtags work on mac keboard
  (global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#"))))

;;; Turn off all the gui stuff we don't need
(use-package tool-bar
  :init (tool-bar-mode 0))

(use-package scroll-bar
  :init (scroll-bar-mode 0))

(use-package menu-bar
  :init (menu-bar-mode 1))

;; ------------------------------------------------------------
;;                       Themes
;; ------------------------------------------------------------

;; icons used in the modeline
(use-package all-the-icons
  :ensure t
  :config
    ;; Uncomment theis line if icons break
  ;; (all-the-icons-install-fonts t)
  )

;; make the modeline look more modern
(use-package doom-modeline
  :ensure t
  :demand t
  :init (doom-modeline-mode 1))

;; main editor theme goes here
(use-package doom-themes
  :ensure t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  :config
  (load-theme 'doom-dark+ t))

;; make scrolling look more modern
(use-package smooth-scroll
  :ensure t
  :config
  (smooth-scroll-mode)
  (setq smooth-scroll/vscroll-step-size 2)
  (setq smooth-scroll/hscroll-step-size 4))

;; make the title bar much nicer
(use-package ns-auto-titlebar
  :ensure t
  :config
  (when (eq system-type 'darwin) (ns-auto-titlebar-mode)))

;; ------------------------------------------------------------
;;                     Editor settings
;; ------------------------------------------------------------

;; -- HELM --
;;Helm setup
(use-package helm
  :ensure t
  :demand t
  :init
  (progn
    (require 'helm-config)
    ;; limit max number of matches displayed for speed
    (setq helm-candidate-number-limit 100)
    ;; ignore boring files like .o and .a
    (setq helm-ff-skip-boring-files t)
    ;; replace locate with spotlight on Mac
    (setq helm-locate-command "mdfind -name %s %s"))

  
  :bind (("M-x" . helm-M-x)
	 ("C-x C-f" . helm-find-files)
	 ("C-x b" . helm-mini)
	 ("C-x C-b" . helm-mini)
	 ("M-y" . helm-show-kill-ring))
  :config (helm-mode 1))

(use-package helm-swoop
  :ensure t
  :demand t
  :bind (("\C-s" . helm-swoop)
	 ("s-f" . helm-swoop)))

(add-hook 'prog-mode-hook 'electric-pair-mode)

;; beacon shows where the cursor is when switching buffers
;; as part of this we also turn on hl line mode
(use-package beacon
  :ensure t
  :init
  (when window-system (add-hook 'prog-mode-hook 'hl-line-mode))
  (beacon-mode 1))

;; line numbers
(use-package display-line-numbers
  :ensure t
  :config
  (global-display-line-numbers-mode t))

;; ------------------------------------------------------------
;;                      Autocomplete
;; ------------------------------------------------------------

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package flycheck
  :ensure t)

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

;;Optional - provides fancier overlays.

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable t
	lsp-ui-doc-use-childframe t
	lsp-ui-doc-position 'top
	lsp-ui-doc-include-signature t
	lsp-ui-sideline-enable nil
	lsp-ui-flycheck-enable t
	lsp-ui-flycheck-list-position 'right
	lsp-ui-flycheck-live-reporting t
	lsp-ui-peek-enable t
	lsp-ui-peek-list-width 60
	lsp-ui-peek-peek-height 25)
  :hook
  (lsp-mode . lsp-ui-mode))

;;Company mode is a standard completion package that works well with lsp-mode.
;;company-lsp integrates company mode completion with lsp-mode.
;;completion-at-point also works out of the box but doesn't support snippets.

(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0
	company-show-numbers nil
	company-dabbrev-ignore-case 1
	company-selection-wrap-around t
	company-minimum-prefix-length 1
	company-tooltip-align-annotations t)

  (global-company-mode t))

(use-package company-lsp
  :ensure t
  :commands company-lsp
  :config
  (push 'company-lsp company-backends)

  (setq company-transformers nil
        company-lsp-async t
        company-lsp-cache-candidates nil))

(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workplace-symbol)


;; fixed bugs ->
;; 1. customize-group RET company-box RET
;; 2. untick all atributes on company-box-scrollbar
(use-package company-box
  :ensure t
  :config
  (setq company-box-doc-enable nil)
  (setq company-box-icons-all-the-icons t)
  (setq company-box-scrollbar t)
  (setq company-box-backends-colors nil)
  (setq show-trailing-whitespace nil)
  :hook (company-mode . company-box-mode))

;; ------------------------------------------------------------
;;                     C
;; ------------------------------------------------------------

;; Use the ccls language server as a backend for completion etc
(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake 1)
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

;; set my default C style to that of Kernigahn and Ritchie
(setq c-default-style "k&r")

;; ------------------------------------------------------------
;;                      Go
;; ------------------------------------------------------------

;;Set up before-save hooks to format buffer and add/delete imports.
;;Make sure you don't have other gofmt/goimports hooks enabled.

(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Go-Eldoc - really nice docs

(use-package go-eldoc
  :ensure t
  :requires go-mode
  :hook (go-mode . go-eldoc-setup))

;; press M-, to compile
(use-package go-mode
:defer t
:ensure t
:mode ("\\.go\\'" . go-mode)
:init
  (setq compile-command "echo Building... && go build -v && echo Testing... && go test -v && echo Linter... && golint")  
  (setq compilation-read-command nil)
:bind (("M-," . compile)
("M-." . godef-jump)))

(setq compilation-window-height 14)
(defun my-compilation-hook ()
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
	(let* ((w (split-window-vertically))
	       (h (window-height w)))
	  (select-window w)
	  (switch-to-buffer "*compilation*")
	  (shrink-window (- h compilation-window-height)))))))
(add-hook 'compilation-mode-hook 'my-compilation-hook)

(global-set-key (kbd "C-c C-c") 'comment-or-uncomment-region)
(setq compilation-scroll-output t)

;; ------------------------------------------------------------
;;                      Python
;; ------------------------------------------------------------

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package py-autopep8
  :defer t
  :ensure t
  :init
  (add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save))

;; ------------------------------------------------------------
;;                     startup
;; ------------------------------------------------------------

(use-package dashboard
  :ensure t
  :config (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t))

;; ------------------------------------------------------------
;;                        File Tree & Tabs
;; ------------------------------------------------------------

(use-package neotree
  :ensure t
  :config
  (global-set-key [f8] 'neotree-toggle)
  (global-set-key (kbd "s-b") 'neotree-toggle)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))


