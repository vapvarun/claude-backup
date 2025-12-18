---
name: code-review
description: Perform thorough code reviews focusing on security, performance, best practices, and maintainability. Use when reviewing PRs, checking code quality, or auditing existing code.
---

# Code Review Skill

## Instructions

When reviewing code:

1. **Security Check**
   - Look for SQL injection, XSS, CSRF vulnerabilities
   - Check for exposed secrets or API keys
   - Verify input validation and sanitization
   - Review authentication/authorization logic

2. **Performance Review**
   - Identify N+1 queries
   - Check for unnecessary re-renders (React)
   - Look for memory leaks
   - Review async/await usage

3. **Best Practices**
   - Check naming conventions
   - Verify proper error handling
   - Review code structure and organization
   - Check for code duplication

4. **Maintainability**
   - Assess readability
   - Check for proper typing (TypeScript)
   - Review test coverage
   - Verify documentation

## Output Format

Provide feedback in this structure:
- **Critical Issues** (must fix)
- **Warnings** (should fix)
- **Suggestions** (nice to have)
- **Positive Notes** (what's done well)
