from django.urls import path

from . import views

app_name = 'health'

urlpatterns = [
    path("", views.health_check, name="health_check"),
    path("readiness/", views.readiness_check, name="readiness_check"),
    path("liveness/", views.liveness_check, name="liveness_check"),
    path("version/", views.version_info, name="version_info"),
]


# curl -f http://localhost:8000/health/
# curl -f http://localhost:8000/health/readiness/
# curl -f http://localhost:8000/health/liveness/
# curl -f http://localhost:8000/health/version/