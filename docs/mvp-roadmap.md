# FH Portal MVP Roadmap

## Overview
This roadmap outlines the 12-week development plan for the FH Portal MVP, organized into 4 phases with detailed timelines, milestones, and resource allocation.

## Project Timeline: 12 Weeks
**Start Date**: [PROJECT_START_DATE]
**MVP Launch Date**: [PROJECT_START_DATE + 12 weeks]

---

## Phase 1: Foundation & Database Refactoring (Weeks 1-3)
**Duration**: 3 weeks
**Focus**: Database refactoring, project infrastructure, design system, and authentication

### Week 1: Database Refactoring & Project Setup
**Dates**: [Week 1 Start] - [Week 1 End]
**CRITICAL**: Existing Frontend Horizon database requires refactoring before development

#### Monday-Tuesday: Database Schema Harmonization
- [ ] **Analyze existing database conflicts**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Developer]
  - Notes: See existing-database-analysis.md

- [ ] **ID type standardization (bigint → uuid)**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Developer]
  - Notes: Critical for consistency across all tables

- [ ] **Foreign key relationship updates**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Developer]
  - Notes: Update all references to use UUID

#### Wednesday: Table Consolidation & MVP Tables
- [ ] **Consolidate fh_projects into projects table**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Developer]
  - Notes: Merge duplicate project tables

- [ ] **Create missing MVP tables (campaigns, goals, actions)**
  - Start: [YYYY-MM-DD 15:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Developer]
  - Notes: Add core MVP hierarchy tables

#### Thursday: Security & Multi-tenancy
- [ ] **Enable RLS on core tables**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Developer]
  - Notes: Critical for multi-tenant security

- [ ] **Create RLS policies**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Developer]
  - Notes: Implement company-based data isolation

- [ ] **Create user_companies junction table**
  - Start: [YYYY-MM-DD 19:00]
  - Estimated: 2 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Developer]

#### Friday: Project Setup & Validation
- [ ] **Initialize Next.js project with existing Supabase**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]
  - Notes: Connect to refactored database

- [ ] **Data migration validation**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Developer]
  - Notes: Verify all relationships work correctly

- [ ] **Setup development environment**
  - Start: [YYYY-MM-DD 17:00]
  - Estimated: 2 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [DevOps/Developer]

**Week 1 Total**: 52 hours (increased due to database refactoring)

### Week 2: Authentication System
**Dates**: [Week 2 Start] - [Week 2 End]

#### Database Design
- [ ] **Design user & company schema**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Designer]

- [ ] **Create Supabase migrations**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

- [ ] **Setup RLS policies**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

#### Frontend Implementation
- [ ] **Create auth components**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

- [ ] **Implement auth flows**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

#### Backend Implementation
- [ ] **Setup NextAuth.js**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

- [ ] **Create auth API routes**
  - Start: [YYYY-MM-DD 15:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

**Week 2 Total**: 44 hours

### Week 3: Company Management
**Dates**: [Week 3 Start] - [Week 3 End]

#### Database & Backend
- [ ] **Extend company schema**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 3 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Designer]

- [ ] **Create company API endpoints**
  - Start: [YYYY-MM-DD 12:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

- [ ] **Implement multi-tenant security**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

#### Frontend Implementation
- [ ] **Create company components**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

- [ ] **Implement company CRUD**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 10 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

- [ ] **Add team management**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

**Week 3 Total**: 47 hours

**Phase 1 Milestone**: ✅ Authentication and Company Management Complete
**Phase 1 Total**: 133 hours

---

## Phase 2: Core Features (Weeks 4-7)
**Duration**: 4 weeks
**Focus**: Campaign, Project, and Task management

### Week 4: Campaign Management
**Dates**: [Week 4 Start] - [Week 4 End]

#### Database Design
- [ ] **Design campaign schema**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Designer]

- [ ] **Create campaign migrations**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 3 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

#### Backend Implementation
- [ ] **Create campaign API endpoints**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 10 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

- [ ] **Add campaign business logic**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

#### Frontend Implementation
- [ ] **Create campaign components**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 14 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

- [ ] **Implement campaign navigation**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

**Week 4 Total**: 43 hours

### Week 5: Project Management
**Dates**: [Week 5 Start] - [Week 5 End]

#### Database & Backend
- [ ] **Design project schema**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Designer]

- [ ] **Create project API endpoints**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

- [ ] **Add project assignment logic**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

#### Frontend Implementation
- [ ] **Create project components**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 16 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

- [ ] **Implement progress tracking**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

**Week 5 Total**: 46 hours

### Week 6: Task Management
**Dates**: [Week 6 Start] - [Week 6 End]

#### Database & Backend
- [ ] **Design task schema**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Designer]

- [ ] **Create task API endpoints**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

- [ ] **Add task workflow logic**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

#### Frontend Implementation
- [ ] **Create task components**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 16 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

- [ ] **Implement task status management**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

**Week 6 Total**: 48 hours

### Week 7: Integration & Testing
**Dates**: [Week 7 Start] - [Week 7 End]

#### Integration
- [ ] **Connect all entity relationships**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Full Stack Developer]

- [ ] **Implement hierarchical navigation**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

#### Testing
- [ ] **Write unit tests**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 16 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [QA/Developer]

- [ ] **Integration testing**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [QA/Developer]

- [ ] **Performance optimization**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Developer]

**Week 7 Total**: 50 hours

**Phase 2 Milestone**: ✅ Core Entity Management Complete
**Phase 2 Total**: 187 hours

---

## Phase 3: Interface & Polish (Weeks 8-10)
**Duration**: 3 weeks
**Focus**: Apple-style interface, dashboard, and search functionality

### Week 8: Apple-Style Card Interface
**Dates**: [Week 8 Start] - [Week 8 End]

#### Design Implementation
- [ ] **Create card design system**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [UI/UX Designer]

- [ ] **Implement card components**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 16 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

- [ ] **Add card interactions**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

#### Navigation
- [ ] **Implement breadcrumb navigation**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

- [ ] **Add responsive grid layouts**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

**Week 8 Total**: 50 hours

### Week 9: Dashboard Implementation
**Dates**: [Week 9 Start] - [Week 9 End]

#### Dashboard Design
- [ ] **Design dashboard layout**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [UI/UX Designer]

- [ ] **Create dashboard components**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 16 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

#### Analytics & Metrics
- [ ] **Implement basic analytics**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

- [ ] **Add activity feeds**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Full Stack Developer]

- [ ] **Create quick actions**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

**Week 9 Total**: 48 hours

### Week 10: Search & Filtering
**Dates**: [Week 10 Start] - [Week 10 End]

#### Search Implementation
- [ ] **Design search architecture**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Backend Developer]

- [ ] **Implement global search**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Full Stack Developer]

- [ ] **Add filtering capabilities**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 10 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

#### Polish & Optimization
- [ ] **Performance optimization**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Developer]

- [ ] **Mobile responsiveness**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

- [ ] **Accessibility improvements**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

**Week 10 Total**: 52 hours

**Phase 3 Milestone**: ✅ Interface and User Experience Complete
**Phase 3 Total**: 150 hours

---

## Phase 4: Testing & Launch (Weeks 11-12)
**Duration**: 2 weeks
**Focus**: Testing, bug fixes, and production deployment

### Week 11: Testing & Bug Fixes
**Dates**: [Week 11 Start] - [Week 11 End]

#### Comprehensive Testing
- [ ] **End-to-end testing**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 16 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [QA Engineer]

- [ ] **User acceptance testing**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Product Manager]

- [ ] **Security testing**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Security Specialist]

#### Bug Fixes & Polish
- [ ] **Critical bug fixes**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 12 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Development Team]

- [ ] **UI/UX polish**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Frontend Developer]

**Week 11 Total**: 56 hours

### Week 12: Production Deployment
**Dates**: [Week 12 Start] - [Week 12 End]

#### Deployment Preparation
- [ ] **Production environment setup**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [DevOps Engineer]

- [ ] **Database migration to production**
  - Start: [YYYY-MM-DD 15:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Database Administrator]

- [ ] **Final security review**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Security Specialist]

#### Launch
- [ ] **Production deployment**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [DevOps Engineer]

- [ ] **Monitoring setup**
  - Start: [YYYY-MM-DD 13:00]
  - Estimated: 4 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [DevOps Engineer]

- [ ] **Launch validation**
  - Start: [YYYY-MM-DD 17:00]
  - Estimated: 2 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Product Manager]

#### Documentation
- [ ] **User documentation**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 8 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Technical Writer]

- [ ] **Developer documentation**
  - Start: [YYYY-MM-DD 09:00]
  - Estimated: 6 hours
  - Completion: [YYYY-MM-DD HH:MM]
  - Owner: [Lead Developer]

**Week 12 Total**: 38 hours

**Phase 4 Milestone**: 🚀 MVP Launch Complete
**Phase 4 Total**: 94 hours

---

## Resource Allocation

### Team Composition
- **1 Lead Developer** (Full Stack)
- **1 Frontend Developer** (React/Next.js)
- **1 Backend Developer** (Node.js/Supabase)
- **1 UI/UX Designer**
- **1 QA Engineer**
- **0.5 DevOps Engineer** (Part-time)
- **0.5 Product Manager** (Part-time)

### Total Project Effort
**Total Estimated Hours**: 564 hours
**Total Team Weeks**: 12 weeks
**Average Hours per Week**: 47 hours
**Average Hours per Person**: ~8 hours/week (with team of 6)

### Critical Path
1. Authentication System (Week 2)
2. Company Management (Week 3)
3. Campaign Management (Week 4)
4. Project Management (Week 5)
5. Task Management (Week 6)
6. Apple-Style Interface (Week 8)
7. Production Deployment (Week 12)

### Risk Mitigation
- **Buffer Time**: 10% buffer built into each phase
- **Parallel Development**: Frontend and backend work in parallel where possible
- **Early Testing**: Testing integrated throughout development
- **Incremental Deployment**: Deploy to staging after each phase

This roadmap provides a structured approach to delivering the FH Portal MVP within 12 weeks while maintaining quality and allowing for iterative feedback.
