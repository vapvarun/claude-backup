---
name: javascript
description: Write modern JavaScript/ES6+ code following best practices for performance, security, and maintainability. Use when writing JS code, fixing bugs, or implementing frontend functionality.
---

# JavaScript Skill

## Instructions

When writing JavaScript:

### 1. Modern Syntax

```javascript
// Use const by default, let when needed
const API_URL = 'https://api.example.com';
let count = 0;

// Arrow functions
const add = (a, b) => a + b;
const greet = name => `Hello, ${name}!`;

// Destructuring
const { name, email } = user;
const [first, second, ...rest] = items;

// Spread operator
const newArray = [...oldArray, newItem];
const newObject = { ...oldObject, newProp: value };

// Template literals
const message = `User ${name} has ${count} items`;

// Optional chaining
const city = user?.address?.city;

// Nullish coalescing
const value = input ?? defaultValue;
```

### 2. Async/Await

```javascript
// Async function
async function fetchData(url) {
  try {
    const response = await fetch(url);

    if (!response.ok) {
      throw new Error(`HTTP error: ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Fetch failed:', error);
    throw error;
  }
}

// Parallel requests
async function fetchAll(urls) {
  const promises = urls.map(url => fetch(url));
  const responses = await Promise.all(promises);
  return Promise.all(responses.map(r => r.json()));
}

// With timeout
async function fetchWithTimeout(url, timeout = 5000) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), timeout);

  try {
    const response = await fetch(url, { signal: controller.signal });
    return await response.json();
  } finally {
    clearTimeout(timeoutId);
  }
}
```

### 3. Array Methods

```javascript
const users = [
  { id: 1, name: 'Alice', age: 25, active: true },
  { id: 2, name: 'Bob', age: 30, active: false },
  { id: 3, name: 'Charlie', age: 35, active: true },
];

// map - transform items
const names = users.map(user => user.name);

// filter - select items
const activeUsers = users.filter(user => user.active);

// find - get first match
const bob = users.find(user => user.name === 'Bob');

// some/every - check conditions
const hasActive = users.some(user => user.active);
const allActive = users.every(user => user.active);

// reduce - aggregate
const totalAge = users.reduce((sum, user) => sum + user.age, 0);

// Chaining
const activeNames = users
  .filter(user => user.active)
  .map(user => user.name)
  .sort();
```

### 4. DOM Manipulation

```javascript
// Selecting elements
const element = document.querySelector('.class');
const elements = document.querySelectorAll('.class');

// Creating elements
const div = document.createElement('div');
div.className = 'card';
div.innerHTML = `
  <h2>${title}</h2>
  <p>${description}</p>
`;

// Event handling
element.addEventListener('click', (event) => {
  event.preventDefault();
  // Handle click
});

// Event delegation
document.querySelector('.list').addEventListener('click', (event) => {
  if (event.target.matches('.item')) {
    handleItemClick(event.target);
  }
});

// IntersectionObserver (lazy loading, animations)
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      observer.unobserve(entry.target);
    }
  });
}, { threshold: 0.1 });

document.querySelectorAll('.animate').forEach(el => observer.observe(el));
```

### 5. Classes

```javascript
class User {
  #privateField; // Private field

  constructor(name, email) {
    this.name = name;
    this.email = email;
    this.#privateField = 'secret';
  }

  // Getter
  get displayName() {
    return this.name.toUpperCase();
  }

  // Setter
  set displayName(value) {
    this.name = value.trim();
  }

  // Method
  greet() {
    return `Hello, I'm ${this.name}`;
  }

  // Static method
  static create(data) {
    return new User(data.name, data.email);
  }
}

// Inheritance
class Admin extends User {
  constructor(name, email, role) {
    super(name, email);
    this.role = role;
  }

  greet() {
    return `${super.greet()} and I'm an ${this.role}`;
  }
}
```

### 6. Modules

```javascript
// Named exports
export const API_URL = 'https://api.example.com';
export function fetchData() { /* ... */ }
export class User { /* ... */ }

// Default export
export default function main() { /* ... */ }

// Importing
import main, { API_URL, fetchData, User } from './module.js';

// Dynamic import
const module = await import('./heavy-module.js');
```

### 7. Error Handling

```javascript
// Custom error
class ValidationError extends Error {
  constructor(message, field) {
    super(message);
    this.name = 'ValidationError';
    this.field = field;
  }
}

// Try-catch with specific handling
try {
  await submitForm(data);
} catch (error) {
  if (error instanceof ValidationError) {
    showFieldError(error.field, error.message);
  } else if (error instanceof NetworkError) {
    showToast('Network error. Please try again.');
  } else {
    console.error('Unexpected error:', error);
    showToast('Something went wrong.');
  }
}
```

### 8. Local Storage

```javascript
// Store data
const saveData = (key, data) => {
  localStorage.setItem(key, JSON.stringify(data));
};

// Retrieve data
const getData = (key, defaultValue = null) => {
  const stored = localStorage.getItem(key);
  return stored ? JSON.parse(stored) : defaultValue;
};

// Remove data
const removeData = (key) => {
  localStorage.removeItem(key);
};
```

### 9. Debounce & Throttle

```javascript
// Debounce - wait until stopped
function debounce(func, delay) {
  let timeoutId;
  return (...args) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func(...args), delay);
  };
}

const debouncedSearch = debounce((query) => {
  fetchResults(query);
}, 300);

// Throttle - limit frequency
function throttle(func, limit) {
  let inThrottle;
  return (...args) => {
    if (!inThrottle) {
      func(...args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

const throttledScroll = throttle(() => {
  updatePosition();
}, 100);
```

### 10. Best Practices

- Use `const` by default
- Prefer arrow functions
- Use async/await over callbacks
- Handle all errors
- Avoid global variables
- Use meaningful variable names
- Keep functions small and focused
- Comment complex logic
- Use strict equality (`===`)
- Validate user input
