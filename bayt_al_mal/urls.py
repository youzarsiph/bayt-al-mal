"""Main App URLConf"""

from django.urls import path, include
from rest_framework.routers import DefaultRouter


# Create your URlConf here.
router = DefaultRouter()


urlpatterns = [
    path("", include(router.urls)),
]
