# FH Portal

Frontend Horizon Portal - A comprehensive project management and workflow platform built with Next.js, Supabase, and deployed on Vercel.

## Features

- **Companies**: Manage your company portfolio and organizational structure
- **Campaigns**: Create and track marketing campaigns and initiatives  
- **Projects**: Organize and manage your development projects
- **Tasks**: Track individual tasks and workflow progress

## Tech Stack

- **Frontend**: Next.js 14 with TypeScript
- **Styling**: Tailwind CSS
- **Database**: Supabase
- **Deployment**: Vercel
- **Authentication**: Supabase Auth

## Getting Started

First, install dependencies:

```bash
npm install
# or
yarn install
# or
pnpm install
```

Then, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Environment Variables

Create a `.env.local` file in the root directory and add your Supabase credentials:

```
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Deployment

This project is optimized for deployment on Vercel. Simply connect your GitHub repository to Vercel for automatic deployments.

**Last deployment triggered:** June 16, 2025 - Manual trigger

## Documentation

See the `docs/` directory for detailed documentation on:
- Architecture plans
- Database schema
- Design system
- Development standards
- Feature development workflow

## Learn More

To learn more about the technologies used:

- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
- [Vercel Documentation](https://vercel.com/docs)
