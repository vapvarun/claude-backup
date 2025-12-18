---
name: bug-fix
description: Systematically diagnose and fix bugs by reproducing issues, identifying root causes, implementing fixes, and preventing regressions. Use when debugging errors, fixing issues, or troubleshooting problems.
---

# Bug Fix Skill

## Instructions

When fixing bugs:

1. **Understand the Issue**
   - Read the bug report/error message carefully
   - Identify expected vs actual behavior
   - Gather reproduction steps
   - Check browser/environment details

2. **Reproduce the Bug**
   - Follow exact reproduction steps
   - Test in same environment
   - Capture error logs and stack traces
   - Identify minimal reproduction case

3. **Investigate Root Cause**
   - Trace the code execution path
   - Check recent changes (git blame/log)
   - Review related code and dependencies
   - Use debugging tools and breakpoints

4. **Implement Fix**
   - Fix the root cause, not just symptoms
   - Keep changes minimal and focused
   - Consider edge cases
   - Avoid introducing new bugs

5. **Verify & Prevent Regression**
   - Test the fix thoroughly
   - Add unit/integration tests
   - Test related functionality
   - Document the fix

## Debugging Checklist

- [ ] Can reproduce the issue
- [ ] Identified root cause
- [ ] Fix is minimal and targeted
- [ ] Added regression test
- [ ] Tested edge cases
- [ ] No new issues introduced
