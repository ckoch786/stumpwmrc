;; Local Variables
;; mode: lisp
;; eval: (stumpwm-mode)
;; End:

;;;; CKoch's stumpwmrc

(in-package :stumpwm)

;; TODO checkout http://lisp-search.acceleration.net/html/index.html
;; change the prefix key to something else
(set-prefix-key (kbd "C-t"))

;; TODO look at *initilizing* and *start-hook*
;; TODO why does this message not show up in the message area?
;;(stumpwm:echo "loading stumpwmrc...\n")
(defparameter *mail-client* "claws-mail") ;; claws-mail, kmail, sylpheed
(defparameter *compose* "--compose")
(defparameter *check-mail* "--receive-all")

;;(setf *debug-level* 10)
;;(setf *debug-level* 1)

;;;; Init
;; TODO test this to make sure it works
(if *initializing*
    (progn
      (mode-line)
      (create-groups)
      (start-apps))
    (echo "Already loaded.\n")) 

https://github.com/ckoch786/stumpwmrc
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
(stumpwm:undefine-key stumpwm:*root-map* (stumpwm:kbd "C-SPC"))
;; TODO for floating group find a way to get the window count and the numbers
;; associated with each window, then have C-TAB cycle through the windows
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-TAB") "next")
;; Applications:
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "c") "exec konsole")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "b") "exec firefox")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "L") "exec xflock4")
(stumpwm:define-key stumpwm:*root-map* (stumpwm:kbd "C-XF86Favorites") "fake-out-intelij")
;; key 1
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86Launch6") "exec google-chrome")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86Mail") "open-mail-client")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "M-XF86Mail") "compose-mail")
;; check for now mail
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "C-XF86Mail") "check-mail")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86Favorites") "exec synapse")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86Search") "exec google-chrome http://www.jetbrains.com/idea/webhelp/getting-help.html")
;; key 3
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86Launch7") "exec xchat")
;; Open timesheet
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86Calculator") "exec libreoffice /home/ckoch/Dropbox/time_sheet")
;; key 4
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86Launch9") "exec /bin/bash ~/TestTrack.sh")
;; key 5
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86Launch8") "exec eclipse")
;; Volume:
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioRaiseVolume") "exec amixer set Master,0 5%+")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioLowerVolume") "exec amixer set Master,0 5%-")
(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "XF86AudioMute") "exec amixer set Master toggle")
;;(stumpwm:define-key stumpwm:*top-map* (stumpwm:kbd "Menu") "fake-out-intelij")

;;(stumpwm:define-key stumpwm:*root-click-hook* (stumpwm:mouse "mouse-1") (gnext))
;; TODO make it easier to transfer windows to groups

;; input focus is transferred to the window you focus on it
(setf *mouse-focus-policy* :sloppy) ; :sloppy, :click, :ignorep

;;;; Hooks
;; Fix this, this does some weird infinite looping over all the groups when
;; stumpwm has been running for a while.
;; (add-hook *mode-line-click-hook* (lambda (m-line button-clicked x-ptr f-ptr)
;;  						   (gnext)))


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
    (stumpwm:run-shell-command (concatenate 'string *mail-client* " " *compose*))
    (gselect(select-group (current-screen) "emacs"))
    (select-window "emacs"))

;;TODO determine my main mail client and select that one
(defcommand open-mail-client ()()
    "Open my mail client"
    (stumpwm:run-shell-command *mail-client*))

(defcommand check-mail ()()
    "Check my mail"
    (stumpwm:run-shell-command (concatenate 'string *mail-client* " " *check-mail*)))

(defcommand fake-out-intelij ()()
  "Send the right click to the code editor window then click to activate the cursor
Precondition: Intelij is fully expanded. 
Assumption: That 800x800 is about the middle of your screen"
  (banish-pointer)
  (ratrelwarp -800 -800)
  (ratclick 3);; right click to enable menu
  (ratclick)) ;; left click to disable menu


;; (defun select-window-from-group-list-menu (windows fmt)
;;   "Allow the user to select a window from the list passed in @var{windows}.  The
;; @var{fmt} argument specifies the window formatting used.  Returns the window
;; selected."
;;   (second (select-from-menu (current-screen)
;; 			    (mapcar (lambda (w)
;; 				      (list (format-expand *window-formatters* fmt w) w))
;;                                     windows)
;;                             nil
;;                             (or (position (current-window) windows) 0))))



;; (defcommand windowlist (&optional (fmt *window-format*)) (:rest)
;; "Allow the user to Select a window from the list of windows and focus
;; the selected window. For information of menu bindings
;; @xref{Menus}. The optional argument @var{fmt} can be specified to
;; override the default window formatting."
;;   (if (null (group-windows (current-group)))
;;       (message "No Managed Windows")
;;       (let* ((group (current-group))
;;              (window (select-window-from-menu (sort-windows group) fmt)))
;;         (if window
;;             (group-focus-window group window)
;;             (throw 'error :abort)))))



;; (defcommand vgroups (&optional gfmt wfmt) (:string :rest)
;; "Like @command{groups} but also display the windows in each group. The
;; optional arguments @var{gfmt} and @var{wfmt} can be used to override
;; the default group formatting and window formatting, respectively."
;;   (echo-groups (current-screen)
;;                (or gfmt *group-format*)
;;                t (or wfmt *window-format*)))

;; TODO have irc group flash on message
;; TODO check to see if we are just starting stumpwm and only eval then.

;; (defcommand select-window-from-group-list ()
;;   ())

;; `C-t G'
;;      Display all and groups windows in each group. For more information
;;      see *note Groups::.
;; `C-t g "'
;;      Select a group from a list and switch to it.


;; Error In Command 'compose-mail': There is no applicable method for the generic function
;;                                               #<STANDARD-GENERIC-FUNCTION
;;                                                 STUMPWM::GROUP-SCREEN (1)>
;;                                             when called with arguments
;;                                               (2).
;; StumpWM Crashed With An Unhandled Error!
;; Copy the error to the clipboard with the 'copy-unhandled-error' command.
;; Interactive interrupt at #x7FFFF73FD158.
;; 0: (SB-DEBUG::MAP-BACKTRACE
;;     #<CLOSURE (LAMBDA # :IN SB-DEBUG:BACKTRACE) {100470056B}>
;;     :START
;;     0
;;     :COUNT
;;     100)
;; 1: (SB-DEBUG:BACKTRACE 100 #<SB-IMPL::STRING-OUTPUT-STREAM {1004700463}>)
;; 2: (STUMPWM::BACKTRACE-STRING)
;; 3: (STUMPWM::PERFORM-TOP-LEVEL-ERROR-ACTION
;;     #<SB-SYS:INTERACTIVE-INTERRUPT {1004700143}>)
;; 4: (SIGNAL #<SB-SYS:INTERACTIVE-INTERRUPT {1004700143}>)
;; 5: ((FLET SB-UNIX::INTERRUPT-IT :IN SB-UNIX::SIGINT-HANDLER))
;; 6: ((FLET #:WITHOUT-INTERRUPTS-BODY-238379 :IN SB-THREAD:INTERRUPT-THREAD))
;; 7: ((FLET #:WITHOUT-INTERRUPTS-BODY-26790 :IN SB-SYS:INVOKE-INTERRUPTION))
;; 8: ((FLET SB-THREAD::EXEC :IN SB-SYS:INVOKE-INTERRUPTION))
;; 9: ((FLET #:WITHOUT-INTERRUPTS-BODY-26779 :IN SB-SYS:INVOKE-INTERRUPTION))
;; 10: (SB-SYS:INVOKE-INTERRUPTION
;;      #<CLOSURE (FLET SB-UNIX::INTERRUPTION :IN SB-SYS:ENABLE-INTERRUPT)
;;        {7FFFF70CE86B}>)
;; 11: (SB-SYS:INVOKE-INTERRUPTION
;;      #<CLOSURE (FLET SB-UNIX::INTERRUPTION :IN SB-SYS:ENABLE-INTERRUPT)
;;        {7FFFF70CE86B}>)[:EXTERNAL]
;; 12: ((FLET SB-UNIX::RUN-HANDLER :IN SB-SYS:ENABLE-INTERRUPT)
;;      13
;;      #.(SB-SYS:INT-SAP #X7FFFF70CEB70)
;;      #.(SB-SYS:INT-SAP #X7FFFF70CEA40))
;; 13: ("foreign function: call_into_lisp")
;; 14: ("foreign function: funcall3")
;; 15: ("foreign function: interrupt_handle_now")
;; 16: ("foreign function: #x413BCE")
;; 17: ("bogus stack frame")
;; 18: (SB-SYS:WAIT-UNTIL-FD-USABLE 5 :INPUT 59 T)
;; 19: (XLIB::BUFFER-INPUT-WAIT-DEFAULT
;;      #<XLIB:DISPLAY :0 (The X.Org Foundation R11304000)>
;;      59)
;; 20: (XLIB::BUFFER-INPUT-WAIT
;;      #<XLIB:DISPLAY :0 (The X.Org Foundation R11304000)>
;;      59)
;; 21: (XLIB::READ-INPUT
;;      #<XLIB:DISPLAY :0 (The X.Org Foundation R11304000)>
;;      59
;;      NIL
;;      #<FUNCTION (LAMBDA # :IN XLIB::WAIT-FOR-EVENT) {100257A9BB}>
;;      #<XLIB:DISPLAY :0 (The X.Org Foundation R11304000)>)
;; 22: (XLIB::WAIT-FOR-EVENT
;;      #<XLIB:DISPLAY :0 (The X.Org Foundation R11304000)>
;;      59
;;      NIL)
;; 23: ((FLET SB-THREAD::WITH-RECURSIVE-LOCK-THUNK :IN XLIB:EVENT-LISTEN))
;; 24: ((FLET #:WITHOUT-INTERRUPTS-BODY-88907 :IN SB-THREAD::CALL-WITH-RECURSIVE-LOCK))
;; 25: (SB-THREAD::CALL-WITH-RECURSIVE-LOCK
;;      #<CLOSURE (FLET SB-THREAD::WITH-RECURSIVE-LOCK-THUNK :IN XLIB:EVENT-LISTEN)
;;        {7FFFF70CF65B}>
;;      #<SB-THREAD:MUTEX "CLX Event Lock"
;;          owner: #<SB-THREAD:THREAD "initial thread" RUNNING {1003B48DA3}>>)
;; 26: ((FLET SB-IMPL::TIMEOUT-BODY :IN XLIB:EVENT-LISTEN))
;; 27: (XLIB:EVENT-LISTEN #<XLIB:DISPLAY :0 (The X.Org Foundation R11304000)> 59)
;; 28: (STUMPWM::STUMPWM-INTERNAL-LOOP)
;; 29: (STUMPWM::STUMPWM-INTERNAL ":0")
;; 30: (STUMPWM ":0")
;; 31: ((LAMBDA () :IN "/home/ckoch/repos/stumpwm/make-image.lisp"))
;; 32: ((FLET #:WITHOUT-INTERRUPTS-BODY-236480 :IN SB-EXT:SAVE-LISP-AND-DIE))
;; 33: ((LABELS SB-IMPL::RESTART-LISP :IN SB-EXT:SAVE-LISP-AND-DIE))

;;;; Got this error twice when opening Idea
;; The slot STUMPWM::GROUP is unbound in the object #S(WINDOW " " #x280004E).
;; 0: (SB-DEBUG::MAP-BACKTRACE
;;     #<CLOSURE (LAMBDA # :IN SB-DEBUG:BACKTRACE) {1006ECA2CB}>
;;     :START
;;     0
;;     :COUNT
;;     100)
;; 1: (SB-DEBUG:BACKTRACE 100 #<SB-IMPL::STRING-OUTPUT-STREAM {1006ECA1C3}>)
;; 2: (STUMPWM::BACKTRACE-STRING)
;; 3: (STUMPWM::PERFORM-TOP-LEVEL-ERROR-ACTION #<UNBOUND-SLOT GROUP {1006EC9C33}>)
;; 4: (SIGNAL #<UNBOUND-SLOT GROUP {1006EC9C33}>)
;; 5: (ERROR #<UNBOUND-SLOT GROUP {1006EC9C33}>)
;; 6: ((SB-PCL::FAST-METHOD SLOT-UNBOUND (T T T))
;;     #<unavailable argument>
;;     #<unavailable argument>
;;     #<unavailable argument>
;;     #S(WINDOW " " #x280004E)
;;     STUMPWM::GROUP)
;; 7: (SB-PCL::SLOT-UNBOUND-INTERNAL #S(WINDOW " " #x280004E) 6)
;; 8: (STUMPWM::WINDOW-SCREEN #S(WINDOW " " #x280004E))
;; 9: (STUMPWM::DESTROY-WINDOW #S(WINDOW " " #x280004E))
;; 10: (STUMPWM::HANDLE-EVENT
;;      :DISPLAY
;;      #<XLIB:DISPLAY :0 (The X.Org Foundation R11304000)>
;;      :EVENT-KEY
;;      :DESTROY-NOTIFY
;;      :EVENT-CODE
;;      17
;;      :SEND-EVENT-P
;;      NIL
;;      :SEQUENCE
;;      52932
;;      :EVENT-WINDOW
;;      #<XLIB:WINDOW :0 170>
;;      :WINDOW
;;      #<XLIB:WINDOW :0 280004E>)
;; 11: ((FLET SB-THREAD::WITH-RECURSIVE-LOCK-THUNK :IN XLIB:PROCESS-EVENT))
;; 12: ((FLET #:WITHOUT-INTERRUPTS-BODY-88907 :IN SB-THREAD::CALL-WITH-RECURSIVE-LOCK))
;; 13: (SB-THREAD::CALL-WITH-RECURSIVE-LOCK
;;      #<CLOSURE (FLET SB-THREAD::WITH-RECURSIVE-LOCK-THUNK :IN XLIB:PROCESS-EVENT)
;;        {7FFFF70CF83B}>
;;      #<SB-THREAD:MUTEX "CLX Event Lock"
;;          owner: #<SB-THREAD:THREAD "initial thread" RUNNING {1003B48DA3}>>)
;; 14: (XLIB:PROCESS-EVENT
;;      #<XLIB:DISPLAY :0 (The X.Org Foundation R11304000)>
;;      :HANDLER
;;      #<FUNCTION STUMPWM::HANDLE-EVENT>
;;      :TIMEOUT
;;      NIL
;;      :PEEK-P
;;      NIL
;;      :DISCARD-P
;;      NIL
;;      :FORCE-OUTPUT-P
;;      T)
;; 15: (STUMPWM::STUMPWM-INTERNAL-LOOP)
;; 16: (STUMPWM::STUMPWM-INTERNAL ":0")
;; 17: (STUMPWM ":0")
;; 18: ((LAMBDA () :IN "/home/ckoch/repos/stumpwm/make-image.lisp"))
;; 19: ((FLET #:WITHOUT-INTERRUPTS-BODY-236480 :IN SB-EXT:SAVE-LISP-AND-DIE))
;; 20: ((LABELS SB-IMPL::RESTART-LISP :IN SB-EXT:SAVE-LISP-AND-DIE))
