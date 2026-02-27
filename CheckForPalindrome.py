def lambda_handler(event, context):
    text = event.get("string")

    # Validate that the key exists and is not empty
    if text is None:
        raise ValueError("Missing required field: 'string'")
    
    if not isinstance(text, str) or text.strip() == "":
        raise ValueError("Input 'string' must be a non-empty string")

    cleaned = text.lower().replace(" ", "")
    is_palindrome = cleaned == cleaned[::-1]

    return {
        "is_palindrome": is_palindrome
    }