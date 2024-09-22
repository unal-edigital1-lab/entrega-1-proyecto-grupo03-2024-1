# Proyecto Electrónica Digital I - Tamagotchi👾

## Contenido
- [Proyecto Electrónica Digital I - Tamagotchi👾](#proyecto-electrónica-digital-i---tamagotchi)
  - [Contenido](#contenido)
  - [Integrantes](#integrantes)
  - [Diseño de Interfaz y Transiciones ✏️](#diseño-de-interfaz-y-transiciones-️)
  - [Especificaciones](#especificaciones)
    - [a. Sistema de botones](#a-sistema-de-botones)
    - [b. Sistema de sensado](#b-sistema-de-sensado)
    - [c. Sistema de visualización](#c-sistema-de-visualización)
    - [d. Manejo de necesidades e indicadores](#d--manejo-de-necesidades-e-indicadores)
  - [Descripción de Hardware](#descripción-de-hardware)
  - [Diagramas de flujo](#diagramas-de-flujo)
  - [Máquina de estados finitos](#máquina-de-estados-finitos)
  - [Diagrama del sistema](#diagrama-del-sistema)
  - [Simulaciones](#simulaciones)
****
## Integrantes

- Andres Santiago Cañon Porras
- Mateo Bustos Aguilar
- Cristian Fabián Martínez Bohórquez

## Diseño de Interfaz y Transiciones ✏️

El diseño de la interfaz de nuestro Tamagotchi está centrado en brindar una interacción fluida y clara para el usuario. Para esto, se han definido los diferentes estados del Tamagotchi, las transiciones entre ellos y cómo se representarán visualmente. A continuación se describen los elementos principales:

- **Pantalla Principal**:

En esta pantalla se muestra el estado general de la mascota virtual, tales como el estado de ánimo, hambre, sueño, cura y vida de nuestra mascota.

<p align="center">
  <img src=https://github.com/user-attachments/assets/d1d8d0df-3d96-45fb-be85-b7963a24cf73>
</p>

Por otra parte, se diseñaron distintas animaciones de la mascota que describen la acción que está realizando en el momento (dormir, curar, comer, jugar), esto con el objetivo de que sea claro para el usuario que actividad está ejecutando la mascota.

<p align="center">
  <img src=https://github.com/user-attachments/assets/fad87c38-b790-432d-9429-f0f37beb3559>
</p>

- **Transiciones de Estado**:
  
  - Los estados principales que gestionan el comportamiento de la mascota son:
    
    - **Felicidad**: refleja cuán contenta está la mascota. Disminuye si no se juega con ella.
    - **Hambre**: indica cuán hambrienta está la mascota. Aumenta si no es alimentada.
    - **Sueño**: muestra el nivel de cansancio. Aumenta con el tiempo y se reduce cuando la mascota descansa.
    - **Cura (enfermedad)**: se activa cuando la mascota ha sido descuidada, indicando que está enferma y necesita atención médica.

- **Interfaz de Usuario**:

La interfaz se implementó mediante un soporte impreso en 3D, una pantalla OLED de 0,91 pulgadas (128 x 32 pixeles), una serie de botones físicos que permiten al usuario interactuar con la mascota, reiniciar el juego, cancelar alguna acción o ejecutar el *test*, así como un joystick que permite desplazarse por los distintos indicadores para que la mascota realice la respectiva acción.
  
<p align="center">
  <img src="https://github.com/user-attachments/assets/4789069b-5219-4b77-96df-a0ebcad8e81c">
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/1831e325-d094-49d5-a2fb-e53f3b6f33d7">
</p>

- **Pantallas Secundarias**:
  
  Así mismo, se diseñaron ambientes para cada acción que esté ejecutando la mascota, esto con el fin de que la interacción usuario-mascota se sienta más amigable:
  
  - *Jugar*:
    
    ![jugar](https://github.com/user-attachments/assets/d84804cd-8418-4474-b0eb-433c0f1dba5e)
    
  - *Comer*:
    
    ![comer](https://github.com/user-attachments/assets/56670c4b-b048-47e9-9302-db2868d4f294)

  - *Dormir*:
    
    ![dormir](https://github.com/user-attachments/assets/e3552f65-322e-4d32-902d-74ac77d30048)
  
  - *Curar*:

    ![curar](https://github.com/user-attachments/assets/6645d3d7-13d1-42b5-ba7b-ddf4793689f8)
    
- Por otra parte, se diseñaron pantallas de inicio y de muerte:
  
  - *Inicio*:
    
    ![inicio](https://github.com/user-attachments/assets/d67b9ab3-c57f-4d45-af5e-4eebab1c18dd)

  - *Muerte*:

    ![muerte](https://github.com/user-attachments/assets/690b99cc-a86b-4352-b148-fd9144adbb24)

## Especificaciones

La FPGA está programada para simular distintos estados de la mascota, basándose en el comportamiento y la interacción con el usuario a través de al menos tres sistemas principales:

### a. Sistema de botones

  <p align="center">
  <img src=https://github.com/user-attachments/assets/2d1d6765-d4a8-40a1-896d-239d0eb33831>
  </p>
  
  La interacción usuario-sistema se realizará mediante los siguientes botones configurados:
  
  - **Reset**: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el botón durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud óptima.
  
  - **Test**: Activa el modo de prueba al mantenerlo pulsado por al menos 5 segundos, permitiendo al usuario navegar entre los diferentes estados del Tamagotchi con cada pulsación.

  - **Select**: Permite al usuario desplazarse por los diferentes indicadores del modo de interacción.

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

### d. Manejo de necesidades e indicadores

Se tendra una serie de atributos los cuales estaran asociados a diferentes valores, y según dichos valores y algún limite establecido se definirán las necesidades de la mascota.

| **Atributos** | **Valores** |
| :-----------: | :---------: |
|    Hambre     |   0 - 100   |
|    Fatiga     |   0 - 100   |
|   Tristeza    |   0 - 100   |
|  Enfermedad   |    0 - 1    |
|    Muerte     |    0 - 1    |
|   Medicina    |   0 - 100   |
|     Vida      |   0 - 100   |

|  **Indicador**  | **Necesidad** |
| :-------------: | :-----------: |
|       Pan       |    Hambre     |
| Bate de beisbol |   Tristeza    |
|   Bostesando    |    Fatiga     |
|    Calavera     |  Enfermedad   |

  <p align="center">
    <img src=https://github.com/user-attachments/assets/7a5ef0f4-ab13-4f3d-933e-77acfc9b5c2a width="500" height="100">
  </p>

## Descripción de Hardware

<p align="center">
    <img src=https://github.com/user-attachments/assets/f7974ce2-26d0-40d5-a00b-80fcbdf70a39>
</p>

## Diagramas de flujo

- **_General_**:

Este diagrama muestra cómo el sistema responde a las variaciones en las necesidades del Tamagotchi a lo largo del tiempo y cómo permite al usuario interactuar con él. A medida que el tiempo avanza, se activan diferentes estados como hambre, sueño o fatiga, representados en los bloques centrales del flujo. El usuario puede elegir entre acciones como jugar, alimentar, curar o dejar que descanse, lo que influye directamente en los valores de las variables life, disease y death. Estas variables cambian en función de cómo se atienden las necesidades del Tamagotchi.

El diagrama también destaca que, si no se gestionan adecuadamente las necesidades, la variable disease podría activarse, lo que podría llevar al estado de death si no se toman medidas a tiempo. Además, se incluyen rutas alternativas como reset, que reinicia el ciclo, y la opción de realizar un test, un mecanismo que permite verificar ciertos estados del Tamagotchi antes de continuar.

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

La máquina de estados finitos (FSM) del Tamagotchi comienza en el estado START, donde el simulador se inicializa. Desde allí, pasa al estado MAIN cuando el temporizador de pausa de la pantalla finaliza o si se detecta un reinicio con un contador específico. En MAIN, el usuario puede interactuar con el Tamagotchi eligiendo diferentes actividades. Si el usuario selecciona jugar, el sistema transiciona a PLAY, donde el Tamagotchi se entretiene. El juego puede ser interrumpido mediante un botón de cancelación, que lo regresa al estado principal. Similarmente, el Tamagotchi puede entrar en el estado SLEEP para descansar, y volver a MAIN al ser interrumpido o cuando haya terminado de dormir.

Cuando el Tamagotchi tiene hambre, pasa al estado EAT para alimentarse, y al igual que en los demás estados de actividad, puede ser cancelado o finalizado, regresando siempre a MAIN. Si el Tamagotchi enferma, se puede iniciar la curación en el estado HEAL, siempre que el indicador lo permita. Una vez curado o si la curación es cancelada, el sistema retorna al estado principal. En caso de que el Tamagotchi muera, entra en el estado DEATH, del cual solo se puede salir mediante un reinicio completo. Este ciclo de vida se gestiona mediante las diversas transiciones y condiciones que activan las actividades, asegurando que el Tamagotchi pueda interactuar con el entorno de manera fluida hasta que finalice el juego o sea reiniciado.

<p align="center">
  <img src=https://github.com/user-attachments/assets/3f63bbfb-6ce2-4bee-94b3-160a88e32143>
</p>

- Modo test

Esta FSM implementa el modo de prueba del simulador Tamagotchi, donde se revisan los estados principales de la máquina de estados original. El modo de prueba comienza en el estado MAIN_REVIEW, y si el valor de prueba (test = 1) está activo, el sistema entra en un ciclo de revisión de los estados. A partir de ahí, transiciona a PLAY_REVIEW cuando el temporizador de prueba (test_timing) alcanza 6, permitiendo verificar el estado de juego. Luego, pasa a EAT_REVIEW para comprobar el comportamiento del estado de comer cuando test_timing = 5, y de forma similar avanza a SLEEP_REVIEW, donde se revisa el estado de dormir. Después, el sistema transita a HEAL_REVIEW, donde se verifica el proceso de curación, y posteriormente a DEATH_REVIEW para comprobar el estado de muerte del Tamagotchi. Tras completar la revisión en este último estado, la FSM retorna a MAIN_REVIEW para continuar el ciclo de pruebas. Este diseño permite verificar el correcto funcionamiento de cada estado clave del Tamagotchi bajo condiciones controladas.

<p align="center">
  <img src=https://github.com/user-attachments/assets/2051398f-ba6d-4f86-a562-6030697d5557>
</p>

## Diagrama del sistema

El diagrama muestra el sistema del Tamagotchi compuesto por varios módulos que interactúan entre sí. El módulo de antirrebote gestiona las entradas de los botones para evitar lecturas erróneas, mientras que la FSM general (Máquina de Estados Finita) controla el flujo del simulador, con estados como "Load", "Save", "Decode" y "Execute", gestionando operaciones clave del Tamagotchi. Este se conecta a la memoria, donde se almacenan datos importantes del estado del simulador, y al módulo de tiempo, que podría manejar actualizaciones periódicas. En la parte del Datapath, el sistema incluye un sumador, un sumador complemento a 2 y un comparador, los cuales realizan cálculos y comparaciones de valores necesarios para la lógica interna, y utiliza un buffer (BR) para almacenar temporalmente los resultados. El sistema también interactúa con dispositivos externos: un sensor de ultrasonido que podría detectar la proximidad del usuario, un conversor A/D para manejar un joystick, y una pantalla OLED controlada por el módulo I2C, que muestra el estado del Tamagotchi. Todos los módulos están sincronizados mediante un reloj, y se comunican a través de buses de datos y señales de control, lo que permite la interacción fluida entre las entradas, el procesador interno y las salidas del sistema.

<p align="center">
  <img src=https://github.com/user-attachments/assets/ed58eb04-efe6-4d46-8d82-c19883ee6816>
</p>

## Simulaciones

- ssd1306_master

<p align="center">
  <img src=https://github.com/user-attachments/assets/e21a4aa7-6525-4379-8b15-c063cef69f97>
</p>

<p align="center">
  <img src=https://github.com/user-attachments/assets/665b2729-0e32-46bf-84dd-f93b46437e35>
</p>

- ads1115_master

<p align="center">
  <img src=https://github.com/user-attachments/assets/439314e4-0a78-4442-b77c-c30e80e179a2>
</p>

- top_hcsr04

<p align="center">
  <img src=https://github.com/user-attachments/assets/17ee4299-b1ab-4849-bed9-4ab149788957>
</p>
