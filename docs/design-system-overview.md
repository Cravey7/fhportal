# FH Portal Design System Overview

## System Architecture

The FH Portal design system is built for consistency, scalability, and AI-friendly development. It integrates seamlessly with Next.js 14, Supabase, and Vercel deployment.

## Core Documents

### 1. [design-system.md](./design-system.md)
**Purpose**: Core design system documentation
**Contents**:
- Design tokens (colors, typography, spacing)
- Component patterns and examples
- Layout patterns and responsive design
- Accessibility guidelines
- Animation and interaction patterns

**AI Usage**: Reference this for exact class names, component patterns, and styling guidelines.

### 2. [development-standards.md](./development-standards.md)
**Purpose**: Coding conventions and development practices
**Contents**:
- File naming conventions
- TypeScript patterns and standards
- React component patterns
- API development standards
- Testing patterns

**AI Usage**: Follow these patterns for consistent code structure and naming.

### 3. [design-system-implementation.md](./design-system-implementation.md)
**Purpose**: Step-by-step setup guide
**Contents**:
- Project initialization
- Tailwind CSS configuration
- shadcn/ui setup
- Supabase integration
- Development tooling setup

**AI Usage**: Use this for project setup and configuration.

### 4. [design-system-enforcement.md](./design-system-enforcement.md)
**Purpose**: Automated validation and enforcement
**Contents**:
- ESLint rules for design system compliance
- Pre-commit hooks and validation scripts
- Vercel deployment configuration
- GitHub Actions workflows

**AI Usage**: Reference for validation rules and automated checks.

## Quick Reference for AI Assistants

### Color System
```typescript
// Primary Colors
bg-primary-50, bg-primary-100, bg-primary-500, bg-primary-600, bg-primary-900
text-primary-50, text-primary-100, text-primary-500, text-primary-600, text-primary-900

// Semantic Colors
bg-success-50, bg-success-500, bg-success-600
bg-warning-50, bg-warning-500, bg-warning-600
bg-error-50, bg-error-500, bg-error-600

// Neutral Colors
bg-gray-50 through bg-gray-900
text-gray-50 through text-gray-900
```

### Component Patterns
```typescript
// Standard Card Pattern
<div className="bg-white rounded-lg shadow-md border border-gray-200 p-6 hover:shadow-lg transition-shadow">
  <div className="flex items-start justify-between mb-4">
    <h3 className="text-lg font-semibold text-gray-900">{title}</h3>
    <Badge variant="secondary">{status}</Badge>
  </div>
  <p className="text-sm text-gray-600 mb-4">{description}</p>
  <div className="flex items-center justify-between">
    <div className="text-xs text-gray-500">{metadata}</div>
    <Button variant="outline" size="sm">View Details</Button>
  </div>
</div>

// Standard Form Field
<div className="space-y-2">
  <Label htmlFor="field" className="text-sm font-medium text-gray-700">Field Label</Label>
  <Input 
    id="field" 
    className="w-full border-gray-300 rounded-md focus:border-primary-500 focus:ring-primary-500" 
    placeholder="Enter value..."
  />
  <p className="text-xs text-gray-500">Helper text goes here</p>
</div>

// Status Badge Patterns
<Badge className="bg-success-50 text-success-600 border-success-200">Active</Badge>
<Badge className="bg-warning-50 text-warning-600 border-warning-200">Pending</Badge>
<Badge className="bg-error-50 text-error-600 border-error-200">Inactive</Badge>
```

### File Structure Patterns
```typescript
// Component File Structure
import React from 'react';
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import type { ComponentProps } from './ComponentName.types';

interface ComponentNameProps extends ComponentProps {
  className?: string;
}

export function ComponentName({ className, ...props }: ComponentNameProps) {
  return (
    <div className={cn("default-classes", className)} {...props}>
      {/* Component content */}
    </div>
  );
}

// Named export (preferred)
export { ComponentName };
```

### Naming Conventions
```typescript
// Files and Directories
kebab-case/          // Directories
ComponentName.tsx    // Components (PascalCase)
useHookName.ts      // Hooks (camelCase with 'use' prefix)
utilityName.ts      // Utilities (camelCase)
CONSTANTS.ts        // Constants (SCREAMING_SNAKE_CASE)

// TypeScript
interface UserProps { }     // Interfaces (PascalCase with suffix)
type Status = 'active';     // Types (PascalCase)
enum UserRole { }          // Enums (PascalCase)
```

## Integration Points

### Next.js Integration
- App Router structure with design system layouts
- Middleware for authentication and company context
- API routes following RESTful patterns
- Server-side rendering with design system styles

### Supabase Integration
- Type-safe database operations
- Row Level Security (RLS) enforcement
- Real-time subscriptions for live updates
- Generated TypeScript types

### Vercel Deployment
- Automated build validation
- Environment variable management
- Performance monitoring
- Preview deployments with design system validation

## Validation and Enforcement

### Automated Checks
1. **Pre-commit Hooks**: Validate design system compliance before commits
2. **ESLint Rules**: Enforce coding standards and design patterns
3. **Type Checking**: Ensure TypeScript compliance
4. **Build Validation**: Verify design system usage during builds
5. **Deployment Checks**: Validate before production deployment

### Manual Validation
1. **Design Review**: Visual consistency checks
2. **Accessibility Testing**: WCAG AA compliance verification
3. **Performance Testing**: Core Web Vitals monitoring
4. **Cross-browser Testing**: Compatibility verification

## Development Workflow

### For AI Assistants
1. **Always reference design-system.md** for styling patterns
2. **Follow development-standards.md** for code structure
3. **Use exact class names** from the design token system
4. **Validate against patterns** before suggesting code
5. **Ask for clarification** if patterns don't exist

### For Human Developers
1. **Setup**: Follow design-system-implementation.md
2. **Development**: Use design-system.md patterns
3. **Validation**: Run automated checks before commits
4. **Review**: Ensure design system compliance in PRs
5. **Deploy**: Automated validation in CI/CD pipeline

## Error Handling

### Common Issues and Solutions
```typescript
// ❌ Avoid arbitrary colors
className="text-red-500 bg-blue-600"

// ✅ Use design system tokens
className="text-error-500 bg-primary-600"

// ❌ Avoid inconsistent spacing
className="p-3 m-7"

// ✅ Use design system spacing
className="p-4 m-6"

// ❌ Avoid inline styles
style={{ color: '#ff0000' }}

// ✅ Use design system classes
className="text-error-500"
```

### Validation Errors
- **Design Token Violations**: Use semantic colors instead of arbitrary values
- **Pattern Violations**: Follow component patterns from design-system.md
- **Naming Violations**: Use naming conventions from development-standards.md
- **Type Violations**: Use generated Supabase types instead of 'any'

## Benefits

### For Development
- **Consistency**: Unified visual language across the application
- **Efficiency**: Reusable patterns and components
- **Maintainability**: Centralized design decisions
- **Scalability**: Easy to extend and modify

### For AI Assistance
- **Predictability**: Clear patterns and naming conventions
- **Validation**: Automated checks for compliance
- **Documentation**: Comprehensive examples and guidelines
- **Error Prevention**: Clear rules and constraints

### For Deployment
- **Quality Assurance**: Automated validation in CI/CD
- **Performance**: Optimized design system assets
- **Reliability**: Consistent behavior across environments
- **Monitoring**: Built-in performance and accessibility tracking

This design system provides a solid foundation for building consistent, scalable, and maintainable user interfaces while supporting both human developers and AI assistants in the development process.
