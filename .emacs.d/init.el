;; Time-stamp: <2022-06-12 18:11:19 zshuang>
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load path:
;;
;; According to elisp:
;;
;; 1. the following paths are always in the load-path:
;;
;;    /usr/local/share/emacs/VERSION/site-lisp
;;    /usr/local/share/emacs/site-lisp
;;
;; 2. each element in load-path automatically expand to include all
;;    subdirs (but not grandsons, nahh)
;;
;; 3. 'nil' means cwd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;(setq load-path
;;      (append (list
;;	       "/usr/share/emacs"	;archlinux
;;	       "/usr/share/emacs/site-lisp" ; system site-lisp on gentoo
;;	       "~/.emacs.d/lisp"	    ; downloaded staff
;;	       "/usr/local/share/emacs"		  ;local
;;	       "/usr/local/share/emacs/site-lisp" ;local
;;	       "/usr/share/maxima/5.34.1/emacs"	  ;maxima and imaxima
;;	       )
;;	      load-path))
(column-number-mode 1)
(ido-mode 1)
(setq
 ido-default-file-method 'maybe-frame 
 ido-default-buffer-method 'maybe-frame)

(setq display-time-day-and-date t)
(display-time)
(setq tab-width 4)
(setq uniquify-buffer-name-style 'reverse)
(setq split-window-keep-point nil)

;;;;;; fonts
;; in addition to .Xresources, need to set the following for fonts to work correctly on a second X410 DISPLAY (e.g., :1.0 in addition to :0.0)
(set-frame-font "Terminus 12")
(add-to-list 'default-frame-alist '(font . "Terminus 12"))

;;;; WSL stuff
;; turn full screen upon open
;;(add-to-list 'initial-frame-alist '(fullscreen . fullheight))
;;(add-to-list 'default-frame-alist '(fullscreen . fullheight))
;; turn off scroll lock tracking. c.f.
;;https://superuser.com/questions/329639/how-to-make-emacs-stop-trapping-scroll-lock
(global-set-key (kbd "<Scroll_Lock>") 'ignore)
;; turn off bell
(setq ring-bell-function 'ignore)

;; package management
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; enable time-stamp
;; add `Time-stamp: ""/<>' to the 1st 8 lines of a file
;(add-hook 'write-file-hooks 'time-stamp)
(add-hook 'before-save-hook 'time-stamp)

;;;; enable color in shell-mode
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;;;;;;;;;;;;;;;;
;; imaxima    ;;
;;;;;;;;;;;;;;;;
;;(autoload 'imaxima "imaxima" "Image support for Maxima." t)
;;(setq imaxima-equation-color "light green" ; "light goldenrod"
;;      imaxima-scale-factor 2
;;      imaxima-use-maxima-mode-flag t)
;;(autoload 'maxima-minor-mode "maxima" "Maxima minor mode" t)


;;;;;;;;;;;;;;;;
;; tex stuff  ;;
;;;;;;;;;;;;;;;;
;;(require 'tex-site)			;auxtex
;; preview-latex
;;(load "preview-latex/preview-latex.el" nil t t)
;(load "preview-latex.el" nil t t)
;(eval-after-load 'preview
;  '(progn
;     (add-to-list 'preview-default-option-list "showlabels")
;     (setq preview-auto-cache-preamble t)))
;; CDLaTeX (at emacs.d/lisp/)
(autoload 'cdlatex-mode "cdlatex" "CDLaTeX Mode" t)
(autoload 'turn-on-cdlatex "cdlatex" "CDLaTeX Mode" nil)
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-cdlatex)   ; with Emacs latex mode
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(add-hook 'latex-mode-hook 'turn-on-reftex)
;; set xelatex as default compiler
(setq TeX-engine 'xetex)
;; enable pdf mode
(setq TeX-PDF-mode t)
;; generate synctex.gz files for forward/backward search
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-method 'synctex)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Synctex for okular                                                ;;
;;                                                                   ;;
;; In ocular, select the "Browse" mode, and shift+left click text to ;;
;; locate its source position in emacs                               ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; this doesn't work well with files with special characters, e.g. space
;;(setq TeX-view-program-list '(("Okular" "okular --unique %u")))
(add-hook 'LaTeX-mode-hook '(lambda ()                                   
                  (add-to-list 'TeX-expand-list                          
                       '("%u" Okular-make-url))))                        
                                                                         
(defun Okular-make-url () (concat                                        
               "file://"                                                 
               (expand-file-name (funcall file (TeX-output-extension) t) 
                         (file-name-directory (TeX-master-file)))        
               "#src:"                                                   
               (TeX-current-line)                                        
               (expand-file-name (TeX-master-directory))                 
               "./"                                                      
               (TeX-current-file-name-master-relative)))                 
                                                                         
(setq TeX-view-program-list '(("Okular" "okular --unique %o#src:%n\"`pwd`/./%b\"")))
(setq TeX-view-program-selection '((output-pdf "Okular")))               

;; Misc stuff
;;(require 'magic-latex-buffer)
;;(setq org-format-latex-options

(setq-default electric-indent-inhibit t) ;; do not reindent the current line upon pressing enter. Otherwise really annoying in python


;;;;;;;;;;;;;;;;
;; python     ;;
;;;;;;;;;;;;;;;;
;;(autoload 'python-mode "python-mode.el" "Python mode." t)
;;(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
;;(add-to-list 'auto-mode-alist '("\\.pyx$" . python-mode))

;;;;;;;;;;;;;;;; jedi-mode
;;
;;;; seems to be important for EIN's c-c c-f to work
;;(add-hook 'python-mode-hook 'jedi:setup)
;;;;
;;(setq jedi:complete-on-dot t)
;;(setq jedi:tooltip-method nil)

;;;; Use IPython 
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "--simple-prompt -i") ; ipython > 5 has some problem with prompt

;;;; Use Jupyter console
;; (setq python-shell-interpreter "jupyter"
;;       python-shell-interpreter-args "console --simple-prompt"
;;       python-shell-prompt-detect-failure-warning nil)
;; (add-to-list 'python-shell-completion-native-disabled-interpreters "jupyter")

;;;;;;;;;;;;;;;;
;;; conda.el ;;;
;;;;;;;;;;;;;;;;
;; https://github.com/necaris/conda.el

;; (require 'conda)
;; ;; (setq conda-anaconda-home "~/miniconda3") ;; miniconda3 is already in conda-home-candidates
;; (conda-env-initialize-interactive-shells)
;; 
;; ;; need to set per-directory local variables, https://www.gnu.org/software/emacs/manual/html_node/emacs/Directory-Variables.html
;; (conda-env-autoactivate-mode t)
;; (add-hook ;; official doc listed this line as add-to-hook, which will cause an error in emacs 27
;;  'find-file-hook
;;  (lambda () (when (bound-and-true-p conda-project-env-path) (conda-env-activate-for-buffer))))
;; ;; show current env in mode line
;; (setq-default mode-line-format (cons '(:exec conda-env-current-name) mode-line-format))

(use-package conda
  :hook
  ;(find-file .  (lambda () (when (bound-and-true-p conda-project-env-path) (conda-env-activate-for-buffer))))
  (python-mode .  (lambda () (when (bound-and-true-p conda-project-env-path) (conda-env-activate-for-buffer))))
  :config
  (setq conda-anaconda-home "~/miniconda3") ;; miniconda3 is already in conda-home-candidates
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell)
  (conda-env-autoactivate-mode t) ;; Relies on the find-file-hook above. Also need to set per-directory local variables, https://www.gnu.org/software/emacs/manual/html_node/emacs/Directory-Variables.html
  (setq-default mode-line-format (cons '(:exec conda-env-current-name) mode-line-format))
  )


;; LSP stuff for python etc.
;; cf. https://ianyepan.github.io/posts/emacs-ide/
;; and https://emacs-lsp.github.io/lsp-mode/page/installation/

(use-package lsp-mode
  :hook ((python-mode) . lsp-deferred)
  :commands (lsp lsp-deferred)
  :config
  ;;(setq lsp-enable-symbol-highlighting nil) ;; disable symbol highlighting
  ;;(setq lsp-lens-enable nil) ;; disable lenses
  ;;(setq lsp-headerline-breadcrumb-enable nil ;; headerline
  ;;(setq lsp-modeline-code-actions-enable nil) ;; modeline code action
  (setq lsp-diagnostics-provider :none) ;; disable flycheck or flymake
  ;;(setq lsp-eldoc-enable-hover nil) ;; disable Eldoc (doc in mini-buffer)
  ;;(setq lsp-modeline-diagnostics-enable nil) ;; modeline diagnostics statistics
  ;;(setq lsp-signature-auto-activate nil) ;; disable signature help in mini-buffer. Can manually request via lsp-signature-activate
  ;;(setq lsp-signature-render-documentation nil) ;; disable signature help documentation (while keeping the signatures)
  ;;(setq lsp-completion-provider :none) ;; disable completion (company-mode)
  ;;(setq lsp-completion-show-detail nil) ;; completion item detail
  ;;(setq lsp-completion-show-kind nil) ;; completion item kind 
  )

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t) ;; on-hover doc
  ;;(setq lsp-ui-doc-show-with-cursor nil) ;; cursor hover (keep mouse hover)
  ;;(setq lsp-ui-doc-show-with-mouse nil) ;; mouse hover (keep cursor hover
  ;;(setq lsp-ui-doc-header t)
  ;;(setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'default))
  ;;(setq lsp-ui-doc-use-childframe t)
  
  (setq lsp-ui-sideline-enable t) ;; whole sideline
  ;;(setq lsp-ui-sideline-show-code-actions t) ;; show code action in sideline (but what *is* code action??)
  ;;(setq lsp-ui-sideline-show-hover nil) ;; hide only hover symbols
  ;;(setq lsp-ui-sideline-show-diagnostics nil) ;; hide errors in sideline
  ;;(setq lsp-ui-sideline-delay 0.05)
  )

;;(use-package lsp-pyright
;;  :hook (python-mode . (lambda ()
;;			 (require 'lsp-pyright)
;;			 (lsp-deferred)))
;;  :config
;;  (setq lsp-pyright-typechecking-mode nil)
;;  )

;;(use-package lsp-mode
;;  :hook (python-mode . lsp-deferred)
;;  :commands lsp)
;;(use-package lsp-ui
;;  :commands lsp-ui-mode)
;;(use-package lsp-pyright
;;  :hook (python-mode . (lambda () (require 'lsp-pyright))))

  
  


;(elpy-enable)

;;;;;;;;;;;;;;;;
;; EIN

;;;; deprecated
;;(setq ein:use-auto-complete t)

;; (setq ein:use-smartrep t)
;; ;;(add-to-list 'ein:url-or-port "http://192.168.1.10:9999")
;; (setq ein:url-or-port '("http://192.168.1.10:9999"))
;; ;;(setq ein:notebook-modes '(ein:notebook-plain-mode))
;; ;;(setq ein:notebook-modes '(ein:notebook-multilang-mode))
;; 
;; ;;(setq ein:complete-on-dot t)
;; ;;(setq ein:complete-on-dot nil)
;; 
;; ;;(setq ein:console-args '("--profile" "default"))
;; ;;(setq ein:console-args nil)
;; 
;; ;;;; auto completion
;; (setq ein:completion-backend 'ein:use-ac-backend)
;; ;;
;; ;;(require 'jedi)
;; ;;(setq ein:completion-backend 'ein:use-ac-jedi-backend)
;; ;;
;; ;;(setq ein:completion-backend 'ein:use-company-backend)
;; 
;; (require 'ein-timestamp)


(use-package vterm
  :ensure t)


;;;;;;;;;;;;;;;;
;; gnuplot    ;;
;;;;;;;;;;;;;;;;
;; on Archlinux, content imported from /usr/share/emacs/site-lisp/dotemacs
;;--------------------------------------------------------------------
;; Lines enabling gnuplot-mode

;; move the files gnuplot.el to someplace in your lisp load-path or
;; use a line like
;;  (setq load-path (append (list "/path/to/gnuplot") load-path))

;; these lines enable the use of gnuplot mode
  (autoload 'gnuplot-mode "gnuplot" "gnuplot major mode" t)
  (autoload 'gnuplot-make-buffer "gnuplot" "open a buffer in gnuplot mode" t)

;; this line automatically causes all files with the .gp extension to
;; be loaded into gnuplot mode
  (setq auto-mode-alist (append '(("\\.gp$" . gnuplot-mode)) auto-mode-alist))

;; This line binds the function-9 key so that it opens a buffer into
;; gnuplot mode 
  (global-set-key [(f9)] 'gnuplot-make-buffer)

;; end of line for gnuplot-mode
;;--------------------------------------------------------------------


;;;;;;;;;
;; lua ;;
;;;;;;;;;
(setq auto-mode-alist (cons '("\.lua$" . lua-mode) auto-mode-alist))
(autoload 'lua-mode "lua-mode" "Lua editing mode." t)


;;;;;;;;;;;
;; julia ;;
;;;;;;;;;;;
(autoload 'julia-mode "julia-mode"
   "Major mode for editing Julia source files" t)
(add-to-list 'auto-mode-alist '("\.jl\'" . julia-mode))


;;;;;;;;;;;;;;;; 
;; suppress 'same file warning' when editing a symlink file
(setq find-file-suppress-same-file-warnings t)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;(custom-set-faces
; ;; custom-set-faces was added by Custom.
; ;; If you edit it by hand, you could mess it up, so be careful.
; ;; Your init file should contain only one such instance.
; ;; If there is more than one, they won't work right.
; '(default ((t (:family "Terminus" :foundry "xos4" :slant normal :weight normal :height 120 :width normal)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(column-number-mode t)
 '(cursor-type 'box)
 '(custom-enabled-themes '(sanityinc-tomorrow-bright))
 '(custom-safe-themes
   '("1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "e8825f26af32403c5ad8bc983f8610a4a4786eb55e3a363fa9acb48e0677fe7e" "4e63466756c7dbd78b49ce86f5f0954b92bf70b30c01c494b37c586639fa3f6f" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "8288b9b453cdd2398339a9fd0cec94105bc5ca79b86695bd7bf0381b1fbe8147" "a632c5ce9bd5bcdbb7e22bf278d802711074413fd5f681f39f21d340064ff292" "0309f5d28c57c327283e579abd9059fe7b4b32e2599879cd78846e2368f8e6e8" "d1aec5dbeb0267f20d73d4e670e94d007dba09d2193ee39df2023fe61b4fe765" "bcc6775934c9adf5f3bd1f428326ce0dcd34d743a92df48c128e6438b815b44f" "718fb4e505b6134cc0eafb7dad709be5ec1ba7a7e8102617d87d3109f56d9615" "c90fd1c669f260120d32ddd20168343f5c717ca69e95d2f805e42e88430c340e" "4154caa8409ff2eb6f74c913741420e7103b9ea26c3c7d1a5a16592d0d2f43e0" "551596f9165514c617c99ad6ce13196d6e7caa7035cea92a0e143dbe7b28be0e" "28ec8ccf6190f6a73812df9bc91df54ce1d6132f18b4c8fcc85d45298569eb53" "d5b121d69e48e0f2a84c8e4580f0ba230423391a78fcb4001ccb35d02494d79e" "47744f6c8133824bdd104acc4280dbed4b34b85faa05ac2600f716b0226fb3f6" "cdd26fa6a8c6706c9009db659d2dffd7f4b0350f9cc94e5df657fa295fffec71" default))
 '(display-time-mode t)
 '(fci-rule-color "#151515")
 '(fringe-mode nil nil (fringe))
 '(global-display-line-numbers-mode t)
 '(indicate-buffer-boundaries 'left)
 '(indicate-empty-lines t)
 '(ispell-dictionary nil)
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(org-format-latex-options
   '(:foreground default :background default :scale 2.0 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
		 ("begin" "$1" "$" "$$" "\\(" "\\[")))
 '(package-selected-packages
   '(vterm company use-package conda lsp-mode lsp-ui magit color-theme-sanityinc-tomorrow ahk-mode lua-mode jedi ein cdlatex org magic-latex-buffer px tangotango-theme spacemacs-theme smyx-theme smartrep seti-theme mustard-theme micgoline markdown-mode inkpot-theme hc-zenburn-theme flatui-dark-theme flatland-theme flatland-black-theme farmhouse-theme darkburn-theme blackboard-theme afternoon-theme abyss-theme))
 '(safe-local-variable-values
   '((conda-project-env-path . "ml")
     (conda-project-env-path 'ml)
     (TeX-command-extra-options . "-shell-escape")))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(tool-bar-mode nil)
 '(vc-annotate-background "#1f2124")
 '(vc-annotate-color-map
   '((20 . "#ff0000")
     (40 . "#ff4a52")
     (60 . "#f6aa11")
     (80 . "#f1e94b")
     (100 . "#f5f080")
     (120 . "#f6f080")
     (140 . "#41a83e")
     (160 . "#40b83e")
     (180 . "#b6d877")
     (200 . "#b7d877")
     (220 . "#b8d977")
     (240 . "#b9d977")
     (260 . "#93e0e3")
     (280 . "#72aaca")
     (300 . "#8996a8")
     (320 . "#afc4db")
     (340 . "#cfe2f2")
     (360 . "#dc8cc3")))
 '(vc-annotate-very-old-color "#dc8cc3")
 '(when
      (or
       (not
	(boundp 'ansi-term-color-vector))
       (not
	(facep
	 (aref ansi-term-color-vector 0))))))
