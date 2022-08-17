(defrule send-credit-card-trx-to-lyra "Envia todas las transacciones de TC a lyra"
 (declare (salience -1))
 ?cd <- (credit-card-payment 
  (transaction_id ?transaction_id)
  (payment_method CREDIT-CARD) 
 )
=>
 (assert (credit-card-payment-response
            (transaction_id ?transaction_id)
            (activation_rule "send-credit-card-trx-to-lyra")
            (action LYRA)
            ))
 (retract ?cd)
)

(defrule send-bancolombia-credit-card-trx-to-sift "Envia todas las transacciones de TC de bancolombia a SIFT"
 ?cd <- (credit-card-payment 
  (transaction_id ?transaction_id)
  (payment_method CREDIT-CARD) 
  (bank ?bank)
 )
 (bank-to-provider
  (bank ?bank)
  (provider ?provider)
 )
=>
 (assert (credit-card-payment-response
            (transaction_id ?transaction_id)
            (activation_rule "send-bancolombia-credit-card-trx-to-sift")
            (action ?provider)
            ))
 (retract ?cd)
)

(defrule send-credit-card-trx-greater-than-2000000-to-sift "Envia todas las transacciones de TC > 2'000.000 a SIFT"
 (declare (salience 1))
 ?cd <- (credit-card-payment 
  (transaction_id ?transaction_id)
  (payment_method CREDIT-CARD) 
  (transaction_amount ?transaction_amount) 
 )
 (test (> ?transaction_amount 2000000))
=>
 (assert (credit-card-payment-response
            (transaction_id ?transaction_id)
            (activation_rule "send-credit-card-trx-greater-than-2000000-to-sift")
            (action SIFT)
            ))
 (retract ?cd)
)

(defrule verify_products "Valida que no se compren más de 3 cigarros"
 (declare (salience 2))
 ?cd <- (credit-card-payment
  (transaction_id ?transaction_id)
  (payment_method CREDIT-CARD)
  (transaction_amount ?transaction_amount)
  (items_names $?prohibido)
  (items_quantities $?quantities)
 )
 (test (member$ "marimba" ?prohibido))
 (test (>= (nth$ (member$ "marimba" ?prohibido) ?quantities ) 5))
 (test (> ?transaction_amount 400000))
=>
 (assert (credit-card-payment-response
            (transaction_id ?transaction_id)
            (activation_rule "verify_products")
            (action REJECT)
            ))
 (retract ?cd)
)