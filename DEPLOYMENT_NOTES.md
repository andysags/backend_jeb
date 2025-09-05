Problème de build `pip install -r requirements.txt`

Contexte
- Railway (ou une autre plateforme) exécute la commande :
  python -m venv --copies /opt/venv && . /opt/venv/bin/activate && pip install -r requirements.txt
- L'erreur survient quand des paquets nécessitent des dépendances système (libpq-dev, build-essential, libssl-dev, libjpeg-dev, etc.) ou quand `requirements.txt` contient beaucoup de paquets inutiles pour la prod.

Étapes recommandées
1. Utiliser un fichier de dépendances pour la production minimal (`requirements-production.txt`) contenant uniquement ce dont l'app a besoin en prod (Django, gunicorn, psycopg2-binary, dj-database-url, etc.).
2. Sur Railway, déclarer `PIP_REQUIREMENTS` ou pointer vers `requirements-production.txt` si possible.
3. Si tu utilises une image Docker custom (recommandé), ajouter les paquets système avant `pip install` :
   - apt-get update && apt-get install -y build-essential libpq-dev libjpeg-dev zlib1g-dev libssl-dev libffi-dev
4. Remplacer `psycopg2` par `psycopg2-binary` en prod pour éviter compilation native.
5. Récupérer l'extrait d'erreur pip si l'erreur persiste : chercher les lignes avec "error:" ou "failed building wheel for".

Commandes utiles pour debug local

# Construire l'image localement
docker build -t myapp:local .

# Lancer un container et inspecter l'installation
docker run --rm -it myapp:local /bin/bash
# puis dans le container
python -m venv --copies /opt/venv && . /opt/venv/bin/activate
pip install -r requirements-production.txt

Si `pip install` échoue, récupérer la sortie complète (stdout+stderr) et rechercher le paquet qui a échoué.

Notes de sécurité
- Ne laisse pas d'URL de base de données ou secrets en clair dans le repo; préfère les variables d'environnement.

Si tu veux, je peux :
- retirer de `requirements.txt` les paquets non nécessaires et produire une version de prod plus complète;
- tester une build Docker locale ici et rapporter l'erreur exacte si elle échoue.
