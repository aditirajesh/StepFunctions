import json

def lambda_handler(event, context):
    is_palindrome = event.get("is_palindrome", False)
    input_string = event.get("string", "").lower().replace(" ", "")

    if is_palindrome:
        return {
            "statusCode": 200,
            "body": {
                "message": "This is a palindrome, yay!",
                "string": input_string
            }
        }
    else:
        return {
            "statusCode": 200,
            "body": {
                "message": "Sorry, not a palindrome",
                "string": input_string,
                "reverse": input_string[::-1]
            }
        }