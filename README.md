# Claude Code Skills Collection

A comprehensive collection of 41 Claude Code skills for web development agencies. The ultimate skill directory covering WordPress, Laravel, PHP, frontend, backend, testing, security, DevOps, and marketing.

## Available Skills (41 Total)

### WordPress & WooCommerce (9 skills)
| Skill | Description |
|-------|-------------|
| **wp-performance-review** | Performance optimization and anti-pattern detection |
| **wp-security-review** | Security audit, OWASP Top 10, vulnerability detection |
| **wp-gutenberg-blocks** | Gutenberg block development, FSE, theme.json |
| **wp-theme-development** | Classic & block themes, template hierarchy |
| **wp-plugin-development** | Plugin architecture, REST API, hooks system |
| **woocommerce** | E-commerce: payment gateways, custom products, REST API |
| **theme-development** | WordPress theme best practices |
| **plugin-development** | WordPress plugin best practices |
| **wordpress-gutenberg** | Block editor development |

### PHP & Laravel (2 skills)
| Skill | Description |
|-------|-------------|
| **php** | Modern PHP 8.x: OOP, type safety, testing, patterns |
| **laravel** | Eloquent, Blade, Pest/PHPUnit, queues, caching |

### Frontend & UI (7 skills)
| Skill | Description |
|-------|-------------|
| **frontend-design** | Distinctive, production-grade UI design |
| **react-component** | React components with TypeScript, hooks |
| **css-styling** | Modern CSS, responsive design, animations |
| **html-markup** | Semantic HTML5, accessibility |
| **typescript** | TypeScript: generics, utility types, React patterns |
| **web-artifacts-builder** | React + Tailwind + shadcn/ui components |
| **theme-factory** | Theming toolkit with 10 pre-built themes |

### Backend & API (4 skills)
| Skill | Description |
|-------|-------------|
| **api-endpoint** | REST/GraphQL API development |
| **javascript** | Modern JS/ES6+ best practices |
| **graphql** | GraphQL: schemas, resolvers, Apollo Server |
| **database** | Schema design, indexing, query optimization |

### Testing & Quality (4 skills)
| Skill | Description |
|-------|-------------|
| **webapp-testing** | Playwright browser testing for web apps |
| **testing** | Unit, integration, and E2E testing |
| **code-review** | Code review best practices |
| **accessibility** | WCAG 2.1 AA compliance, ARIA, screen readers |

### Security & DevOps (3 skills)
| Skill | Description |
|-------|-------------|
| **security** | OWASP Top 10, auth, input validation, cryptography |
| **devops** | Docker, CI/CD, deployment, monitoring |
| **mcp-builder** | MCP server development guide |

### Development Tools (4 skills)
| Skill | Description |
|-------|-------------|
| **bug-fix** | Systematic debugging approach |
| **git-workflow** | Git best practices, commits, PRs |
| **skill-creator** | Create new Claude Code skills |
| **pdf** | PDF manipulation, extraction, creation |
| **xlsx** | Excel spreadsheet creation and analysis |

### Content & Marketing (7 skills)
| Skill | Description |
|-------|-------------|
| **marketing** | Product marketing, announcements |
| **seo-optimization** | On-page SEO, Core Web Vitals |
| **landing-page** | High-converting landing pages |
| **email-marketing** | Email campaigns, newsletters |
| **social-media** | Social content, engagement |
| **documentation** | Technical documentation |
| **customer-support** | Support ticket handling |

## Installation

Copy all skills to your Claude Code configuration:

```bash
cp -r skills/* ~/.claude/skills/
```

Or copy specific categories:

```bash
# WordPress & WooCommerce
cp -r skills/wp-* skills/woocommerce ~/.claude/skills/

# PHP & Laravel
cp -r skills/php skills/laravel ~/.claude/skills/

# Frontend
cp -r skills/frontend-design skills/react-component skills/css-styling skills/typescript ~/.claude/skills/

# Backend
cp -r skills/api-endpoint skills/graphql skills/database ~/.claude/skills/

# Security & DevOps
cp -r skills/security skills/devops ~/.claude/skills/

# Testing
cp -r skills/webapp-testing skills/testing skills/accessibility ~/.claude/skills/
```

## Skill Categories

| Category | Count | Focus |
|----------|-------|-------|
| WordPress & WooCommerce | 9 | WordPress ecosystem, e-commerce |
| PHP & Laravel | 2 | PHP frameworks and patterns |
| Frontend & UI | 7 | React, CSS, TypeScript, design |
| Backend & API | 4 | APIs, databases, server-side |
| Testing & Quality | 4 | Testing, accessibility, code review |
| Security & DevOps | 3 | Security, deployment, infrastructure |
| Development Tools | 4 | Debugging, Git, utilities |
| Content & Marketing | 7 | SEO, marketing, documentation |

## Skill Highlights

### WordPress Skills
- 200+ code examples with BAD/GOOD patterns
- WordPress Coding Standards compliance
- OWASP Top 10 security mapping
- WooCommerce payment gateways & custom products

### Laravel Skills
- Eloquent relationships & eager loading
- TDD with Pest/PHPUnit
- Queues, caching, and performance
- Form requests, policies, API resources

### Security Skills
- OWASP Top 10 vulnerability prevention
- JWT and OAuth 2.0 authentication
- Input validation with Zod schemas
- Security headers and CSRF protection

### DevOps Skills
- Docker multi-stage builds
- GitHub Actions & GitLab CI/CD
- Nginx configuration
- Monitoring with Prometheus

### Frontend Skills
- TypeScript generics and utility types
- React hooks with proper typing
- WCAG 2.1 AA accessibility compliance
- Modern CSS patterns and animations

## Sources

Skills curated and enhanced from:
- [anthropics/skills](https://github.com/anthropics/skills) - Official Anthropic skills
- [jpcaparas/superpowers-laravel](https://github.com/jpcaparas/superpowers-laravel) - Laravel patterns
- [jeremylongshore/claude-code-plugins-plus](https://github.com/jeremylongshore/claude-code-plugins-plus) - Plugin marketplace

---
*Last updated: 2025-12-20 | Total Skills: 41*
