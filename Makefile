# ===== cg_trans — Makefile =====
# Utilisation rapide :
#   make up           # build + run (hot reload)
#   make down         # stop + remove
#   make logs         # voir les logs
#   make sh           # shell dans le conteneur front
#   make npm-i        # npm install dans le conteneur
#   make dev          # npm run dev (si le conteneur tourne)
#   make typecheck    # tsc --noEmit
#   make clean        # rm volumes anonymes node_modules
#   make rebuild      # rebuild image + restart

SHELL := /bin/sh

COMPOSE := docker compose
SERVICE := front           # nom du service dans docker-compose.yml
APP_DIR := /app            # workdir dans le conteneur

# ---------- Aide ----------
.PHONY: help
help:
	@echo "Cibles disponibles :"
	@echo "  up         - build + run le service front"
	@echo "  down       - stop + remove containers"
	@echo "  restart    - restart le service front"
	@echo "  rebuild    - rebuild l'image et relance"
	@echo "  logs       - affiche les logs du front"
	@echo "  ps         - liste les containers"
	@echo "  sh         - ouvre un shell dans le conteneur front"
	@echo "  npm-i      - npm install dans le conteneur"
	@echo "  npm-ci     - npm ci (si package-lock.json existe)"
	@echo "  dev        - npm run dev (containeur up requis)"
	@echo "  typecheck  - tsc --noEmit"
	@echo "  test       - vitest (si configuré)"
	@echo "  lint       - eslint (si configuré)"
	@echo "  clean      - supprime les volumes anonymes node_modules"

# ---------- Cycle de vie docker ----------
.PHONY: up down restart rebuild logs ps
up:
	$(COMPOSE) up --build -d
	@echo "Front dispo sur http://localhost:5173"

down:
	$(COMPOSE) down

restart:
	$(COMPOSE) restart $(SERVICE)

rebuild:
	$(COMPOSE) build --no-cache $(SERVICE)
	$(COMPOSE) up -d $(SERVICE)

logs:
	$(COMPOSE) logs -f $(SERVICE)

ps:
	$(COMPOSE) ps

# ---------- Dev : shell & npm ----------
.PHONY: sh npm-i npm-ci dev typecheck test lint
sh:
	$(COMPOSE) exec $(SERVICE) sh

# Installe les deps dans le conteneur (volume /app/node_modules)
npm-i:
	$(COMPOSE) exec $(SERVICE) npm install

npm-ci:
	$(COMPOSE) exec $(SERVICE) npm ci

# Démarre le server Vite si le conteneur tourne déjà (sinon, fais 'make up')
dev:
	$(COMPOSE) exec $(SERVICE) npm run dev -- --host 0.0.0.0

# Type-check (nécessite typescript dans devDependencies)
typecheck:
	$(COMPOSE) exec $(SERVICE) npx tsc --noEmit

# Tests (si Vitest configuré)
test:
	$(COMPOSE) exec $(SERVICE) npx vitest run

# Lint (si ESLint configuré)
lint:
	$(COMPOSE) exec $(SERVICE) npx eslint .

# ---------- Nettoyage ----------
.PHONY: clean
clean:
	# Supprime le volume anonyme /app/node_modules créé par docker-compose
	# (les dépendances seront réinstallées au prochain 'make up' + 'make npm-i')
	@echo "Suppression des volumes anonymes node_modules…"
	-$(COMPOSE) down -v
	@echo "OK. Relance avec 'make up' puis 'make npm-i' si besoin."
