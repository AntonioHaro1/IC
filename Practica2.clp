;;;;;;; JUGADOR DE 4 en RAYA ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;;;;;;;;;; Version de 4 en raya clásico: Tablero de 6x7, donde se introducen fichas por arriba
;;;;;;;;;;;;;;;;;;;;;;; y caen hasta la posicion libre mas abajo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;; Hechos para representar un estado del juego

;;;;;;; (Turno M|J)   representa a quien corresponde el turno (M maquina, J jugador)
;;;;;;; (Tablero Juego ?i ?j _|M|J) representa que la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)

;;;;;;;;;;;;;;;; Hechos para representar estado del analisis
;;;;;;; (Tablero Analisis Posicion ?i ?j _|M|J) representa que en el analisis actual la posicion i,j del tablero esta vacia (_), o tiene una ficha propia (M) o tiene una ficha del jugador humano (J)
;;;;;;; (Sondeando ?n ?i ?c M|J)  ; representa que estamos analizando suponiendo que la ?n jugada h sido ?i ?c M|J
;;;

;;;;;;;;;;;;; Hechos para representar una jugadas

;;;;;;; (Juega M|J ?columna) representa que la jugada consiste en introducir la ficha en la columna ?columna 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; INICIALIZAR ESTADO


(deffacts Estado_inicial
(Tablero Juego 1 1 _) (Tablero Juego 1 2 _) (Tablero Juego 1 3 _) (Tablero Juego  1 4 _) (Tablero Juego  1 5 _) (Tablero Juego  1 6 _) (Tablero Juego  1 7 _)
(Tablero Juego 2 1 _) (Tablero Juego 2 2 _) (Tablero Juego 2 3 _) (Tablero Juego 2 4 _) (Tablero Juego 2 5 _) (Tablero Juego 2 6 _) (Tablero Juego 2 7 _)
(Tablero Juego 3 1 _) (Tablero Juego 3 2 _) (Tablero Juego 3 3 _) (Tablero Juego 3 4 _) (Tablero Juego 3 5 _) (Tablero Juego 3 6 _) (Tablero Juego 3 7 _)
(Tablero Juego 4 1 _) (Tablero Juego 4 2 _) (Tablero Juego 4 3 _) (Tablero Juego 4 4 _) (Tablero Juego 4 5 _) (Tablero Juego 4 6 _) (Tablero Juego 4 7 _)
(Tablero Juego 5 1 _) (Tablero Juego 5 2 _) (Tablero Juego 5 3 _) (Tablero Juego 5 4 _) (Tablero Juego 5 5 _) (Tablero Juego 5 6 _) (Tablero Juego 5 7 _)
(Tablero Juego 6 1 _) (Tablero Juego 6 2 _) (Tablero Juego 6 3 _) (Tablero Juego 6 4 _) (Tablero Juego 6 5 _) (Tablero Juego 6 6 _) (Tablero Juego 6 7 _)
(Jugada 0)
)

(defrule Elige_quien_comienza
=>
(printout t "Quien quieres que empieze: (escribre M para la maquina o J para empezar tu) ")
(assert (Turno (read)))
)

;;;;;;;;;;;;;;;;;;;;;;; MUESTRA POSICION ;;;;;;;;;;;;;;;;;;;;;;;
(defrule muestra_posicion
(declare (salience 10))
(muestra_posicion)
(Tablero Juego 1 1 ?p11) (Tablero Juego 1 2 ?p12) (Tablero Juego 1 3 ?p13) (Tablero Juego 1 4 ?p14) (Tablero Juego 1 5 ?p15) (Tablero Juego 1 6 ?p16) (Tablero Juego 1 7 ?p17)
(Tablero Juego 2 1 ?p21) (Tablero Juego 2 2 ?p22) (Tablero Juego 2 3 ?p23) (Tablero Juego 2 4 ?p24) (Tablero Juego 2 5 ?p25) (Tablero Juego 2 6 ?p26) (Tablero Juego 2 7 ?p27)
(Tablero Juego 3 1 ?p31) (Tablero Juego 3 2 ?p32) (Tablero Juego 3 3 ?p33) (Tablero Juego 3 4 ?p34) (Tablero Juego 3 5 ?p35) (Tablero Juego 3 6 ?p36) (Tablero Juego 3 7 ?p37)
(Tablero Juego 4 1 ?p41) (Tablero Juego 4 2 ?p42) (Tablero Juego 4 3 ?p43) (Tablero Juego 4 4 ?p44) (Tablero Juego 4 5 ?p45) (Tablero Juego 4 6 ?p46) (Tablero Juego 4 7 ?p47)
(Tablero Juego 5 1 ?p51) (Tablero Juego 5 2 ?p52) (Tablero Juego 5 3 ?p53) (Tablero Juego 5 4 ?p54) (Tablero Juego 5 5 ?p55) (Tablero Juego 5 6 ?p56) (Tablero Juego 5 7 ?p57)
(Tablero Juego 6 1 ?p61) (Tablero Juego 6 2 ?p62) (Tablero Juego 6 3 ?p63) (Tablero Juego 6 4 ?p64) (Tablero Juego 6 5 ?p65) (Tablero Juego 6 6 ?p66) (Tablero Juego 6 7 ?p67)
=>
(printout t crlf)
(printout t ?p11 " " ?p12 " " ?p13 " " ?p14 " " ?p15 " " ?p16 " " ?p17 crlf)
(printout t ?p21 " " ?p22 " " ?p23 " " ?p24 " " ?p25 " " ?p26 " " ?p27 crlf)
(printout t ?p31 " " ?p32 " " ?p33 " " ?p34 " " ?p35 " " ?p36 " " ?p37 crlf)
(printout t ?p41 " " ?p42 " " ?p43 " " ?p44 " " ?p45 " " ?p46 " " ?p47 crlf)
(printout t ?p51 " " ?p52 " " ?p53 " " ?p54 " " ?p55 " " ?p56 " " ?p57 crlf)
(printout t ?p61 " " ?p62 " " ?p63 " " ?p64 " " ?p65 " " ?p66 " " ?p67 crlf)
(printout t  crlf)
)


;;;;;;;;;;;;;;;;;;;;;;; RECOGER JUGADA DEL CONTRARIO ;;;;;;;;;;;;;;;;;;;;;;;
(defrule mostrar_posicion
(declare (salience 9999))
(Turno J)
=>
(assert (muestra_posicion))
)

(defrule jugada_contrario
?f <- (Turno J)
=>
(printout t "en que columna introduces la siguiente ficha? ")
(assert (Juega J (read)))
(retract ?f)
)

(defrule juega_contrario_check_entrada_correcta
(declare (salience 1))
?f <- (Juega J ?c)
(test (and (neq ?c 1) (and (neq ?c 2) (and (neq ?c 3) (and (neq ?c 4) (and (neq ?c 5) (and (neq ?c 6) (neq ?c 7))))))))
=>
(printout t "Tienes que indicar un numero de columna: 1,2,3,4,5,6 o 7" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_check_columna_libre
(declare (salience 1))
?f <- (Juega J ?c)
(Tablero Juego 1 ?c ?X) 
(test (neq ?X _))
=>
(printout t "Esa columna ya esta completa, tienes que jugar en otra" crlf)
(retract ?f)
(assert (Turno J))
)

(defrule juega_contrario_actualiza_estado
?f <- (Juega J ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego ?i ?c J))
)

(defrule juega_contrario_actualiza_estado_columna_vacia
?f <- (Juega J ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno M) (Tablero Juego 6 ?c J))
)


;;;;;;;;;;; ACTUALIZAR  ESTADO TRAS JUGADA DE CLISP ;;;;;;;;;;;;;;;;;;

(defrule juega_clisp_actualiza_estado
?f <- (Juega M ?c)
?g <- (Tablero Juego ?i ?c _)
(Tablero Juego ?j ?c ?X) 
(test (= (+ ?i 1) ?j))
(test (neq ?X _))
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego ?i ?c M))
)

(defrule juega_clisp_actualiza_estado_columna_vacia
?f <- (Juega M ?c)
?g <- (Tablero Juego 6 ?c _)
=>
(retract ?f ?g)
(assert (Turno J) (Tablero Juego 6 ?c M))
)

;;;;;;;;;;; CLISP JUEGA SIN CRITERIO ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule elegir_jugada_aleatoria
(declare (salience -9998))
?f <- (Turno M)
=>
(assert (Jugar (random 1 7)))
(retract ?f)
)

(defrule comprobar_posible_jugada_aleatoria
?f <- (Jugar ?c)
(Tablero Juego 1 ?c M|J)
=>
(retract ?f)
(assert (Turno M))
)

(defrule clisp_juega_sin_criterio
(declare (salience -9999))
?f<- (Jugar ?c)
=>
(printout t "JUEGO en la columna (sin criterio) " ?c crlf)
(retract ?f)
(assert (Juega M ?c))
(printout t "Juego sin razonar, que mal"  crlf) 
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;  Comprobar si hay 4 en linea ;;;;;;;;;;;;;;;;;;;;;

(defrule cuatro_en_linea_horizontal
(declare (salience 9999))
(Tablero ?t ?i ?c1 ?jugador)
(Tablero ?t ?i ?c2 ?jugador) 
(test (= (+ ?c1 1) ?c2))
(Tablero ?t ?i ?c3 ?jugador)
(test (= (+ ?c1 2) ?c3))
(Tablero ?t ?i ?c4 ?jugador)
(test (= (+ ?c1 3) ?c4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador horizontal ?i ?c1))
)

(defrule cuatro_en_linea_vertical
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i1 ?c ?jugador)
(Tablero ?t ?i2 ?c ?jugador)
(test (= (+ ?i1 1) ?i2))
(Tablero ?t ?i3 ?c  ?jugador)
(test (= (+ ?i1 2) ?i3))
(Tablero ?t ?i4 ?c  ?jugador)
(test (= (+ ?i1 3) ?i4))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador vertical ?i1 ?c))
)

(defrule cuatro_en_linea_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (+ ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (+ ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (+ ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_directa ?i ?c))
)

(defrule cuatro_en_linea_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Tablero ?t ?i ?c ?jugador)
(Tablero ?t ?i1 ?c1 ?jugador)
(test (= (+ ?i 1) ?i1))
(test (= (- ?c 1) ?c1))
(Tablero ?t ?i2 ?c2  ?jugador)
(test (= (+ ?i 2) ?i2))
(test (= (- ?c 2) ?c2))
(Tablero ?t ?i3 ?c3  ?jugador)
(test (= (+ ?i 3) ?i3))
(test (= (- ?c 3) ?c3))
(test (or (eq ?jugador M) (eq ?jugador J) ))
=>
(assert (Cuatro_en_linea ?t ?jugador diagonal_inversa ?i ?c))
)

;;;;;;;;;;;;;;;;;;;; DESCUBRE GANADOR
(defrule gana_fila
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador horizontal ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la fila " ?i crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_columna
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador vertical ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la columna " ?c crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_directa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_directa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal que empieza la posicion " ?i " " ?c   crlf)
(retract ?f)
(assert (muestra_posicion))
) 

(defrule gana_diagonal_inversa
(declare (salience 9999))
?f <- (Turno ?X)
(Cuatro_en_linea Juego ?jugador diagonal_inversa ?i ?c)
=>
(printout t ?jugador " ha ganado pues tiene cuatro en linea en la diagonal hacia arriba que empieza la posicin " ?i " " ?c   crlf)
(retract ?f)
(assert (muestra_posicion))
) 


;;;;;;;;;;;;;;;;;;;;;;;  DETECTAR EMPATE

(defrule empate
(declare (salience -9999))
(Turno ?X)
(Tablero Juego 1 1 M|J)
(Tablero Juego 1 2 M|J)
(Tablero Juego 1 3 M|J)
(Tablero Juego 1 4 M|J)
(Tablero Juego 1 5 M|J)
(Tablero Juego 1 6 M|J)
(Tablero Juego 1 7 M|J)
=>
(printout t "EMPATE! Se ha llegado al final del juego sin que nadie gane" crlf)
)

;;;;;;;;;;;;;;;;;;;;;; CONOCIMIENTO EXPERTO ;;;;;;;;;;
;;;;; ¡¡¡¡¡¡¡¡¡¡ Añadir conocimiento para que juege como vosotros jugariais !!!!!!!!!!!!
;;;;; ejercicio 1 para detectar los siguientes y los anteriores (siguiente fila columna direccion fila columna)
;;;;;
(defrule deduce_siguiente_horizontal
(Tablero Juego ?f ?c _ )
(test (< ?c 7))
=> 
(assert (siguiente ?f ?c h ?f (+ ?c 1)))
)

(defrule deduce-siguiente-vertical
(Tablero Juego ?f ?c _ )
(test (> ?f 1))
=>
(assert (siguiente ?f ?c v (- ?f 1) ?c))
)

(defrule deduce-siguiente-diagonal1
(Tablero Juego ?f ?c _ )
(test (< ?c 7))
(test (< ?f 6))
=>
(assert (siguiente ?f ?c d1 (+ ?f 1) (+ ?c 1)))
)

(defrule deduce-siguiente-diagonal2
(Tablero Juego ?f ?c _ )
(test (< ?c 7))
(test (> ?f 1))
=>
(assert (siguiente ?f ?c d2 (- ?f 1) (+ ?c 1)))
)

(defrule deduce_anterior
(siguiente ?f ?c ?d ?f1 ?c1)
=>
(assert (anterior ?f1 ?c1 ?d ?f ?c)))

;;;EJERCICIO 2 deduce donde caeria, primera linea es practicamente para inicializarlos
;;;; Luego actualizar si hay algun cambio y se pone un jugador borra el fact y pone uno nuevo donde caeria
;;;; eliminar es cuando llega al limite para que no haya un caeria en esa columna

(defrule caeria_primeralinea
(Tablero Juego 6 ?c _)
=>
(assert (caeria 6 ?c))
)

(defrule caeria_actualizar

?regla <-(caeria ?f ?c)

(Tablero Juego ?f ?c ?J)
(test (neq ?J _))
(test (> ?f 1))
=>

(retract ?regla)
(assert (caeria (- ?f 1) ?c))
)

(defrule caeria_eliminar
?regla <- (caeria ?f ?c)
(Tablero Juego ?f ?c M|J)
(test (eq ?f 1))
=>
(retract ?regla)
)

;;;; EJERCICIO 3 
;;;; deduce si hay dos en linea de cualquier jugador con el test y son seguidos
;;;; conectado juego direccion fila1 columna1 fila2 columna2 jugador

(defrule linea2
(Tablero Juego ?f1 ?c1 ?J)
(Tablero Juego ?f2 ?c2 ?J)
(test (neq ?J _))
(siguiente ?f1 ?c1 ?d ?f2 ?c2)
=>
(assert (conectado Juego ?d ?f1 ?c1 ?f2 ?c2 ?J))
)

;;;; EJERCICIO 4
;;;; Deduce si hay 3 en linea de cualquier jugador con el test y si son seguidos
;;;; con ambos conectados para asegurarse que son 3 seguidos en la misma direccion y jugador
;;;; y crea un fact con Ctres juego direccion fila1 columna1 fila2 columna2 fila3 columna3 jugador

(defrule linea3_siguiente
(Tablero Juego ?f1 ?c1 ?J)
(Tablero Juego ?f2 ?c2 ?J)
(Tablero Juego ?f3 ?c3 ?J)
(test (neq ?J _))
(conectado Juego ?d ?f1 ?c1 ?f2 ?c2 ?J)
(conectado Juego ?d ?f2 ?c2 ?f3 ?c3 ?J)
=>
(assert (Ctres Juego ?d ?f1 ?c1 ?f2 ?c2 ?f3 ?c3 ?J))
)


;;; EJERCICIO 5
;;;

;;;; NEGAR GANAR AL JUGADOR
;;;; COMENTARIO: Esta funcion la he intentado todo lo posible pero nunca la detecta lo he intentado de todas las maneras con ?J y luego un test,cambiando los siguientes de todas las maneras posible y nada
;;;; Mi idea era que en el turno de la maquina si hubiese tres fichas del jugador y una vacia estando los 3 en linea y la vacia estuviese en anterior
;;;; o siguiente misma direccion con los tres unidos que m jugase para negarlo pero como comente no me lo detecta nunca de ninguna manera
;;;; y prosupuesto caeria para siempre saber que esta vacia y es la siguiente en poner

(defrule neg_ganar
(declare (salience 999))
?f <-(Turno M)
(Tablero Juego ?f1 ?c1 J)
(Tablero Juego ?f2 ?c2 J)
(Tablero Juego ?f3 ?c3 J)
(Tablero Juego ?f4 ?c4 _)
(Ctres Juego ?d ?f1 ?c1 ?f2 ?c2 ?f3 ?c3 J)
(caeria ?f4 ?c4)
(or 
    (siguiente ?f3 ?c3 ?d ?f4 ?c4)
    (anterior ?f1 ?c1 ?d ?f4 ?c4)
)
=>
(retract ?f)
(printout t "JUEGO en la columna por neg_ganar " ?c4 crlf)
(assert (Juega M ?c4))
)

;;;; lo intente con solo dos J y evitarlo antes pero tampoco funciona

(defrule neg_ganar
(declare (salience 999))
?f <-(Turno M)
(Tablero Juego ?f1 ?c1 J)
(Tablero Juego ?f2 ?c2 J)
(Tablero Juego ?f4 ?c4 _)
(conectado Juego ?d ?f1 ?c1 ?f2 ?c2 J)
(caeria ?f4 ?c4)
(or 
    (siguiente ?f2 ?c2 ?d ?f4 ?c4)
    (anterior ?f1 ?c1 ?d ?f4 ?c4)
)
=>
(retract ?f)
(printout t "JUEGO en la columna por neg_ganar " ?c4 crlf)
(assert (Juega M ?c4))
)

;;;; M_Ganar horizontal vertical y diagonal En un principio era uno solo pero me di cuenta que no era lo mejor y creo
;;;; que para enseñar a principiantes es mejor que primero eliga victorias en horizontal vertical y por ultimo diagonal si no queda de otra
;;;; funciona detectanto 3 fichas de M y una vacia, se asegura de que estan las tres conectadas y la vacia esta en _MMM o MMM_
;;;; y prosupuesto caeria para siempre saber que esta vacia y retract de turno porque cuando no estaba algunas veces ponia muchas seguidas
;;; por lo que decidi poner retract del fact turno m para asegurarse que no se repite ninguna

(defrule M_ganarh
(declare (salience 107))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f3 ?c3 M)
(Tablero Juego ?f4 ?c4 _)
(Ctres Juego h ?f1 ?c1 ?f2 ?c2 ?f3 ?c3 M)
(caeria ?f4 ?c4)
(or 
    (anterior ?f1 ?c1 h ?f4 ?c4)
    (siguiente ?f3 ?c3 h ?f4 ?c4)
)
?f <- (Turno M)
=>
(printout t "Para ganar en horizontal pongo una ficha en la columna " ?c4 crlf)
(assert (Juega M ?c4))
(retract ?f)
)

;;;; lo unico diferente es que solo hay siguiente en vertical porque abajo ya estan ocupadas

(defrule M_ganarv
(declare (salience 106))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f3 ?c3 M)
(Tablero Juego ?f4 ?c4 _)
(Ctres Juego v ?f1 ?c1 ?f2 ?c2 ?f3 ?c3 M)
(caeria ?f4 ?c4)
(siguiente ?f3 ?c3 v ?f4 ?c4)
?f <- (Turno M)
=>
(printout t "Para ganar en vertical pongo una ficha en la columna  " ?c4 crlf)
(assert (Juega M ?c4))
(retract ?f)
)

(defrule M_ganarv
(declare (salience 106))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f4 ?c4 _)
(Ctres Juego v ?f1 ?c1 ?f2 ?c2 ?f3 ?c3 M)
(caeria ?f4 ?c4)
(siguiente ?f3 ?c3 v ?f4 ?c4)
?f <- (Turno M)
=>
(printout t "Para ganar en vertical pongo una ficha en la columna  " ?c4 crlf)
(assert (Juega M ?c4))
(retract ?f)
)

;;;; hay dos diagonales porque  originalmente eran 2 pero hacia esta funcion cuando estaba en esta posicion 
;;;;    M
;;;;   MJ_ <---  y tuve que cambiarlas

(defrule M_ganard1
(declare (salience 105))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f3 ?c3 M)
(Tablero Juego ?f4 ?c4 _)
(Ctres Juego d1 ?f1 ?c1 ?f2 ?c2 ?f3 ?c3 M)
(caeria ?f4 ?c4)
(or 
    (anterior ?f1 ?c1 d1 ?f4 ?c4)
    (siguiente ?f3 ?c3 d1 ?f4 ?c4)
)
?f <- (Turno M)
=>
(printout t "Para ganar en diagonal pongo una ficha en la columna " ?c4 crlf)
(assert (Juega M ?c4))
(retract ?f)
)

(defrule M_ganard2
(declare (salience 105))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f3 ?c3 M)
(Tablero Juego ?f4 ?c4 _)
(Ctres Juego d2 ?f1 ?c1 ?f2 ?c2 ?f3 ?c3 M)
(caeria ?f4 ?c4)
(or 
    (anterior ?f1 ?c1 d2 ?f4 ?c4)
    (siguiente ?f3 ?c3 d2 ?f4 ?c4)
)
?f <- (Turno M)
=>
(printout t "Para ganar en diagonal pongo una ficha en la columna" ?c4 crlf)
(assert (Juega M ?c4))
(retract ?f)
)

;;;; Realizar jugada para conectar 2 en linea
;;;; Estas deducciones siguiente la misma estructura detecta una m y un _ asegurarse de que cae ahi y estan juega_contrario_actualiza_estado
;;;; estas deducciones son las mas basicas pero se asegura de que vaya haciendo algunas parejas
;;;; diagonal esta juntas porque al ser de 2 no hace falta separarlos 

(defrule jugar2enlinead
(declare (salience 60))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 _)
(caeria ?f2 ?c2)
(or
    (anterior ?f1 ?c1 d1|d2 ?f2 ?c2)
    (siguiente ?f1 ?c1 d1|d2 ?f2 ?c2)
)
?f <- (Turno M)
=>
(printout t "Para hacer 2 en diagonal y acumular fichas unidas pongo una ficha en la columna " ?c2 crlf)
(assert (Juega M ?c2))
(retract ?f)
)

(defrule jugar2enlineah
(declare (salience 65))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 _)
(caeria ?f2 ?c2)
(or
    (anterior ?f1 ?c1 h ?f2 ?c2)
    (siguiente ?f1 ?c1 h ?f2 ?c2)
)
?f <- (Turno M)
=>
(printout t "Para hacer 2 en horizontal y acumular fichas unidas pongo una ficha en la columna " ?c2 crlf)
(assert (Juega M ?c2))
(retract ?f)
)

(defrule jugar2enlineav
(declare (salience 62))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 _)
(caeria ?f2 ?c2)
(siguiente ?f1 ?c1 v ?f2 ?c2)
?f <- (Turno M)
=>
(printout t "Para hacer 2 en vertical y acumular fichas unidas pongo una ficha en la columna " ?c2 crlf)
(assert (Juega M ?c2))
(retract ?f)
)


;;;; Realizar jugada para conectar 3 en linea
;;;; deduce 2 seguidas una _ que estan conectados de algunas manera siguiente, anterior con caeria y estructura
;;;; estan separadas en distintas reglas porque algunas veces hacia muchas diagonales y creo que es mejor aprender horizontal vertical y diagonal respectivamente


(defrule jugar3enlineah
(declare (salience 93))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f3 ?c3 _)
(conectado Juego h ?f1 ?c1 ?f2 ?c2 M)
(or 
    (siguiente ?f2 ?c2 h ?f3 ?c3)
    (anterior ?f3 ?c3 h ?f1 ?c1)
)
(caeria ?f3 ?c3)
?f <- (Turno M)
=>
(printout t "Para hacer 3 en horizontal y acumular fichas unidas pongo una ficha en la columna " ?c3 crlf)
(assert (Juega M ?c3))
(retract ?f)
)


(defrule jugar3enlinead1
(declare (salience 91))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f3 ?c3 _)
(caeria ?f3 ?c3)
(conectado Juego d1 ?f1 ?c1 ?f2 ?c2 M)
(siguiente ?f2 ?c2 d1 ?f3 ?c3)
?f <- (Turno M)
=>
(printout t "Para hacer 3 en diagonal y acumular fichas unidas pongo una ficha en la columna " ?c3 crlf)
(assert (Juega M ?c3))
(retract ?f)
)

(defrule jugar3enlinead2
(declare (salience 91))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f3 ?c3 _)
(caeria ?f3 ?c3)
(conectado Juego d2 ?f1 ?c1 ?f2 ?c2 M)
(or
    (anterior ?f1 ?c1 d2 ?f3 ?c3)
    (siguiente ?f2 ?c2 d2 ?f3 ?c3)
)
?f <- (Turno M)
=>
(printout t "Para hacer 3 en diagonal y acumular fichas unidas pongo una ficha en la columna " ?c3 crlf)
(assert (Juega M ?c3))
(retract ?f)
)

(defrule jugar3enlineav
(declare (salience 92))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f3 ?c3 _)
(caeria ?f3 ?c3)
(conectado Juego v ?f1 ?c1 ?f2 ?c2 M)
(siguiente ?f2 ?c2 v ?f3 ?c3)
?f <- (Turno M)
=>
(printout t "Para hacer 3 en vertical y acumular fichas unidas pongo una ficha en la columna " ?c3 crlf)
(assert (Juega M ?c3))
(retract ?f)
)

;;;; hace M-M
;;;; con las mismas estructuras hace que m consiga muchas m seguidas y hacer que m se unan mas porque
;;;; si estan separadas no haria 2 seguidas ni 3 con las deducciones anteriores nos aseguramos que si 
;;;; acumulando unidas de esta manera tambien
;;;; detecta M_M la _ con siguiente e anterior de las m si es la misma sabemos que esta ahi 

(defrule jugarJ_J
(declare (salience 99))
(Turno M)
(Tablero Juego ?f1 ?c1 M)
(Tablero Juego ?f2 ?c2 M)
(Tablero Juego ?f3 ?c3 _)
(caeria ?f3 ?c3)
(siguiente ?f1 ?c1 h ?f3 ?c3)
(anterior ?f2 ?c2 h ?f3 ?c3)
?f <- (Turno M)
=>
(printout t "Para tener mas M seguidas juego en la columna " ?c3 crlf)
(assert (Juega M ?c3))
(retract ?f)
)


;;;; evita J-J
;;;; al igual que la siguiente pero asegura que j no acumule muchas seguidas y gane

(defrule jugarJ_J
(declare (salience 98))
(Turno M)
(Tablero Juego ?f1 ?c1 J)
(Tablero Juego ?f2 ?c2 J)
(Tablero Juego ?f3 ?c3 _)
(caeria ?f3 ?c3)
(siguiente ?f1 ?c1 h ?f3 ?c3)
(anterior ?f2 ?c2 h ?f3 ?c3)
?f <- (Turno M)
=>
(printout t "Para evitar muchas acumulaciones de J juego en la columna " ?c3 crlf)
(assert (Juega M ?c3))
(retract ?f)

)





