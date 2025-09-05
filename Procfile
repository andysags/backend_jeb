# API Django (serveur web)
web: gunicorn incubator.wsgi --log-file -

# Worker Cron (sync API JEB par ex.)
worker: python manage.py crontab add && python manage.py crontab run
