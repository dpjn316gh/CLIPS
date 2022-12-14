# CLIPS embedded in Python using clipspy and exposing through FastAPI
## Running locally

1. Starting point is: `app/main.py`

2. Working directory is: `python-clips-poc/`

3. On `app/main.py` file set 
`ENVIRONMENT = 'localhost'` for local tests

4. Then run `http://localhost:8000`

5. Post to `http://localhost:8000/credit-card-payment`
   ```json
   {
     "action_type": "payment",
     "transaction_id": "1",
     "email": "jorge.porras@mycompany.co",
     "user_fullname": "Jorge Porras",
     "user_name": "jorge.porras",
     "payment_method": "CREDIT-CARD",
     "card_fullname": "JORGE PORRAS",
     "card_bin": "4111111111111111) ",
     "card_expire": "2210",
     "cvv_result": "123",
     "bank": "BANCOLOMBIA",
     "phone_number": "123456789",
     "transaction_amount": 1000000
   }
   ```
   
   ```json
   {
     "action_type": "payment",
     "transaction_id": "2",
     "email": "jorge.porras@mycompany.co",
     "user_fullname": "Jorge Porras",
     "user_name": "jorge.porras",
     "payment_method": "CREDIT-CARD",
     "card_fullname": "JORGE PORRAS",
     "card_bin": "4111111111111112) ",
     "card_expire": "2210",
     "cvv_result": "123",
     "bank": "COLPATRIA",
     "phone_number": "123456789",
     "transaction_amount": 500000
   }
   ```
   
   ```json
   {
     "action_type": "payment",
     "transaction_id": "3",
     "email": "jorge.porras@mycompany.co",
     "user_fullname": "Jorge Porras",
     "user_name": "jorge.porras",
     "payment_method": "CREDIT-CARD",
     "card_fullname": "JORGE PORRAS",
     "card_bin": "4111111111111112) ",
     "card_expire": "2210",
     "cvv_result": "123",
     "bank": "COLPATRIA",
     "phone_number": "123456789",
     "transaction_amount": 2500000
   }
   ```
   
   ```json
   {
     "action_type": "payment",
     "transaction_id": "4",
     "email": "jorge.porras@mycompany.co",
     "user_fullname": "Jorge Porras",
     "user_name": "jorge.porras",
     "payment_method": "CREDIT-CARD",
     "card_fullname": "JORGE PORRAS",
     "card_bin": "4111111111111111) ",
     "card_expire": "2210",
     "cvv_result": "123",
     "bank": "BANCOLOMBIA",
     "phone_number": "123456789",
     "transaction_amount": 1000000,
     "items_names": [
       "cerveza",
       "aguardiente",
       "cigarrillo"
     ],
     "items_prices": [
       50000,
       100000,
       300000
     ],
     "items_quantities": [
       5,
       4,
       5
     ],
     "items_skus": [
       "99123456",
       "99123457",
       "99123458"
     ]
   }
   ```

## Running using AWS

### Exporting to lambda

1. On `app/main.py` file set 
`ENVIRONMENT = 'aws'` for aws lambda tests

2. Create a zip file that contains the code.
    ```shell
    cd venv/lib/python3.8/site-packages/
    zip -r9 ../../../../function.zip .
    cd ../../../../
    zip -g ./function.zip -r app
    ```
   
3. Create a S3 bucket 
4. Upload the zip file into the S3 bucket
5. Create a lambda function
   
   - Option: Author from scratch
   - Runtime: Python 3.8 or 3.7. Depends on your locally environment
6. Edit lambda function

   - Runtime settings.
     - Handler: app.main.handler
   - Upload a file from Amazon S3
   - Set the permission->roles for the lambda function:
     
     - AmazonS3ReadOnlyAccess
     - AmazonS3ObjectLambdaExecutionRolePolicy

7. Create API Gateway -> Rest API

   - Create method ANY
     
     - Use Lambda Proxy integration: True
     - Lambda function name: <Give lambda's name>
     - Create New Child Resource
       
       - proxy resource
       - Lambda Function name
     
8. Testing:

    - {proxy}: credit-card-payment
    - Body: Use the example as it's shown for locally testing