# PR1: Práctica integrada de herramientas

## Introducción

Esta actividad permite ejercitar de forma integrada los conceptos trabajados en los laboratorios TER, VIM y TES. Se utilizará la terminal para compilar y ejecutar un programa, corregirlo con Vim, controlar sus canales de entrada y salida, analizar test cases y ejecutar una suite automatizada.

La actividad está pensada para ser desarrollada en aproximadamente 35 minutos. No introduce herramientas nuevas y puede repetirse hasta completar todos los puntos.

### Pre-requisitos

- Saber navegar y administrar archivos desde la terminal
- Saber compilar programas en C con `gcc`
- Saber editar archivos con Vim
- Saber utilizar redirecciones y consultar códigos de salida
- Saber ejecutar y analizar test cases con `diff`

### Objetivo general

- Integrar el flujo de edición, compilación y pruebas de un programa en C

### Objetivos específicos

- Corregir un warning informado por el compilador
- Analizar una condición de borde incorrecta
- Distinguir un error del programa de un error en un archivo `.expected`
- Crear un test case para una situación específica
- Ejecutar una suite automatizada y analizar sus resultados

### Estructura inicial

```text
workspace/
├── code/
│   └── carga.c
├── tests/
│   ├── error.in
│   ├── test001.expected
│   ├── test001.in
│   ├── test002.expected
│   ├── test002.in
│   ├── test003.expected
│   └── test003.in
└── scripts/
    ├── check.sh
    └── tests-run.sh
```

Durante la actividad se generarán archivos `.out`, `.err` y `.diff`. También se crearán `test004.in` y `test004.expected`.

## Contexto

El programa `carga.c` clasifica la carga de una nave de transporte a partir de un número entero:

| Carga | Salida |
| --- | --- |
| Menor que `0` | Error mediante `stderr` y código de salida `1` |
| Desde `0` hasta `99` | `Carga: ligera` |
| Desde `100` hasta `499` | `Carga: media` |
| `500` o mayor | `Carga: pesada` |

Una entrada que no corresponda a un número entero también produce un mensaje mediante `stderr` y código de salida `1`.

## Actividad

### 1. Compilar y corregir un warning

#### 1.1. Preparar el directorio de trabajo

Desde la raíz del repositorio, entrar a `workspace` e inspeccionar el contenido de `code`, `tests` y `scripts`.

#### 1.2. Compilar el programa

Construir el comando necesario para compilar `code/carga.c` con `-Wall`, `-Wextra`, `-Werror` y `-std=c11`. El ejecutable debe llamarse `carga` y quedar dentro de `code`.

Leer atentamente el warning informado por el compilador. Abrir el código con Vim, corregir el problema y repetir la compilación hasta que se genere el ejecutable sin warnings.

### 2. Ejercitar la shell

#### 2.1. Ejecutar con un here-document

Ejecutar el programa entregando el valor `75` mediante un here-document con `<<`. Comprobar la salida y consultar inmediatamente el código entregado por el programa.

#### 2.2. Separar los canales de salida

El archivo `tests/error.in` contiene una entrada inválida. Ejecutar el programa utilizando ese archivo como `stdin`, guardar `stdout` en `tests/error.out` y guardar `stderr` en `tests/error.err`.

Consultar inmediatamente el código de salida. Comprobar que `error.out` esté vacío y que `error.err` contenga el mensaje correspondiente.

#### 2.3. Agregar resultados a un archivo

Crear `tests/registro.out` con el resultado de ejecutar el programa para la carga `50`. Luego utilizar `>>` para agregar al mismo archivo el resultado correspondiente a la carga `700`.

Inspeccionar `registro.out` y comprobar que conserve ambos resultados en el orden en que fueron ejecutados.

### 3. Analizar los test cases entregados

#### 3.1. Ejecutar `test001` manualmente

Utilizar `test001.in` como entrada, guardar el resultado en `test001.out` y compararlo con `test001.expected` mediante `diff -u`. La prueba debe coincidir.

#### 3.2. Ejecutar la suite

Revisar los permisos de `scripts/tests-run.sh` y agregar permiso de ejecución para el propietario. El script recibe la ruta del ejecutable y el directorio que contiene los test cases.

Construir el comando necesario para ejecutar la suite. Inicialmente se observarán casos que no coinciden con lo esperado.

#### 3.3. Corregir los problemas

Inspeccionar la entrada, el resultado esperado, el resultado obtenido y la especificación para cada prueba que falla.

- Uno de los casos evidencia una condición de borde incorrecta en el programa
- Otro caso contiene un resultado esperado incorrecto

Corregir cada archivo responsable con Vim. Cuando se modifique `carga.c`, volver a compilar antes de repetir la suite.

### 4. Crear un test case adicional

#### 4.1. Construir `test004`

Crear `tests/test004.in` y `tests/test004.expected` para comprobar el comportamiento cuando la carga es exactamente `100`.

Deducir el contenido de ambos archivos a partir de la especificación y mantener la convención de nombres de los casos anteriores.

#### 4.2. Ejecutar la suite completa

Ejecutar nuevamente `tests-run.sh`. Los cuatro test cases deben entregar `PASS`.

### 5. Revisar el estado de la actividad

#### 5.1. Habilitar `check.sh`

Revisar los permisos de `scripts/check.sh` y agregar permiso de ejecución para el propietario.

#### 5.2. Ejecutar la revisión

Ejecutar `check.sh` desde `workspace`. El script informa qué puntos se encuentran completos y cuáles siguen pendientes.
