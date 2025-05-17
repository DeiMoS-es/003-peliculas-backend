peliculas-backend/
│
├── bin/                    # Ejecutables, principalmente el archivo "console" para comandos CLI
│
├── config/                 # Configuración del proyecto (rutas, servicios, paquetes, seguridad)
│   ├── packages/           # Configuración específica de bundles (doctrine.yaml, security.yaml, etc)
│   ├── routes/             # Rutas del proyecto, pueden estar en varios archivos YAML o PHP
│   └── services.yaml       # Configuración general de servicios (inyección de dependencias)
│
├── public/                 # Carpeta pública, raíz web, donde va index.php (punto de entrada)
│                           # También aquí se ponen assets públicos (imágenes, CSS, JS)
│
├── src/                    # Código PHP principal del proyecto
│   ├── Controller/         # Controladores (clases que responden a rutas HTTP)
│   ├── Entity/             # Entidades Doctrine (modelos que representan tablas de la base de datos)
│   ├── Repository/         # Repositorios para consultas personalizadas de entidades
│   ├── Security/           # Clases relacionadas con la seguridad (User, Voters, Providers)
│   ├── Service/            # Servicios (clases con lógica de negocio reusable)
│   └── ...                 # Puedes crear más carpetas según necesidad (EventListener, DTOs, etc)
│
├── templates/              # Plantillas Twig para vistas (si haces frontend con Symfony)
│
├── translations/           # Archivos de traducción (idiomas)
│
├── var/                    # Archivos temporales, cachés, logs
│
├── vendor/                 # Dependencias instaladas con Composer
│
├── .env                    # Variables de entorno para configuración (bd, APP_ENV, etc)
├── composer.json           # Definición de dependencias PHP y scripts de Composer
├── symfony.lock            # Control de versiones de recetas de Symfony Flex
└── README.md               # Información del proyecto (si la tienes)


## Flujo de trabajo con ramas

Para organizar el desarrollo de la funcionalidad de usuarios, seguimos esta convención de ramas:

- `feature-users-entities`: para la creación y gestión de las entidades relacionadas con usuarios.
- `feature-users-register`: para la implementación del registro de usuarios.
- `feature-users-login`: para la funcionalidad de inicio de sesión.
- `feature-users-jwt`: para la implementación y gestión de tokens JWT para autenticación.

Esta estructura ayuda a mantener el proyecto organizado y facilita la colaboración en tareas específicas sin conflictos.

---

Las ramas se crean a partir de `main` o `develop` y se hacen merge cuando la funcionalidad está probada y lista para integración.
