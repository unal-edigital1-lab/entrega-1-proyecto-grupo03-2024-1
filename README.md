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
  - [Descripción del código](#descripción-del-código)
  - [Simulaciones](#simulaciones)
  - [Analizador lógico](#analizador-lógico)
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
  <img src="https://github.com/user-attachments/assets/1831e325-d094-49d5-a2fb-e53f3b6f33d7">
</p>
  
  La interacción usuario-sistema se realizará mediante los siguientes botones configurados:
  
  - **Reset**: Reestablece el Tamagotchi a un estado inicial conocido al mantener pulsado el botón durante al menos 5 segundos. Este estado inicial simula el despertar de la mascota con salud óptima.

  - **Cancel**: Permite al usuario salir de las opciones y modos de interacción, retornándolo al menu principal.
  
  - **Test**: Activa el modo de prueba al mantenerlo pulsado por al menos 5 segundos, permitiendo al usuario navegar entre los diferentes estados del Tamagotchi con cada pulsación.

  - **Select (Joystick)**: Permite al usuario desplazarse por los diferentes indicadores del modo de interacción.

  - **Action (Joystick)**: Permite al usuario luego de desplazarse por los indicadores decidir cual de las acciones realizar o repetir.

  

### b. Sistema de Sensores

Para integrar al Tamagotchi con el entorno real y enriquecer la experiencia de interacción, se incorporará al menos un sensor que modifique el comportamiento de la mascota virtual en respuesta a estímulos externos. Los sensores permitirán simular condiciones ambientales y actividades que afecten directamente el bienestar de la mascota.

- **Conversor de Voltaje (Joystick)**: El conversor de voltaje se utiliza para asegurar que la señal esté dentro de un rango adecuado, permitiendo su correcta interpretación y detección del movimiento.

- **Sensor Ultrasonido**: Permitirá al usuario luego de seleccionar la interacción dormir, despertar a la mascota si el usuario se acerca a el sensor.

### c. Sistema de visualización

Para visualizar todas las interacciones y estados del dispositivo se utilizara únicamente un módulo display LCD OLED SPI

- Voltaje de Operación DC: 3V ~ 5V
- Controlador: SSD1306
- Resolución: 128 x 32

  <p align="center">
    <img src=https://github.com/user-attachments/assets/70f14481-869c-4089-9578-7f43465e5de7>
  </p>

### d. Manejo de necesidades e indicadores

Se tendra una serie de atributos los cuales estaran asociados a diferentes valores, y según dichos valores y algún limite establecido se definirán las necesidades de la mascota.

<div align="center">

| ***Atributos*** | ***Valores*** |
| :-----------: | :---------: |
|    Hambre     |   0 - 100   |
|     Sueño     |   0 - 100   |
|   Diversión   |   0 - 100   |
|     Vida      |   0 - 100   |

</div>

<p align="center">
    <img src=https://github.com/user-attachments/assets/7b86d0e1-7cbc-4aae-8779-bf5c758d76e9>
</p>

## Descripción de Hardware

<div align="center">

| ***Nombre***        |  ***Referencia***                             |   ***Imagen***                                                                                   |***Descripción*** |  ***Datasheet*** |
| :-----------:       | :---------:                                   | :---------:                                                                                      | :---------:      | :---------:      |
| Pantalla OLED       |   OLED Display 0.91"                          |   ![oled (2)](https://github.com/user-attachments/assets/50b60b46-4207-4c44-9626-d0c27bb06b46)   |   <br>La pantalla OLED de 0.91" es un display compacto de tipo OLED (Diodo Orgánico Emisor de Luz), tiene un tamaño de 0.91 pulgadas, generalmente con una resolución de 128x32 píxeles, y se caracteriza por su alto contraste, brillo, y amplio ángulo de visión.<br> |  [Link](http://www.lcdwiki.com/res/MC091GX/SSD1306-Revision%201.5.pdf)        |
|     FPGA            |   ALTERA Cyclone IV EP4CE6E22C8N              |   ![FPGA (1)](https://github.com/user-attachments/assets/b95f1e59-8a16-4553-98f7-a312b09973e3)   |  <br> Es un dispositivo programable de lógica avanzada (FPGA) de la familia Cyclone IV, desarrollada por Altera (ahora parte de Intel). Esta FPGA está diseñada para aplicaciones de bajo costo y bajo consumo de energía, ideal para proyectos de electrónica digital y sistemas embebidos. <br>        |   [Link](https://www.mouser.com/datasheet/2/612/cyiv_51001-1299459.pdf)        |
|  Sensor Ultrasonido |  HCSR04                                       |   ![A1 (1)](https://github.com/user-attachments/assets/02ab6477-c7b0-459d-a84b-a35ad791daf9)     |   <br> El sensor ultrasónico HC-SR04 es un dispositivo ampliamente utilizado para medir distancias a través de ondas de ultrasonido. Funciona emitiendo un pulso ultrasónico y midiendo el tiempo que tarda en regresar tras reflejarse en un objeto. Este tiempo se convierte en una medida de distancia, generalmente en centímetros. <br>        |   [Link](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf)        |
|     Joystick        |   DUAL XY ANALOGO CON PULSADOR                |   ![3-17 (1)](https://github.com/user-attachments/assets/63f6a59f-dd0d-45a1-9dee-e4200c51cf87)   |   <br> Es un joystick analógico que detecta movimientos en dos ejes (X e Y) y cuenta con un botón integrado (pulsador). Los ejes X e Y corresponden al movimiento horizontal y vertical, respectivamente, y cada uno genera una señal analógica que varía según la inclinación del joystick. <br>       |   [Link](https://naylampmechatronics.com/img/cms/Datasheets/000036%20-%20datasheet%20KY-023-Joy-IT.pdf)        |

</div>

## Diagramas de flujo

- **_General_**:

Este diagrama muestra cómo el sistema responde a las variaciones en las necesidades del Tamagotchi a lo largo del tiempo y cómo permite al usuario interactuar con él. A medida que el tiempo avanza, se activan diferentes estados como hambre, sueño o fatiga, representados en los bloques centrales del flujo. El usuario puede elegir entre acciones como jugar, alimentar, curar o dejar que descanse, lo que influye directamente en los valores de las variables life, disease y death. Estas variables cambian en función de cómo se atienden las necesidades del Tamagotchi.

El diagrama también destaca que, si no se gestionan adecuadamente las necesidades, la variable disease podría activarse, lo que podría llevar al estado de death si no se toman medidas a tiempo. Además, se incluyen rutas alternativas como reset, que reinicia el ciclo, y la opción de realizar un test, un mecanismo que permite verificar ciertos estados del Tamagotchi antes de continuar.

  <p align="center">
    <img src=https://github.com/user-attachments/assets/cc9e54d6-5540-4a3a-ab70-5e8e26670b56>
  </p>

- **_Necesidades_**:

El diagrama de flujo siguiente muestra el ciclo de vida de nuestra mascota que tiene atributos de vida, comida, diversión y descanso. Cada 0.8 segundos, estos valores disminuyen, lo que afecta el estado de vida. Si la vida llega a 0, se activa la muerte. Si la vida es menor que 16, se activa la variable disease, que influye directamente en la vida de la mascota.


  <p align="center">
    <img src=https://github.com/user-attachments/assets/2aaac5ae-2807-4d9c-bbcc-0b18ad60a5a6>
  </p>

- **_Casos de interacción_**:

Los siguientes diagramas representan los casos de interacción a los que el usuario puede acceder dependiendo el menú/estado que se seleccione, es de suma importancia tener presente como funciona cada uno de estos menús para conocer el funcionamiento del tamagotchi y estar al tanto de como suben y bajan los indicadores conforme el tiempo avanza.

![diagrama necesidades1 drawio](https://github.com/user-attachments/assets/6b863574-c685-40da-a53f-f07a1133f6a3)


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

## Descripción del código 

Para el manejo de los módulos del tamagotchi, se usa un módulo llamado top en el que también esta la Finite State Machine del juego.
A continuación se pueden ver los módulos llamados hacia el módulo top:

```ruby
top_ads1115 UTT_joystick (
    .clk(clk),
	.sw(btn_action),
    .sda(sda_converter),
    .scl(scl_converter),
    .led1(led_left),
    .led2(led_middle),
    .led3(led_right),
	.led4(led_action)
);

top_hcsr04 UTT_ultrasonido (
    .clk(clk),
    .echo(echo),
    .enable(enable),
    .trigger(trigger),
    .level1(level1),
    .level2(level2)
);

top_oled UUT_oled (
	.clk(clk),
	.screen_param(screen_param),
	.needs_values(needs_values),
	.sda(sda_display), 
	.scl(scl_display)
);
```
Se llama el "top_ads1115" joystick para usar las activaciones del joystick para moverse a través de los indicadores, tambien el "top_hcsr04" para recibir las confirmaciones del sensor ultra sonido, y por ultimo el "top_oled" para el manejo de la pantalla.

Se usan dos registros para almacenar el control de la pantalla, para controlar los niveles de las necesidades y para el indicador que tiene seleccionado.

```ruby
wire [8:0] screen_param = {test, act_eat, act_heal, act_play, act_sleep, state};
wire [32:0] needs_values = {disease, life, food, fun, rest, ind_select};
```
En el registro "screen_param" se guarda la configuración de pantalla que debe mostrar cuando se genere la acción determinada, en "needs_values" se guardan los valores actuales de las necesidades y también el indicador actual.

Luego, se definen registros de 7 bits para los valores actuales como life, fun, food y rest, además de crear registros de 1 bit para indicar si el tamagotchi esta enfermo (disease) , muerto (death) o en modo test.

Se crea un always para determinar el estado general del tamagotchi, "disease" o "death":
```ruby
always @(posedge clk) begin 
    if (life <= 16) begin
        disease <= 1;
    end
    else begin
        disease <= 0;
    end

    if (life == 0) begin
        death = 1;
    end
    else begin
        death = 0;
    end
end
```
Asi se establece que si la vida es menor o igual a 16 se active el estado de enfermedad para a su vez, activar el indice de heal. Y si la vida llega a 0 se active el estado muerte.
Posteriormente para la fsm se crean los estados de la maquina finita:


```ruby
localparam START = 4'd0;
localparam MAIN = 4'd1;
localparam PLAY = 4'd2;
localparam SLEEP = 4'd3;
localparam EAT = 4'd4;
localparam HEAL = 4'd5;
localparam DEATH = 4'd6;

reg [3:0] state = START;
```
y el "state" un registro que indica el estado actual. También se generan múltiples localparam para los delays requeridos, para los estados del botón test y también se crean varios contadores para controlar el clk en segundos.

Luego se crea un always que es donde irá toda la máquina de estados finita. En este always se crea un pulso para controlar el descenso de cada necesidad, se establece que cada 0.8 segundos baje en cada una de las necesidades de la siguiente manera.

```ruby
if (cont_food >= 5'd1 && food > 0) begin
            food <= food - 1'b1;
            cont_food <= 0;
        end

        if (cont_fun >= 5'd1 && fun > 0) begin
            fun <= fun - 1'b1;
            cont_fun <= 0;
        end

        if (cont_rest >= 5'd1 && rest > 0) begin
            rest <= rest - 1'b1;
            cont_rest <= 0;
        end
```

Para tener en cuenta las tres necesidades en el cálculo general de la vida, se utiliza la siguiente relación:
```ruby
   life = (rest + fun + food)/3;
```
Se programa el botón reset.
```ruby
if (btn_reset == 1) begin
        if (cont_reset == 0) begin
                state <= START;
                life = 7'd100;
                fun <= 7'd100;
                rest <= 7'd100;
                food <= 7'd100;
                test <= 0;
                ind_select <=  IND_PLAY;
                state_test <= MAIN_REVIEW;
                cont_reset <=  DELAY_5SEG;
                test_timing <= 0;

                cont_reset <= DELAY_5SEG;
            end
            else begin
                cont_reset <= cont_reset - 1'b1;
            end
        end
```
El botón de cancel se usa para volver a el main estando en cualquiera de los menús de las necesidades tales como heal, eat y sleep.
La parte central del tamagotchi es la máquina de estados finita que indica en cúal menú se encuentra el usuario, para ello se realiza un "case" el cúal dependa del estado actual del registro "state".
El primer estado es el estado "START", el cúal se encarga de mostrar la imagen de inicio y mandar al siguiente estado.
```ruby
case (state)
            START: begin
                if (cont_screen_pause == 0) begin
                    state <= MAIN;
                    cont_screen_pause = DELAY_SCREEN_PAUSE;
                end
                else begin
                    cont_screen_pause <= cont_screen_pause - 1'b1;
                end
```

El siguiente estado es "MAIN" como su nombre lo dice, es el menú principal del tamagotchi, en el salen los distintos indicadores que tiene el tamagotchi y su estado actual, además de los indicadores de cada menú en la parte superior de la pantalla.

```ruby
MAIN: begin
                led_s1 = 1;
                led_s2 = 0;
                led_s3 = 1;

                if (btn_action== 0 && ind_select == IND_PLAY) begin
                    state <= PLAY;
                end
                
                if (btn_action == 0 && ind_select == IND_EAT) begin
                    state <= EAT;
                end
                
                if (btn_action == 0 && ind_select == IND_SLEEP) begin
                    state <= SLEEP;
                end
                
                if (btn_action == 0 && ind_select == IND_HEAL) begin
                    state <= HEAL;
                end
```
En esta parte se verifica el lugar en donde este ubicado el indicador, y si se presiona el botón sw del joystick, le dice que cambie de estado al estado seleccionado, en este mismo estado también se programa como debe funcionar el movimiento entre los indicadores, puesto que debe estar al tanto de si el tamagotchi tiene activado el registro de enfermedad o no, para mostrarle respectivamente el menú de curación.

Estado PLAY:
```ruby
PLAY: begin
                led_s1 = 1;
                led_s2 = 1;
                led_s3 = 0;

                if (btn_action == 0) begin
                    act_play = 1;
                    if (cont_actions == 26'd50000000) begin
                        cont_actions <= 0;

                        if (fun + 7'd10 < 7'd100) begin
                            fun <= fun + 7'd10;
                        end
                        else begin
                            fun <= 7'd100;
                        end
                    end
                    else begin
                        cont_actions <= cont_actions + 1'd1;
                    end
                end
                else begin
                    cont_actions = 0;
                    act_play = 0;
                end
            end
```
Estado SLEEP:
```ruby
SLEEP: begin
                led_s1 = 0;
                led_s2 = 0;
                led_s3 = 1;
                
                if (level2 == 0) begin
                    act_sleep = 1;
                    if (cont_actions == 26'd50000000) begin
                        cont_actions <= 0;

                        if (rest + 7'd10 < 7'd100) begin
                            rest <= rest + 7'd10;
                        end
                        else begin
                            rest <= 7'd100;
                        end
                    end
                    else begin
                        cont_actions <= cont_actions + 1'd1;
                    end
                end
                else begin
                    cont_actions = 0;
                    act_sleep = 0;
                end
            end
```
Estado EAT:
```ruby
EAT: begin
                led_s1 = 1;
                led_s2 = 0;
                led_s3 = 0;

                if (btn_action == 0) begin
                    act_eat = 1;
                    if (cont_actions == 26'd50000000) begin
                        cont_actions <= 0;

                        if (food + 7'd10 < 7'd100) begin
                            food <= food + 7'd10;
                        end
                        else begin
                            food <= 7'd100;
                        end
                    end
                    else begin
                        cont_actions <= cont_actions + 1'd1;
                    end
                end
                else begin
                    cont_actions = 0;
                    act_eat = 0;
                end

            end
```
Como se puede observar el funcionamiento de estos tres estados es bastante similar, después de la activación del botón, se da la orden a la pantalla de mostrar la pantalla de acción y se suman los indicadores siempre que estos no sean igual a 90, el unico que cambia es el menú de SLEEP, pues este no recibe la activación del botón, sino la señal que le manda el ultrasonido para despertar al tamagotchi.

Por último, está el estado de HEAL, cuando el tamagotchi esta enfermo:
```ruby
HEAL: begin
                led_s1 = 0;
                led_s2 = 1;
                led_s3 = 0;

                if (btn_action == 0) begin
                    act_heal = 1;
                    if (cont_actions == 26'd50000000) begin
                        cont_actions <= 0;

                        food <= 7'd50;
                        fun <= 7'd50;
                        rest <= 7'd50;
                    end
                    else begin
                        cont_actions <= cont_actions + 1'd1;
                    end
                end
                else begin
                    cont_actions = 0;
                    act_heal = 0;
                end
            end

            DEATH: begin
                led_s1 = 0;
                led_s2 = 0;
                led_s3 = 0;
            end
```
Al detectar el botón de acción, pone todos las necesidades en 50, lo que indicaría que la vida también sube a 50 puntos ya que si tiene este menú disponible, significa que el tamagotchi está debajo de los 50 puntos de vida debido a la fórmula.

El último elemento del código es el botón test, el cúal funciona en otra máquina de estados, se accede a ella mediante pulsar el botón test por 5 segundos, la manera en la que funciona, es que mediamente el usuario va usando el joystick hacia la derecha, el tamagotchi va a estar mostrando todas sus funcionalidades una por una, por ejemplo, en el primer review, main:
```ruby
MAIN_REVIEW: begin
                state <= MAIN;
                case (test_timing)
                    0: begin
                        fun <= 7'd100;
                        rest <= 7'd100;
                        food <= 7'd100;
                        life <= 7'd100;
                    end
                    1: begin
                        life <= 7'd83;
                    end
                    2: begin
                        fun <= 7'd67;
                        rest <= 7'd67;
                        food <= 7'd67;
                        life <= 7'd67;
                    end
                    3: begin
                        life <= 7'd50;
                    end
                    4: begin
                        fun <= 7'd33;
                        rest <= 7'd33;
                        food <= 7'd33;
                        life <= 7'd33;
                    end
                    5: begin
                        life <= 7'd16;
                    end
                    6: begin
                        test_timing <= 4'd0;
                        state_test <= PLAY_REVIEW;
                    end
```
Como en el menú principal lo que se muestra es en general todos los indicadores y la vida, lo que se empieza a variar con el joystick es eso mismo, entonces con la primera activación del joystick la vida bajara a 83, mostrando como se quita medio corazón en su indicador, y así con todos los indicadores, una vez finalizado se reinicia el test_timing para manejar la máquina de estados y se lleva al otro estado de review, play.

Los siguientes funcionan de la siguiente manera:
```ruby
PLAY_REVIEW: begin
                state <= PLAY;
                case (test_timing)
                    0: begin
                        act_play <= 0;
                    end
                    1: begin
                        act_play <= 1;
                    end
                    2: begin
                        fun <= 7'd67;
                    end
                    3: begin
                        fun <= 7'd100;
                    end
                    4: begin
                        act_play <= 0;
                    end
                    5: begin
                        test_timing <= 4'd0;
                        state_test <= EAT_REVIEW;
                    end
```
Como se mencionó anteriormente, va mostrando como el tamagotchi juega y como va subiendo y bajando el indicador del estado actual, para posteriormente cambiar al siguiente, así se repite de igual manera hasta llegar al HEAL y luego, mostrar la muerte del tamagothci y esperar a que el usuario presione el botón reiniciar para iniciar nuevamente el juego.


Es importante recalcar que el módulo "ssd1306_master.v", se encarga de según los estados actuales del tamagotchi y de algunas otras variables tales como si se presionan o no los botones, cambiar adecuadamente la información y los valores que se le envían a la pantalla para mostrar adecuadamente lo que se requiere.
## Simulaciones

- **_ssd1306_master_**

I2C-bus Write data:

<p align="center">
  <img src=https://github.com/user-attachments/assets/e21a4aa7-6525-4379-8b15-c063cef69f97>
</p>

Gtkwave:

<p align="center">
  <img src=https://github.com/user-attachments/assets/665b2729-0e32-46bf-84dd-f93b46437e35>
</p>

En el diagrama del datasheet, se describe cómo se envía una secuencia de bytes, comenzando por la dirección del esclavo, seguida de un byte de control y posteriormente varios bytes de datos o comandos. Este proceso es exactamente lo que se observa en la simulación: la comunicación I2C se inicia con el envío de la dirección del esclavo, luego se transmite el byte de control, y finalmente, los datos o comandos necesarios para la configuración de la pantalla.

En la simulación, también se pueden ver claramente las señales de reconocimiento (ACK) que ocurren después de cada byte transmitido, confirmando que el esclavo está recibiendo los datos como lo dicta el protocolo I2C. Esto asegura que cada paso del proceso de comunicación, desde la dirección hasta los datos, está siendo aceptado correctamente por el dispositivo esclavo.

Además, la simulación refleja cómo la comunicación pasa por diferentes estados del protocolo. Estos estados coinciden con los que describe el datasheet para la transmisión de bytes, gestionando cada fase de la comunicación I2C. Desde la dirección del esclavo hasta la escritura de comandos o datos, la simulación sigue el flujo de manera precisa, mostrando un ciclo completo de escritura en la pantalla OLED, tal como lo detalla el datasheet del SSD1306.

- **_ads1115_master_**

Two-Wire Timing Diagram for Read Word Format

<p align="center">
  <img src=https://github.com/user-attachments/assets/8ae2c961-3bf6-4f1a-a26e-9a292503c055>
</p>

Two-Wire Timing Diagram for Write Word Format:

<p align="center">
  <img src=https://github.com/user-attachments/assets/d5b27520-49f2-437e-88b5-1ff434722237>
</p>

Gtkwave:

<p align="center">
  <img src=https://github.com/user-attachments/assets/439314e4-0a78-4442-b77c-c30e80e179a2>
</p>

En el diagrama del datasheet del ADS1115, se describe cómo se realiza el proceso de comunicación I2C, comenzando por el envío de la dirección del esclavo, seguida de la selección de un registro y posteriormente los datos de configuración o conversión. Este proceso es replicado fielmente en la simulación: la secuencia inicia con la transmisión de la dirección del ADS1115, seguida del byte que indica el registro que se va a configurar, y luego se envían los bytes de configuración necesarios para establecer parámetros como la ganancia y la velocidad de muestreo del ADC.

Durante la simulación, se observa claramente cómo se generan las señales de reconocimiento (ACK) tras la transmisión de cada byte, lo que confirma que el dispositivo ADS1115 está recibiendo correctamente los datos, como lo dicta el protocolo I2C. Esta validación es crucial para asegurar que cada paso, desde la dirección hasta los datos de configuración, se está llevando a cabo sin errores.

La simulación también refleja la transición a los diferentes estados del protocolo I2C, tal como se describe en el datasheet. Aunque el proceso de selección del registro de conversión y la lectura de los dos bytes correspondientes al valor convertido fue programado, debido a la complejidad de replicar el comportamiento exacto del convertidor ADC, esta parte no se ilustra completamente en la simulación.

- **_top_hcsr04_**

Gtkwave:

<p align="center">
  <img src=https://github.com/user-attachments/assets/17ee4299-b1ab-4849-bed9-4ab149788957>
</p>

En el diagrama del datasheet del HCSR04, se describe cómo el sensor emite un pulso de "trigger" para iniciar la medición de distancia, seguido por la espera de un pulso de "echo" que indica la recepción de la señal reflejada. Este proceso fue replicado en la simulación: tras enviar el pulso de trigger, el sistema empieza a contar el tiempo hasta que se recibe el pulso de echo, lo que permite calcular la distancia en función del tiempo transcurrido.

En la simulación, se observa cómo el contador comienza justo después del trigger y continúa hasta que el pulso de echo es recibido. La distancia calculada, una vez determinada, se clasifica en dos niveles: nivel1 y nivel2, que corresponden a diferentes rangos de distancia según qué tan lejos esté el objeto detectado. Aunque la simulación no ilustra el cálculo exacto de la distancia, se enfoca en mostrar el proceso de emisión del trigger y la recepción del echo, y cómo los niveles resultantes se asignan de acuerdo con la distancia medida.

## Analizador lógico

- **_Pantalla oled_**

<p align="center">
  <img src=https://github.com/user-attachments/assets/22058cd4-fc61-4a19-8c4a-3677f1a79c24>
</p>

En la evaluación del funcionamiento del código para la pantalla OLED 128x32 (SSD1306), se utilizó un analizador lógico para capturar y analizar las señales en el bus I2C. Los resultados confirmaron que la pantalla estaba operando correctamente. El analizador mostró la secuencia adecuada de la dirección del esclavo, seguida de los bytes de control y los datos necesarios para inicializar la pantalla y dibujar gráficos. Las señales de reconocimiento (ACK) generadas después de cada byte transmitido indicaron que el OLED estaba recibiendo los datos sin errores, validando así la correcta implementación del protocolo I2C en el código.

- **_Conversor A/D (Joystick)_**

<p align="center">
  <img src=https://github.com/user-attachments/assets/fa526531-874a-4bdf-84da-58099ecc2e05>
</p>

En la evaluación del código para el conversor A/D (ADS1115), el analizador lógico se utilizó para registrar y analizar las señales en el bus I2C durante el proceso de configuración y lectura. Los resultados mostraron que el ADS1115 estaba respondiendo adecuadamente a las instrucciones enviadas. Se observaron las transiciones correctas en el bus I2C al seleccionar el registro de configuración y al leer el valor digitalizado, lo que confirma que el dispositivo estaba operando según lo esperado. Además, se registró la emisión del pulso de trigger y la recepción de los datos de conversión, indicando que el ADC estaba funcionando de manera efectiva.

## Video prueba

<p align="center">
  <video src="https://github.com/user-attachments/assets/cbe0fcec-eda6-44f3-8e6a-52cdbb66d697">
<p/>
