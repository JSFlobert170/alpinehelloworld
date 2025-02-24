# Utiliser une version stable de Python Alpine
FROM python:3.11-alpine

# Installer les dépendances système nécessaires
RUN apk add --no-cache --update python3 py3-pip bash

# Définir un répertoire de travail temporaire
WORKDIR /tmp

# Copier et installer les dépendances Python dans un venv
COPY webapp/requirements.txt /tmp/requirements.txt
RUN python3 -m venv /opt/venv \
    && . /opt/venv/bin/activate \
    && pip install --no-cache-dir -q -r /tmp/requirements.txt

# Copier le code source de l'application après l'installation des dépendances
COPY webapp /opt/webapp/

# Définir le répertoire de travail final
WORKDIR /opt/webapp

# Créer et utiliser un utilisateur non-root
RUN adduser -D myuser
USER myuser

# Définir une valeur par défaut pour le port
ENV PORT=5000

# Exécuter Gunicorn depuis le venv
CMD ["/opt/venv/bin/gunicorn", "--bind", "0.0.0.0:5000", "wsgi"]
