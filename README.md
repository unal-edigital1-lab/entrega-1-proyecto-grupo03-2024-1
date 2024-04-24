# Entrega #1 - Proyecto Electrónica Digital I 👾

## Contenido

- [Entrega #1 - Proyecto Electrónica Digital I 👾](#entrega-1---proyecto-electrónica-digital-i-)
  - [Contenido](#contenido)
  - [Integrantes](#integrantes)
  - [Diseño de Interfaz y Transiciones ✏️](#diseño-de-interfaz-y-transiciones-️)
  - [Maquina de estados finitos](#máquina-de-estados-finitos)

## Integrantes

- Andres Santiago Cañon Porras
- Mateo Bustos Aguilar
- Cristian Fabián Martínez Bohórquez

## Diseño de Interfaz y Transiciones ✏️

Se planea diseñar una interfaz de usuario y mostrar la información acerca de la mascota en una pantalla LCD, incluyendo su estado actual, necesidades y demás detalles.

<p align="center">
  <img src="https://tamagotchi.com/wp-content/uploads/OGTAMA_Instruction-1-800x699.png" alt="A beautiful sunset" width="400" height="349,5">
</p>

La interfaz de usuario del Tamagotchi será un componente esencial para la interacción efectiva entre el usuario y la mascota virtual. Por otro lado, incorporará botones físicos intuitivos para permitir al usuario navegar entre las opciones y modos del juego, como alimentación, limpieza y juego, así como seleccionar acciones específicas para cuidar de la mascota. También se puede agregar retroalimentación visual a través de luces LED y sonidos mediante un altavoz para alertar al usuario sobre las necesidades y actividades de la mascota, facilitando así una experiencia de juego envolvente y fácil de usar.

Asimismo, en la pantalla LCD se podrá mostrar gráficos simples y amigables, así como iconos o símbolos que representen las distintas acciones o estados de la mascota, facilitando la comprensión del usuario.

Otras características adicionales que podrían incluirse en la interfaz son animaciones ligeras para mejorar la interacción visual con la mascota y la opción de ajustar configuraciones personalizables como el volumen del sonido o el brillo de la pantalla. En general, la interfaz de usuario se centra en ofrecer un acceso rápido a las funciones principales, transiciones suaves entre modos y una experiencia de juego atractiva y fácil de usar para mantener al usuario interesado y comprometido con el cuidado de la mascota virtual.

<p align="center">
  <img src="https://i.ytimg.com/vi/S9QTScMz8w4/maxresdefault.jpg" alt="A beautiful sunset" width="640" height="360">
</p>

## Especificaciones

La FPGA está programada para simular distintos estados de la mascota, basándose en el comportamiento y la interacción con el usuario a través de al menos tres sistemas principales:

## Máquina de estados finitos

  ### a. Sistema de botones
  
  La interacción usuario-sistema se realizará mediante los siguientes botones configurados:
  
  **1. Reset**: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el botón durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud óptima.
  
  **2. Test**: Activa el modo de prueba al mantenerlo pulsado por al menos 5 segundos, permitiendo al usuario navegar entre los diferentes estados del Tamagotchi con cada pulsación.
  
  **3. Dedice**: Permite al usuario luego de desplazarse por los indicadores decidir cual de las acciones realizar o repetir.
  
  **4. Cancel**: Permite al usuario retornar a estados más generales, su función es semejante a un botón return.
  
  ### b. Sistema de sensado
  
  Para integrar al Tamagotchi con el entorno real y enriquecer la experiencia de interacción, se incorporará al menos un sensor que modifique el comportamiento de la mascota virtual en respuesta a estímulos externos. Los sensores permitirán simular condiciones ambientales y actividades que afecten directamente el bienestar de la mascota.
  
  **1. Acelerometro**: Permitira al usuario luego de seleccionar el modo de juego activarlo mediante la agitación del tamagochi.
  
  ### c. Sistema de visualización
  
  Para visualizar todas las interacciones y estados del dispositivo se utilizara unicamente un módulo display LCD OLED SPI

  - Voltaje de Operación DC: 3V ~ 5V
  - Controlador: SH1106 (Compatible con SSD1306)
  - Resolución: 128 x 64

  ### Manejo de necesidades

  La macota virtual tendra una serie de atributos los cuales estaran asociados a diferentes valores, y según dichos valores se definiran las necesidades de la mascota. 

  | **Atributos** | **Valores** |
  |---------------|-------------|
  | Peso          | 7-0         |
  | Salud         | 7-0         |
  | Energia       | 7-0         |
  | Diversión     | 7-0         |

## Máquina de estados

En cuento a la forma de operación del dispositivo, inicialmente se contaran con 8 estados, los cuales son:

  - **Principal**: En este estado el usuario podra visualizar su mascota y mediante pequeños indicadores conocer las necesidades insatisfechas.

  - **Necesidades**: En este estado el usuario podra visualizar su mascota, alternar entre los diferentes indicadores y seleccionar a cual quiere acceder.

  - **Alimentar**: En este estado el usuario podra alimentar a su mascota, esto con el objetivo de mitigar el indicador de "Hambre" mediante un incremento en su peso.
    
  - **Sanar**: En este estado el usuario podra sanar a su mascota, esto con el objetivo de mitigar el indicador de "Enfermedad" mediante un incremento en su salud.

  - **Descansar**: En este estado el usuario le permitira descansar a su mascota, esto con el objetivo de mitigar el indicador de "Cansancio" mediante un incremento en su energia.

  - **Jugar**: En este estado el usuario puede elegir/iniciar alguno de los juegos disponibles, esto con el objetivo de incrementar el nivel de diversión de su mascota. 

  - **Juego1**: En este estado el usuario jugara con su mascota mediante el sensor de movimiento, esto con el objetivo de mitigar el indicador de "Aburrimiento" mediante un incremento en su diversion.

  - **Morir**: En este estado la mascota muere debido a que alguna de las necesides llego a un valor de 0, dejandole al usuario como unica opción reiniciar la partida.

<p align="center">
  <img src="https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo03-2024-1/assets/95363361/ca14c3b0-b480-45b0-8f7b-a5e73a0e037d" alt="A beautiful sunset" width="740" height="460">
  <!-- ![FSM drawio](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo03-2024-1/assets/95363361/ca14c3b0-b480-45b0-8f7b-a5e73a0e037d) -->
</p>

## Descripción de Hardware

![Opera Instantánea_2024-04-23_232014_docs google com](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo03-2024-1/assets/95363516/7c63ccbd-8e56-4a1e-b47f-3d938221d923)

## Diagrama Hardware

![Blank diagram](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo03-2024-1/assets/95363516/a02495bc-3718-42d4-a847-87f133cebe88)


