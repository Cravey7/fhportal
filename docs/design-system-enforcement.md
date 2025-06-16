# Design System Enforcement Guide

## Overview
This document outlines how to enforce the FH Portal design system across Next.js, Supabase, and Vercel deployments. It provides automated tools and processes to ensure consistency and AI-friendly development.

## 1. ESLint Configuration for Design System

### Custom ESLint Rules
Create `.eslintrc.js` with design system enforcement:

```javascript
module.exports = {
  extends: [
    'next/core-web-vitals',
    '@typescript-eslint/recommended',
  ],
  plugins: ['@typescript-eslint'],
  rules: {
    // Design System Enforcement
    '@typescript-eslint/naming-convention': [
      'error',
      {
        selector: 'interface',
        format: ['PascalCase'],
        suffix: ['Props', 'State', 'Config', 'Data']
      },
      {
        selector: 'typeAlias',
        format: ['PascalCase']
      },
      {
        selector: 'function',
        format: ['camelCase', 'PascalCase']
      },
      {
        selector: 'variable',
        format: ['camelCase', 'PascalCase', 'UPPER_CASE']
      }
    ],
    
    // Component Structure Rules
    'react/function-component-definition': [
      'error',
      {
        namedComponents: 'function-declaration',
        unnamedComponents: 'arrow-function'
      }
    ],
    
    // Import Organization
    'import/order': [
      'error',
      {
        groups: [
          'builtin',
          'external',
          'internal',
          'parent',
          'sibling',
          'index'
        ],
        pathGroups: [
          {
            pattern: '@/**',
            group: 'internal',
            position: 'before'
          }
        ],
        'newlines-between': 'always'
      }
    ],
    
    // TypeScript Strict Rules
    '@typescript-eslint/no-explicit-any': 'error',
    '@typescript-eslint/no-unused-vars': 'error',
    '@typescript-eslint/prefer-nullish-coalescing': 'error',
    '@typescript-eslint/prefer-optional-chain': 'error',
    
    // Design System Class Usage
    'no-restricted-syntax': [
      'error',
      {
        selector: 'Literal[value=/^(text-|bg-|border-)[a-z]+-[0-9]+$/]',
        message: 'Use design system color tokens instead of arbitrary Tailwind colors'
      }
    ]
  }
};
```

### Custom ESLint Plugin for Design System
Create `eslint-plugin-design-system.js`:

```javascript
module.exports = {
  rules: {
    'use-design-tokens': {
      meta: {
        type: 'problem',
        docs: {
          description: 'Enforce usage of design system tokens',
        },
        schema: []
      },
      create(context) {
        return {
          Literal(node) {
            if (typeof node.value === 'string') {
              // Check for non-design-system colors
              const forbiddenPatterns = [
                /text-red-\d+/,
                /bg-blue-\d+/,
                /border-green-\d+/
              ];
              
              forbiddenPatterns.forEach(pattern => {
                if (pattern.test(node.value)) {
                  context.report({
                    node,
                    message: 'Use design system semantic colors instead'
                  });
                }
              });
            }
          }
        };
      }
    }
  }
};
```

## 2. Pre-commit Hooks Configuration

### Husky Setup
```json
// package.json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "pre-push": "npm run type-check && npm run test"
    }
  },
  "lint-staged": {
    "*.{ts,tsx}": [
      "eslint --fix",
      "prettier --write",
      "npm run design-system-check"
    ],
    "*.{css,scss}": [
      "stylelint --fix",
      "prettier --write"
    ],
    "*.{md,json}": [
      "prettier --write"
    ]
  }
}
```

### Design System Validation Script
Create `scripts/design-system-check.js`:

```javascript
const fs = require('fs');
const path = require('path');
const glob = require('glob');

const DESIGN_SYSTEM_PATTERNS = {
  colors: {
    primary: ['primary-50', 'primary-100', 'primary-500', 'primary-600', 'primary-900'],
    semantic: ['success-50', 'success-500', 'warning-50', 'warning-500', 'error-50', 'error-500'],
    neutral: ['gray-50', 'gray-100', 'gray-200', 'gray-300', 'gray-400', 'gray-500', 'gray-600', 'gray-700', 'gray-800', 'gray-900']
  },
  spacing: ['p-1', 'p-2', 'p-3', 'p-4', 'p-5', 'p-6', 'p-8', 'p-10', 'p-12', 'p-16', 'p-20', 'p-24'],
  typography: ['text-xs', 'text-sm', 'text-base', 'text-lg', 'text-xl', 'text-2xl', 'text-3xl', 'text-4xl']
};

function validateDesignSystem() {
  const files = glob.sync('src/**/*.{ts,tsx}');
  const errors = [];

  files.forEach(file => {
    const content = fs.readFileSync(file, 'utf8');
    
    // Check for non-design-system classes
    const classNameRegex = /className="([^"]+)"/g;
    let match;
    
    while ((match = classNameRegex.exec(content)) !== null) {
      const classes = match[1].split(' ');
      
      classes.forEach(cls => {
        // Check for arbitrary color values
        if (/^(text|bg|border)-\w+-\d+$/.test(cls)) {
          const isValidDesignToken = Object.values(DESIGN_SYSTEM_PATTERNS.colors)
            .flat()
            .some(token => cls.includes(token.split('-')[0]));
            
          if (!isValidDesignToken) {
            errors.push({
              file,
              class: cls,
              message: 'Use design system color tokens instead'
            });
          }
        }
      });
    }
  });

  if (errors.length > 0) {
    console.error('Design System Violations:');
    errors.forEach(error => {
      console.error(`${error.file}: ${error.class} - ${error.message}`);
    });
    process.exit(1);
  }
  
  console.log('✅ Design system validation passed');
}

validateDesignSystem();
```

## 3. Vercel Deployment Configuration

### Build-time Validation
Create `vercel.json`:

```json
{
  "framework": "nextjs",
  "buildCommand": "npm run build:validate",
  "devCommand": "npm run dev",
  "installCommand": "npm install",
  "functions": {
    "app/api/**/*.ts": {
      "runtime": "nodejs18.x"
    }
  },
  "env": {
    "NEXT_PUBLIC_SUPABASE_URL": "@supabase_url",
    "NEXT_PUBLIC_SUPABASE_ANON_KEY": "@supabase_anon_key",
    "SUPABASE_SERVICE_ROLE_KEY": "@supabase_service_role_key",
    "NEXTAUTH_SECRET": "@nextauth_secret"
  },
  "build": {
    "env": {
      "SKIP_ENV_VALIDATION": "false"
    }
  }
}
```

### Custom Build Script
Add to `package.json`:

```json
{
  "scripts": {
    "build:validate": "npm run design-system-check && npm run type-check && npm run lint && npm run build",
    "design-system-check": "node scripts/design-system-check.js",
    "type-check": "tsc --noEmit",
    "lint": "next lint",
    "test:design-system": "jest --testPathPattern=design-system"
  }
}
```

## 4. Supabase Integration Enforcement

### Type Safety Validation
Create `scripts/supabase-type-check.js`:

```javascript
const { createClient } = require('@supabase/supabase-js');

async function validateSupabaseTypes() {
  try {
    // Validate that all database operations use generated types
    const typeFiles = glob.sync('src/types/database.types.ts');
    
    if (typeFiles.length === 0) {
      throw new Error('Missing Supabase generated types. Run: npx supabase gen types typescript');
    }
    
    // Check for any usage of 'any' type in Supabase operations
    const apiFiles = glob.sync('src/lib/supabase/**/*.ts');
    
    apiFiles.forEach(file => {
      const content = fs.readFileSync(file, 'utf8');
      
      if (content.includes(': any') || content.includes('<any>')) {
        throw new Error(`Found 'any' type in ${file}. Use generated Supabase types instead.`);
      }
    });
    
    console.log('✅ Supabase type validation passed');
  } catch (error) {
    console.error('❌ Supabase validation failed:', error.message);
    process.exit(1);
  }
}

validateSupabaseTypes();
```

### Row Level Security Validation
Create `scripts/rls-check.js`:

```javascript
const { createClient } = require('@supabase/supabase-js');

async function validateRLS() {
  const supabase = createClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL,
    process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  try {
    // Check that RLS is enabled on all tables
    const { data: tables } = await supabase
      .from('information_schema.tables')
      .select('table_name')
      .eq('table_schema', 'public');

    const requiredTables = ['companies', 'campaigns', 'projects', 'tasks', 'goals', 'actions'];
    
    for (const table of requiredTables) {
      const { data: rlsStatus } = await supabase
        .rpc('check_rls_enabled', { table_name: table });
        
      if (!rlsStatus) {
        throw new Error(`RLS not enabled on table: ${table}`);
      }
    }
    
    console.log('✅ RLS validation passed');
  } catch (error) {
    console.error('❌ RLS validation failed:', error.message);
    process.exit(1);
  }
}

validateRLS();
```

## 5. GitHub Actions Workflow

Create `.github/workflows/design-system-validation.yml`:

```yaml
name: Design System Validation

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  validate:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
          
      - name: Install dependencies
        run: npm ci
        
      - name: Design System Check
        run: npm run design-system-check
        
      - name: Type Check
        run: npm run type-check
        
      - name: Lint
        run: npm run lint
        
      - name: Test
        run: npm run test
        
      - name: Build
        run: npm run build
        
      - name: Supabase Validation
        run: npm run supabase:validate
        env:
          NEXT_PUBLIC_SUPABASE_URL: ${{ secrets.SUPABASE_URL }}
          SUPABASE_SERVICE_ROLE_KEY: ${{ secrets.SUPABASE_SERVICE_ROLE_KEY }}
```

## 6. AI Assistant Integration

### AI-Friendly Documentation
All design system documentation includes:
- Exact class names and patterns
- Copy-paste ready code examples
- Clear naming conventions
- Validation rules and error messages

### Automated AI Assistance
Create `scripts/ai-helper.js`:

```javascript
// Helper script for AI assistants to validate design system usage
function validateAIGeneratedCode(code) {
  const validationRules = [
    {
      pattern: /className="[^"]*"/g,
      validator: (match) => {
        // Validate Tailwind classes against design system
        return validateTailwindClasses(match);
      }
    },
    {
      pattern: /interface \w+Props/g,
      validator: (match) => {
        // Validate component prop interfaces
        return match.includes('Props');
      }
    }
  ];
  
  return validationRules.every(rule => {
    const matches = code.match(rule.pattern) || [];
    return matches.every(rule.validator);
  });
}

module.exports = { validateAIGeneratedCode };
```

This enforcement system ensures consistent design system usage across all development workflows while maintaining AI-friendly patterns and automated validation.
