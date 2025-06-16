# Database Refactoring Plan for FH Portal MVP

## Overview
This plan outlines the step-by-step process to refactor the existing Frontend Horizon database to align with our MVP documentation while preserving valuable existing infrastructure.

## Refactoring Strategy

### Phase 1: Schema Harmonization (Days 1-3)

#### Day 1: ID Type Standardization
**Objective**: Convert all bigint IDs to UUID for consistency

```sql
-- Step 1: Add new UUID columns to existing tables
ALTER TABLE companies ADD COLUMN temp_uuid_id UUID DEFAULT uuid_generate_v4();
ALTER TABLE team_members ADD COLUMN temp_uuid_id UUID DEFAULT uuid_generate_v4();
ALTER TABLE fh_projects ADD COLUMN temp_uuid_id UUID DEFAULT uuid_generate_v4();
ALTER TABLE fh_tasks ADD COLUMN temp_uuid_id UUID DEFAULT uuid_generate_v4();

-- Step 2: Create mapping tables for migration
CREATE TABLE id_mappings (
    table_name VARCHAR(50),
    old_id BIGINT,
    new_id UUID,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Step 3: Populate mapping tables
INSERT INTO id_mappings (table_name, old_id, new_id)
SELECT 'companies', id, temp_uuid_id FROM companies;

INSERT INTO id_mappings (table_name, old_id, new_id)
SELECT 'team_members', id, temp_uuid_id FROM team_members;

INSERT INTO id_mappings (table_name, old_id, new_id)
SELECT 'fh_projects', id, temp_uuid_id FROM fh_projects;

INSERT INTO id_mappings (table_name, old_id, new_id)
SELECT 'fh_tasks', id, temp_uuid_id FROM fh_tasks;
```

#### Day 2: Foreign Key Updates
**Objective**: Update all foreign key references to use UUIDs

```sql
-- Update projects table company_id reference
ALTER TABLE projects ADD COLUMN temp_company_uuid UUID;
UPDATE projects SET temp_company_uuid = (
    SELECT new_id FROM id_mappings 
    WHERE table_name = 'companies' AND old_id = projects.company_id
);

-- Update fh_tasks project_id reference
ALTER TABLE fh_tasks ADD COLUMN temp_project_uuid UUID;
UPDATE fh_tasks SET temp_project_uuid = (
    SELECT new_id FROM id_mappings 
    WHERE table_name = 'fh_projects' AND old_id = fh_tasks.project_id
);

-- Update calendar_events references
ALTER TABLE calendar_events ADD COLUMN temp_company_uuid UUID;
ALTER TABLE calendar_events ADD COLUMN temp_project_uuid UUID;
ALTER TABLE calendar_events ADD COLUMN temp_task_uuid UUID;
ALTER TABLE calendar_events ADD COLUMN temp_assigned_uuid UUID;

UPDATE calendar_events SET 
    temp_company_uuid = (SELECT new_id FROM id_mappings WHERE table_name = 'companies' AND old_id = calendar_events.company_id),
    temp_project_uuid = (SELECT new_id FROM id_mappings WHERE table_name = 'fh_projects' AND old_id = calendar_events.project_id),
    temp_task_uuid = (SELECT new_id FROM id_mappings WHERE table_name = 'fh_tasks' AND old_id = calendar_events.task_id),
    temp_assigned_uuid = (SELECT new_id FROM id_mappings WHERE table_name = 'team_members' AND old_id = calendar_events.assigned_to);

-- Update contacts table
ALTER TABLE contacts ADD COLUMN temp_company_uuid UUID;
UPDATE contacts SET temp_company_uuid = (
    SELECT new_id FROM id_mappings 
    WHERE table_name = 'companies' AND old_id = contacts.company_id
);
```

#### Day 3: Table Consolidation
**Objective**: Merge fh_projects into projects table

```sql
-- Add missing columns to projects table for fh_projects compatibility
ALTER TABLE projects ADD COLUMN IF NOT EXISTS end_date DATE;
ALTER TABLE projects ADD COLUMN IF NOT EXISTS progress_percentage INTEGER DEFAULT 0;

-- Migrate data from fh_projects to projects
INSERT INTO projects (
    id, name, description, status, start_date, end_date, budget, 
    company_id, created_at, updated_at, project_type
)
SELECT 
    temp_uuid_id, name, description, status, start_date, end_date, budget,
    (SELECT new_id FROM id_mappings WHERE table_name = 'companies' AND old_id = fh_projects.company_id),
    created_at, updated_at, 'migrated'
FROM fh_projects
WHERE temp_uuid_id NOT IN (SELECT id FROM projects);

-- Update fh_tasks to reference projects instead of fh_projects
UPDATE fh_tasks SET temp_project_uuid = (
    SELECT id FROM projects p 
    JOIN id_mappings im ON p.id = im.new_id 
    WHERE im.table_name = 'fh_projects' AND im.old_id = fh_tasks.project_id
);
```

### Phase 2: Add Missing MVP Tables (Days 4-5)

#### Day 4: Create Core MVP Tables
**Objective**: Add campaigns, goals, actions, and user_companies tables

```sql
-- Create campaigns table
CREATE TABLE campaigns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'paused', 'completed', 'cancelled')),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    actual_spend DECIMAL(12,2) DEFAULT 0,
    target_revenue DECIMAL(12,2),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT fk_campaigns_company FOREIGN KEY (company_id) REFERENCES companies(temp_uuid_id),
    CONSTRAINT fk_campaigns_created_by FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Create goals table
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID,
    campaign_id UUID,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    goal_type VARCHAR(50) DEFAULT 'metric' CHECK (goal_type IN ('metric', 'milestone', 'revenue', 'completion')),
    target_value DECIMAL(12,2),
    current_value DECIMAL(12,2) DEFAULT 0,
    unit VARCHAR(50),
    due_date DATE,
    status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'completed', 'cancelled', 'on_hold')),
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    created_by UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT fk_goals_project FOREIGN KEY (project_id) REFERENCES projects(id),
    CONSTRAINT fk_goals_campaign FOREIGN KEY (campaign_id) REFERENCES campaigns(id),
    CONSTRAINT fk_goals_created_by FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Create actions table
CREATE TABLE actions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID,
    task_id UUID,
    goal_id UUID,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    action_type VARCHAR(50) DEFAULT 'task' CHECK (action_type IN ('task', 'email', 'call', 'meeting', 'follow_up', 'research')),
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled', 'blocked')),
    priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'critical')),
    due_date TIMESTAMP WITH TIME ZONE,
    completed_date TIMESTAMP WITH TIME ZONE,
    assigned_to UUID,
    created_by UUID,
    estimated_hours DECIMAL(5,2),
    actual_hours DECIMAL(5,2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT fk_actions_project FOREIGN KEY (project_id) REFERENCES projects(id),
    CONSTRAINT fk_actions_task FOREIGN KEY (task_id) REFERENCES fh_tasks(temp_uuid_id),
    CONSTRAINT fk_actions_goal FOREIGN KEY (goal_id) REFERENCES goals(id),
    CONSTRAINT fk_actions_assigned_to FOREIGN KEY (assigned_to) REFERENCES users(id),
    CONSTRAINT fk_actions_created_by FOREIGN KEY (created_by) REFERENCES users(id)
);

-- Create user_companies junction table for multi-tenancy
CREATE TABLE user_companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    company_id UUID NOT NULL,
    role VARCHAR(50) DEFAULT 'user' CHECK (role IN ('owner', 'admin', 'manager', 'user', 'viewer')),
    permissions JSONB DEFAULT '[]',
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending')),
    invited_by UUID,
    invited_at TIMESTAMP WITH TIME ZONE,
    joined_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT fk_user_companies_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_companies_company FOREIGN KEY (company_id) REFERENCES companies(temp_uuid_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_companies_invited_by FOREIGN KEY (invited_by) REFERENCES users(id),
    UNIQUE(user_id, company_id)
);
```

#### Day 5: Establish MVP Hierarchy
**Objective**: Create campaign-project relationships and populate default data

```sql
-- Add campaign_id to projects table
ALTER TABLE projects ADD COLUMN campaign_id UUID;
ALTER TABLE projects ADD CONSTRAINT fk_projects_campaign 
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id);

-- Create default campaigns for existing projects
INSERT INTO campaigns (company_id, name, description, status, created_by)
SELECT DISTINCT 
    temp_company_uuid,
    'Default Campaign - ' || c.name,
    'Auto-created campaign for existing projects',
    'active',
    (SELECT id FROM users LIMIT 1)
FROM projects p
JOIN companies c ON c.temp_uuid_id = p.temp_company_uuid
WHERE p.temp_company_uuid IS NOT NULL;

-- Link existing projects to campaigns
UPDATE projects SET campaign_id = (
    SELECT camp.id 
    FROM campaigns camp 
    WHERE camp.company_id = projects.temp_company_uuid 
    LIMIT 1
) WHERE temp_company_uuid IS NOT NULL;

-- Populate user_companies for existing team members
INSERT INTO user_companies (user_id, company_id, role, status)
SELECT DISTINCT 
    tm.user_id,
    c.temp_uuid_id,
    CASE 
        WHEN tm.role = 'admin' THEN 'admin'
        WHEN tm.role = 'manager' THEN 'manager'
        ELSE 'user'
    END,
    'active'
FROM team_members tm
JOIN companies c ON c.id = (
    SELECT company_id FROM contacts ct WHERE ct.id = tm.id LIMIT 1
)
WHERE tm.user_id IS NOT NULL
ON CONFLICT (user_id, company_id) DO NOTHING;
```

### Phase 3: Security Implementation (Days 6-7)

#### Day 6: Enable RLS
**Objective**: Enable Row Level Security on all core tables

```sql
-- Enable RLS on core tables
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE actions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;

-- Enable RLS on existing tables that don't have it
ALTER TABLE fh_tasks ENABLE ROW LEVEL SECURITY;
```

#### Day 7: Create RLS Policies
**Objective**: Implement comprehensive RLS policies

```sql
-- Companies policies
CREATE POLICY "Users can view companies they belong to" ON companies
    FOR SELECT USING (
        temp_uuid_id IN (SELECT company_id FROM user_companies WHERE user_id = auth.uid())
    );

CREATE POLICY "Company admins can update companies" ON companies
    FOR UPDATE USING (
        temp_uuid_id IN (
            SELECT company_id FROM user_companies 
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
        )
    );

-- Campaigns policies
CREATE POLICY "Users can view campaigns in their companies" ON campaigns
    FOR SELECT USING (
        company_id IN (SELECT company_id FROM user_companies WHERE user_id = auth.uid())
    );

CREATE POLICY "Managers can manage campaigns" ON campaigns
    FOR ALL USING (
        company_id IN (
            SELECT company_id FROM user_companies 
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'manager')
        )
    );

-- Projects policies
CREATE POLICY "Users can view projects in their companies" ON projects
    FOR SELECT USING (
        temp_company_uuid IN (SELECT company_id FROM user_companies WHERE user_id = auth.uid())
    );

CREATE POLICY "Project members can update projects" ON projects
    FOR UPDATE USING (
        id IN (
            SELECT project_id FROM project_team_members ptm
            WHERE ptm.user_id = auth.uid()
        ) OR
        temp_company_uuid IN (
            SELECT company_id FROM user_companies 
            WHERE user_id = auth.uid() AND role IN ('owner', 'admin', 'manager')
        )
    );

-- Goals policies
CREATE POLICY "Users can view goals in their projects" ON goals
    FOR SELECT USING (
        project_id IN (
            SELECT p.id FROM projects p
            WHERE p.temp_company_uuid IN (
                SELECT company_id FROM user_companies WHERE user_id = auth.uid()
            )
        ) OR
        campaign_id IN (
            SELECT c.id FROM campaigns c
            WHERE c.company_id IN (
                SELECT company_id FROM user_companies WHERE user_id = auth.uid()
            )
        )
    );

-- Actions policies
CREATE POLICY "Users can view actions in their projects" ON actions
    FOR SELECT USING (
        project_id IN (
            SELECT p.id FROM projects p
            WHERE p.temp_company_uuid IN (
                SELECT company_id FROM user_companies WHERE user_id = auth.uid()
            )
        ) OR
        assigned_to = auth.uid()
    );

-- User companies policies
CREATE POLICY "Users can view their company memberships" ON user_companies
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Company owners can manage memberships" ON user_companies
    FOR ALL USING (
        company_id IN (
            SELECT company_id FROM user_companies 
            WHERE user_id = auth.uid() AND role = 'owner'
        )
    );
```

### Phase 4: Cleanup and Optimization (Days 8-10)

#### Day 8: Column Cleanup
**Objective**: Remove old columns and rename temporary ones

```sql
-- Drop old bigint ID columns and rename UUID columns
-- Companies table
ALTER TABLE companies DROP COLUMN id CASCADE;
ALTER TABLE companies RENAME COLUMN temp_uuid_id TO id;
ALTER TABLE companies ADD PRIMARY KEY (id);

-- Team members table
ALTER TABLE team_members DROP COLUMN id CASCADE;
ALTER TABLE team_members RENAME COLUMN temp_uuid_id TO id;
ALTER TABLE team_members ADD PRIMARY KEY (id);

-- Update all foreign key references to use new column names
-- Projects table
ALTER TABLE projects DROP COLUMN company_id;
ALTER TABLE projects RENAME COLUMN temp_company_uuid TO company_id;

-- Calendar events table
ALTER TABLE calendar_events DROP COLUMN company_id, DROP COLUMN project_id, 
    DROP COLUMN task_id, DROP COLUMN assigned_to;
ALTER TABLE calendar_events RENAME COLUMN temp_company_uuid TO company_id;
ALTER TABLE calendar_events RENAME COLUMN temp_project_uuid TO project_id;
ALTER TABLE calendar_events RENAME COLUMN temp_task_uuid TO task_id;
ALTER TABLE calendar_events RENAME COLUMN temp_assigned_uuid TO assigned_to;

-- Contacts table
ALTER TABLE contacts DROP COLUMN company_id;
ALTER TABLE contacts RENAME COLUMN temp_company_uuid TO company_id;
```

#### Day 9: Recreate Foreign Key Constraints
**Objective**: Add proper foreign key constraints with new UUID references

```sql
-- Add foreign key constraints
ALTER TABLE campaigns ADD CONSTRAINT fk_campaigns_company 
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE projects ADD CONSTRAINT fk_projects_company 
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE projects ADD CONSTRAINT fk_projects_campaign 
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE SET NULL;

ALTER TABLE contacts ADD CONSTRAINT fk_contacts_company 
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

ALTER TABLE calendar_events ADD CONSTRAINT fk_calendar_company 
    FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;

-- Update fh_tasks to reference projects properly
ALTER TABLE fh_tasks ADD CONSTRAINT fk_fh_tasks_project 
    FOREIGN KEY (temp_project_uuid) REFERENCES projects(id) ON DELETE CASCADE;
```

#### Day 10: Performance Optimization
**Objective**: Add indexes and optimize queries

```sql
-- Add performance indexes
CREATE INDEX idx_campaigns_company_id ON campaigns(company_id);
CREATE INDEX idx_campaigns_status ON campaigns(status);
CREATE INDEX idx_projects_campaign_id ON projects(campaign_id);
CREATE INDEX idx_projects_company_id ON projects(company_id);
CREATE INDEX idx_projects_status ON projects(status);
CREATE INDEX idx_goals_project_id ON goals(project_id);
CREATE INDEX idx_goals_campaign_id ON goals(campaign_id);
CREATE INDEX idx_actions_project_id ON actions(project_id);
CREATE INDEX idx_actions_assigned_to ON actions(assigned_to);
CREATE INDEX idx_user_companies_user_id ON user_companies(user_id);
CREATE INDEX idx_user_companies_company_id ON user_companies(company_id);

-- Add composite indexes for common queries
CREATE INDEX idx_user_companies_user_company ON user_companies(user_id, company_id);
CREATE INDEX idx_projects_company_status ON projects(company_id, status);
CREATE INDEX idx_actions_assigned_status ON actions(assigned_to, status);
```

### Phase 5: Data Validation (Days 11-12)

#### Day 11: Data Integrity Checks
**Objective**: Validate all data migration and relationships

```sql
-- Check for orphaned records
SELECT 'Orphaned projects' as issue, count(*) as count
FROM projects WHERE company_id NOT IN (SELECT id FROM companies);

SELECT 'Orphaned goals' as issue, count(*) as count  
FROM goals WHERE project_id IS NOT NULL AND project_id NOT IN (SELECT id FROM projects);

SELECT 'Orphaned actions' as issue, count(*) as count
FROM actions WHERE project_id IS NOT NULL AND project_id NOT IN (SELECT id FROM projects);

-- Validate RLS policies
SET ROLE authenticated;
SELECT count(*) as accessible_companies FROM companies;
SELECT count(*) as accessible_projects FROM projects;
RESET ROLE;
```

#### Day 12: Final Testing and Documentation
**Objective**: Complete testing and update documentation

```sql
-- Test multi-tenant isolation
-- Test CRUD operations with RLS
-- Validate performance with indexes
-- Update API documentation
-- Update frontend type definitions
```

## Updated Documentation References

### Files Requiring Updates

1. **architecture-plans.md**: Update database schema section
2. **mvp-roadmap.md**: Adjust timeline for database refactoring
3. **dependency-mapping.md**: Update database dependencies
4. **feature-development-workflow.md**: Add database refactoring checklist

### New Timeline Integration

The refactoring plan integrates with our existing timeline as follows:

- **Week 1**: Database refactoring (replaces project setup week)
- **Week 2**: Authentication integration with existing users table
- **Week 3**: Campaign management (new layer in hierarchy)
- **Week 4-12**: Continue with enhanced MVP leveraging existing infrastructure

This refactoring plan ensures we maintain the valuable existing infrastructure while aligning with our MVP documentation and design patterns.
