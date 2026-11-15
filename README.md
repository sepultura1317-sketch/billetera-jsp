# Caso 1: Billetera Digital — Recarga y Movimientos (Servlet + JSP)

Aplicación web desarrollada en **Java EE / Jakarta EE 10 (sin frameworks)** que implementa una billetera digital simplificada con renderizado en el servidor (**Server-Side Rendering**). Mantiene el saldo e historial de transacciones en memoria utilizando la sesión HTTP (`HttpSession`) y renderiza la vista empleando **JSP**, **Expression Language (EL)**, **JSTL 3.0** (`<c:forEach>`, `<c:if>`, `<c:choose>`, `<fmt:formatNumber>`) y **Bootstrap 5.3**, sin utilizar scriptlets.

---

## 📋 Versiones y Requisitos del Entorno

* **Java Development Kit (JDK):** JDK 17 o superior (compatible con JDK 17, 21 y 24)
* **Servidor de Aplicaciones / Contenedor de Servlets:** Apache Tomcat 10.1.x (Jakarta EE 10 / Servlet 6.0 / JSP 3.1)
* **Gestor de Dependencias y Construcción:** Apache Maven 3.9+
* **Librerías incluidas:**
  * `jakarta.servlet:jakarta.servlet-api:6.0.0` (`provided`)
  * `jakarta.servlet.jsp.jstl:jakarta.servlet.jsp.jstl-api:3.0.0`
  * `org.glassfish.web:jakarta.servlet.jsp.jstl:3.0.1`
  * **Bootstrap:** v5.3.3 (vía CDN)

---

## 📁 Estructura del Proyecto

```text
billetera-jsp/
├── pom.xml                                                        # Configuración Maven y empaquetado .war
├── billetera-jsp.war                                              # Archivo .war listo para desplegar en Tomcat
├── target/
│   └── billetera-jsp.war                                          # Salida de compilación Maven
└── src/
    └── main/
        ├── java/pe/edu/upn/billetera/
        │   ├── controller/
        │   │   └── BilleteraServlet.java                          # Controlador HTTP (doGet / doPost)
        │   └── model/
        │       └── Movimiento.java                                # JavaBean del movimiento (tipo, monto)
        └── webapp/
            ├── WEB-INF/
            │   └── web.xml                                        # Descriptor de despliegue Jakarta EE 10
            └── billetera.jsp                                      # Vista JSP con JSTL + EL + Bootstrap 5
```

---

## 🚀 Pasos de Ejecución y Despliegue en Apache Tomcat

### Opción A: Despliegue directo con el archivo `.war` incluido
1. Localizar el archivo compilado `billetera-jsp.war` (ubicado en la raíz del repositorio y en `target/billetera-jsp.war`).
2. Copiar el archivo `billetera-jsp.war` dentro del directorio `webapps/` de su instalación de **Apache Tomcat 10.1+**.
3. Iniciar el servidor Tomcat:
   * **Windows:** Ejecutar `bin\startup.bat`
   * **macOS / Linux:** Ejecutar `./bin/startup.sh`
4. Abrir en el navegador web:
   ```
   http://localhost:8080/billetera-jsp/billetera
   ```

### Opción B: Compilar desde el código fuente con Maven
1. Clonar el repositorio:
   ```bash
 git clone https://github.com/sepultura1317-sketch/billetera-jsp.git 
   ```
2. Generar el paquete `.war`:
   ```bash
   mvn clean package
   ```
3. Copiar `target/billetera-jsp.war` a la carpeta `webapps/` de Apache Tomcat 10.1+ e iniciar el servidor.
4. Acceder desde el navegador a `http://localhost:8080/billetera-jsp/billetera`.

---

## ✅ Protocolo de Pruebas Funcionales (Rúbrica)

| # | Acción | Resultado esperado |
|---|--------|--------------------|
| **1** | Abrir la aplicación | Saldo inicial `S/ 250.00`; historial vacío (`Aún no hay movimientos registrados.`). |
| **2** | Registrar recarga de `S/ 100.00` | Saldo sube a `S/ 350.00`; la recarga se incorpora al inicio del historial. |
| **3** | Registrar gasto de `S/ 50.00` | Saldo baja a `S/ 300.00`; el gasto aparece en la primera fila (`Más reciente`), antes que la recarga. |
| **4** | Intentar gasto de `S/ 400.00` | Se rechaza la operación; aparece mensaje de error de validación indicando saldo insuficiente; el saldo continúa intacto en `S/ 300.00`. |
| **5** | Ingresar cero, negativo o monto vacío | Se rechaza la operación con alerta descriptiva; no cambia el saldo ni el historial. |
