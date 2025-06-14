# 📸 Facial Access Control System

Un sistema de control de acceso inteligente por reconocimiento facial, desarrollado con **Flutter**, **Google ML Kit**, **AWS Rekognition** y **Node.js**. Esta solución permite autenticar y registrar usuarios de forma eficiente, almacenando los registros de accesos en una base de datos relacional, con control de roles y gestión de espacios.

---

## 🚀 Tecnologías utilizadas

- **Frontend**: [Flutter](https://flutter.dev/)
- **Reconocimiento facial en el dispositivo**: [Google ML Kit Face Detection](https://developers.google.com/ml-kit/vision/face-detection/flutter)
- **Reconocimiento facial en la nube**: [AWS Rekognition](https://aws.amazon.com/rekognition/)
- **Almacenamiento de imágenes**: [Amazon S3](https://aws.amazon.com/s3/)
- **Backend API**: [Node.js](https://nodejs.org/) + [Express.js](https://expressjs.com/)
- **Base de datos relacional**: MySQL / PostgreSQL (ajustable según entorno)
- **Autenticación y roles**: Sistema propio con soporte para estudiantes, profesores, administrativos y super administradores

---

## 🧠 Arquitectura general

Flutter App (Mobile)

│
├── Google ML Kit (detección facial local)

│
├── API REST (Node.js + Express)

│   ├── Subida de imágenes a AWS S3

│   ├── Comparación facial con AWS Rekognition

│   ├── Registro y autenticación de usuarios

│   └── Control de acceso con historial

│
└── Base de datos relacional (usuarios, roles, accesos)



## 📲 Funcionalidades clave

### 👤 Registro de usuarios
- Captura facial inicial con cámara.
- Almacenamiento de imagen en **AWS S3**.
- Registro de datos del usuario y su rol (estudiante, profesor, etc.).

### 🔐 Autenticación facial
- Captura en tiempo real y detección facial con **Google ML Kit**.
- Imagen enviada al backend para verificación con **AWS Rekognition**.
- Validación de coincidencia y control de acceso.

### 🏫 Control de espacios
- Asociación de usuarios a espacios físicos definidos.
- Acceso controlado y registrado con fecha y hora.

### 📚 Roles del sistema
- **Estudiante**: Solo accede a espacios permitidos.
- **Profesor**: Puede ver registros y validar accesos.
- **Administrativo**: Gestión parcial de espacios y usuarios.
- **Super Admin**: Control total del sistema y acceso a todos los módulos.

---

## ⚙️ Instalación del backend

- git clone 
- cd project
- npm install
- npm start

## Configura variables de entorno de AWS, base de datos y Rekognition

- AWS_ACCESS_KEY_ID=your_access_key
- AWS_SECRET_ACCESS_KEY=your_secret_key
- AWS_REGION=us-east-1
- AWS_S3_BUCKET_NAME=your_bucket_name
- REKOGNITION_COLLECTION_ID=your_collection_id

- DB_HOST=localhost
- DB_USER=root
- DB_PASSWORD=your_password
- DB_NAME=facial_access_db
- PORT=3000



