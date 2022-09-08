(deftemplate thing
  (slot id)
  (slot category (allowed-values place item actor scenery))
  (slot location (default nowhere))
  (multislot description)
)

(deftemplate command
  (multislot action)
)

(deftemplate path
  (multislot direction)
  (multislot from)
  (slot      to              (default nowhere))
  (slot      blocked         (default FALSE))
  (slot      blocked_message (default "The way is blocked."))
  (slot      symmetric       (default FALSE))
)

(deftemplate track
  (multislot action)
)

(deftemplate symmetrical_path
  (multislot from)
  (slot to)
)