from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from .models import UserBase

admin.site.register(UserBase)


# @admin.register(UserBase)
# class CustomUserAdmin(UserAdmin):
#     list_display = ('user_name', 'pk')
#     ordering = ['user_name']