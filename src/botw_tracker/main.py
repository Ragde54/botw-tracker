"""FastAPI app: serves the frontend (static/index.html) and the progress API."""

from contextlib import asynccontextmanager
from pathlib import Path
from typing import Annotated

from fastapi import FastAPI, Path as PathParam
from fastapi.responses import FileResponse
from pydantic import BaseModel, Field

from botw_tracker import db

STATIC_DIR = Path(__file__).parent / "static"

Level = Annotated[int, Field(ge=0, le=4)]


class InventoryItem(BaseModel):
    qty: Annotated[int, Field(ge=0, le=9999)]


class Progress(BaseModel):
    levels: dict[str, Level] = {}
    skip: dict[str, bool] = {}


@asynccontextmanager
async def lifespan(_: FastAPI):
    db.pool.open(wait=True, timeout=30)
    db.init_schema()
    yield
    db.pool.close()


app = FastAPI(title="Inventario de Mejoras BOTW", lifespan=lifespan)


@app.get("/", include_in_schema=False)
def index() -> FileResponse:
    return FileResponse(STATIC_DIR / "index.html")


@app.get("/api/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


# Plain `def` endpoints: FastAPI runs them in a threadpool, which suits the sync psycopg pool.
@app.get("/api/progress")
def get_progress() -> Progress:
    levels, skipped = db.read_progress()
    return Progress(levels=levels, skip={s: True for s in skipped})


@app.put("/api/progress")
def put_progress(progress: Progress) -> Progress:
    skipped = [k for k, v in progress.skip.items() if v]
    db.write_progress(progress.levels, skipped)
    return progress


@app.get("/api/inventory")
def get_inventory() -> dict[str, int]:
    return db.read_inventory()


@app.put("/api/inventory/{material}")
def put_inventory(
    material: Annotated[str, PathParam(min_length=1, max_length=100)],
    item: InventoryItem,
) -> dict[str, int]:
    db.set_inventory(material, item.qty)
    return {material: item.qty}


def run() -> None:
    import uvicorn

    uvicorn.run("botw_tracker.main:app", host="0.0.0.0", port=8000, reload=True)
