# Używamy gotowego obrazu ze środowiskiem KOS
FROM ghcr.io/kazade/kallisti-os:latest

# Instalacja dodatkowych narzędzi (opcjonalnie)
RUN apt-get update && apt-get install -y \
    make \
    git \
    && rm -rf /var/lib/apt/lists/*
