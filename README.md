# Gestor de Gastos Personales

Una aplicación móvil desarrollada en Flutter para gestionar finanzas personales, permitiendo registrar ingresos y egresos, categorizar gastos y visualizar un resumen mensual.

## Características

- 🔐 **Autenticación de usuarios** con Firebase Auth
- 💰 **Registro de transacciones** (ingresos y gastos)
- 📊 **Categorización** de transacciones
- 📈 **Resumen mensual** con balance
- 🌙 **Tema claro/oscuro** con Provider
- 📱 **Interfaz moderna** y responsiva
- ☁️ **Persistencia de datos** con Firestore

## Tecnologías Utilizadas

- **Flutter** - Framework de desarrollo móvil
- **Firebase Auth** - Autenticación de usuarios
- **Cloud Firestore** - Base de datos en la nube
- **Provider** - Gestión de estado
- **Material Design 3** - Sistema de diseño

## Estructura del Proyecto

```
lib/
├── auth/
│   └── auth_gate.dart          # Control de autenticación
├── components/
│   ├── category_card.dart      # Tarjeta de categoría
│   ├── my_button.dart          # Botón personalizado
│   ├── my_text_field.dart      # Campo de texto personalizado
│   └── transaction_card.dart   # Tarjeta de transacción
├── models/
│   ├── category.dart           # Modelo de categoría
│   ├── transaction.dart        # Modelo de transacción
│   └── user.dart              # Modelo de usuario
├── pages/
│   ├── add_transaction_page.dart # Página para agregar/editar transacciones
│   ├── categories_page.dart    # Página de gestión de categorías
│   ├── home_page.dart          # Página principal
│   ├── login_page.dart         # Página de inicio de sesión
│   ├── register_page.dart      # Página de registro
│   └── settings_page.dart      # Página de configuración
├── services/
│   ├── auth_service.dart       # Servicio de autenticación
│   ├── category_service.dart   # Servicio de categorías
│   └── transaction_service.dart # Servicio de transacciones
├── themes/
│   ├── dark_mode.dart          # Tema oscuro
│   ├── light_mode.dart         # Tema claro
│   └── theme_provider.dart     # Proveedor de temas
├── firebase_options.dart       # Configuración de Firebase
└── main.dart                   # Punto de entrada de la aplicación
```

## Funcionalidades Implementadas

### Autenticación
- Registro de nuevos usuarios
- Inicio de sesión
- Cierre de sesión
- Validación de formularios

### Gestión de Transacciones
- Agregar nuevas transacciones (ingresos/gastos)
- Editar transacciones existentes
- Eliminar transacciones
- Visualización por mes
- Categorización automática

### Gestión de Categorías
- Categorías predefinidas para nuevos usuarios
- Edición de categorías existentes
- Eliminación de categorías
- Filtrado por tipo (ingreso/gasto)

### Resumen Financiero
- Balance mensual
- Total de ingresos
- Total de gastos
- Navegación entre meses

### Configuración
- Cambio de tema (claro/oscuro)
- Información del usuario
- Ayuda y información de la app

## Requisitos del Proyecto

Este proyecto cumple con los siguientes requisitos académicos:

- ✅ **Navegación entre pantallas** - Implementada con Navigator
- ✅ **Widgets Stateless y Stateful** - Utilizados en toda la aplicación
- ✅ **Gestión de estado con Provider** - Para el tema y datos globales
- ✅ **Tema claro/oscuro** - Con ChangeNotifier
- ✅ **Firebase Auth** - Autenticación completa
- ✅ **Firestore** - Persistencia de datos
- ✅ **Estructura modular** - Código organizado y reutilizable

## Instalación y Configuración

### Prerrequisitos
- Flutter SDK (versión 3.9.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Cuenta de Firebase

### Pasos de instalación

1. **Clonar el repositorio**
   ```bash
   git clone <repository-url>
   cd balance_app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   - Crear un proyecto en [Firebase Console](https://console.firebase.google.com/)
   - Habilitar Authentication (Email/Password)
   - Habilitar Firestore Database
   - Descargar `google-services.json` (Android) y `GoogleService-Info.plist` (iOS)
   - Colocar los archivos en las carpetas correspondientes

4. **Generar configuración de Firebase**
   ```bash
   flutterfire configure
   ```

5. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## Uso de la Aplicación

1. **Registro/Login**: Crea una cuenta o inicia sesión
2. **Agregar Transacciones**: Usa el botón + para registrar ingresos o gastos
3. **Categorizar**: Selecciona la categoría apropiada para cada transacción
4. **Ver Resumen**: Consulta tu balance mensual en la pantalla principal
5. **Gestionar Categorías**: Personaliza las categorías desde el menú
6. **Configurar**: Cambia el tema y ajusta configuraciones

## Contribución

Este proyecto fue desarrollado como parte de un curso académico. Para contribuir:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## Equipo de Desarrollo

- [Nombre del integrante 1] - Desarrollo y diseño
- [Nombre del integrante 2] - Backend y Firebase
- [Nombre del integrante 3] - UI/UX y componentes
- [Nombre del integrante 4] - Testing y documentación
- [Nombre del integrante 5] - Gestión de proyecto

## Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para detalles.

## Fecha de Entrega

**24 de septiembre de 2025** - Proyecto final y sustentación

---

*Desarrollado con ❤️ usando Flutter y Firebase*