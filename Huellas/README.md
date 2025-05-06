# Huellas - Aplicación de Adopción de Mascotas

## Descripción
**Huellas** es una solución desarrollada en Salesforce para gestionar y registrar las adopciones de mascotas. Este proyecto tiene como objetivo facilitar el proceso de adopción a través de una plataforma organizada y funcional, implementando componentes clave y automatizaciones que garantizan la integridad de los datos y una experiencia óptima para los usuarios.

## Características Principales

### Modelo de Datos
La aplicación utiliza cuatro objetos personalizados:
1. **Contacto**:
   - Campos estándar: Nombre, Teléfono, Fecha de Nacimiento, Correo Electrónico.
   - Campo fórmula: Edad (calculada en base a la fecha de nacimiento).

2. **Mascota**:
   - Campos: Nombre, Especie (Picklist), Raza (Picklist dependiente), Fecha de Última Vacunación, Fecha de Próxima Vacunación.

3. **Adopción**:
   - Campos: Nombre (Numeración automática), Estado (Picklist con valores automáticos), Fecha, Contacto (relación), Mascota (relación).

4. **Historial de Vacunación**:
   - Campos: Nombre (Numeración automática), Lugar, Fecha, Mascota (relación).

### Automatizaciones Implementadas
- **Estados de Adopción Automáticos**:
  - Estado inicial: "Abierto".
  - Cambios automáticos basados en procesos de aprobación y acciones del usuario.
  
- **Validaciones**:
  - Prohibir adopciones con fechas anteriores a hoy.
  - Verificar que el contacto tenga al menos 18 años para adoptar.
  - Validar que la fecha de adopción no sea posterior al mes en curso.
  - Evitar duplicados de contacto con el mismo correo electrónico.

### Componentes Técnicos
1. **Componente LWC para Visualización de Adopciones**:
   - Muestra información detallada del contacto, la mascota y el estado de la adopción.
   - Incluye un sello visual cuando una mascota ha sido adoptada.

2. **Trabajo Batch para Recordatorio de Vacunación**:
   - Un job diario en Apex que genera tareas para mascotas con vacunación pendiente.

3. **Certificado de Mascota**:
   - Acción rápida para generar un PDF dinámico con información de la mascota.

4. **Flujo de Pantalla para Confirmación de Código**:
   - Permite finalizar una adopción validando un código de adopción.

5. **Triggers en Apex**:
   - Actualización automática de la fecha de próxima vacunación usando metadatos personalizados.
   - Relleno de la fecha de última vacunación al crear un historial de vacunación.

### Informes y Dashboards
- Creación de informes personalizados y dashboards para monitorear indicadores clave de adopciones, vacunaciones y estado general de la plataforma.

## Configuración del Proyecto
1. Clonar el repositorio:
   ```bash
   git clone https://github.com/Linda-Reyes/Huellas.git
.

