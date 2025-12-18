---
name: react-component
description: Create React components with TypeScript, following best practices for hooks, state management, accessibility, and testing. Use when building new UI components or refactoring existing ones.
---

# React Component Skill

## Instructions

When creating React components:

1. **Component Structure**
   - Use functional components with TypeScript
   - Define clear prop interfaces
   - Use proper file naming (PascalCase)
   - Keep components focused and single-purpose

2. **Hooks Best Practices**
   - Use appropriate hooks (useState, useEffect, useMemo, useCallback)
   - Follow rules of hooks
   - Create custom hooks for reusable logic
   - Avoid unnecessary re-renders

3. **Styling**
   - Use CSS modules, Tailwind, or styled-components
   - Follow design system if available
   - Ensure responsive design
   - Support dark mode if applicable

4. **Accessibility**
   - Use semantic HTML
   - Add ARIA labels where needed
   - Ensure keyboard navigation
   - Test with screen readers

5. **Testing**
   - Write unit tests with React Testing Library
   - Test user interactions
   - Test edge cases and error states

## Template

```tsx
interface ComponentNameProps {
  // Define props
}

export function ComponentName({ ...props }: ComponentNameProps) {
  // Component logic
  return (
    // JSX
  );
}
```
