# FH Portal Design System

## Overview
This design system provides a comprehensive guide for building consistent, accessible, and beautiful interfaces for the FH Portal. It's designed to be AI-friendly with clear patterns and enforceable rules.

## AI Assistant Guidelines
When working with this design system:
- Always reference these exact class names and patterns
- Use the provided component examples as templates
- Follow the naming conventions strictly
- Validate against the design tokens before implementation
- If a pattern doesn't exist, ask before creating new ones

## Design Tokens

### Colors
Our color system is based on Apple's design principles with semantic naming for AI clarity.

#### Primary Colors
```css
/* Primary Brand Colors */
--primary-50: #eff6ff;    /* Very light blue */
--primary-100: #dbeafe;   /* Light blue */
--primary-500: #3b82f6;   /* Main brand blue */
--primary-600: #2563eb;   /* Darker blue */
--primary-900: #1e3a8a;   /* Darkest blue */

/* Tailwind Classes */
bg-primary-50, bg-primary-100, bg-primary-500, bg-primary-600, bg-primary-900
text-primary-50, text-primary-100, text-primary-500, text-primary-600, text-primary-900
border-primary-50, border-primary-100, border-primary-500, border-primary-600, border-primary-900
```

#### Semantic Colors
```css
/* Success Colors */
--success-50: #f0fdf4;    /* Light green background */
--success-500: #22c55e;   /* Success green */
--success-600: #16a34a;   /* Darker success */

/* Warning Colors */
--warning-50: #fffbeb;    /* Light amber background */
--warning-500: #f59e0b;   /* Warning amber */
--warning-600: #d97706;   /* Darker warning */

/* Error Colors */
--error-50: #fef2f2;      /* Light red background */
--error-500: #ef4444;     /* Error red */
--error-600: #dc2626;     /* Darker error */

/* Tailwind Classes */
bg-success-50, bg-success-500, bg-success-600
bg-warning-50, bg-warning-500, bg-warning-600
bg-error-50, bg-error-500, bg-error-600
text-success-500, text-warning-500, text-error-500
```

#### Neutral Colors
```css
/* Gray Scale */
--gray-50: #f9fafb;       /* Lightest gray */
--gray-100: #f3f4f6;      /* Very light gray */
--gray-200: #e5e7eb;      /* Light gray */
--gray-300: #d1d5db;      /* Medium light gray */
--gray-400: #9ca3af;      /* Medium gray */
--gray-500: #6b7280;      /* Base gray */
--gray-600: #4b5563;      /* Dark gray */
--gray-700: #374151;      /* Darker gray */
--gray-800: #1f2937;      /* Very dark gray */
--gray-900: #111827;      /* Darkest gray */

/* Tailwind Classes */
bg-gray-50, bg-gray-100, bg-gray-200, bg-gray-300, bg-gray-400, bg-gray-500, bg-gray-600, bg-gray-700, bg-gray-800, bg-gray-900
text-gray-50, text-gray-100, text-gray-200, text-gray-300, text-gray-400, text-gray-500, text-gray-600, text-gray-700, text-gray-800, text-gray-900
```

### Typography

#### Font Families
```css
/* Primary Font - Inter */
font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;

/* Tailwind Class */
font-sans
```

#### Font Sizes & Line Heights
```css
/* Headings */
--text-xs: 0.75rem;       /* 12px - Small labels */
--text-sm: 0.875rem;      /* 14px - Body small */
--text-base: 1rem;        /* 16px - Body text */
--text-lg: 1.125rem;      /* 18px - Large body */
--text-xl: 1.25rem;       /* 20px - Small heading */
--text-2xl: 1.5rem;       /* 24px - Medium heading */
--text-3xl: 1.875rem;     /* 30px - Large heading */
--text-4xl: 2.25rem;      /* 36px - Extra large heading */

/* Tailwind Classes */
text-xs, text-sm, text-base, text-lg, text-xl, text-2xl, text-3xl, text-4xl
```

#### Font Weights
```css
/* Font Weights */
--font-normal: 400;       /* Regular text */
--font-medium: 500;       /* Medium emphasis */
--font-semibold: 600;     /* Strong emphasis */
--font-bold: 700;         /* Bold headings */

/* Tailwind Classes */
font-normal, font-medium, font-semibold, font-bold
```

### Spacing System

#### Spacing Scale
```css
/* Spacing Values */
--space-1: 0.25rem;       /* 4px */
--space-2: 0.5rem;        /* 8px */
--space-3: 0.75rem;       /* 12px */
--space-4: 1rem;          /* 16px */
--space-5: 1.25rem;       /* 20px */
--space-6: 1.5rem;        /* 24px */
--space-8: 2rem;          /* 32px */
--space-10: 2.5rem;       /* 40px */
--space-12: 3rem;         /* 48px */
--space-16: 4rem;         /* 64px */
--space-20: 5rem;         /* 80px */
--space-24: 6rem;         /* 96px */

/* Tailwind Classes */
p-1, p-2, p-3, p-4, p-5, p-6, p-8, p-10, p-12, p-16, p-20, p-24
m-1, m-2, m-3, m-4, m-5, m-6, m-8, m-10, m-12, m-16, m-20, m-24
gap-1, gap-2, gap-3, gap-4, gap-5, gap-6, gap-8, gap-10, gap-12, gap-16, gap-20, gap-24
```

### Border Radius
```css
/* Border Radius */
--radius-sm: 0.125rem;    /* 2px - Small elements */
--radius-md: 0.375rem;    /* 6px - Default */
--radius-lg: 0.5rem;      /* 8px - Cards */
--radius-xl: 0.75rem;     /* 12px - Large cards */
--radius-2xl: 1rem;       /* 16px - Modals */
--radius-full: 9999px;    /* Full circle */

/* Tailwind Classes */
rounded-sm, rounded-md, rounded-lg, rounded-xl, rounded-2xl, rounded-full
```

### Shadows
```css
/* Shadow System */
--shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
--shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
--shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
--shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);

/* Tailwind Classes */
shadow-sm, shadow-md, shadow-lg, shadow-xl
```

## Component Patterns

### Card Components
Standard card pattern for all entity displays (companies, campaigns, projects, etc.):

```tsx
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
```

### Button Variants
```tsx
// Primary Button
<Button className="bg-primary-500 hover:bg-primary-600 text-white">Primary Action</Button>

// Secondary Button
<Button variant="outline" className="border-gray-300 text-gray-700 hover:bg-gray-50">Secondary</Button>

// Destructive Button
<Button variant="destructive" className="bg-error-500 hover:bg-error-600 text-white">Delete</Button>

// Ghost Button
<Button variant="ghost" className="text-gray-600 hover:text-gray-900 hover:bg-gray-100">Cancel</Button>
```

### Form Patterns
```tsx
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

// Error State
<div className="space-y-2">
  <Label htmlFor="field" className="text-sm font-medium text-gray-700">Field Label</Label>
  <Input 
    id="field" 
    className="w-full border-error-500 rounded-md focus:border-error-500 focus:ring-error-500" 
    placeholder="Enter value..."
  />
  <p className="text-xs text-error-500">Error message here</p>
</div>
```

### Status Indicators
```tsx
// Status Badge Patterns
<Badge className="bg-success-50 text-success-600 border-success-200">Active</Badge>
<Badge className="bg-warning-50 text-warning-600 border-warning-200">Pending</Badge>
<Badge className="bg-error-50 text-error-600 border-error-200">Inactive</Badge>
<Badge className="bg-gray-50 text-gray-600 border-gray-200">Draft</Badge>
```

### Navigation Patterns
```tsx
// Breadcrumb Pattern
<nav className="flex items-center space-x-2 text-sm text-gray-500 mb-6">
  <Link href="/companies" className="hover:text-gray-700">Companies</Link>
  <ChevronRight className="w-4 h-4" />
  <Link href="/campaigns" className="hover:text-gray-700">Campaigns</Link>
  <ChevronRight className="w-4 h-4" />
  <span className="text-gray-900 font-medium">Current Page</span>
</nav>

// Tab Navigation
<Tabs defaultValue="overview" className="w-full">
  <TabsList className="grid w-full grid-cols-4 bg-gray-100 rounded-lg p-1">
    <TabsTrigger value="overview" className="rounded-md">Overview</TabsTrigger>
    <TabsTrigger value="tasks" className="rounded-md">Tasks</TabsTrigger>
    <TabsTrigger value="goals" className="rounded-md">Goals</TabsTrigger>
    <TabsTrigger value="actions" className="rounded-md">Actions</TabsTrigger>
  </TabsList>
</Tabs>
```

## Layout Patterns

### Page Layout Structure
```tsx
// Standard Page Layout
<div className="min-h-screen bg-gray-50">
  {/* Header */}
  <header className="bg-white border-b border-gray-200 px-6 py-4">
    <div className="flex items-center justify-between">
      <Breadcrumb />
      <div className="flex items-center gap-4">
        <Button variant="outline">Secondary Action</Button>
        <Button>Primary Action</Button>
      </div>
    </div>
  </header>

  {/* Main Content */}
  <main className="px-6 py-8">
    <div className="max-w-7xl mx-auto">
      {/* Page Title */}
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">{pageTitle}</h1>
        <p className="text-gray-600">{pageDescription}</p>
      </div>

      {/* Content Area */}
      <div className="space-y-6">
        {children}
      </div>
    </div>
  </main>
</div>
```

### Grid Layouts
```tsx
// Card Grid Layout
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
  {items.map(item => (
    <Card key={item.id} {...item} />
  ))}
</div>

// Dashboard Grid Layout
<div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
  {/* Main Content */}
  <div className="lg:col-span-2 space-y-6">
    <StatsCards />
    <RecentActivity />
  </div>

  {/* Sidebar */}
  <div className="space-y-6">
    <QuickActions />
    <UpcomingTasks />
  </div>
</div>
```

## Data Display Patterns

### Table Pattern
```tsx
// Standard Data Table
<div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
  <div className="px-6 py-4 border-b border-gray-200">
    <h3 className="text-lg font-semibold text-gray-900">Table Title</h3>
  </div>
  <Table>
    <TableHeader>
      <TableRow className="bg-gray-50">
        <TableHead className="text-left font-medium text-gray-700">Name</TableHead>
        <TableHead className="text-left font-medium text-gray-700">Status</TableHead>
        <TableHead className="text-left font-medium text-gray-700">Date</TableHead>
        <TableHead className="text-right font-medium text-gray-700">Actions</TableHead>
      </TableRow>
    </TableHeader>
    <TableBody>
      {data.map(item => (
        <TableRow key={item.id} className="hover:bg-gray-50">
          <TableCell className="font-medium">{item.name}</TableCell>
          <TableCell><StatusBadge status={item.status} /></TableCell>
          <TableCell className="text-gray-600">{item.date}</TableCell>
          <TableCell className="text-right">
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="sm">
                  <MoreHorizontal className="w-4 h-4" />
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end">
                <DropdownMenuItem>Edit</DropdownMenuItem>
                <DropdownMenuItem>Delete</DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </TableCell>
        </TableRow>
      ))}
    </TableBody>
  </Table>
</div>
```

### Empty States
```tsx
// Empty State Pattern
<div className="text-center py-12">
  <div className="w-16 h-16 mx-auto mb-4 bg-gray-100 rounded-full flex items-center justify-center">
    <Icon className="w-8 h-8 text-gray-400" />
  </div>
  <h3 className="text-lg font-medium text-gray-900 mb-2">No items found</h3>
  <p className="text-gray-600 mb-6">Get started by creating your first item.</p>
  <Button>Create New Item</Button>
</div>
```

### Loading States
```tsx
// Loading Skeleton Pattern
<div className="space-y-4">
  {[...Array(3)].map((_, i) => (
    <div key={i} className="bg-white rounded-lg border border-gray-200 p-6">
      <div className="animate-pulse">
        <div className="flex items-center justify-between mb-4">
          <div className="h-4 bg-gray-200 rounded w-1/4"></div>
          <div className="h-6 bg-gray-200 rounded w-16"></div>
        </div>
        <div className="space-y-2">
          <div className="h-3 bg-gray-200 rounded w-3/4"></div>
          <div className="h-3 bg-gray-200 rounded w-1/2"></div>
        </div>
      </div>
    </div>
  ))}
</div>
```

## Responsive Design Rules

### Breakpoints
```css
/* Tailwind Breakpoints */
sm: 640px   /* Small devices */
md: 768px   /* Medium devices */
lg: 1024px  /* Large devices */
xl: 1280px  /* Extra large devices */
2xl: 1536px /* 2X large devices */
```

### Responsive Patterns
```tsx
// Responsive Grid
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 lg:gap-6">

// Responsive Text
<h1 className="text-2xl sm:text-3xl lg:text-4xl font-bold">

// Responsive Spacing
<div className="p-4 lg:p-6 xl:p-8">

// Responsive Visibility
<div className="hidden lg:block">Desktop Only</div>
<div className="block lg:hidden">Mobile Only</div>
```

## Accessibility Guidelines

### Color Contrast
- All text must meet WCAG AA standards (4.5:1 ratio)
- Interactive elements must have clear focus states
- Use semantic colors consistently

### Focus Management
```tsx
// Focus Ring Pattern
<Button className="focus:outline-none focus:ring-2 focus:ring-primary-500 focus:ring-offset-2">
  Accessible Button
</Button>

// Focus Visible Only
<Link className="focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary-500">
  Accessible Link
</Link>
```

### Semantic HTML
```tsx
// Use proper heading hierarchy
<h1>Page Title</h1>
<h2>Section Title</h2>
<h3>Subsection Title</h3>

// Use semantic elements
<main>Main content</main>
<nav>Navigation</nav>
<aside>Sidebar content</aside>
<article>Article content</article>
```

## Animation Guidelines

### Transition Classes
```css
/* Standard Transitions */
transition-colors    /* Color changes */
transition-transform /* Transform changes */
transition-opacity   /* Opacity changes */
transition-shadow    /* Shadow changes */
transition-all       /* All properties */

/* Duration */
duration-150  /* 150ms - Fast */
duration-300  /* 300ms - Standard */
duration-500  /* 500ms - Slow */
```

### Animation Patterns
```tsx
// Hover Effects
<div className="hover:shadow-lg hover:scale-105 transition-all duration-300">

// Loading Spinner
<div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-500">

// Fade In
<div className="animate-fade-in opacity-0 animate-delay-300">
```

## Error Handling Patterns

### Form Validation
```tsx
// Field Error State
<div className="space-y-2">
  <Label className="text-sm font-medium text-gray-700">Email</Label>
  <Input
    className={cn(
      "w-full rounded-md",
      error ? "border-error-500 focus:border-error-500 focus:ring-error-500" : "border-gray-300"
    )}
  />
  {error && <p className="text-xs text-error-500">{error.message}</p>}
</div>
```

### Error Boundaries
```tsx
// Error State Display
<div className="text-center py-12">
  <div className="w-16 h-16 mx-auto mb-4 bg-error-50 rounded-full flex items-center justify-center">
    <AlertCircle className="w-8 h-8 text-error-500" />
  </div>
  <h3 className="text-lg font-medium text-gray-900 mb-2">Something went wrong</h3>
  <p className="text-gray-600 mb-6">Please try again or contact support if the problem persists.</p>
  <Button onClick={retry}>Try Again</Button>
</div>
```
