# Frontend Structure Plan

## Technology Stack
- **Framework**: Next.js 14+ (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS + shadcn/ui
- **Design System**: Custom design system (see design-system.md)
- **Development Standards**: Enforced via development-standards.md
- **State Management**: Zustand + TanStack Query
- **Forms**: React Hook Form + Zod
- **Charts**: Recharts
- **Authentication**: NextAuth.js
- **Deployment**: Vercel with automated CI/CD

## Design System Integration

### Component Hierarchy
All components must follow the design system patterns defined in `design-system.md`:

```typescript
// Standard component structure following development-standards.md
import React from 'react';
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import type { ComponentProps } from './ComponentName.types';

interface ComponentNameProps extends ComponentProps {
  className?: string;
}

export function ComponentName({ className, ...props }: ComponentNameProps) {
  return (
    <div className={cn("design-system-classes", className)} {...props}>
      {/* Component content following design patterns */}
    </div>
  );
}
```

### Design Token Usage
```typescript
// Use design tokens from design-system.md
const cardClasses = cn(
  "bg-white rounded-lg shadow-md border border-gray-200 p-6",
  "hover:shadow-lg transition-shadow",
  className
);

// Status indicators using semantic colors
const statusClasses = {
  active: "bg-success-50 text-success-600 border-success-200",
  pending: "bg-warning-50 text-warning-600 border-warning-200",
  inactive: "bg-error-50 text-error-600 border-error-200",
  draft: "bg-gray-50 text-gray-600 border-gray-200"
};
```

## Project Structure
```
src/
├── app/                           # Next.js App Router
│   ├── globals.css               # Global styles
│   ├── layout.tsx                # Root layout
│   ├── page.tsx                  # Landing page
│   ├── (auth)/                   # Auth route group
│   │   ├── login/
│   │   │   └── page.tsx
│   │   ├── register/
│   │   │   └── page.tsx
│   │   └── layout.tsx            # Auth layout
│   ├── dashboard/                # Main dashboard
│   │   ├── page.tsx              # Dashboard home
│   │   ├── layout.tsx            # Dashboard layout
│   │   ├── companies/
│   │   │   ├── page.tsx          # Companies list
│   │   │   ├── [id]/
│   │   │   │   ├── page.tsx      # Company details
│   │   │   │   ├── settings/
│   │   │   │   │   └── page.tsx
│   │   │   │   └── members/
│   │   │   │       └── page.tsx
│   │   │   └── new/
│   │   │       └── page.tsx      # Create company
│   │   ├── campaigns/
│   │   │   ├── page.tsx          # Campaigns list
│   │   │   ├── [id]/
│   │   │   │   ├── page.tsx      # Campaign details
│   │   │   │   └── projects/
│   │   │   │       ├── page.tsx  # Projects in campaign
│   │   │   │       └── [projectId]/
│   │   │   │           └── page.tsx
│   │   │   └── new/
│   │   │       └── page.tsx
│   │   ├── projects/
│   │   │   ├── page.tsx          # All projects view
│   │   │   ├── [id]/
│   │   │   │   ├── page.tsx      # Project dashboard
│   │   │   │   ├── tasks/
│   │   │   │   │   └── page.tsx
│   │   │   │   ├── goals/
│   │   │   │   │   └── page.tsx
│   │   │   │   ├── okrs/
│   │   │   │   │   └── page.tsx
│   │   │   │   └── kpis/
│   │   │   │       └── page.tsx
│   │   │   └── new/
│   │   │       └── page.tsx
│   │   ├── reports/
│   │   │   ├── page.tsx
│   │   │   ├── [id]/
│   │   │   │   └── page.tsx
│   │   │   └── new/
│   │   │       └── page.tsx
│   │   ├── contacts/
│   │   │   ├── page.tsx
│   │   │   ├── [id]/
│   │   │   │   └── page.tsx
│   │   │   └── new/
│   │   │       └── page.tsx
│   │   ├── leads/
│   │   │   ├── page.tsx
│   │   │   ├── [id]/
│   │   │   │   └── page.tsx
│   │   │   └── new/
│   │   │       └── page.tsx
│   │   └── messages/
│   │       ├── page.tsx
│   │       └── [id]/
│   │           └── page.tsx
│   └── api/                      # API routes (if needed)
│       └── auth/
│           └── [...nextauth]/
│               └── route.ts
├── components/
│   ├── ui/                       # shadcn/ui base components
│   │   ├── button.tsx
│   │   ├── input.tsx
│   │   ├── card.tsx
│   │   ├── dialog.tsx
│   │   ├── dropdown-menu.tsx
│   │   ├── table.tsx
│   │   ├── tabs.tsx
│   │   ├── badge.tsx
│   │   ├── progress.tsx
│   │   └── ...
│   ├── layout/                   # Layout components
│   │   ├── header.tsx
│   │   ├── sidebar.tsx
│   │   ├── breadcrumb.tsx
│   │   ├── company-switcher.tsx
│   │   └── user-menu.tsx
│   ├── forms/                    # Reusable form components
│   │   ├── company-form.tsx
│   │   ├── campaign-form.tsx
│   │   ├── project-form.tsx
│   │   ├── task-form.tsx
│   │   ├── goal-form.tsx
│   │   ├── contact-form.tsx
│   │   └── lead-form.tsx
│   ├── charts/                   # Chart components
│   │   ├── progress-chart.tsx
│   │   ├── kpi-chart.tsx
│   │   ├── budget-chart.tsx
│   │   └── timeline-chart.tsx
│   ├── data-tables/              # Data table components
│   │   ├── campaigns-table.tsx
│   │   ├── projects-table.tsx
│   │   ├── tasks-table.tsx
│   │   ├── contacts-table.tsx
│   │   └── leads-table.tsx
│   └── features/                 # Feature-specific components
│       ├── auth/
│       │   ├── login-form.tsx
│       │   ├── register-form.tsx
│       │   └── auth-guard.tsx
│       ├── dashboard/
│       │   ├── stats-cards.tsx
│       │   ├── recent-activity.tsx
│       │   └── quick-actions.tsx
│       ├── companies/
│       │   ├── company-card.tsx
│       │   ├── company-settings.tsx
│       │   └── member-management.tsx
│       ├── campaigns/
│       │   ├── campaign-card.tsx
│       │   ├── campaign-stats.tsx
│       │   └── campaign-timeline.tsx
│       ├── projects/
│       │   ├── project-card.tsx
│       │   ├── project-kanban.tsx
│       │   ├── project-timeline.tsx
│       │   └── project-stats.tsx
│       ├── tasks/
│       │   ├── task-list.tsx
│       │   ├── task-card.tsx
│       │   ├── task-filters.tsx
│       │   └── task-calendar.tsx
│       ├── goals/
│       │   ├── goal-card.tsx
│       │   ├── goal-progress.tsx
│       │   └── goal-tracker.tsx
│       ├── okrs/
│       │   ├── objective-card.tsx
│       │   ├── key-result-item.tsx
│       │   └── okr-dashboard.tsx
│       ├── kpis/
│       │   ├── kpi-card.tsx
│       │   ├── kpi-chart.tsx
│       │   └── kpi-dashboard.tsx
│       ├── reports/
│       │   ├── report-builder.tsx
│       │   ├── report-viewer.tsx
│       │   └── report-export.tsx
│       ├── contacts/
│       │   ├── contact-card.tsx
│       │   ├── contact-details.tsx
│       │   └── contact-import.tsx
│       ├── leads/
│       │   ├── lead-card.tsx
│       │   ├── lead-pipeline.tsx
│       │   └── lead-conversion.tsx
│       └── messages/
│           ├── message-list.tsx
│           ├── message-composer.tsx
│           └── message-thread.tsx
├── lib/
│   ├── api/                      # API client functions
│   │   ├── client.ts             # Base API client
│   │   ├── auth.ts               # Auth API calls
│   │   ├── companies.ts          # Company API calls
│   │   ├── campaigns.ts          # Campaign API calls
│   │   ├── projects.ts           # Project API calls
│   │   ├── tasks.ts              # Task API calls
│   │   ├── goals.ts              # Goal API calls
│   │   ├── okrs.ts               # OKR API calls
│   │   ├── kpis.ts               # KPI API calls
│   │   ├── reports.ts            # Report API calls
│   │   ├── contacts.ts           # Contact API calls
│   │   ├── leads.ts              # Lead API calls
│   │   └── messages.ts           # Message API calls
│   ├── auth/                     # Authentication utilities
│   │   ├── config.ts             # NextAuth config
│   │   ├── providers.ts          # Auth providers
│   │   └── middleware.ts         # Auth middleware
│   ├── utils/                    # General utilities
│   │   ├── cn.ts                 # Class name utility
│   │   ├── format.ts             # Formatting utilities
│   │   ├── date.ts               # Date utilities
│   │   ├── currency.ts           # Currency formatting
│   │   └── permissions.ts        # Permission checking
│   ├── validations/              # Zod schemas
│   │   ├── auth.ts               # Auth validation schemas
│   │   ├── company.ts            # Company validation schemas
│   │   ├── campaign.ts           # Campaign validation schemas
│   │   ├── project.ts            # Project validation schemas
│   │   ├── task.ts               # Task validation schemas
│   │   ├── goal.ts               # Goal validation schemas
│   │   ├── contact.ts            # Contact validation schemas
│   │   └── lead.ts               # Lead validation schemas
│   └── constants/                # App constants
│       ├── routes.ts             # Route constants
│       ├── permissions.ts        # Permission constants
│       └── status.ts             # Status constants
├── hooks/                        # Custom React hooks
│   ├── use-auth.ts               # Authentication hook
│   ├── use-company.ts            # Company context hook
│   ├── use-permissions.ts        # Permission checking hook
│   ├── use-debounce.ts           # Debounce hook
│   ├── use-local-storage.ts      # Local storage hook
│   └── use-websocket.ts          # WebSocket hook
├── stores/                       # Zustand stores
│   ├── auth-store.ts             # Authentication state
│   ├── company-store.ts          # Current company state
│   ├── ui-store.ts               # UI state (sidebar, modals)
│   └── notification-store.ts     # Notification state
├── types/                        # TypeScript type definitions
│   ├── auth.ts                   # Auth types
│   ├── company.ts                # Company types
│   ├── campaign.ts               # Campaign types
│   ├── project.ts                # Project types
│   ├── task.ts                   # Task types
│   ├── goal.ts                   # Goal types
│   ├── okr.ts                    # OKR types
│   ├── kpi.ts                    # KPI types
│   ├── report.ts                 # Report types
│   ├── contact.ts                # Contact types
│   ├── lead.ts                   # Lead types
│   ├── message.ts                # Message types
│   └── api.ts                    # API response types
└── middleware.ts                 # Next.js middleware
```

## Key Features Implementation

### 1. Multi-tenant Architecture
- Company switcher in header following design-system.md navigation patterns
- All data scoped by selected company using Zustand store
- Role-based access control with consistent UI patterns
- Company-specific settings using design system form patterns

### 2. Design System Enforcement
- **Component Validation**: All components use design-system.md patterns
- **Type Safety**: Full TypeScript coverage following development-standards.md
- **Consistent Styling**: Tailwind classes from design token system
- **AI-Friendly Structure**: Clear naming conventions for AI assistance

### 3. Development Workflow Integration
- **Pre-commit Hooks**: Validate design system compliance
- **ESLint Rules**: Enforce coding standards and design patterns
- **Automated Testing**: Component tests validate design system usage
- **Vercel Deployment**: Automated deployment with quality checks

### 2. Hierarchical Navigation
- Breadcrumb navigation
- Contextual sidebar based on current level
- Deep linking support
- Back navigation preservation

### 3. Real-time Updates
- WebSocket integration for live data
- Optimistic updates
- Real-time notifications
- Live collaboration features

### 4. Advanced Data Tables
- Server-side pagination
- Multi-column sorting
- Advanced filtering
- Export functionality
- Bulk actions

### 5. Dashboard Analytics
- Interactive charts and graphs
- KPI tracking
- Progress visualization
- Custom report generation

### 6. Responsive Design
- Mobile-first approach
- Adaptive layouts
- Touch-friendly interactions
- Progressive web app features

This structure provides a scalable foundation for the multi-tenant business management platform with clear separation of concerns and reusable components.
