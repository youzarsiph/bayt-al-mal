# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3-slim

EXPOSE 8000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

# Create new Django project and configure the settings
RUN python -m django startproject core
RUN cp -r bayt_al_mal core
RUN echo "AUTH_USER_MODEL = 'users.User'" >> core/settings.py
RUN echo "INSTALLED_APPS += ['bayt_al_mal', 'bayt_al_mal.users', 'rest_wind', 'rest_framework']" >> core/settings.py
RUN echo "from django.urls import include" >> core/urls.py
RUN echo "urlpatterns += [path('', include('bayt_al_mal.urls'))" >> core/urls.py

WORKDIR /bayt_al_mal
COPY . /bayt_al_mal

# Creates a non-root user with an explicit UID and adds permission to access the /bayt_al_mal folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /bayt_al_mal
USER appuser

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "core.wsgi"]
