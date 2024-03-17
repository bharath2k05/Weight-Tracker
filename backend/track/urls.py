from django.urls import path
from django.contrib import admin
from . import views
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('admin/', admin.site.urls),
    path('track/login/', views.user_login, name='user_login'),
    path('track/register/', views.user_register, name='user_register'),
    path('track/logout/', views.user_logout, name='user_logout'),
    path('track/add_weight_entry/', views.add_weight_entry, name='add_weight_entry'),
    path('track/get_weight_entries/', views.get_weight_entries, name='get_weight_entries'),
    path('track/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('track/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
]
