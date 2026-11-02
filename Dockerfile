FROM python:3.12-slim

# uv binary from the official image, pinned to a minor version
COPY --from=ghcr.io/astral-sh/uv:0.11 /uv /uvx /bin/

WORKDIR /app
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PATH="/app/.venv/bin:$PATH"

# 1) Dependencies only (cached layer while pyproject/uv.lock don't change)
COPY pyproject.toml uv.lock .python-version ./
RUN uv sync --frozen --no-dev --no-install-project

# 2) The project itself
COPY src ./src
RUN uv sync --frozen --no-dev

EXPOSE 8000
CMD ["uvicorn", "botw_tracker.main:app", "--host", "0.0.0.0", "--port", "8000"]
