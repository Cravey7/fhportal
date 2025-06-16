# FH Portal Development Standards

## Overview
This document defines coding conventions, file structure, naming patterns, and enforcement rules for the FH Portal project. These standards are designed to be AI-friendly and enforceable through tooling.

## AI Assistant Guidelines
When working with this codebase:
- Follow these exact naming conventions and patterns
- Use the provided file structure templates
- Validate code against these standards before committing
- Ask for clarification if a pattern doesn't exist
- Always use TypeScript with strict mode enabled

## File Structure & Organization

### Directory Naming
```
kebab-case for all directories
✅ user-management/
✅ api-routes/
✅ data-tables/
❌ userManagement/
❌ ApiRoutes/
❌ data_tables/
```

### File Naming Conventions
```typescript
// Components: PascalCase
UserProfile.tsx
CompanyCard.tsx
CampaignForm.tsx

// Hooks: camelCase starting with 'use'
useCompanies.ts
useAuth.ts
useLocalStorage.ts

// Utilities: camelCase
formatDate.ts
apiClient.ts
validation.ts

// Types: camelCase with .types.ts suffix
user.types.ts
company.types.ts
api.types.ts

// Constants: SCREAMING_SNAKE_CASE
API_ENDPOINTS.ts
DEFAULT_VALUES.ts
ERROR_MESSAGES.ts
```

### Component File Structure
```typescript
// Standard component file structure
import React from 'react';
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import type { ComponentProps } from './ComponentName.types';

interface ComponentNameProps extends ComponentProps {
  // Component-specific props
}

export function ComponentName({ 
  prop1, 
  prop2, 
  className,
  ...props 
}: ComponentNameProps) {
  return (
    <div className={cn("default-classes", className)} {...props}>
      {/* Component content */}
    </div>
  );
}

// Named export (preferred)
export { ComponentName };

// Default export only for pages
export default ComponentName;
```

## TypeScript Standards

### Type Definitions
```typescript
// Use interfaces for object shapes
interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  createdAt: Date;
}

// Use types for unions, primitives, and computed types
type Status = 'active' | 'inactive' | 'pending';
type UserWithCompany = User & { company: Company };

// Use enums for constants with semantic meaning
enum UserRole {
  ADMIN = 'admin',
  MANAGER = 'manager',
  USER = 'user'
}
```

### Function Signatures
```typescript
// Prefer function declarations for components
function UserCard({ user, onEdit }: UserCardProps) {
  // Component logic
}

// Use arrow functions for utilities and handlers
const formatUserName = (user: User): string => {
  return `${user.firstName} ${user.lastName}`;
};

// Async functions should always return Promise<T>
async function fetchUser(id: string): Promise<User> {
  // Fetch logic
}
```

### Error Handling
```typescript
// Use Result pattern for operations that can fail
type Result<T, E = Error> = 
  | { success: true; data: T }
  | { success: false; error: E };

// Example usage
async function createUser(userData: CreateUserData): Promise<Result<User>> {
  try {
    const user = await api.users.create(userData);
    return { success: true, data: user };
  } catch (error) {
    return { success: false, error: error as Error };
  }
}
```

## React Patterns

### Component Patterns
```typescript
// Use composition over inheritance
interface CardProps {
  children: React.ReactNode;
  className?: string;
}

function Card({ children, className }: CardProps) {
  return (
    <div className={cn("card-base-styles", className)}>
      {children}
    </div>
  );
}

// Compound components for complex UI
Card.Header = function CardHeader({ children }: { children: React.ReactNode }) {
  return <div className="card-header-styles">{children}</div>;
};

Card.Content = function CardContent({ children }: { children: React.ReactNode }) {
  return <div className="card-content-styles">{children}</div>;
};
```

### Hook Patterns
```typescript
// Custom hooks should start with 'use'
function useCompanies() {
  const [companies, setCompanies] = useState<Company[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  // Hook logic

  return { companies, loading, error, refetch };
}

// Use React Query for server state
function useCompany(id: string) {
  return useQuery({
    queryKey: ['company', id],
    queryFn: () => api.companies.getById(id),
    enabled: !!id,
  });
}
```

### State Management
```typescript
// Use Zustand for global state
interface AppState {
  currentCompany: Company | null;
  user: User | null;
  setCurrentCompany: (company: Company) => void;
  setUser: (user: User) => void;
}

export const useAppStore = create<AppState>((set) => ({
  currentCompany: null,
  user: null,
  setCurrentCompany: (company) => set({ currentCompany: company }),
  setUser: (user) => set({ user }),
}));
```

## API Standards

### API Route Structure
```typescript
// app/api/companies/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { auth } from '@/lib/auth';
import { db } from '@/lib/database';

const CreateCompanySchema = z.object({
  name: z.string().min(1),
  description: z.string().optional(),
});

export async function GET(request: NextRequest) {
  try {
    const session = await auth();
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const companies = await db.companies.findMany({
      where: { userId: session.user.id },
    });

    return NextResponse.json({ data: companies });
  } catch (error) {
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const session = await auth();
    if (!session) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await request.json();
    const validatedData = CreateCompanySchema.parse(body);

    const company = await db.companies.create({
      data: {
        ...validatedData,
        userId: session.user.id,
      },
    });

    return NextResponse.json({ data: company }, { status: 201 });
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation error', details: error.errors },
        { status: 400 }
      );
    }

    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

### API Response Format
```typescript
// Standard API response types
interface ApiResponse<T> {
  data?: T;
  error?: string;
  message?: string;
}

interface PaginatedResponse<T> extends ApiResponse<T[]> {
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

// Example responses
// Success: { data: [...] }
// Error: { error: "Error message" }
// Validation Error: { error: "Validation error", details: [...] }
```

## Database Standards

### Supabase Integration
```typescript
// lib/supabase.ts
import { createClient } from '@supabase/supabase-js';
import type { Database } from '@/types/database.types';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient<Database>(supabaseUrl, supabaseKey);

// Server-side client with service role
export const supabaseAdmin = createClient<Database>(
  supabaseUrl,
  process.env.SUPABASE_SERVICE_ROLE_KEY!
);
```

### Query Patterns
```typescript
// Use type-safe queries
async function getCompanies(userId: string): Promise<Company[]> {
  const { data, error } = await supabase
    .from('companies')
    .select('*')
    .eq('user_id', userId)
    .order('created_at', { ascending: false });

  if (error) throw error;
  return data || [];
}

// Use RLS policies for security
// Enable RLS on all tables
// Create policies for each user role
```

## Testing Standards

### Unit Testing
```typescript
// Component testing with React Testing Library
import { render, screen, fireEvent } from '@testing-library/react';
import { UserCard } from './UserCard';

describe('UserCard', () => {
  const mockUser = {
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    email: 'john@example.com',
  };

  it('renders user information correctly', () => {
    render(<UserCard user={mockUser} />);
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  it('calls onEdit when edit button is clicked', () => {
    const onEdit = jest.fn();
    render(<UserCard user={mockUser} onEdit={onEdit} />);
    
    fireEvent.click(screen.getByRole('button', { name: /edit/i }));
    expect(onEdit).toHaveBeenCalledWith(mockUser);
  });
});
```

### API Testing
```typescript
// API route testing
import { GET, POST } from '@/app/api/companies/route';
import { NextRequest } from 'next/server';

describe('/api/companies', () => {
  it('returns companies for authenticated user', async () => {
    const request = new NextRequest('http://localhost:3000/api/companies');
    const response = await GET(request);
    const data = await response.json();

    expect(response.status).toBe(200);
    expect(data.data).toBeInstanceOf(Array);
  });
});
```
