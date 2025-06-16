-- FH Portal Database Schema
-- PostgreSQL Database Schema for Multi-tenant Business Management Platform

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    avatar_url VARCHAR(500),
    email_verified BOOLEAN DEFAULT FALSE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Companies table (Multi-tenant)
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    logo_url VARCHAR(500),
    website VARCHAR(255),
    industry VARCHAR(100),
    size VARCHAR(50), -- startup, small, medium, large, enterprise
    settings JSONB DEFAULT '{}',
    subscription_plan VARCHAR(50) DEFAULT 'free', -- free, basic, pro, enterprise
    subscription_status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- User-Company relationships with roles
CREATE TABLE user_companies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    role VARCHAR(50) NOT NULL DEFAULT 'user', -- owner, admin, manager, user, viewer
    permissions JSONB DEFAULT '{}',
    status VARCHAR(50) DEFAULT 'active', -- active, inactive, pending
    joined_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, company_id)
);

-- Campaigns
CREATE TABLE campaigns (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'draft', -- draft, active, paused, completed, cancelled
    type VARCHAR(50), -- marketing, sales, product, etc.
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    spent DECIMAL(12,2) DEFAULT 0,
    target_audience TEXT,
    goals TEXT,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Projects
CREATE TABLE projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    campaign_id UUID REFERENCES campaigns(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'planning', -- planning, active, on_hold, completed, cancelled
    priority VARCHAR(50) DEFAULT 'medium', -- low, medium, high, critical
    start_date DATE,
    end_date DATE,
    budget DECIMAL(12,2),
    spent DECIMAL(12,2) DEFAULT 0,
    progress INTEGER DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
    created_by UUID REFERENCES users(id),
    assigned_to UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Tasks
CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    parent_task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'todo', -- todo, in_progress, review, done, cancelled
    priority VARCHAR(50) DEFAULT 'medium',
    estimated_hours DECIMAL(5,2),
    actual_hours DECIMAL(5,2),
    due_date TIMESTAMP,
    assigned_to UUID REFERENCES users(id),
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Goals
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) DEFAULT 'outcome', -- outcome, output, impact
    target_value DECIMAL(12,2),
    current_value DECIMAL(12,2) DEFAULT 0,
    unit VARCHAR(50), -- percentage, count, currency, etc.
    target_date DATE,
    status VARCHAR(50) DEFAULT 'active', -- active, achieved, missed, cancelled
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Actions (specific actionable items)
CREATE TABLE actions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    task_id UUID REFERENCES tasks(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    action_type VARCHAR(50), -- email, call, meeting, research, etc.
    status VARCHAR(50) DEFAULT 'pending', -- pending, in_progress, completed, cancelled
    due_date TIMESTAMP,
    assigned_to UUID REFERENCES users(id),
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- OKRs (Objectives and Key Results)
CREATE TABLE objectives (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    quarter VARCHAR(10), -- Q1-2024, Q2-2024, etc.
    year INTEGER,
    status VARCHAR(50) DEFAULT 'active', -- active, completed, cancelled
    progress INTEGER DEFAULT 0 CHECK (progress >= 0 AND progress <= 100),
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE key_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    objective_id UUID REFERENCES objectives(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    target_value DECIMAL(12,2) NOT NULL,
    current_value DECIMAL(12,2) DEFAULT 0,
    unit VARCHAR(50), -- percentage, count, currency, etc.
    status VARCHAR(50) DEFAULT 'active', -- active, achieved, at_risk, missed
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- KPIs (Key Performance Indicators)
CREATE TABLE kpis (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key_result_id UUID REFERENCES key_results(id) ON DELETE CASCADE,
    project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    metric_type VARCHAR(50), -- count, percentage, currency, ratio, etc.
    target_value DECIMAL(12,2),
    current_value DECIMAL(12,2) DEFAULT 0,
    unit VARCHAR(50),
    frequency VARCHAR(50) DEFAULT 'daily', -- daily, weekly, monthly, quarterly
    data_source VARCHAR(100), -- manual, api, integration, etc.
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Reports
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    campaign_id UUID REFERENCES campaigns(id) ON DELETE SET NULL,
    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    report_type VARCHAR(50), -- performance, financial, progress, custom
    data JSONB, -- Flexible JSON data for report content
    filters JSONB, -- Saved filter settings
    schedule VARCHAR(50), -- manual, daily, weekly, monthly
    status VARCHAR(50) DEFAULT 'draft', -- draft, published, archived
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Messages/Communications
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    campaign_id UUID REFERENCES campaigns(id) ON DELETE SET NULL,
    project_id UUID REFERENCES projects(id) ON DELETE SET NULL,
    sender_id UUID REFERENCES users(id) ON DELETE SET NULL,
    recipient_id UUID REFERENCES users(id) ON DELETE SET NULL,
    subject VARCHAR(255),
    content TEXT NOT NULL,
    message_type VARCHAR(50) DEFAULT 'internal', -- internal, email, sms, notification
    status VARCHAR(50) DEFAULT 'sent', -- draft, sent, delivered, read
    priority VARCHAR(50) DEFAULT 'normal', -- low, normal, high, urgent
    read_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Contacts
CREATE TABLE contacts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    job_title VARCHAR(100),
    company_name VARCHAR(255),
    contact_type VARCHAR(50) DEFAULT 'prospect', -- prospect, customer, partner, vendor
    status VARCHAR(50) DEFAULT 'active', -- active, inactive, blocked
    source VARCHAR(100), -- website, referral, event, etc.
    tags JSONB DEFAULT '[]',
    notes TEXT,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Leads
CREATE TABLE leads (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    contact_id UUID REFERENCES contacts(id) ON DELETE SET NULL,
    campaign_id UUID REFERENCES campaigns(id) ON DELETE SET NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'new', -- new, qualified, proposal, negotiation, won, lost
    value DECIMAL(12,2),
    probability INTEGER DEFAULT 0 CHECK (probability >= 0 AND probability <= 100),
    source VARCHAR(100),
    assigned_to UUID REFERENCES users(id),
    expected_close_date DATE,
    actual_close_date DATE,
    created_by UUID REFERENCES users(id),
    updated_by UUID REFERENCES users(id),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

-- Performance Indexes
CREATE INDEX idx_user_companies_user_id ON user_companies(user_id);
CREATE INDEX idx_user_companies_company_id ON user_companies(company_id);
CREATE INDEX idx_campaigns_company_id ON campaigns(company_id);
CREATE INDEX idx_projects_campaign_id ON projects(campaign_id);
CREATE INDEX idx_tasks_project_id ON tasks(project_id);
CREATE INDEX idx_goals_project_id ON goals(project_id);
CREATE INDEX idx_actions_project_id ON actions(project_id);
CREATE INDEX idx_objectives_project_id ON objectives(project_id);
CREATE INDEX idx_key_results_objective_id ON key_results(objective_id);
CREATE INDEX idx_kpis_key_result_id ON kpis(key_result_id);
CREATE INDEX idx_kpis_project_id ON kpis(project_id);
CREATE INDEX idx_reports_company_id ON reports(company_id);
CREATE INDEX idx_messages_company_id ON messages(company_id);
CREATE INDEX idx_contacts_company_id ON contacts(company_id);
CREATE INDEX idx_leads_company_id ON leads(company_id);
CREATE INDEX idx_companies_slug ON companies(slug);

-- Composite indexes for common queries
CREATE INDEX idx_projects_status_priority ON projects(status, priority);
CREATE INDEX idx_tasks_assignee_status ON tasks(assigned_to, status);
CREATE INDEX idx_leads_status_assigned ON leads(status, assigned_to);
CREATE INDEX idx_messages_recipient_status ON messages(recipient_id, status);
