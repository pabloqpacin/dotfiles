# PHP setup


## arch linux

- Instala les paquetes

```bash
sudo pacman -Syu php composer

```

- Código boilerplate

```php
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello, World!</title>
    <style>
        body {
            background-color: #333;
            color: #fff;
            /* font-family: 'Arial', sans-serif; */
            font-family: system-ui, -apple-system, 'Segoe UI', Roboto, Ubuntu, sans-serif;
            text-align: center;
            padding: 20px;
        }
    </style>
</head>
<body>
    <?php
        echo "Hello, World!";
    ?>
</body>
</html>
```


- Correr en el navegador

```bash
php -S localhost:8000
```