;; -*-mode: lisp;-*-
;;;; CKoch's stumpwmrc

(in-package :stumpwm)

(echo "loading stumpwmrc...")
;;;; time
;; format hh:mm:ss AM/PM day mm/dd/yyyy 
(setf *time-format-string-default* "%r %a %D")

;; TODO is there a better way to do this?
;; TODO have groups create for the following and have apps default to them:
;; '(emacs irc browser email)
;;;; Keybindings
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-c") "exec konsole")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "c") "exec konsole")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "b") "exec firefox")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Mail") "exec claws-mail")
;; check for now mail
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-XF86Mail") "exec claws-mail --receive-all")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Favorites") "exec synapse")

;; Volume
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86AudioRaiseVolume") "exec amixer set Master,0 5%+")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86AudioLowerVolume") "exec amixer set Master,0 5%-")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86AudioMute") "exec amixer set Master toggle")

;;(stumpwm:define-key stumpwm:*root-click-hook* (stumpwm:mouse "mouse-1") (gnext))

;; TODO make it easier to transfer windows to groups

;; input focus is transferred to the window you click on
(setf *mouse-focus-policy* :click)

;;; Groups
;;; TODO can I use the CREATE macro for this?
;;(loop for g in '("emacs" "irc" "browser" "email")
;;     do (gnewbg g))


;; TODO is there a way to eval a line in this file like C-x e in Emacs? _yes_ see stumpwm-mode.el
;; TODO have irc group flash on message
;; TODO check to see if we are just starting stumpwm and only eval then.

;;;; mode-line
;;(mode-line)
;; TODO call time instead of date
(setf stumpwm:*screen-mode-line-format*
      (list "%g | %w                | "
	    '(:eval (stumpwm:run-shell-command "date '+%r %a %D'" t))))

;; change to stump function def
;; (defun select-window-from-group-list ()
;;   ())

;; `C-t G'
;;      Display all and groups windows in each group. For more information
;;      see *note Groups::.
;; `C-t g "'
;;      Select a group from a list and switch to it.
