## Ecommerce Store (2021) - Part 1: Building models, views and testing

---

### How to start the most basic Django project?

2. Create & activate the environment:

    - `$ conda create -n django-env python=3.8 -y` → Create a environment with the given name, env_name
    - `$ cae django-env`
    - `$ pip install django` → install django in the activated conda environment.
    - `$ pip3 install -r requirements.txt` → Install the packages from 'requirment.txt' file if you have any.

3. Make the Directory where Django project will be created:

    - `$ mkdir bookstore`

4. Change directory into the directory:

    - `$ cd bookstore`

5. Start the Django project in the current Directory:

    - `$ django-admin startproject core .`

6. Run the Django Server:

    - `$ python manage.py runserver localhost:8000`

7. Now checkout the `localhost:8000`

8. How to stop the Django Server:

    ```bash
    ps -ax | grep 'python manage.py runserver'  # Find the Django `runserver` process.
    kill <PID>  # to kill django `runserver` process by process ID.
    ```

9. Migrate Data:

    - `$ python manage.py makemigrations`
        - The `makemigrations` command looks at all your available models and creates migrations for whichever tables don’t already exist. `migrate` runs the migrations and creates tables in your database, as well as optionally providing much richer schema control.
        - By running makemigrations, you’re telling Django that you’ve made some changes to your models and that you’d like the changes to be stored as a migration.
        - `makemigrations` command create a file under `app_name/migrations/` with the database structure to create
    - `$ python manage.py migrate`
        - `migrate`: The migrate command takes all the migrations that haven’t been applied (Django tracks which ones are applied using a special table in your database called django_migrations) and runs them against your database - essentially, synchronizing the changes you made to your models with the schema in the database.
    - Observations on Database:
        -
        -

10. Create a superuser:

    - `$ python manage.py createsuperuser`→ Create admin user.

    ```yaml
    # Created admin user with following credentials:
    username: a.momin
    password: 1111
    email: a.momin.nyc@gmail.com
    ```

11. Checkout Django admin page at `localhost:8000/admin`

### How to Create and Start a Django App?

-   Note:

    -   In the context of web development using the Django framework, a project refers to a collection of settings, configurations, and apps that make up a complete web application. An app, on the other hand, refers to a self-contained module that performs a specific function within the project.
    -   A Django project typically consists of multiple apps that work together to create a cohesive web application. Each app focuses on a specific feature or functionality of the web application, such as user authentication, database management, or content management.

-   `$ python manage.py startapp store` → Create Django App by the name of `store`

1. Register the newly created App by appending it into `INSTALLED_APPS`.

    ```python
    # core/settings.py
    INSTALLED_APPS = [
        ...,
        'store',
    ]
    ```

2. Create models of your store [10:46 - ]

    ```python
    # store/models.py
    from django.contrib.auth.models import User
    from django.db import models
    from django.urls import reverse

    class ProductManager(models.Manager):
        ...

    class Category(models.Model):
        ...

    class Product(models.Model):
        ...
    ```

3. Create & config Media Folder [31:41 - 36:26]

    - For image to be loaded, we need to create the media folder and configure it.

    - `$ mkdir media`

    ```python
    # core/settings.py
    MEDIA_URL = '/media/'
    MEDIA_ROOT = os.path.join(BASE_DIR, 'media/')
    ...
    ```

4. Create the url `namespane` for the new app.

    ```python
    # core/urls.py
    from django.conf import settings
    from django.conf.urls.static import static

    urlpatterns = [
        ...,
        path('', include('store.urls', namespace='store')),
    ]

    if settings.DEBUG:
        urlpatterns += static(settings.MEDIA_URL, document_root = settings.MEDIA_ROOT)
    ```

5. Create the urls for the app

    ```python
    # store/urls.py
    from django.urls import path
    from . import views

    app_name = 'store'

    urlpatterns = [
        path('', views.product_all, name='product_all'),
        path('<slug:slug>', views.product_detail, name='product_detail'),
        path('shop/<slug:category_slug>/', views.category_list, name='category_list'),
    ]
    ```

6. Register custom models to Django's Admin features

    ```python
    # store/admin.py
    from django.contrib import admin
    from .models import Category, Product

    @admin.register(Category)
    class CategoryAdmin(admin.ModelAdmin):
        ...

    @admin.register(Product)
    class ProductAdmin(admin.ModelAdmin):
        ...
    ```

7. Create Views [01:19:16]

    ```python
    # store/views.py
    from django.shortcuts import get_object_or_404, render
    from .models import Category, Product

    def product_all(request):
        products = Product.products.all()
        return render(request, 'store/home.html', {'products': products})

    def category_list(request, category_slug=None):
        ...

    def product_detail(request, slug):
        ...
    ```

8. Create and register Context Processor. [01:38:36]

    ```python
    # store/context_processors.py
    from .models import Category

    def categories(request):
        return {
            'categories': Category.objects.all()
        }
    ```

    ```python
    # core/settings.py
    TEMPLATES = [
        {
            ...,
            'OPTIONS': {
                'context_processors': [
                    ...,
                    'store.context_processors.categories'
                ],
            },
        },
    ]
    ```

9. Create Templates

    ```python
    # core/settings.py
    TEMPLATES = [
        {
            ...,
            'DIRS': [BASE_DIR/'templates'],
            ...,
        },
    ]
    ```

    ```html
    <!-- templates/home.html  -->

    {% for product in products %}

    <div class="col">
        <div class="card shadow-sm">
            <img
                class="img-fluid"
                alt="Responsive image"
                src="{{ product.image.url }}"
            />
            <div class="card-body">
                <p class="card-text">
                    <a
                        class="text-dark text-decoration-none"
                        href="{{ product.get_absolute_url }}"
                        >{{ product.title }}</a
                    >
                </p>
                <div class="d-flex justify-content-between align-items-center">
                    <small class="text-muted">9min read</small>
                </div>
            </div>
        </div>
    </div>

    {% endfor %}
    ```

10. Migrate Data

    - `$ python manage.py makemigrations`
        - The `makemigrations` command looks at all your available models and creates migrations for whichever tables don’t already exist. `migrate` runs the migrations and creates tables in your database, as well as optionally providing much richer schema control.
        - By running makemigrations, you’re telling Django that you’ve made some changes to your models and that you’d like the changes to be stored as a migration.
        - makemigrations Create a file under `app_name/migrations/` with the database structure to create
    - `$ python manage.py migrate`

        - `migrate`: The migrate command takes all the migrations that haven’t been applied (Django tracks which ones are applied using a special table in your database called django_migrations) and runs them against your database - essentially, synchronizing the changes you made to your models with the schema in the database.

    - Observations on Database:
        -
        -

11. Create `Fixtures` and upload data into your app.

    - `$ mkdir store/fixtures` → Make 'fixtures' directory
    - `$ touch store/fixtures/categories.json` → Create a fixture by the name of 'categories'.
    - `$ touch store/fixtures/books.json` → Create a fixture by the name of 'books'.
    - `$ python manage.py loaddata categories.json` → Load the categories fixture into the app
    - `$ python manage.py loaddata books.json` → Load the books fixture into the app

12. Check connection using `telnet`/`curl` (Optional)

    - `$ curl -v localhost:8010`
    - `$ telnet localhost 8000`
        ```txt
        Trying ::1...
        telnet: connect to address ::1: Connection refused
        Trying 127.0.0.1...
        Connected to localhost.
        Escape character is '^]'.
        ======= THEN TYPE: =======
        GET / HTTP/1.0
        Host: localhost
        ```

13. [How to install Django Debugger Tool](https://django-debug-toolbar.readthedocs.io/en/latest/installation.html#installation)
