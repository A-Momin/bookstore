from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import UserBase

# admin.site.register(UserBase)


@admin.register(UserBase)
class CustomUserAdmin(UserAdmin):
    list_display = ('pk', 'user_name')
    ordering = ['user_name']