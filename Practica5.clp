;;;; Este sistema experto actua como yo lo haria por lo tanto explicare antes el conocimiento que tengo sobre cada rama 
;;;; CSI: Tengo entendido que le debe gustar las matematicas ya que se usan bastante,debe de tener buena|media notas,No hardware, Le interesa la IA y No le gusta mucho el desarrollo web
;;;; IS: Tengo entendido que no hay muchas matematicas porque es practicamente desarrollo web, media|baja nostas(por lo que si tiene buenas notas tambien podria), No hardware, No le intereasa IA y le gusta el desarrollo web
;;;; IC: no mates, cualquier nota esta bien, Si hardware,no IA y no desarrollo web
;;;; SI: Si mates (ya que SI ayudan a administrar, recolectar, recuperar, procesar, almacenar,distribuir información relevante para los procesos fundamentales y creo que las mates vendria bien),Cualquier nota, no hardware,no IA,no desarollo web
;;;; TI: Si mates, Buena|media, Si hardware ya que se centra en hardware y softwarte, IA no, no desarrollo web
;;;; Cuando tiene notas que no son buenas y le gusta las que tiene buenas, le pregunta si le gusta esforzarse, si elige mucho entonces se las recomienda porque no es imposible y si elige poco les recomienda otras parecidas
;;;; el sistema tiene algunas caracterictas con las respuestas del usuario gusta_---- Si|No 
;;;; al principio solo preguntas unas cuentas si no tiene suficiente informacion para deducir una adecuada le prugunta algunas mas o elige dependiendo de las notas de media que haya introducido
;;;; en nota_media ?x 
;;;; cuando decide una realiza un hecho como (conclusion -) ---> - es la distinta rama
;;;;

(deffacts Ramas
(Rama Computación_y_Sistemas_Inteligentes)
(Rama Ingeniería_del_Software)
(Rama Ingeniería_de_Computadores)
(Rama Sistemas_de_Información)
(Rama Tecnologías_de_la_Información)
(Rama nada)
)

(deffacts datos
(Asignatura ALEM)
(Asignatura CA)
(Asignatura FFT)
(Asignatura FP)
(Asignatura FS)
(Asignatura EC)
(Asignatura PDOO)
(Asignatura SCD)
(Asignatura SO)
(Asignatura ES)
(Asignatura IES)
(Asignatura LMD)
(Asignatura MP)
(Asignatura TOC)
(Asignatura ALG)
(Asignatura AC)
(Asignatura FBD)
(Asignatura FIS)
(Asignatura IA)
)

;;;; PRESENTACION Y ELECCION DE MODULO

(defrule Presentacion
(declare (salience 9999))
=>
(printout t"Hola usuario, Este sistema puede aconsejarte con la rama o con dos asignaturas¿que prefiere? Asignaturas/Ramas" crlf)
(assert (modulo (read)))
)

;;;; FUNCIONES DE LA PLANTILLA DE FACTOR CERTEZA 

;(FactorCerteza ?h si|no ?f) representa que ?h se ha deducido con factor de certeza ?factor
;?h podra_ser:
; -Computación_y_Sistemas_Inteligentes
; -Ingeniería_del_Software
; -Ingeniería_de_Computadores
; -Sistemas_de_Información
; -Tecnologías_de_la_Información
;(Evidencia ?e si|no) representa el hecho de si evidencia ?e se dato
; ?e podra 
; -le gusta las matematicas
; -le gusta_hardware
; -le gusta_IA
; -pregunta nota
; - le gusta desarrollo software(DW)


;;; convertimos cada evidencia en una afirmacion sobre su factor
;;; de certeza
(defrule certeza_evidencias
(Evidencia ?e ?r)
=>
(assert (FactorCerteza ?e ?r 1)) )

;; También podríamos considerar evidencias con una cierta
;;incertidumbre: al preguntar por la evidencia, pedir y recoger
;;directamente el grado de certeza

;;; encadenado
(deffunction encadenado 
(?fc_antecedente ?fc_regla)
(if (> ?fc_antecedente 0)
then
(bind ?rv (* ?fc_antecedente ?fc_regla))
else
(bind ?rv 0) )
?rv)

(deffunction combinacion 
(?fc1 ?fc2)
(if (and (> ?fc1 0) (> ?fc2 0) )
then
(bind ?rv (- (+ ?fc1 ?fc2) (* ?fc1 ?fc2) ) )
else
(if (and (< ?fc1 0) (< ?fc2 0) )
then
(bind ?rv (+ (+ ?fc1 ?fc2) (* ?fc1 ?fc2) ) )
else
(bind ?rv (/ (+ ?fc1 ?fc2) (- 1 (min (abs ?fc1) (abs ?fc2))) ))
)
)
?rv)

;;;;;; Combinar misma deduccion por distintos caminos
(defrule combinar
(declare (salience 1))
?f <- (FactorCerteza ?h ?r ?fc1)
?g <- (FactorCerteza ?h ?r ?fc2)
(test (neq ?fc1 ?fc2))
=>
(retract ?f ?g)
(assert (FactorCerteza ?h ?r (combinacion ?fc1 ?fc2))) 
)



;;;; inicio el valor en default para que empiecepreguntando
;;;; MODULO DE RAMAS
;;;;

(defrule valores_default

=>
(assert (conclusion NONE))
)

;;;; 
;;;; PREGUNTAS DEL MODULO RAMAS
;;;;

(defrule pregunta_nota
(declare (salience 100))
(modulo Ramas)
=>
(printout t "¿Que nota media tiene?alta(9/10)/media(7,8)/baja(5,6)" crlf)
(assert (Evidencia nota_media (read)))
)

(defrule pregunta_gustarMates
(declare (salience 100))
(modulo Ramas)
=>
(printout t "¿Le gusta las matematicas?si/no/nose" crlf)
(assert (Evidencia gusta_matematicas (read)))
)

(defrule preguntar_gustarHardware
(declare (salience 10))
(modulo Ramas)
=>
(printout t "¿Le gusta el hardware?si/no/nose" crlf)
(assert (Evidencia gusta_hardware (read)))
)

(defrule preguntar_gustarIA
(declare (salience 10))
(modulo Ramas)
=>
(printout t "¿Le gusta la inteligencia artificial?si/no/nose" crlf)
(assert (Evidencia gusta_IA (read)))
)

(defrule preguntar_gustarDW
(declare (salience 10))
(modulo Ramas)
=>
(printout t "¿Le gusta el desarrollo web? si/no/nose" crlf)
(assert (Evidencia gusta_DW (read)))
)


(defrule pregunta_programar
(modulo Ramas)
=>
(printout t"Le gusta programar? si|no|nose" crlf)
(assert (Evidencia gusta_programar(read)))
)

(defrule pregunta_buenanotasMates
(modulo Ramas)
=>
(printout t"Tiene buenas notas en mates si|no|nose" crlf)
(assert (Evidencia gusta_buenasnotasmates(read)))
)

(defrule preguntar_esfuerzo
(modulo Ramas)
=>
(printout t"Prefiriria estudiar lo que le gusta pero esforzarse mucho o poco y algo parecido? si|no|nose" crlf)
(assert (Evidencia gusta_esfuerzo(read)))
)


;;;; los que en el ejemplo de factor de  certeza serian los Rs donde se ponen los FACTORES
;;;; los he puesto segun la descripcion de arriba

(defrule gusta_nada
(declare (salience -10))
(modulo Ramas)
(FactorCerteza gusta_matematicas no ?f1)
(FactorCerteza gusta_hardware no ?f1)
(FactorCerteza gusta_IA no ?f1)
(FactorCerteza gusta_DW no ?f1)
(FactorCerteza gusta_esfuerzo no ?f1)
(FactorCerteza gusta_programar no ?f1)
=>
(printout t "No te gusta nada mejor salte de la carrera" crlf)
)

(defrule gusta_matematicas_SI
(modulo Ramas)
(FactorCerteza gusta_matematicas si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si(encadenado ?f1 0.3)))
(assert (FactorCerteza Sistemas_de_Información si(encadenado ?f1 0.4)))
(assert (FactorCerteza Tecnologías_de_la_Información si (encadenado ?f1 0.3)))
)

(defrule gusta_matematicas_NO
(modulo Ramas)
(FactorCerteza gusta_matematicas si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si(encadenado ?f1 -0.3)))
(assert (FactorCerteza Sistemas_de_Información si(encadenado ?f1 -0.4)))
(assert (FactorCerteza Tecnologías_de_la_Información si (encadenado ?f1 -0.3)))
)


(defrule nota_media_baja
(modulo Ramas)
(FactorCerteza nota_media baja ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si(encadenado ?f1 -0.3)))
(assert (FactorCerteza Tecnologías_de_la_Información si(encadenado ?f1 -0.15)))
)

(defrule nota_media_alta
(modulo Ramas)
(FactorCerteza nota_media alta ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si(encadenado ?f1 0.3)))
(assert (FactorCerteza Tecnologías_de_la_Información si(encadenado ?f1 0.15)))
)

(defrule gusta_hardware_SI
(modulo Ramas)
(FactorCerteza gusta_hardware si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Ingeniería_de_Computadores si(encadenado ?f1 0.5)))
(assert (FactorCerteza Tecnologías_de_la_Información si(encadenado ?f1 0.25)))
)

(defrule gusta_hardware_NO
(modulo Ramas)
(FactorCerteza gusta_hardware no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Ingeniería_de_Computadores si(encadenado ?f1 -0.5)))
(assert (FactorCerteza Tecnologías_de_la_Información si(encadenado ?f1 -0.25)))
)

(defrule gusta_IA_SI
(modulo Ramas)
(FactorCerteza gusta_IA si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si (encadenado ?f1 0.5)))
)

(defrule gusta_IA_NO
(modulo Ramas)
(FactorCerteza gusta_IA no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si (encadenado ?f1 -0.5)))
)

(defrule gusta_DW_SI
(modulo Ramas)
(FactorCerteza gusta_DW si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Ingeniería_del_Software si (encadenado ?f1 0.6)))
)

(defrule gusta_DW_NO
(modulo Ramas)
(FactorCerteza gusta_DW no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Ingeniería_del_Software si (encadenado ?f1 -0.6)))
)


(defrule gusta_programar_SI
(modulo Ramas)
(FactorCerteza gusta_programar si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si (encadenado ?f1 0.29)))
(assert (FactorCerteza Ingeniería_del_Software si (encadenado ?f1 0.37)))
(assert (FactorCerteza Tecnologías_de_la_Información si (encadenado ?f1 0.27)))
)

(defrule gusta_programar_NO
(modulo Ramas)
(FactorCerteza gusta_programar no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Tecnologías_de_la_Información si (encadenado ?f1 -0.27)))
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si (encadenado ?f1 -0.29)))
(assert (FactorCerteza Ingeniería_del_Software si (encadenado ?f1 -0.37)))
)


(defrule gusta_buenasnotasmates_SI
(modulo Ramas)
(FactorCerteza gusta_buenasnotasmates si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si (encadenado ?f1 0.14)))
(assert (FactorCerteza Tecnologías_de_la_Información si (encadenado ?f1 0.10)))
(assert (FactorCerteza Sistemas_de_Información si (encadenado ?f1 0.15)))
(assert (FactorCerteza Ingeniería_de_Computadores si (encadenado ?f1 -0.2)))
(assert (FactorCerteza Ingeniería_del_Software si (encadenado ?f1 -0.18)))
)

(defrule gusta_buenasnotasmates_NO
(modulo Ramas)
(FactorCerteza gusta_buenasnotasmates si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Ingeniería_de_Computadores si (encadenado ?f1 0.2)))
(assert (FactorCerteza Ingeniería_del_Software si (encadenado ?f1 0.18)))
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si (encadenado ?f1 -0.14)))
(assert (FactorCerteza Tecnologías_de_la_Información si (encadenado ?f1 -0.10)))
(assert (FactorCerteza Sistemas_de_Información si (encadenado ?f1 -0.15)))
)

(defrule gusta_esfuerzo_SI
(modulo Ramas)
(FactorCerteza gusta_esfuerzo si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si (encadenado ?f1 0.15)))
(assert (FactorCerteza Tecnologías_de_la_Información si (encadenado ?f1 0.12)))
(assert (FactorCerteza Ingeniería_del_Software si (encadenado ?f1 -0.10)))
(assert (FactorCerteza Ingeniería_de_Computadores si (encadenado ?f1 -0.11)))
(assert (FactorCerteza Sistemas_de_Información si (encadenado ?f1 -0.13)))
)

(defrule gusta_esfuerzo_NO
(modulo Ramas)
(FactorCerteza gusta_esfuerzo no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza Ingeniería_del_Software si (encadenado ?f1 0.10)))
(assert (FactorCerteza Ingeniería_de_Computadores si (encadenado ?f1 0.11)))
(assert (FactorCerteza Sistemas_de_Información si (encadenado ?f1 0.13)))
(assert (FactorCerteza Computación_y_Sistemas_Inteligentes si (encadenado ?f1 -0.15)))
(assert (FactorCerteza Tecnologías_de_la_Información si (encadenado ?f1 -0.12)))
)

(defrule Max_hipotesis_inicializacion
(declare (salience 11))
(modulo Ramas)
=>
(assert (Max_hipotesis desconocido 0))
)



;;;; elecciones de las hipotesis cuando son Max_hipotesis

(defrule hipotesis_CSI
(declare (salience -1))
(modulo Ramas)
?f<-(FactorCerteza Computación_y_Sistemas_Inteligentes si ?f1)
?g<-(Max_hipotesis ?X ?f2)
(test (> ?f1 ?f2))
=>
(retract ?f ?g)
(assert (Max_hipotesis Computación_y_Sistemas_Inteligentes ?f1))
)

(defrule hipotesis_IS
(declare (salience -1))
(modulo Ramas)
?f<-(FactorCerteza Ingeniería_del_Software si ?f1)
?g<-(Max_hipotesis ?X ?f2)
(test (> ?f1 ?f2))
=>
(retract ?f ?g)
(assert (Max_hipotesis Ingeniería_del_Software ?f1))
)

(defrule hipotesis_IC
(declare (salience -1))
(modulo Ramas)
?f<-(FactorCerteza Ingeniería_de_Computadores si ?f1)
?g<-(Max_hipotesis ?X ?f2)
(test (> ?f1 ?f2))
=>
(retract ?f ?g)
(assert (Max_hipotesis Ingeniería_de_Computadores ?f1))
)

(defrule hipotesis_SI
(declare (salience -1))
(modulo Ramas)
?f<-(FactorCerteza Sistemas_de_Información si ?f1)
?g<-(Max_hipotesis ?X ?f2)
(test (> ?f1 ?f2))
=>
(retract ?f ?g)
(assert (Max_hipotesis Sistemas_de_Información ?f1))
)

(defrule hipotesis_TI
(declare (salience -1))
(modulo Ramas)
?f<-(FactorCerteza Tecnologías_de_la_Información si ?f1)
?g<-(Max_hipotesis ?X ?f2)
(test (> ?f1 ?f2))
=>
(retract ?f ?g)
(assert (Max_hipotesis Tecnologías_de_la_Información ?f1))
)

;;;; cuando ya no hay mas cambios en Max_hipotesis pues se decide un problema FINALMENTE

(defrule decision_CSI 
(declare (salience -4))
(modulo Ramas)
?f<-(Max_hipotesis ?hip ?x)
(test (and (> ?x 0)(eq ?hip Computación_y_Sistemas_Inteligentes)))
=>
(retract ?f)
(assert (conclusion Computación_y_Sistemas_Inteligentes ?x))
)

(defrule decision_IS
(declare (salience -4))
(modulo Ramas)
?f<-(Max_hipotesis ?hip ?x)
(test (and (> ?x 0)(eq ?hip Ingeniería_del_Software)))
=>
(retract ?f)
(assert (conclusion Ingeniería_del_Software ?x))
)

(defrule decision_IC
(declare (salience -4))
(modulo Ramas)
?f<-(Max_hipotesis ?hip ?x)
(test (and (> ?x 0)(eq ?hip Ingeniería_de_Computadores)))
=>
(retract ?f)
(assert (conclusion Ingeniería_de_Computadores ?x))
)

(defrule decision_SI
(declare (salience -4))
(modulo Ramas)
?f<-(Max_hipotesis ?hip ?x)
(test (and (> ?x 0)(eq ?hip Sistemas_de_Información)))
=>
(retract ?f)
(assert (conclusion Sistemas_de_Información ?x))
)

(defrule decision_TI
(declare (salience -4))
(modulo Ramas)
?f<-(Max_hipotesis ?hip ?x)
(test (and (> ?x 0)(eq ?hip Tecnologías_de_la_Información)))
=>
(retract ?f)
(assert (conclusion Tecnologías_de_la_Información ?x))
)

;;;;  la decision FINALMENTE

(defrule decision_final
(declare (salience -8))
(modulo Ramas)
(conclusion ?hip ?x)
=>
(bind ?expl (str-cat "El sistema ha deducido que " ?hip " es la rama de mas compatible con usted porque =>"))
(assert(explicacion ?expl))
)

;;;; explicaciones


(defrule explicacion_mates
(declare (salience -7))
(modulo Ramas)
(conclusion ?hip ?x)
(Evidencia gusta_matematicas ?a)
=>
(bind ?expl (str-cat ?a " le gusta las matematicas "))
(assert(explicacion ?expl)) 
)

(defrule explicacion_Hardware
(declare (salience -7))
(modulo Ramas)
(conclusion ?hip ?x)
(Evidencia gusta_hardware ?a)
=>
(bind ?expl (str-cat ?a " le gusta el hardware "))
(assert(explicacion ?expl)) 
)

(defrule explicacion_DW
(declare (salience -7))
(modulo Ramas)
(conclusion ?hip ?x)
(Evidencia gusta_DW ?a)
=>
(bind ?expl (str-cat ?a " le gusta el deserrallo web " ))
(assert(explicacion ?expl)) 
)

(defrule explicacion_IA
(declare (salience -7))
(modulo Ramas)
(conclusion ?hip ?x)
(Evidencia gusta_IA ?a)
=>
(bind ?expl (str-cat ?a " le gusta la inteligencia artificial " ))
(assert(explicacion ?expl)) 
)

(defrule explicacion_notas
(declare (salience -7))
(modulo Ramas)
(conclusion ?hip ?x)
(Evidencia nota_media ?y)
=>
(bind ?expl (str-cat "tiene nota media: " ?y " " ))
(assert(explicacion ?expl)) 
)

(defrule explicacion_esfuerzo
(declare (salience -7))
(modulo Ramas)
(conclusion ?hip ?x)
(Evidencia gusta_esfuerzo ?a)
=>
(bind ?expl (str-cat ?a " le gusta esforzarse " ))
(assert(explicacion ?expl)) 
)

(defrule explicacion_progamar
(declare (salience -7))
(modulo Ramas)
(conclusion ?hip ?x)
(Evidencia gusta_programar ?a)
=>
(bind ?expl (str-cat ?a " le gusta programar " ))
(assert(explicacion ?expl)) 
)


(defrule explicacion_notasmates
(declare (salience -7))
(modulo Ramas)
(conclusion ?hip ?x)
(Evidencia gusta_buenasnotasmates ?a)
=>
(bind ?expl (str-cat ?a " tiene buenas notas en mates " ))
(assert(explicacion ?expl)) 
)

(defrule imprimir_solucion_Ramas
(declare (salience -100))
(modulo Ramas)
(conclusion ?hip ?x)
?f<-(explicacion ?expl)
=>
(printout t ?expl crlf)
(retract ?f)
(bind ?expl2 (str-cat ?expl))
(assert (Consejo ?hip ?expl2))
)


(defrule salir_Ramas
(declare (salience -900))
?f<-(modulo Ramas)
=>
(retract ?f)
)






;;;;;;;;;;;;;
;;;;;;;;;;;;; MODULO ASIGNATURA
;;;;;;;;;;;;;


;;;; PREGUNTAS

(defrule pregunta_mates
(declare (salience 100))
(modulo Asignaturas)
=>
(printout t "¿Le gusta las matematicas?si/no/nose" crlf)
(assert (Evidencia gusta_Asignatura_matematicas (read)))
)

(defrule preguntar_Practicas
(declare (salience 10))
(modulo Asignaturas)
=>
(printout t "¿Le gusta mas practica que teoria?si/no/nose" crlf)
(assert (Evidencia gusta_Asignatura_Practicas (read)))
)

(defrule preguntar_Programar
(declare (salience 10))
(modulo Asignaturas)
=>
(printout t "¿Le gusta programar?si/no/nose" crlf)
(assert (Evidencia gusta_Asignatura_Programar (read)))
)

(defrule preguntar_Facil
(declare (salience 10))
(modulo Asignaturas)
=>
(printout t "¿Prefiere que sean asignaturas mas faciles? si/no/nose" crlf)
(assert (Evidencia gusta_Asignatura_facil (read)))
)

(defrule pregunta_Asignaturas
(declare (salience 10))
(modulo Asignaturas)
=>
(printout t "¿Que asignaturas quiere comparar?(ponga solo sus iniciales como sale en el calendario) por ejemplo Calculo=> CA" crlf)
(assert (Comparar1 (read)))
(assert (Comparar2 (read)))
)


;;;;; FACTORES CERTEZA

(defrule gusta_Asignatura_matematicas
(FactorCerteza gusta_Asignatura_matematicas si ?f1)
(test (> ?f1 0))
(modulo Asignaturas)
=>
(assert (FactorCerteza ALEM si(encadenado ?f1 0.55)))
(assert (FactorCerteza CA si(encadenado ?f1 0.7)))
(assert (FactorCerteza FFT si (encadenado ?f1 0.5)))
(assert (FactorCerteza ES si(encadenado ?f1 0.65)))
(assert (FactorCerteza LMD si(encadenado ?f1 0.35)))
(assert (FactorCerteza ALG si(encadenado ?f1 0.20)))
)

(defrule gusta_Practicas_SI
(modulo Asignaturas)
(FactorCerteza gusta_Asignatura_Practicas si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza ALEM si(encadenado ?f1 -0.52)))
(assert (FactorCerteza CA si(encadenado ?f1 -0.53)))
(assert (FactorCerteza FFT si (encadenado ?f1 -0.3)))
(assert (FactorCerteza FP si (encadenado ?f1 0.46)))
(assert (FactorCerteza EC si (encadenado ?f1 0.5)))
(assert (FactorCerteza IES si (encadenado ?f1 -0.7)))
(assert (FactorCerteza ES si(encadenado ?f1 -0.36)))
(assert (FactorCerteza LMD si(encadenado ?f1 -0.33)))
(assert (FactorCerteza MP si (encadenado ?f1 0.47)))
(assert (FactorCerteza TOC si (encadenado ?f1 0.57)))
(assert (FactorCerteza AC si (encadenado ?f1 0.38)))
(assert (FactorCerteza FBD si (encadenado ?f1 -0.3)))
(assert (FactorCerteza FIS si (encadenado ?f1 -0.51)))
)

(defrule gusta_Practicas_NO
(modulo Asignaturas)
(FactorCerteza gusta_Asignatura_Practicas no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza ALEM si(encadenado ?f1 0.52)))
(assert (FactorCerteza CA si(encadenado ?f1 0.53)))
(assert (FactorCerteza FFT si (encadenado ?f1 0.3)))
(assert (FactorCerteza FP si (encadenado ?f1 -0.46)))
(assert (FactorCerteza EC si (encadenado ?f1 -0.5)))
(assert (FactorCerteza IES si (encadenado ?f1 0.7)))
(assert (FactorCerteza ES si(encadenado ?f1 0.36)))
(assert (FactorCerteza LMD si(encadenado ?f1 0.33)))
(assert (FactorCerteza MP si (encadenado ?f1 -0.47)))
(assert (FactorCerteza TOC si (encadenado ?f1 -0.57)))
(assert (FactorCerteza AC si (encadenado ?f1 -0.38)))
(assert (FactorCerteza FBD si (encadenado ?f1 0.3)))
(assert (FactorCerteza FIS si (encadenado ?f1 0.51)))
)


(defrule gusta_Asignatura_programar_SI
(modulo Asignaturas)
(FactorCerteza gusta_Asignatura_Programar si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza ALEM si(encadenado ?f1 -0.25)))
(assert (FactorCerteza CA si(encadenado ?f1 -0.37)))
(assert (FactorCerteza FP si (encadenado ?f1 0.67)))
(assert (FactorCerteza PDOO si (encadenado ?f1 0.46)))
(assert (FactorCerteza SCD si (encadenado ?f1 0.28)))
(assert (FactorCerteza IES si (encadenado ?f1 -0.7)))
(assert (FactorCerteza ES si(encadenado ?f1 -0.58)))
(assert (FactorCerteza LMD si(encadenado ?f1 -0.52)))
(assert (FactorCerteza MP si (encadenado ?f1 0.78)))
(assert (FactorCerteza ALG si (encadenado ?f1 0.37)))
(assert (FactorCerteza FBD si (encadenado ?f1 0.14)))
(assert (FactorCerteza FIS si (encadenado ?f1 -0.53)))
(assert (FactorCerteza IA si (encadenado ?f1 0.38)))
(assert (FactorCerteza AC si (encadenado ?f1 0.23)))
)

(defrule gusta_Asignatura_programar_NO
(modulo Asignaturas)
(FactorCerteza gusta_Asignatura_Programar no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza ALEM si(encadenado ?f1 0.25)))
(assert (FactorCerteza CA si(encadenado ?f1 0.37)))
(assert (FactorCerteza FP si (encadenado ?f1 -0.67)))
(assert (FactorCerteza PDOO si (encadenado ?f1 -0.46)))
(assert (FactorCerteza SCD si (encadenado ?f1 -0.28)))
(assert (FactorCerteza IES si (encadenado ?f1 0.7)))
(assert (FactorCerteza ES si(encadenado ?f1 0.58)))
(assert (FactorCerteza LMD si(encadenado ?f1 0.52)))
(assert (FactorCerteza MP si (encadenado ?f1 -0.78)))
(assert (FactorCerteza ALG si (encadenado ?f1 -0.37)))
(assert (FactorCerteza FBD si (encadenado ?f1 -0.14)))
(assert (FactorCerteza FIS si (encadenado ?f1 0.53)))
(assert (FactorCerteza IA si (encadenado ?f1 -0.38)))
(assert (FactorCerteza AC si (encadenado ?f1 -0.23)))
)

(defrule gusta_Asignatura_facil_si
(modulo Asignaturas)
(FactorCerteza gusta_Asignatura_facil si ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza ALEM si(encadenado ?f1 -0.39)))
(assert (FactorCerteza CA si(encadenado ?f1 0.12)))
(assert (FactorCerteza FP si (encadenado ?f1 0.32)))
(assert (FactorCerteza FS si (encadenado ?f1 0.16)))
(assert (FactorCerteza EC si (encadenado ?f1 -0.35)))
(assert (FactorCerteza PDOO si (encadenado ?f1 0.31)))
(assert (FactorCerteza SCD si (encadenado ?f1 -0.37)))
(assert (FactorCerteza IES si (encadenado ?f1 0.47)))
(assert (FactorCerteza ES si(encadenado ?f1 0.35)))
(assert (FactorCerteza LMD si(encadenado ?f1 0.11)))
(assert (FactorCerteza MP si (encadenado ?f1 -0.27)))
(assert (FactorCerteza TOC si (encadenado ?f1 0.34)))
(assert (FactorCerteza ALG si (encadenado ?f1 -0.42)))
(assert (FactorCerteza FBD si (encadenado ?f1 0.31)))
(assert (FactorCerteza FIS si (encadenado ?f1 0.53)))
(assert (FactorCerteza IA si (encadenado ?f1 0.22)))
(assert (FactorCerteza AC si (encadenado ?f1 -0.49)))
)

(defrule gusta_Asignatura_facil_NO
(modulo Asignaturas)
(FactorCerteza gusta_Asignatura_facil no ?f1)
(test (> ?f1 0))
=>
(assert (FactorCerteza ALEM si(encadenado ?f1 0.39)))
(assert (FactorCerteza CA si(encadenado ?f1 -0.12)))
(assert (FactorCerteza FP si (encadenado ?f1 -0.32)))
(assert (FactorCerteza FS si (encadenado ?f1 -0.16)))
(assert (FactorCerteza EC si (encadenado ?f1 0.35)))
(assert (FactorCerteza PDOO si (encadenado ?f1 -0.31)))
(assert (FactorCerteza SCD si (encadenado ?f1 0.37)))
(assert (FactorCerteza IES si (encadenado ?f1 -0.47)))
(assert (FactorCerteza ES si(encadenado ?f1 -0.35)))
(assert (FactorCerteza LMD si(encadenado ?f1 -0.11)))
(assert (FactorCerteza MP si (encadenado ?f1 0.27)))
(assert (FactorCerteza TOC si (encadenado ?f1 -0.34)))
(assert (FactorCerteza ALG si (encadenado ?f1 0.42)))
(assert (FactorCerteza FBD si (encadenado ?f1 -0.31)))
(assert (FactorCerteza FIS si (encadenado ?f1 -0.53)))
(assert (FactorCerteza IA si (encadenado ?f1 -0.22)))
(assert (FactorCerteza AC si (encadenado ?f1 0.49)))
)

(defrule decision_final_nada
(declare (salience -10))
(modulo Asignaturas)
(FactorCerteza gusta_Asignatura_facil si ?f1)
(FactorCerteza gusta_Asignatura_matematicas no ?f1)
(FactorCerteza gusta_Asignatura_Practicas no ?f1)
(FactorCerteza gusta_Asignatura_Programar no ?f1)
=>
(printout t "No elijas ninguna no te gusta nada y vas a lo facil" crlf)
)


(defrule decision_final1
(declare (salience -6))
(modulo Asignaturas)
?f<-(Comparar1 ?a)
?g<-(Comparar2 ?b)
(FactorCerteza ?x si ?f1)
(FactorCerteza ?y si ?f2)
(test (eq ?x ?a))
(test (eq ?y ?b))
(test (> ?f1 ?f2))
=>
(printout t "El sistema ha deducido que mejor elijas la asignatura " ?x " porque =>" crlf)
(retract ?f ?g)
)


(defrule decision_final2
(declare (salience -6))
(modulo Asignaturas)
?f<-(Comparar1 ?a)
?g<-(Comparar2 ?b)
(FactorCerteza ?x si ?f1)
(FactorCerteza ?y si ?f2)
(test (eq ?x ?a))
(test (eq ?y ?b))
(test (> ?f2 ?f1))
=>
(printout t "El sistema ha deducido que mejor elijas la asignatura " ?y " porque =>" crlf)
(retract ?f ?g)
)

(defrule decision_final3
(declare (salience -6))
(modulo Asignaturas)
?f<-(Comparar1 ?a)
?g<-(Comparar2 ?b)
(FactorCerteza ?x si ?f1)
(FactorCerteza ?y si ?f2)
(test (eq ?x ?a))
(test (eq ?y ?b))
(test (eq ?f2 ?f1))
=>
(printout t "El sistema ha deducido que segun tus gustos cualquier asignatura te gustaria,segun => " crlf)
(retract ?f ?g)
)

;;;; explicaciones

(defrule explicacion_AsignaturaMates
(declare (salience -7))
(modulo Asignaturas)
(Evidencia gusta_Asignatura_matematicas ?x)
=>
(bind ?expl (str-cat  ?x " le gusta las matematicas "))
(assert(explicacion ?expl)) 
)

(defrule explicacion_Asignatura_practicas
(declare (salience -7))
(modulo Asignaturas)
(Evidencia gusta_Asignatura_Practicas si)
=>
(bind ?expl (str-cat " prefiere mas practicas que teoria "))
(assert(explicacion ?expl)) 
)

(defrule explicacion_Asignatura_teoria
(declare (salience -7))
(modulo Asignaturas)
(Evidencia gusta_Asignatura_Practicas no)
=>
(bind ?expl (str-cat "prefiere mas teoria que practicas "))
(assert(explicacion ?expl)) 
)

(defrule explicacion_Asignatura_programar_Si
(declare (salience -7))
(modulo Asignaturas)
(Evidencia gusta_Asignatura_Programar si)
=>
(bind ?expl (str-cat "le gusta programar " ))
(assert(explicacion ?expl)) 
)

(defrule explicacion_Asignatura_programar_no
(declare (salience -7))
(modulo Asignaturas)
(Evidencia gusta_Asignatura_Programar no)
=>
(bind ?expl (str-cat "no le gusta programar " ))
(assert(explicacion ?expl)) 
)

(defrule explicacion_Asignatura_facil_si
(declare (salience -7))
(modulo Asignaturas)
(Evidencia gusta_Asignatura_facil si)
=>
(bind ?expl (str-cat "prefiere que las asignaturas sean mas faciles " ))
(assert(explicacion ?expl)) 
)

(defrule explicacion_Asignatura_facil_no
(declare (salience -7))
(modulo Asignaturas)
(Evidencia gusta_Asignatura_facil no)
=>
(bind ?expl (str-cat "no prefiere que las asignaturas sean mas faciles " ))
(assert(explicacion ?expl)) 
)

(defrule imprimir_solucion_Asignatura
(declare (salience -100))
(modulo Asignaturas)
?f<-(explicacion ?y)
=>
(printout t ?y crlf)
(retract ?f)
)

(defrule salir_Asignatura
(declare (salience -900))
?f<-(modulo Asignatura)
=>
(retract ?f)
)





