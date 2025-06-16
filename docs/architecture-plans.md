# FH Portal - Architecture Plans

## Project Overview
Based on brainstorm.md, this is a hierarchical business management system with the following entity structure:
- Users → Companies → Campaigns → Projects → Tasks/Goals/Actions/OKRs → KPIs
- Additional entities: Reports, Messages, Contacts, Leads

## 1. Frontend Architecture Plan

### Technology Stack
- **Framework**: Next.js 14+ (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS + shadcn/ui components
- **Design System**: Custom design system with AI-friendly patterns
- **State Management**: Zustand + React Query (TanStack Query)
- **Forms**: React Hook Form + Zod validation
- **Charts/Analytics**: Recharts or Chart.js
- **Authentication**: NextAuth.js
- **Deployment**: Vercel with automated CI/CD

### Component Architecture
```
src/
├── app/                    # Next.js App Router
│   ├── (auth)/            # Auth routes
│   ├── dashboard/         # Main dashboard
│   ├── companies/         # Company management
│   ├── campaigns/         # Campaign management
│   └── projects/          # Project management
├── components/
│   ├── ui/               # shadcn/ui base components
│   ├── forms/            # Reusable form components
│   ├── charts/           # Chart components
│   ├── layout/           # Layout components
│   └── features/         # Feature-specific components
│       ├── companies/
│       ├── campaigns/
│       ├── projects/
│       ├── tasks/
│       └── reports/
├── lib/
│   ├── api/              # API client functions
│   ├── auth/             # Authentication utilities
│   ├── utils/            # General utilities
│   └── validations/      # Zod schemas
├── hooks/                # Custom React hooks
├── stores/               # Zustand stores
└── types/                # TypeScript type definitions
```

### Key Features
- **Multi-tenant Dashboard**: Company-scoped views
- **Hierarchical Navigation**: Breadcrumb navigation through entity hierarchy
- **Real-time Updates**: WebSocket integration for live data
- **Responsive Design**: Mobile-first approach
- **Role-based UI**: Different views based on user permissions
- **Advanced Filtering**: Multi-level filtering and search
- **Data Visualization**: Charts and analytics for KPIs and reports

### State Management Strategy
- **Global State**: User authentication, current company context
- **Server State**: React Query for API data caching and synchronization
- **Local State**: Component-specific state with useState/useReducer
- **Form State**: React Hook Form for complex forms

## 2. Backend Architecture Plan

### Technology Stack
- **Runtime**: Node.js with Express.js or Fastify
- **Language**: TypeScript
- **Database**: PostgreSQL with Prisma ORM
- **Authentication**: JWT tokens + refresh tokens
- **Validation**: Zod schemas
- **API Documentation**: OpenAPI/Swagger
- **Real-time**: Socket.io for WebSocket connections
- **File Storage**: AWS S3 or similar
- **Caching**: Redis

### API Architecture
```
src/
├── routes/
│   ├── auth/             # Authentication endpoints
│   ├── users/            # User management
│   ├── companies/        # Company CRUD
│   ├── campaigns/        # Campaign CRUD
│   ├── projects/         # Project CRUD
│   ├── tasks/            # Task management
│   ├── reports/          # Reporting endpoints
│   ├── messages/         # Messaging system
│   ├── contacts/         # Contact management
│   └── leads/            # Lead management
├── middleware/
│   ├── auth.ts           # Authentication middleware
│   ├── validation.ts     # Request validation
│   ├── rateLimit.ts      # Rate limiting
│   └── errorHandler.ts   # Error handling
├── services/
│   ├── authService.ts    # Authentication logic
│   ├── userService.ts    # User business logic
│   ├── companyService.ts # Company business logic
│   └── ...               # Other service layers
├── models/               # Database models (Prisma)
├── utils/
│   ├── database.ts       # Database connection
│   ├── logger.ts         # Logging utility
│   └── validators.ts     # Validation schemas
└── types/                # TypeScript interfaces
```

### API Design Principles
- **RESTful Design**: Standard HTTP methods and status codes
- **Hierarchical Routes**: `/companies/:id/campaigns/:id/projects/:id`
- **Consistent Response Format**: Standardized JSON responses
- **Pagination**: Cursor-based pagination for large datasets
- **Filtering & Sorting**: Query parameter-based filtering
- **Versioning**: API versioning strategy (/api/v1/)

### Authentication & Authorization
- **Multi-tenant Security**: Company-scoped data access
- **Role-based Access Control (RBAC)**: Admin, Manager, User roles
- **JWT Strategy**: Access tokens (15min) + Refresh tokens (7 days)
- **Permission System**: Granular permissions for different actions
- **Company Isolation**: Strict data isolation between companies

### Key Endpoints Structure
```
POST   /api/v1/auth/login
POST   /api/v1/auth/register
POST   /api/v1/auth/refresh

GET    /api/v1/companies
POST   /api/v1/companies
GET    /api/v1/companies/:id/campaigns
POST   /api/v1/companies/:id/campaigns
GET    /api/v1/companies/:id/campaigns/:id/projects
POST   /api/v1/companies/:id/campaigns/:id/projects
GET    /api/v1/projects/:id/tasks
GET    /api/v1/projects/:id/goals
GET    /api/v1/projects/:id/okrs
```

## 3. Data Architecture Plan

### Database Schema Design

#### Core Entities
```sql
-- Users table
users (
  id UUID PRIMARY KEY,
  email VARCHAR UNIQUE NOT NULL,
  password_hash VARCHAR NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  avatar_url VARCHAR,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Companies table (Multi-tenant)
companies (
  id UUID PRIMARY KEY,
  name VARCHAR NOT NULL,
  slug VARCHAR UNIQUE NOT NULL,
  description TEXT,
  logo_url VARCHAR,
  settings JSONB DEFAULT '{}',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- User-Company relationships
user_companies (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  role VARCHAR NOT NULL DEFAULT 'user', -- admin, manager, user
  permissions JSONB DEFAULT '{}',
  joined_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, company_id)
);

-- Campaigns
campaigns (
  id UUID PRIMARY KEY,
  company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  description TEXT,
  status VARCHAR DEFAULT 'active', -- active, paused, completed
  start_date DATE,
  end_date DATE,
  budget DECIMAL(12,2),
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Projects
projects (
  id UUID PRIMARY KEY,
  campaign_id UUID REFERENCES campaigns(id) ON DELETE CASCADE,
  name VARCHAR NOT NULL,
  description TEXT,
  status VARCHAR DEFAULT 'planning', -- planning, active, completed, cancelled
  priority VARCHAR DEFAULT 'medium', -- low, medium, high, critical
  start_date DATE,
  end_date DATE,
  budget DECIMAL(12,2),
  progress INTEGER DEFAULT 0, -- 0-100
  created_by UUID REFERENCES users(id),
  assigned_to UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

### Indexing Strategy
```sql
-- Performance indexes
CREATE INDEX idx_user_companies_user_id ON user_companies(user_id);
CREATE INDEX idx_user_companies_company_id ON user_companies(company_id);
CREATE INDEX idx_campaigns_company_id ON campaigns(company_id);
CREATE INDEX idx_projects_campaign_id ON projects(campaign_id);
CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_companies_slug ON companies(slug);

-- Composite indexes for common queries
CREATE INDEX idx_projects_status_priority ON projects(status, priority);
CREATE INDEX idx_tasks_assignee_status ON tasks(assigned_to, status);
```

### Data Access Patterns
- **Hierarchical Queries**: Efficient traversal of company → campaign → project → task hierarchy
- **Multi-tenant Isolation**: All queries scoped by company_id
- **Soft Deletes**: Implement deleted_at timestamps for audit trails
- **Audit Logging**: Track all changes with created_by, updated_by fields
- **Optimistic Locking**: Version fields for concurrent update handling

### Caching Strategy
- **Redis Layers**:
  - Session storage (user authentication)
  - Frequently accessed company settings
  - Dashboard aggregation data
  - Real-time notification queues
- **Database Query Caching**: Cache expensive aggregation queries
- **CDN**: Static assets and file uploads

## 4. Design System Integration

### Design System Enforcement
- **Automated Linting**: ESLint rules for design system compliance
- **Pre-commit Hooks**: Validate design patterns before commits
- **Component Library**: Centralized shadcn/ui components with custom extensions
- **AI-Friendly Patterns**: Consistent naming and structure for AI assistance

### Design Token Management
```typescript
// Design tokens are enforced through Tailwind configuration
// All colors, spacing, typography defined in design-system.md
// Custom CSS properties for semantic colors and spacing
```

### Component Standards
- **Consistent Patterns**: All components follow design-system.md patterns
- **Type Safety**: Full TypeScript coverage with strict mode
- **Accessibility**: WCAG AA compliance enforced through linting
- **Responsive Design**: Mobile-first approach with consistent breakpoints

### Development Workflow Integration
- **Vercel Deployment**: Automated deployment with design system validation
- **Supabase Integration**: Type-safe database operations with generated types
- **Error Boundaries**: Consistent error handling patterns across the application
- **Performance Monitoring**: Built-in performance tracking and optimization

### Quality Assurance
- **Design System Tests**: Automated testing of component patterns
- **Visual Regression Testing**: Ensure design consistency across updates
- **Performance Budgets**: Enforce performance standards in CI/CD
- **Accessibility Testing**: Automated a11y testing in deployment pipeline

This architecture provides a solid foundation for a scalable, multi-tenant business management platform with clear separation of concerns, enforced design standards, and room for future growth.
