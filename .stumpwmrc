;; -*-mode: lisp;-*-
;;;; CKoch's stumpwmrc

(in-package :stumpwm)

;;;; time
(setf *time-format-string-default* "%r %D")

;; TODO is there a better way to do this?
;; TODO have groups create for the following and have apps default to them:
;; '(emacs irc browser email)
;;;; Keybindings
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-c") "exec konsole")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "c") "exec konsole")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "b") "exec firefox")
;; TODO kmail does not display my mail when run from stumpwm ?
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Mail") "exec kmail")

;;; Groups
;;; TODO can I use the CREATE macro for this?
(loop for g in '("emacs" "irc" "browser" "email")
     do (gnewbg g))


;; TODO is there a way to eval a line in this file like C-x e in Emacs?
;; TODO have irc group flash on message
;; TODO check to see if we are just starting stumpwm and only eval then.

;;;; mode-line
;;(mode-line)
;; TODO call time instead of date
(setf stumpwm:*screen-mode-line-format*
      (list "%g | %w                | "
	    '(:eval (stumpwm:run-shell-command "date '+%r %D'" t))))


