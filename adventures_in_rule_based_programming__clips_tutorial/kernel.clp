(defrule look_no_description
 ?c <- (command (action look at ?id))
 (thing (id adventurer)
   (location ?location))
 (thing (id ?id)
   (location ?location | adventurer)
   (description))
=>
 (retract ?c)
 (println "You see nothing special.")
)

(defrule look_description
 ?c <- (command (action look at ?id))
 (thing (id adventurer)
    (location ?location))
 (thing (id ?id)
    (location ?location | adventurer)
    (description $?text))
 (test (> (length$ ?text) 0 ))
=>
  (retract ?c)
  (foreach ?line ?text
    (println ?line))
)

(defrule look_can't_see
  ?c <- (command (action look at ?id))
  (thing (id adventurer) (location ?location))
  (not (thing (id ?id)
    (location ?location | adventurer)))
=>
  (retract ?c)
  (println "You can't see any such thing.")
)

(defrule print_place
  ?c <- (command (action look))
  (thing (id adventurer)
    (location ?location))
  (thing (id ?location)
    (category place)
    (description $?text))
=>
  (retract ?c)
  (foreach ?line ?text
     (println ?line)
  )
)

(defrule go_valid_path
  ?c <- (command (action go ?direction))
  ?p <- (thing (id adventurer)
          (location ?location))
  (path (direction $? ?direction $?)
    (from $? ?location $?)
    (to ?new_location)
    (blocked FALSE))
=>
  (retract ?c)
  (modify ?p (location ?new_location))
  (assert (command (action look)))
)

(defrule go_invalid_path
  ?c <- (command (action go ?direction))
  ?p <- (thing (id adventurer)
          (location ?location))
  (not (path (direction $? ?direction $?)
         (from $? ?location $?)))
=>
  (retract ?c)
  (println "You can't go there.")
)

(defrule verify_invalid_direction
  (declare (salience 1))
  ?c <- (command (action go ?direction &~north&~south&~east&~west&~up&~down))  
  ;;; (thing (id adventurer) (location ?location))
=>
  (retract ?c)
  (println "I can't understand the direction '" ?direction "'.")
)

(defrule go_valid_path_blocked
 ?c <- (command (action go ?direction ))
 ?p <- (thing (id adventurer)
         (location ?location))
 (path (direction $? ?direction $?)
    (from $? ?location $?)
    (to ?new_location)
    (blocked TRUE)
    (blocked_message ?text))
=>
  (retract ?c)
  (println ?text)
)

(defrule climb_action
 ?c <- (command (action climb up))
=>
 (modify ?c (action go up))
)

;;;;;;;;;;;;;


(defrule create_symmetrical_path
  (path 
    (symmetric TRUE)
    (direction $?direction)
    (from $?from_check)
    (to ?to)
    (blocked ?blocked)
    (blocked_message ?blocked_message)    
  )
  (test (= (length$ ?from_check) 1))
  (test (= (length$ ?direction) 1))  
  (symmetrical_path
    (from $?direction)
    (to ?new_direction)
  )
=>
  (println (nth$ 1 ?from_check))
  (assert 
    (path 
      (direction ?new_direction)
      (from ?to )
      (to (nth$ 1 ?from_check))
      (blocked ?blocked)
      (blocked_message ?blocked_message)
    )
  )
)




(defrule eat_default
  (declare (salience -5))
  ?c <- (command (action eat ?))
  =>
  (retract ?c)
  (println "Think about escape, not lunch."))