# Entrega #1 - Proyecto Electrónica Digital I 👾

## Contenido

- [Entrega #1 - Proyecto Electrónica Digital I 👾](#entrega-1---proyecto-electrónica-digital-i-)
  - [Contenido](#contenido)
  - [Integrantes](#integrantes)
  - [Diseño de Interfaz y Transiciones ✏️](#diseño-de-interfaz-y-transiciones-️)
  - [Especificaciones](#especificaciones)
  - [Descripción del Hardware](#descripción-de-Hardware)
  - [Diagramas de Flujo](#diagramas-de-flujo)
  - [Maquina de estados finitos](#máquina-de-estados-finitos)
  - [Diagrama del sistema](#diagrama-del-sistema)

## Integrantes

- Andres Santiago Cañon Porras
- Mateo Bustos Aguilar
- Cristian Fabián Martínez Bohórquez

## Diseño de Interfaz y Transiciones ✏️

Se planea diseñar una interfaz de usuario y mostrar la información acerca del tamagochi en una pantalla OLED, incluyendo su estado actual, necesidades y demás detalles.

<p align="center">
  <img src="https://github.com/user-attachments/assets/5be8157f-a5f7-46c7-aeb2-2d29e8df4f79">
</p>

La interfaz de usuario del Tamagotchi será un componente esencial para la interacción efectiva entre el usuario y la mascota virtual. Por otro lado, incorporará botones físicos intuitivos para permitir al usuario navegar entre las opciones y modos de interacción, como alimentación, dormir, curar y juego, así como seleccionar acciones específicas para cuidar de la mascota. También se puede agregar retroalimentación visual a través de luces LED y sonidos mediante un altavoz para alertar al usuario sobre las necesidades y actividades de la mascota, facilitando así una experiencia de juego envolvente y fácil de usar.

Asimismo, en la pantalla OLED se podrá mostrar gráficos simples y amigables, así como iconos o símbolos que representen las distintas acciones o estados de la mascota, facilitando la comprensión del usuario.

Otras características adicionales que podrían incluirse en la interfaz son animaciones ligeras para mejorar la interacción visual con la mascota y la opción de ajustar configuraciones personalizables como el volumen del sonido o el brillo de la pantalla. En general, la interfaz de usuario se centra en ofrecer un acceso rápido a las funciones principales, transiciones suaves entre modos y una experiencia de juego atractiva y fácil de usar para mantener al usuario interesado y comprometido con el cuidado de la mascota virtual.

<p align="center">
  <img src="https://i.ytimg.com/vi/S9QTScMz8w4/maxresdefault.jpg" alt="A beautiful sunset" width="640" height="360">
</p>

## Especificaciones

La FPGA está programada para simular distintos estados de la mascota, basándose en el comportamiento y la interacción con el usuario a través de al menos tres sistemas principales:

### a. Sistema de botones

  <p align="center">
  <img src=https://github.com/user-attachments/assets/2d1d6765-d4a8-40a1-896d-239d0eb33831>
  </p>
  
  La interacción usuario-sistema se realizará mediante los siguientes botones configurados:
  
  - **Reset**: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el botón durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud óptima.
  
  - **Test**: Activa el modo de prueba al mantenerlo pulsado por al menos 5 segundos, permitiendo al usuario navegar entre los diferentes estados del Tamagotchi con cada pulsación.

  - **Select**: Permite al usuario desplezarse por los diferentes indicadores del modo de interacción.
  
  - **Action**: Permite al usuario luego de desplazarse por los indicadores decidir cual de las acciones realizar o repetir.
  
  - **Cancel**: Permite al usuario salir de las opciones y modos de interacción, retornandolo al menu principal.
  
  ### b. Sistema de sensado
  
  Para integrar al Tamagotchi con el entorno real y enriquecer la experiencia de interacción, se incorporará al menos un sensor que modifique el comportamiento de la mascota virtual en respuesta a estímulos externos. Los sensores permitirán simular condiciones ambientales y actividades que afecten directamente el bienestar de la mascota.
  
  - **Giroscopio/Acelerómetro**: Permitirá al usuario luego de seleccionar la interacción juego (Fun) activarlo mediante la agitación del tamagochi.

  - **Sensor de ultrasonido**: Permitirá al usuario luego de seleccionar la interacción dormir (Rest) despertar al tamagochi acercandose a el.
  
  ### c. Sistema de visualización
  
  Para visualizar todas las interacciones y estados del dispositivo se utilizara únicamente un módulo display LCD OLED SPI

  - Voltaje de Operación DC: 3V ~ 5V
  - Controlador: SSD1306
  - Resolución: 128 x 32

  ### d.  Manejo de necesidades e indicadores

  Se tendra una serie de atributos los cuales estaran asociados a diferentes valores, y según dichos valores y algún limite establecido se definirán las necesidades de la mascota. 

  | **Atributos** | **Valores** |
  |:-------------:|:-----------:|
  | Hambre        | 0 - 100     |
  | Fatiga        | 0 - 100     |
  | Tristeza      | 0 - 100     |
  | Enfermedad    | 0 - 1       |
  | Muerte        | 0 - 1       |
  | Medicina      | 0 - 100     |
  | Vida          | 0 - 100     |

  |  **Indicador**  | **Necesidad** |
  |:---------------:|:-------------:|
  |       Pan       |     Hambre    |
  | Bate de beisbol |    Tristeza   |
  |    Bostesando   |     Fatiga    |
  |     Calavera    |   Enfermedad  |

  <p align="center">
    <img src=https://github.com/user-attachments/assets/7a5ef0f4-ab13-4f3d-933e-77acfc9b5c2a width="500" height="100">
  </p>


## Descripción de Hardware

<p align="center">
    <img src=https://github.com/user-attachments/assets/f7974ce2-26d0-40d5-a00b-80fcbdf70a39>
</p>

## Diagramas de flujo

- **_General_**:

  <p align="center">
    <img src=https://github.com/user-attachments/assets/7e2f38d4-e526-45f2-9adb-b15c06d68c6b>
  </p>

- **_Indicadores_**:

  <p align="center">
    <img src=https://github.com/user-attachments/assets/e127bd8d-2397-4231-8100-e8da54c9553f>
  </p>

- **_Necesidades_**:

  - Hungry:

  <p align="center">
    <img src=https://github.com/user-attachments/assets/af49c016-3f4e-40a1-9307-d28b70e1e94d>
  </p>

  - Sadness:
    
  <p align="center">
    <img src=https://github.com/user-attachments/assets/0e12d205-7ec6-4831-8b12-de2cc9f72591>
  </p>

  - Fatigue:
  
  <p align="center">
    <img src=https://github.com/user-attachments/assets/eca3294f-3177-4347-add5-e9ff4e2e4641>
  </p>
 - **_Casos de interacción_**:
  - Heal:

![diagrama base, heal drawio (1)](https://github.com/user-attachments/assets/421e729a-14e2-4d26-a697-44cfc3ad2a26)

  - Feed:

![diagrama feed drawio](https://github.com/user-attachments/assets/9e91d889-d7e1-44a3-b621-c4f044939f1b)


  - Rest:

![DIAGRAMA rest drawio](https://github.com/user-attachments/assets/ec6fb1d5-8c69-4f53-a8d6-bfdf28c7f16d)

  
  - Fun:

![JUGAR drawio](https://github.com/user-attachments/assets/41cc9234-9be6-427f-9d0f-47a14367f266)


## Máquina de estados finitos

- **_General_**:

  <p align="center">
    <img src=https://github.com/user-attachments/assets/f5ac48e6-5699-487c-95c5-23c7887cfb1e>
  </p>

- **_Indicadores_**:

  <p align="center">
    <img src=https://github.com/user-attachments/assets/9368eeff-3645-43cf-9c70-fc470060c4f9>
  </p>

- **_Necesidades_**:

  - Hungry:
 
  <p align="center">
    <img src=https://github.com/user-attachments/assets/8fcfdf29-5f84-413b-b039-03f66fe6767d>
  </p>

  - Sadness:
    
  <p align="center">
    <img src=https://github.com/user-attachments/assets/f411b84a-6bb9-4f6f-bb61-b4ac3158de2a>
  </p>

  - Fatigue:
 
  <p align="center">
    <img src=https://github.com/user-attachments/assets/d094b43a-279b-4b5c-be75-babe642f5d7f>
  </p>

- **_Casos de interacción_**:
  
  - Heal:

  <p align="center">
    <img src=https://github.com/user-attachments/assets/9b95d0d1-227c-42b9-8564-efe27ffefb82>
  </p>

  - Feed:

  <p align="center">
    <img src=https://github.com/user-attachments/assets/fb8444c9-3259-409a-b078-e899e0c64850>
  </p>

  - Rest:

  <p align="center">
    <img src=https://github.com/user-attachments/assets/00490f80-3bb5-4e0c-818e-efb52796665e>
  </p>
  
  - Fun:

  <p align="center">
    <img src=https://github.com/user-attachments/assets/32177f78-8a1b-4c0e-a901-3ef62578f27c>
  </p>

## Diagrama del sistema

<p align="center">
  <img src=https://github.com/user-attachments/assets/d4aaa4b8-a69b-4f43-bcde-eee6af9c3386>
</p>


