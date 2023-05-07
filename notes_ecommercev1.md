## Ecommerce Store (2021) - Part 1: Building models, views and testing

---

### How to start the most basic Django project?

0. Create & activate the environment

    - `$ conda create -n django-env python=3.8 -y` → Create a environment with the given name, env_name
    - `$ cae django-env`
    - `$ pip install django` → install django in the activated conda environment.
    - `$ pip3 install -r requirements.txt` → Install the packages from 'requirment.txt' file if you have any.

1. Make the Directory where Django project will be created

    - `$ mkdir bookstore`

2. `cd` into the newly created directory

    - `$ cd bookstore`

3. Create the Django project in the current Directory

    - `$ django-admin startproject core .`

4. Run the Django Server:

    - `$ python manage.py runserver localhost:8000`

5. Now checkout the `localhost:8000`

    - Observation:
        - The pre-built Django home page is rendered.

6. How to stop the Django Server:

    - `$ ^ + c` #
    - `$ ps -ax | grep 'python manage.py runserver'` # Find the Django `runserver` process.
    - `$ kill <PID>` # to kill django `runserver` process by process ID.

7. Migrate Data:

    - `$ python manage.py makemigrations`
        - The `makemigrations` command looks at all your available models and creates migrations for whichever tables don’t already exist. `migrate` runs the migrations and creates tables in your database, as well as optionally providing much richer schema control.
        - By running makemigrations, you’re telling Django that you’ve made some changes to your models and that you’d like the changes to be stored as a migration.
        - `makemigrations` command create a file under `app_name/migrations/` with the database structure to create
    - `$ python manage.py migrate`
        - `migrate`: The migrate command takes all the migrations that haven’t been applied (Django tracks which ones are applied using a special table in your database called django_migrations) and runs them against your database - essentially, synchronizing the changes you made to your models with the schema in the database.
    - Observations:
        - the `db.sqlite3` file is created.
        - The data is stored in the database.

8. Create a superuser:

    - `$ python manage.py createsuperuser`→ Create admin user.
        ```yaml
        # Created admin user with following credentials:
        username: a.momin
        password: 1111
        email: a.momin.nyc@gmail.com
        ```
    - Run the Database (db.sqlite3) file with SQLITE EXPLORER (a VSCode Tool)
    - Observations:
        - The data is stored in the database.

9. Checkout Django admin page at `localhost:8000/admin`
    - Observation:
        - The default login page is rendered.
    - Login using the super user credentials from the last step.
    - Logout clicking the `logout` button on the home admin page.

### How to Create and Start a Django App?

-   Notes:

    -   In the context of web development using the Django framework, a project refers to a collection of settings, configurations, and apps that make up a complete web application. An app, on the other hand, refers to a self-contained module that performs a specific function within the project.
    -   A Django project typically consists of multiple apps that work together to create a cohesive web application. Each app focuses on a specific feature or functionality of the web application, such as user authentication, database management, or content management.

0. Create a Django App by the name of `store`.

    - `$ python manage.py startapp store`

1. Register the newly created App by appending it's name into `INSTALLED_APPS` as follows.

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
    - Update the projects's setting file (core/settings.py)

        ```python
        # core/settings.py
        MEDIA_URL = '/media/'
        MEDIA_ROOT = os.path.join(BASE_DIR, 'media/')
        ...
        ```

4. Create the `namespace` url for the `store` app.

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

9. Register project templates.

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

10. Create Templates

    - Create the base template (`templates/store/base.html`).
    - Create the home template.

        ```html
        <!-- templates/store/home.html  -->

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
                    <div
                        class="d-flex justify-content-between align-items-center"
                    >
                        <small class="text-muted">9min read</small>
                    </div>
                </div>
            </div>
        </div>

        {% endfor %}
        ```

11. Migrate Data

    - `$ python manage.py makemigrations`
        - The `makemigrations` command looks at all your available models and creates migrations for whichever tables don’t already exist. `migrate` runs the migrations and creates tables in your database, as well as optionally providing much richer schema control.
        - By running makemigrations, you’re telling Django that you’ve made some changes to your models and that you’d like the changes to be stored as a migration.
        - makemigrations Create a file under `app_name/migrations/` with the database structure to create
    - `$ python manage.py migrate`
        - `migrate`: The migrate command takes all the migrations that haven’t been applied (Django tracks which ones are applied using a special table in your database called django_migrations) and runs them against your database - essentially, synchronizing the changes you made to your models with the schema in the database.
    - Observations:
        - `db.sqlite3` file is created in the base directory.
        - Data is migrated into the database.

12. Create `Fixtures` and upload data into your app.

    - `$ mkdir store/fixtures` → Make 'fixtures' directory
    - `$ touch store/fixtures/categories.json` → Create a fixture by the name of 'categories'.
    - `$ touch store/fixtures/books.json` → Create a fixture by the name of 'books'.
    - `$ python manage.py loaddata categories.json` → Load the categories fixture into the app
    - `$ python manage.py loaddata books.json` → Load the books fixture into the app

13. Check connection using `telnet`/`curl` (Optional)

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

14. [How to install Django Debugger Tool](https://django-debug-toolbar.readthedocs.io/en/latest/installation.html#installation)

---

## Ecommerce Store (2021) - Part 2: Basket with session handling

---

### How to set up and use Session:

![How session in Django works](/assets/django-session-steps.png)

-   [How to use sessions](https://docs.djangoproject.com/en/4.1/topics/http/sessions/)

1.  Create a new `basket` App.

    -   `$ python manage.py startapp basket` → Create a Django App by the name of `basket`

2.  Register the `basket` app by appending it's name into `INSTALLED_APPS` as follows.

    ```python
    # core/settings.py
    INSTALLED_APPS = [
        ...,
        'basket',
        ...,
    ]
    ```

3.  Configure the urls for `basket` app

    ```python
    # core/urls.py
    from django.conf import settings
    from django.conf.urls.static import static

    urlpatterns = [
        ...,
        path('basket/', include('basket.urls', namespace='basket')),
    ]
    ```

    ```python
    # basket/urls.py
    from django.urls import path
    from . import views

    app_name = 'basket'

    urlpatterns = [
        path('', views.basket_summary, name='basket_summary'),
        path('add/', views.basket_add, name='basket_add'),
        path('delete/', views.basket_delete, name='basket_delete'),
        path('update/', views.basket_update, name='basket_update')
    ]
    ```

4.  Create `Basket` object:

    ```python
    # basket/basket.py
    from decimal import Decimal
    from store.models import Product


    class Basket():
        def __init__(self, request):
            pass

        def add(self, product, qty):
            pass

        def __iter__(self):
            pass

        def __len__(self):
            pass

        def save(salf):
            pass

        def update(self, product, qty):
            pass

        def delete(self, product):
            pass

        def get_total_price(self):
            pass
    ```

5.  Create and register a context processor:

    ```python
    # basket/context_processors.py
    from .basket import Basket

    def basket(request):
        return {'basket': Basket(request)}
    ```

    ```python
    # core/settings.py
    TEMPLATES = [
        {
            ...,
            'OPTIONS': {
                'context_processors': [
                    ...,
                    'basket.context_processors.basket'
                ],
            },
        },
    ]
    ```

6.  Create the viewes for the app

    ```python
    # basket/views.py
    from django.http import JsonResponse
    from django.shortcuts import get_object_or_404, render
    from store.models import Product
    from .basket import Basket

    def basket_summary(request):
        pass

    def basket_add(request):
        pass

    def basket_delete(request):
        pass

    def basket_update(request):
        pass
    ```

7.  Create the template (`templates/basket/summary.html`)

    ```html
    <!-- templates/basket/summary.html -->

    ...

    <script>
        $(document).on("click", ".delete-button", function (e) {
            ...
        });

        $(document).on("click", ".update-button", function (e) {
            ...
        });
    </script>
    ```

8.  update `templates/store/products/single.html`

    ```html
    <!-- templates/store/products/single.html -->
    ...

    <script>
        $(document).on("click", "#add-button", function (e) {
            ...
        });
    </script>
    ```

## Ecommerce Store (2021) - Part 3: Build a user, payment and order management system

---

-   [Youtube](https://www.youtube.com/watch?v=ncsCnC3Ynlw&list=PLOLrQ9Pn6caxY4Q1U9RjO1bulQp5NDYS_&index=3&t=3956s)

### Implement a registration system using a form build from scratch.

0. Start the `account` app.

    - `$ python manage.py startapp account`

1. Register the app and add the `AUTH_USER_MODEL` parameter to the settings(`core/settings.py`).

    ```python
    # core/settings.py
    INSTALLED_APPS = [
    ...
    'account',
    ]
    ...
    AUTH_USER_MODEL = 'account.UserBase'
    ...
    ```

2. Create custom user (UserBase) and custom manager (CustomAccountManager) model.

    ```python
    # account/models.py
    class CustomAccountManager(BaseUserManager):

        def create_superuser(self, email, user_name, password, **other_fields):
            pass
        def create_user(self, email, user_name, password, **other_fields):
            pass


    class UserBase(AbstractBaseUser, PermissionsMixin):
        ...
        objects = CustomAccountManager()
    ```

3. Resister the custom user with the admin site.

    ```python
    from django.contrib import admin
    from .models import UserBase

    admin.site.register(UserBase)
    ```

4. Register the App and add an required parameter into `settings.py`.

    ```python
    # core/settings.py
    INSTALLED_APPS = [
    ...
    'account',
    ]
    ...
    AUTH_USER_MODEL = 'account.UserBase'
    ...
    ```

5. Update product model in the store app.

    ```python
    # store/models.py
    class Product(models.Model):
        ...
        created_by = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='product_creator', on_delete=models.CASCADE)
        ...
    ```

6. Update project urls and create the app urls.

    ```python
    # core/urls.py
    urlpatterns = [
        ...,
        path('account/', include('account.urls', namespace='account')),
    ]
    ```

    ```python
    # account/urls.py
    app_name = 'account'
    urlpatterns = [
        path('dashboard/', views.dashboard, name='dashboard'),
        path('register/', views.account_register, name='register'),
        path('activate/<slug:uidb64>/<slug:token>/', views.account_activate, name='activate'),
    ]
    ```

7. Create the registration model form.

    ```python
    # account/forms.py
    class RegistrationForm(forms.ModelForm):

    user_name = forms.CharField(label='Enter Username', min_length=4, max_length=50, help_text='Required')
    email = forms.EmailField(max_length=100, help_text='Required', error_messages={'required': 'Sorry, you will need an email'})
    password = forms.CharField(label='Password', widget=forms.PasswordInput)
    password2 = forms.CharField(label='Repeat password', widget=forms.PasswordInput)

    class Meta:
        model = UserBase
        fields = ('user_name', 'email',)

    def clean_user_name(self):
        pass
    def clean_password2(self):
        pass
    def clean_email(self):
        pass

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['user_name'].widget.attrs.update({'class': 'form-control mb-3', 'placeholder': 'Username'})
        self.fields['email'].widget.attrs.update({'class': 'form-control mb-3', 'placeholder': 'E-mail', 'name': 'email', 'id': 'id_email'})
        self.fields['password'].widget.attrs.update({'class': 'form-control mb-3', 'placeholder': 'Password'})
        self.fields['password2'].widget.attrs.update({'class': 'form-control', 'placeholder': 'Repeat Password'})
    ```

8. Create a Token object.

    ```python
    # account/token.py
    class AccountActivationTokenGenerator(PasswordResetTokenGenerator):
    def _make_hash_value(self, user, timestamp):
        pass

    account_activation_token = AccountActivationTokenGenerator()
    ```

9. Create the account views.

    ```python
    @login_required
    def dashboard(request):
        return render(request, 'account/user/dashboard.html')

    # account/views.py
    def account_register(request):
        pass
    def account_activate(request, uidb64, token):
        pass
    ```

10. Set `EMAIL_BACKEND` parameter

    - The EMAIL_BACKEND parameter is used to specify the email delivery backend that should be used by the application for sending emails.
    - By default, Django uses the SMTP backend, which is a simple email backend that sends email messages using the Simple Mail Transfer Protocol (SMTP). However, Django provides a variety of other email backends that can be used depending on your application's requirements.
    - For example, if you want to use the console backend for testing and development purposes, you can define the EMAIL_BACKEND setting like this:

    ```python
    # core/settings.py
    ...
    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
    ```

11. Create the registration Templates

    - create `templates/account/user/dashboard.html`
    - create `templates/account/registration/register.html`
    - create `templates/account/registration/account_activation_email.html`
    - create `templates/account/registration/activation_invalid.html`

12. Test the registration routes:
    - Checkout:
        - `account/register/`
        - `account/'activate/<slug:uidb64>/<slug:token>/'`
        -

### Implement the login & logout system

0.  Create the login URL using built-in Classed-based views.

    ```python
    # account/urls.py
    urlpatterns = [
        ...
        path('login/', auth_views.LoginView.as_view(template_name='account/registration/login.html', form_class=UserLoginForm), name='login'),
    ]
    ```

1.  Add the following setting parameters into setting file.

    -   The `LOGIN_REDIRECT_URL` parameter is used to specify the URL where the user should be redirected after they have successfully logged in.
    -   The `LOGIN_URL` parameter is used to specify the URL where the user should be redirected if they try to access a protected resource without being authenticated.

    ```python
    # core/setting.py
    ...
    LOGIN_REDIRECT_URL = '/account/dashboard'
    LOGIN_URL = '/account/login/'
    ```

2.  Create the user login model form.

    ```python
    # account/forms.py
    class UserLoginForm(AuthenticationForm):
        username = forms.CharField(widget=forms.TextInput(attrs={'class': 'form-control mb-3', 'placeholder': 'Username', 'id': 'login-username'}))
        password = forms.CharField(widget=forms.PasswordInput(attrs={'class': 'form-control', 'placeholder': 'Password', 'id': 'login-pwd',}))
    ```

3.  Create the login template (`template/accoint/registration/login.html`)

4.  Assign the login url with the login button on base template (`template/store/base.html`)

    ```html
    <!-- template/store/base.html -->
    ...

    <a
        type="button"
        role="button"
        href="{% url 'account:login' %}"
        class="btn btn-outline-secondary border-0 basket-btn"
    >
        <div>
            <svg
                xmlns="http://www.w3.org/2000/svg"
                width="22"
                height="22"
                fill="currentColor"
                class="bi bi-door-closed"
                viewBox="0 0 16 16"
            >
                <path
                    d="M3 2a1 1 0 0 1 1-1h8a1 1 0 0 1 1 1v13h1.5a.5.5 0 0 1 0 1h-13a.5.5 0 0 1 0-1H3V2zm1 13h8V2H4v13z"
                />
                <path d="M9 9a1 1 0 1 0 2 0 1 1 0 0 0-2 0z" />
            </svg>
        </div>
        <span class="fs15 fw500">Login</span>
    </a>
    ```

5.  Link the login url with the `Already have an account?` button on register template (`template/account/register.html`)

6.  Create the logout URL using built-in Classed-based views

    ```python
    # account/urls.py
    urlpatterns = [
        ...
        path('logout/', auth_views.LogoutView.as_view(next_page='/account/login/'), name='logout'),
    ]
    ```
