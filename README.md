# ArtNest 🎨

Red social para compartir hobbies creativos.

## Stack
- Frontend: React + TypeScript + Vite + Tailwind
- Backend: Node + Express + TypeScript
- Base de datos: PostgreSQL con SQL puro (librería `pg`, sin ORM)

## Instalación

### Frontend
\`\`\`bash
cd frontend
npm install
npm run dev
\`\`\`
Corre en http://localhost:5173

### Backend
\`\`\`bash
cd backend
npm install
cp .env.example .env   # y llena tus propias variables
psql "TU_DATABASE_URL" -f src/shared/schema.sql   # crea las tablas
npm run dev
\`\`\`
Corre en http://localhost:3000

## Base de datos
El esquema (tablas) está definido en \`backend/src/shared/schema.sql\` en SQL puro.
La conexión se maneja con la librería \`pg\` desde \`backend/src/shared/db.ts\`.

## Estructura del proyecto
Ver documento "ArtNest_Arquitectura.md" para el detalle de organización modular.
