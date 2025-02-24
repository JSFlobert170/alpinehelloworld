# Utiliser une version stable de Python Alpine
FROM python:3.11-alpine

# Installer les dépendances système
RUN apk add --no-cache --update python3 py3-pip bash

# Copier les fichiers nécessaires
COPY webapp/requirements.txt /tmp/requirements.txt

# Installer les dépendances Python
RUN python3 -m venv /opt/venv \
    && . /opt/venv/bin/activate \
    && pip install --no-cache-dir -q -r /tmp/requirements.txt

# Copier le code source de l'application
COPY webapp /opt/webapp/

# Définir le répertoire de travail
WORKDIR /opt/webapp

# Créer et utiliser un utilisateur non-root
RUN adduser -D myuser
USER myuser

# Définir une valeur par défaut pour le port
ENV PORT=5000

# Lancer l'application avec gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "wsgi"]
