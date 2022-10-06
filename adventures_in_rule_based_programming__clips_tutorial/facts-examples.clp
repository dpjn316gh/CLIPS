(assert 
 (credit-card-payment
  (action_type payment)
  (transaction_id 001)
  (email "jorge.porras@example.com")
  (user_fullname "Jorge Porras")
  (user_name "jorge.porras")
  (payment_method CREDIT-CARD)
  (card_fullname "JORGE PORRAS")
  (card_bin 4111111111111111)  
  (card_expire 2210)
  (cvv_result 123)
  (bank BANCOLOMBIA)
  (phone_number 123456789)
  (transaction_amount 1000000)
 )
)

(assert 
 (credit-card-payment
  (action_type payment)
  (transaction_id 002)
  (email "jorge.porras@example.com")
  (user_fullname "Jorge Porras")
  (user_name "jorge.porras")
  (payment_method CREDIT-CARD)
  (card_fullname "JORGE PORRAS")
  (card_bin 4111111111111112)  
  (card_expire 2210)
  (cvv_result 123)
  (bank COLPATRIA)
  (phone_number 123456789)
  (transaction_amount 500000)
 )
)

(assert 
 (credit-card-payment
  (action_type payment)
  (transaction_id 003)
  (email "jorge.porras@example.com")
  (user_fullname "Jorge Porras")
  (user_name "jorge.porras")
  (payment_method CREDIT-CARD)
  (card_fullname "JORGE PORRAS")
  (card_bin 4111111111111112)  
  (card_expire 2210)
  (cvv_result 123)
  (bank COLPATRIA)
  (phone_number 123456789)
  (transaction_amount 2500000)
 )
)



















