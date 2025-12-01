.PHONY: help setup install run test clean docker-build docker-run docker-stop

help:
	@echo "Alpine AI - Available Commands"
	@echo ""
	@echo "  make setup        - Initial setup (create venv, install deps)"
	@echo "  make install      - Install/update dependencies"
	@echo "  make run          - Run the application"
	@echo "  make test         - Run tests"
	@echo "  make clean        - Clean up temporary files"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-run   - Run with Docker Compose"
	@echo "  make docker-stop  - Stop Docker containers"

setup:
	@bash scripts/setup.sh

install:
	pip install -r requirements.txt

run:
	python -m uvicorn alpine.api.main:app --reload --host 0.0.0.0 --port 8000

test:
	pytest tests/ -v --cov=alpine

clean:
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf .pytest_cache .coverage htmlcov

docker-build:
	docker build -t alpine-ai:latest .

docker-run:
	docker-compose up -d

docker-stop:
	docker-compose down
