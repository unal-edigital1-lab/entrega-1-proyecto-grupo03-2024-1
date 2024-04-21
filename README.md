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

## Máquina de estados finitos

En cuento a la forma de operación del dispositivo, inicialmente se contaran con 8 estados, los cuales son:

  - **Principal**: En este estado el usuario podra visualizar su mascota y mediante pequeños indicadores conocer las necesidades insatisfechas.

  - **Necesidades**: En este estado el usuario podra visualizar su mascota y alternar entre los diferentes indicadores para posteriormente seleccionarlos.

  - **Alimentar**: En este estado el usuario podra alimentar a su mascota, esto con el objetivo de borrar el indicador respectivo mediante un incremento en su peso.
    
  - **Sanar**: En este estado el usuario podra sanar a su mascota, esto con el objetivo de eliminar el indicador respectivo mediante un incremento en su salud.

  - **Descansar**: En este estado el usuario le permitira descansar a su mascota, esto con el objetivo de eliminar el indicador respectivo mediante un incremento en su energia.

  - **Jugar**: En este estado el usuario puede elegir/iniciar alguna de los juegos disponibles para subir el nivel de diversión de su mascota. 

  - **Juego1**: En este estado el usuario podra jugar con su mascota, esto con el objetivo de eliminar el indicador respectivo mediante un incremento en su diversion.

  - **Morir**: En este estado la mascota muere debido a que alguna de las necesides llego a un valor de 0, dejandole al usuario como unica opción reiniciar la partida.

<p align="center">
  <img src="https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo03-2024-1/assets/95363361/ca14c3b0-b480-45b0-8f7b-a5e73a0e037d" alt="A beautiful sunset" width="740" height="460">
  <!-- ![FSM drawio](https://github.com/unal-edigital1-lab/entrega-1-proyecto-grupo03-2024-1/assets/95363361/ca14c3b0-b480-45b0-8f7b-a5e73a0e037d) -->
</p>






