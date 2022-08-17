(defrule search_rubble_first_time
   (thing (id adventurer) (location pit_south))
   (not (track (action search rubble1)))
   ?c <- (command (action search rubble))   
=>
   (retract ?c)
   (assert (track (action search rubble1)))
   (println "From the top of the rubble, you can see that the")
   (println "ground has collapsed creating a path down to a cavern bellow.")
)

(defrule search_rubble_second_time
   (thing (id adventurer) (location pit_south))
   (track (action search rubble1))
   ?c <- (command (action search rubble))   
=>
   (retract ?c)
   (println "You find nothing of interest")
)

(defrule make_wish
   (thing (id adventurer) (location cavern))   
   ?c <- (command (action make wish))
   ?sr1 <- (track (action search rubble1))
=>
   (retract ?c)
   (retract ?sr1)
   (println "You wish is granted. You've been")
   (println "magically transported to safety.")
   (halt)
)
