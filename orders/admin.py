from django.contrib import admin
from .models import Order, OrderItem

# admin.site.register(Order)
@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ["user", "created", "total_paid", "order_key", "billing_status"]


# admin.site.register(OrderItem)
@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    list_display = ["order", "product", "price", "quantity"]
