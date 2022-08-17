(deffacts places
  (thing 
    (id pit_north)
    (category place)
    (description
     "You're at the pit's north end."
     "A giant mushroom is here. The"
     "ground is littered with the"
     "bodies of deat adventurers."))
  (thing 
    (id pit_south)
    (category place)
    (description
     "You're at the pit's south end."
     "A large pile of rubble has"
     "collapsed from the wall above."
     "A path through the rubble leads down."))
  (thing
    (id cavern)
    (category place)
    (description
    "You're in a cavern lit by glowing algae with a"
    "well in the center. A path made of rubble leads up."
    )
  )
)

(deffacts player
  (thing 
    (id adventurer) 
    (category actor) 
    (location pit_north))
)

(deffacts scenery
  (thing 
    (id mushroom)
    (location pit_north)
    (category scenery)
    (description 
      "It's squished. I wouldn't"
      "try landing on it again.")
  )
  
  (thing 
    (id bodies)
    (location pit_north)
    (category scenery)
    (description 
      "Apparently this is what happens"
      "when you miss the mushroom.")
  )
  
  (thing 
     (id rubble)
     (location pit_south)
     (category scenery)
  )

  (thing
    (id well)
    (location cavern)
    (category scenery)
    (description "This is no ordinary well")
  )
)

(deffacts paths
  (path 
    (direction south) 
    (from pit_north) 
    (to pit_south)
  )
  (path 
    (direction north) 
    (from pit_south) 
    (to pit_north)
  )
  (path 
    (direction up)
    (from pit_north pit_south) 
    (blocked TRUE) 
    (blocked_message "The walls are too slick.")
  )
  (path
    (direction down)
    (from pit_south)
    (to cavern)
  )
  (path
    (direction up)
    (from cavern)
    (to pit_south)
  )

)


;;;;;;;;;;;;;;;;;;;;;;;

(defrule quit
  ?c <- (command (action quit))
  =>
  (retract ?c)
  (halt))

(defrule bad_command
  (declare (salience -10))
  ?c <- (command)
  =>
  (println "I don't understand your command")
  (retract ?c))

(defrule empty_command
  (declare (salience -5))
  ?c <- (command (action))
  =>
  (println "COMANDO VACIO")
  (retract ?c))

(defrule get_command
  (declare (salience -10))
  (not (command))
  =>
  (println)
  (print "> ")
  (bind ?rsp (explode$ (lowcase (readline))))
  (assert (command (action ?rsp))))

(defrule exposition
  (declare (salience 10))
  =>
  (println "Captured by goblins, you've been")
  (println "tossed in a pit a their lair."))

