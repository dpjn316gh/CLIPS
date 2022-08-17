; exercices
;; (defrule exposition
;;  (declare (salience 10))
;;  ?p <- (thing (id adventurer))
;;  =>
;;  (println "Captured by goblins, you've been")
;;  (println "tossed in a pit a their lair.")
;; )

(defrule mushroom_is_not_sturdy
        (thing (id adventurer) (location pit_north))
  ?c <- (command (action climb mushroom))
 =>
 (retract ?c)
 (println "The mushroom is not sturdy enough to climb"))

 
(defrule place_wand_in_the_rubble_at_pit_south
 =>
 (assert (thing (id wand) (category item) (location rubbble)))
)

(defrule undiscovered_wand_at_pit_south
 ?w <- (thing (id wand) (location rubbble))
    (thing (id adventurer) (location pit_south))
 ?c <- (command (action search rubble1))
 =>
 (retract ?c)
 (modify ?w (location pit_south))
 (println "You find a wand.")
)

(defrule discovered_wand
?w <- (thing (id wand) (location pit_south))
 (thing (id adventurer) (location pit_south))
 =>
 (modify ?w (location adventurer))
 (println "You find nothing of interests")
)

(defrule teleported
 (thing (id wand) (location adventurer))
 =>
 (println "Poof! you are teleported out of the pit")
)


(defrule eat_mushroom1
 (thing (id adventurer) (location pit_north))
 (not (track (action eat mushroom1)))
 ?c <- (command (action eat mushroom))
 =>
 (retract ?c)
 (assert (track (action eat mushroom1)))
 (println "You probably shouldn't do that")
 (println "It might be poisonous")
)

(defrule eat_mushroom2
 (thing (id adventurer) (location pit_north))
 (not (track (action eat mushroom2)))
 (track (action eat mushroom1))
 ?c <- (command (action eat mushroom))
 =>
 (retract ?c)
 (assert (track (action eat mushroom2)))
 (println "Seriously? You have no idea what could happen!")
)

(defrule eat_mushroom3
 (thing (id adventurer) (location pit_north))
 ?t1 <- (track (action eat mushroom1))
 ?t2 <- (track (action eat mushroom2))
 ?c <- (command (action eat mushroom))
 =>
 (retract ?c)
 (retract ?t1)
 (retract ?t2)
 (println "OK, you pull off a small piece and eat it. Your")
 (println "head spins and then your body feels light. With a")
 (println "mighty spring, you leap out of the pit")
 (halt)
)
