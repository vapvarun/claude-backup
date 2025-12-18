---
name: api-endpoint
description: Create REST or GraphQL API endpoints with proper validation, error handling, authentication, and documentation. Use when building backend APIs or serverless functions.
---

# API Endpoint Skill

## Instructions

When creating API endpoints:

1. **Request Handling**
   - Validate all inputs (use Zod, Joi, or similar)
   - Sanitize user data
   - Parse and validate query params, body, headers
   - Handle file uploads securely

2. **Authentication & Authorization**
   - Verify JWT/session tokens
   - Check user permissions
   - Implement rate limiting
   - Log access attempts

3. **Response Format**
   - Use consistent response structure
   - Include proper HTTP status codes
   - Return meaningful error messages
   - Paginate large datasets

4. **Error Handling**
   - Catch and handle all errors
   - Don't expose internal errors to clients
   - Log errors for debugging
   - Return user-friendly messages

5. **Documentation**
   - Document request/response schemas
   - Include example requests
   - List possible error responses
   - Note authentication requirements

## Response Structure

```json
{
  "success": true,
  "data": {},
  "meta": {
    "page": 1,
    "total": 100
  }
}
```

## Error Structure

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "User-friendly message",
    "details": []
  }
}
```
