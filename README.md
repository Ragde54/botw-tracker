# Inventario de Mejoras BOTW

Tracker local de los materiales que faltan para subir a ★4 las armaduras de Zelda: Breath of the Wild.

## Arrancar

```bash
docker compose up --build
```

Abre http://localhost:8000. El progreso se guarda en Postgres (volumen `pgdata`), así que sobrevive a `docker compose down`.
Para borrarlo todo: `docker compose down -v`.

## Estructura

```
src/botw_tracker/
  main.py          FastAPI: sirve la UI y la API
  db.py            Pool de psycopg + esquema (se crea al arrancar)
  static/index.html  UI (HTML/CSS/JS sin build). El catálogo de armaduras está aquí, en SETS/SINGLES
```

## API

| Método | Ruta | Qué hace |
|---|---|---|
| GET | `/api/progress` | `{levels: {"barbaro/0": 3, ...}, skip: {"tiempo": true}}` |
| PUT | `/api/progress` | Reemplaza todo el progreso (niveles 0-4, validado) |
| GET | `/api/health` | Comprobación de vida |
| GET | `/docs` | Swagger generado por FastAPI |

Los ids de pieza son `<set_id>/<índice de pieza>` (0 = cabeza, 1 = torso, 2 = piernas).

## Desarrollo

- Con compose, `src/` está montado y uvicorn recarga al guardar. Cambios en `index.html` basta con refrescar el navegador.
- Sin Docker para la app (solo Postgres en Docker):
  ```bash
  docker compose up -d db
  uv sync
  uv run botw-tracker
  ```
- Base de datos: `psql postgresql://botw:botw@localhost:5432/botw`
  Tablas: `piece_level(piece_id, level)` y `skipped_set(set_id)`.
