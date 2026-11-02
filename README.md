# Inventario de Mejoras BOTW

Tracker local de los materiales que faltan para subir a ★4 las armaduras de Zelda: Breath of the Wild.
Las armaduras de amiibo están excluidas.

## Arrancar

```bash
docker compose up -d --build
```

Abre http://localhost:8000.

## Funcionalidades

- **Conjuntos y piezas**: marca con las estrellas el nivel actual de cada pieza, o usa "Mejorar conjunto +1★" para subir las tres a la vez. Las estrellas no tocan el inventario, así que sirven para registrar niveles que ya tenías.
- **Contar**: desmárcalo en un conjunto que no te interese y saldrá de todos los cálculos.
- **Próximas mejoras**: cada pieza aparece con su siguiente estrella, ordenada por las unidades que te faltan para conseguirla teniendo en cuenta tu inventario. Si empatan, va primero la que tiene menos materiales distintos pendientes.
  - Las piezas a las que ya no les falta nada tienen el botón **"Mejorada: descontar"**, que sube la estrella y resta del inventario lo que gasta la Gran Hada.
  - **⇄** marca un material que también piden otras piezas para su siguiente nivel. El cálculo trata cada pieza por separado y no reparte el inventario, así que puede que solo te llegue para una.
- **Materiales**: para cada material ves
  - **Tengo**: tu inventario. Se edita con − / + o escribiendo el número.
  - **Falta sig.**: lo que te falta para el siguiente nivel de todas las piezas que cuentan. Sale ✓ si ya tienes suficiente.
  - **Falta ★4**: lo que te falta para llegar al máximo.
  - Por defecto se ordena por "Menos por conseguir". Si pulsas un material, se filtran las piezas que todavía lo necesitan.

## Persistencia

Postgres guarda los datos en el volumen con nombre `pgdata`, que se mantiene tras `docker compose down`, al reiniciar el ordenador y al reconstruir con `--build`.

- **Nunca uses `docker compose down -v`**: la `-v` borra el volumen y todo tu progreso.
- Levanta siempre el proyecto desde **la misma carpeta**. El volumen toma el nombre de la carpeta (`botw-tracker_pgdata`), así que si lo arrancas desde otra se crea uno nuevo y vacío.

Copia de seguridad y restauración:

```bash
docker compose exec db pg_dump -U botw botw > backup.sql
docker compose exec -T db psql -U botw botw < backup.sql
```

## Actualizar el código

Copia los ficheros nuevos **encima** de los de esta carpeta, sin reemplazar la carpeta entera, y después:

```bash
docker compose restart app   # solo hace falta si cambias main.py o db.py
```

Para cambios en `index.html` basta con recargar el navegador con Cmd+Shift+R. Si no ves los cambios, comprueba que el fichero local es el nuevo antes de tocar Docker, por ejemplo con `grep -c "texto nuevo" src/botw_tracker/static/index.html`.

## Estructura

```
src/botw_tracker/
  main.py            FastAPI: sirve la UI y la API
  db.py              Pool de psycopg + esquema (se crea al arrancar)
  static/index.html  UI (HTML/CSS/JS sin build). El catálogo de armaduras está aquí, en SETS/SINGLES
```

## API

| Método | Ruta | Qué hace |
|---|---|---|
| GET | `/api/progress` | `{levels: {"barbaro/0": 3, ...}, skip: {"tiempo": true}}` |
| PUT | `/api/progress` | Reemplaza todo el progreso (niveles 0-4, validado) |
| GET | `/api/inventory` | `{"Cuerno de centaleón": 4, ...}` |
| PUT | `/api/inventory/{material}` | Body `{"qty": 4}` (0-9999). Con 0 se borra la fila |
| GET | `/api/health` | Comprobación de vida |
| GET | `/docs` | Swagger generado por FastAPI |

Los ids de pieza son `<set_id>/<índice de pieza>` (0 = cabeza, 1 = torso, 2 = piernas).
Las piezas sueltas tienen un único índice, 0 (p. ej. `pendientes-de-topacio/0`).
Los materiales se identifican por su nombre en español, tal como aparece en la UI.

## Base de datos

`psql postgresql://botw:botw@localhost:5432/botw`

| Tabla | Columnas | Contenido |
|---|---|---|
| `piece_level` | `piece_id`, `level` | Nivel de cada pieza (solo las que están por encima de 0) |
| `skipped_set` | `set_id` | Conjuntos que no cuentan |
| `inventory` | `material`, `qty` | Unidades que tienes de cada material (solo las que están por encima de 0) |

Las tablas se crean al arrancar la app con `CREATE TABLE IF NOT EXISTS`, así que una tabla nueva no necesita migración.

## Desarrollo

- Con compose, `src/` está montado en el contenedor y uvicorn recarga al guardar.
- Para ejecutar la app sin Docker, dejando solo Postgres en Docker:
  ```bash
  docker compose up -d db
  uv sync
  uv run botw-tracker
  ```

## Fuente de datos

Recetas de mejora sacadas de la [guía de armaduras de Vandal](https://vandal.elespanol.com/guias/guia-zelda-breath-of-the-wild/armaduras), con algunas erratas corregidas (están descritas al pie de la UI).