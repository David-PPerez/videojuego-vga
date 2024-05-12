Este es el repositorio de la última práctica de la asignatura DISEÑO DE SISTEMAS ELÉCTRONICOS, ejecutado por David Pérez Pérez y Cristian Fernández Díaz
Se ha llevado a cabo la creación de un videojuego que se muestra por pantalla mediante el protocolo VGA, usando una Nexys4 y código VHDL. Se tiene un circuito y dos jugadores, el fantasma controlado por la máquina, el coche controlado por el jugador. Hay que darle al botón central (btnC) para que comience el juego, el personaje del jugador se controla con los botones de la placa btnR, btnL, btnU y btnD. Cuando algún jugador pase por la línea de meta se parará el cronómetro. Si se quiere volver a jugar, se ha de subir y bajar el sw1 de la placa, que sirve de reset.

Descripción breve de cada una de las carpetas y de los .vhd que forman parte del proyecto
biestables : 	
		biestables d : 2 biestables d en cascada
		biestable t : biestable t
		biestables : implementación de 2 biestables d y 1 biestable t en cascada

bitstream : bitstream que muestra el juego en su totalidad

comparadores :
		comparadores : implementación de dos comparadores
		comparator : implementación comparador
		
contrain : archivo de constrain .xdc del proyecto		
		
contadores : 
	contador_generico : contador generico con finales de cuenta variable
	cronometro : contadores en cascada, capaces de contar de décimas hasta minutos
	
máquinas de estado :	
	fsm_bordeo : máquina de estados finitos que controla el comportamiento del fantasma
	fsm_jugador : máquina de estados finitos que controla el comportamiento del personaje controlado por el jugador
	parada_crono : detector de secuencia en forma de máquina de estados, controla si se pasa por la línea de meta
	paradas_crono : implementación de 2 parada_crono independientes para controlar si lo hace el personaje automático o el jugador
	
memorias :
	rom1b_blue_32num_play_sprite16x16 : memoria de personajes color azul(créditos Felipe Machado)
	rom1b_green_32num_play_sprite16x16 : memoria de personajes color verde(créditos Felipe Machado)
	rom1b_red_32num_play_sprite16x16 : memoria de personajes color rojo (créditos Felipe Machado)
	rom1b_blue_racetrack_1 : memoria de circuito color azul (créditos Felipe Machado)
	rom1b_green_racetrack_1 : memoria de circuito color verde (créditos Felipe Machado)
	rom1b_red_racetrack_1 : memoria de circuito color rojo (créditos Felipe Machado)
	fondos : implementación de las 3 memorias de color del circuito y 3 multiplexores de 32
	
multiplexores y selectores: 	
	mux_2 : multiplexor de 2 a 1, longitud de entrada de datos 1 bit
	mux2 : selector de dato, 2 entradas, una salida y un selector, de longitud de datos 3 bits
	mux4 : multiplexor de 4, longitud de entrada de datos 3 bits
	mux32 : multiplexor de 32, longitud de entrada de datos 1 bit

paquetes de recursos
	pkg_racetrack : matriz de '1' y '0' que se usa para ver si el personaje está dentro o fuera de la pista (créditos Felipe Machado)
	vga_pkg : archivo que contiene constantes necesarias para el protocolo VGA (créditos Felipe Machado)
	
selectores de memoria: 
	memo_address_selector : selector dinámico de dirección y bit de memoria en función de lo requerido por el estado
	memo_address_selector_num : selector dinámico de dirección de memoria en función de lo establecido por el cronómetro

sincro vga :	
	P_fin_col : se encarga de definir la zona visible por columnas en el protocolo VGA, también activa y desactiva la sincronización horizontal y activa el inicio de la siguiente línea en pantalla
	P_fin_line : se encarga de definir la zona visible por filas en el protocolo VGA, también activa y desactiva la sincronización vertical
	syncro_vga : bloque encargado de llevar a cabo el protocolo VGA

testbenches : 
	sim : testbench de la implementación del videojuego completa
	sim_control : testbench del control de pulsaciones de los botones de la placa
	sim_jugador : testbench de la máquina de estados que rige el comportamiento del personaje controlado por el jugador
	sim_parada : testbench del detector de secuencia que comprueba si se ha llegado a la línea de meta
	sim_bordeo : testbench de la máquina de estados del personaje automático

	control_jugador : relaciona las pulsaciones de los botones de la placa con una variable "pulsos" que entra a la máquina de estados del jugador	
	P4_DAVIDPEREZ_CRISTIANFDEZ : Archivo comprimido del proyecto completo
	pinta : se encarga de qué pintar en cada lugar de la pantalla
	TOP : implementación de todos los componentes para llevar a cabo el juego
