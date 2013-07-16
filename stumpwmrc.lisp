;; -*-mode: lisp;-*-
;;;; CKoch's stumpwmrc

(in-package :stumpwm)

;; TODO look at *initilizing* and *start-hook*
;; TODO why does this message not show up in the message area?
;;(stumpwm:echo "loading stumpwmrc...\n")
(defparameter mail-client "sylpheed")
(defparameter compose "--compose")

;;(setf *debug-level* 10)
;;(setf *debug-level* 1)

;;;; Init
(unless *initializing*
    (lambda ()
	   (mode-line)
	   (create-groups)
	   (start-apps))
    (echo "Already loaded.\n")) 


;;(create-groups)
;;(start-apps)

;;;; time
;; format hh:mm:ss AM/PM day mm/dd/yyyy 
(setf *time-format-string-default* "%r %a %D")

;;;; mode-line
;; TODO call time instead of date
;;(setq *screen-mode-line-format* (format nil "%g~%%W"))
(setf stumpwm:*screen-mode-line-format*
      (list "%g  | " '(:eval (stumpwm:run-shell-command "date '+%r %a %D'" t))
	    "%W"))

;; TODO is there a better way to do this?
;; TODO have groups create for the following and have apps default to them:
;; '(emacs irc browser email)
;;;; Keybindings
;; stumpwm:
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-r") "loadrc")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-m") "mode-line")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-c") "command-mode")
;; Applications:
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "c") "exec konsole")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "b") "exec firefox")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "L") "exec xflock4")
;; TODO kmail does not display my mail when run from stumpwm ?
;;(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Mail") "exec claws-mail")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Favorites") "exec synapse")
;; key 1
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Launch6") "exec google-chrome")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Mail") "exec sylpheed")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "M-XF86Mail") "compose-mail")
;; check for now mail
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-XF86Mail") "exec sylpheed --receive-all")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Favorites") "exec synapse")
;; key 3
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Launch7") "exec xchat")
;; Open timesheet
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Calculator") "exec libreoffice /home/ckoch/Dropbox/time_sheet")
;; key 4
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Launch9") "exec /bin/bash ~/TestTrack.sh")
;; key 5
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86Launch8") "exec eclipse")
;; Volume:
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86AudioRaiseVolume") "exec amixer set Master,0 5%+")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86AudioLowerVolume") "exec amixer set Master,0 5%-")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "XF86AudioMute") "exec amixer set Master toggle")

;;(stumpwm:define-key stumpwm:*root-click-hook* (stumpwm:mouse "mouse-1") (gnext))
;; TODO make it easier to transfer windows to groups

;; input focus is transferred to the window you focus on it
(setf *mouse-focus-policy* :sloppy)

;; Is there a better macro for this than the IF form?
;; (unless *mode-line-click-hook*
;;   (gnext))

(add-hook *mode-line-click-hook* (lambda (m-line button-clicked x-ptr f-ptr)
 						   (gnext)))


;; (defparameter out (groups))
;; (message "out = ~S" out)
;; (message " out == ~S" (stumpwm::screen-groups (current-screen)))

;; (let ((g (grouplist))
;;       (groups '("emacs" "shell" "irc" "browser" "email") ))
;;   (dolist (group groups)
;;     (cond ((member (groups g)) (echo "Already a group")) ;
;; 	  (t (echo "creating group")))))

;;; Groups
;;; TODO can I use the CREATE macro for this?
(defcommand create-groups () ()
"Create my most used groups"
  (loop for g in '("emacs" "shell" "irc" "browser" "email")
     do (gnewbg g)))

;; TODO have each app goto the correct group, use a pair?
(defcommand start-apps () ()
"Start my favorite apps"
  (dolist (cmd '("emacs" "konsole" "claws-mail" "xchat"))
   (stumpwm:run-shell-command cmd )))

;; TODO if emacs is not in group emacs or if the group emacs DNE then
;; find the instance of emacs.
(defcommand compose-mail () ()
"Create new message and bring emacs to the front"
    (stumpwm:run-shell-command (concatenate 'string mail-client " " compose))
    (gselect "emacs") ;; why does this not work?
    (select "emacs"))

;; TODO have irc group flash on message
;; TODO check to see if we are just starting stumpwm and only eval then.

;; (defcommand select-window-from-group-list ()
;;   ())

;; `C-t G'
;;      Display all and groups windows in each group. For more information
;;      see *note Groups::.
;; `C-t g "'
;;      Select a group from a list and switch to it.
