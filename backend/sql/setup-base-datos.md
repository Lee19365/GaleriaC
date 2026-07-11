# Configurar la base de datos — ArtNest

Guía rápida para dejar corriendo la base de datos Postgres del proyecto en tu máquina local.

## Requisitos previos

- Tener PostgreSQL instalado en tu computadora (Windows/Mac/Linux).
- Tener el repo del backend clonado, con la carpeta `sql/schema.sql` incluida.

## Paso 1: Confirmar que Postgres está corriendo

En Windows (PowerShell):

```powershell
Get-Service -Name postgresql*
```

Debe decir `Running` en la columna `Status`. Si dice `Stopped`, inícialo con:

```powershell
Start-Service nombre-del-servicio
```

(usa el nombre exacto que te haya salido en el comando anterior)

## Paso 2: Crear la base de datos

Conéctate al motor de Postgres con `psql`:

```powershell
psql -U postgres -h localhost
```

> Si te sale el error `'psql' no se reconoce como nombre de un cmdlet`, usa la ruta completa al ejecutable en su lugar, por ejemplo:
> ```powershell
> & "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -h localhost
> ```
> (ajusta el número de versión según lo que tengas instalado)

Te va a pedir la contraseña del usuario `postgres`. Una vez adentro, crea la base de datos del proyecto:

```sql
CREATE DATABASE artnest;
```

Verifica que se creó:

```sql
\l
```

Y sal con:

```sql
\q
```

## Paso 3: Configurar tu archivo `.env`

En la carpeta `backend`, crea (o edita) el archivo `.env` con esta línea, usando tu propia contraseña de Postgres:

```
DATABASE_URL="postgresql://postgres:TU_CONTRASEÑA@localhost:5432/artnest"
```

> ⚠️ Si tu contraseña tiene símbolos como `@`, `#`, `%` o `/`, hay que codificarlos (URL-encode) o la cadena de conexión se rompe. Si te pasa, avisa en el grupo y lo resolvemos juntas.

## Paso 4: Crear las tablas

Parada en la carpeta `backend`, corre el script que ya trae las 6 tablas del proyecto (`usuarios`, `publicaciones`, `follows`, `likes`, `favoritos`, `comentarios`):

```powershell
psql -U postgres -h localhost -d artnest -f sql/schema.sql
```

(si `psql` no se reconoce, usa la ruta completa como en el Paso 2)

Si todo sale bien, vas a ver 6 bloques repetidos así:

```
NOTICE:  la tabla «usuarios» no existe, omitiendo
DROP TABLE
CREATE TABLE
```

Los `NOTICE` son normales la primera vez — es el aviso de que no había nada que borrar todavía. Lo importante es que cada bloque termine en `CREATE TABLE`.

## Paso 5: Probar que el backend se conecta

Instala las dependencias y levanta el servidor:

```powershell
npm install
npm run dev
```

Abre en el navegador:

```
http://localhost:3000/test-db
```

Si ves algo como esto, ya quedó todo conectado:

```json
{"conectado": true, "hora_servidor": {"now": "2026-07-10T05:38:01.958Z"}}
```

## Problemas comunes

| Error | Causa probable | Solución |
|---|---|---|
| `'psql' no se reconoce como cmdlet` | `psql` no está en el PATH de esta terminal | Usa la ruta completa al `.exe` (ver Paso 2) |
| `No such file or directory` al correr el script | No estás parada en la carpeta `backend` | `cd` a la carpeta correcta antes de correr el comando |
| `ECONNREFUSED` al conectar | Postgres no está corriendo, o el puerto en `DATABASE_URL` está mal | Revisa el Paso 1 y que el puerto en `.env` sea `5432` |
| `client password must be a string` | La variable `DATABASE_URL` no se cargó (problema de orden de `import`/`dotenv.config()`) | Confirma que `dotenv.config()` esté en `db.ts`, antes de crear el `Pool` |
| El `.env` trae algo como `prisma+postgres://...` | Quedó una URL generada por Prisma Dev, no es un Postgres real | Reemplázala por el formato estándar `postgresql://usuario:contraseña@host:puerto/basededatos` |

## Orden de las tablas (por si necesitas recrearlas a mano)

El orden importa por las llaves foráneas (FK): una tabla no puede crearse si la tabla a la que apunta todavía no existe.

1. `usuarios` (no depende de nadie)
2. `publicaciones` (depende de `usuarios`)
3. `follows` (depende de `usuarios`)
4. `likes` (depende de `usuarios` y `publicaciones`)
5. `favoritos` (depende de `usuarios` y `publicaciones`)
6. `comentarios` (depende de `usuarios` y `publicaciones`)
