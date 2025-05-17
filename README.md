# 🎬 Películas Backend

API backend desarrollada con **Symfony**, destinada a gestionar películas y usuarios de forma eficiente y segura.

## 🚀 Estructura del Proyecto

```plaintext
peliculas-backend/
│
├── bin/                    # Ejecutables, especialmente el archivo "console" para comandos CLI
│
├── config/                 # Configuración general del proyecto
│   ├── packages/           # Configuraciones específicas de bundles (doctrine.yaml, security.yaml, etc.)
│   ├── routes/             # Definición de rutas (YAML, PHP)
│   └── services.yaml       # Configuración de servicios e inyección de dependencias
│
├── public/                 # Raíz pública web (index.php y assets: imágenes, CSS, JS)
│
├── src/                    # Código fuente PHP principal
│   ├── Controller/         # Controladores HTTP
│   ├── Entity/             # Entidades Doctrine (modelos de base de datos)
│   ├── Repository/         # Repositorios para consultas personalizadas
│   ├── Security/           # Clases relacionadas con seguridad (Users, Voters, Providers)
│   ├── Service/            # Servicios con lógica de negocio reusable
│   └── ...                 # Otros directorios según necesidad (EventListener, DTOs, etc.)
│
├── templates/              # Plantillas Twig para frontend (si aplica)
│
├── translations/           # Archivos para traducciones y localización
│
├── var/                    # Archivos temporales, caché y logs
│
├── vendor/                 # Dependencias instaladas vía Composer
│
├── .env                    # Variables de entorno (configuración sensible)
├── composer.json           # Gestión de dependencias y scripts Composer
├── symfony.lock            # Control de versiones para Symfony Flex recipes
└── README.md               # Documentación del proyecto

## 🌿 Flujo de trabajo con ramas

Para un desarrollo organizado y modular, se utilizan ramas específicas para la funcionalidad de usuarios:

- `feature-users-entities`: definición y gestión de entidades relacionadas con usuarios.
- `feature-users-register`: desarrollo de la funcionalidad de registro de usuarios.
- `feature-users-login`: implementación del inicio de sesión.
- `feature-users-jwt`: gestión de autenticación mediante tokens JWT.

Cada rama parte de `main` (o `develop`) y se integran cuando la funcionalidad está testeada y lista para producción. Esta organización facilita la colaboración y el control de versiones.

---

¡Bienvenido al proyecto! Si tienes dudas o sugerencias, no dudes en contribuir.
