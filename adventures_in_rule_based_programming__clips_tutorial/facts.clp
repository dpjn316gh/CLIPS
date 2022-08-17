
(deffacts player
 (thing (id adventurer) (category actor) (location pit_north))
)



(assert (command (action climb up)))

(modify 1 (location pit_south))

(assert (command (action go north)))
(assert (command (action go south)))

(assert (command (action climb mushroom)))


(assert (command (action search rubble)))

;;;;;;;;;;;;;;;;;;;;


(deftemplate userinput
  (multislot input))


(defrule empty_input
(userinput (input ""))
=>
  (println "Es vacío")
)


(assert (userinput (input (bind ?f (readline)))))



