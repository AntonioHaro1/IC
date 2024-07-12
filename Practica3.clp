
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
(Rama NADA)
)



;;;; inicio el valor en default para que empiecepreguntando

;;;;

(defrule valores_default

=>
(assert (preguntar_Nota SI))

(assert (conclusion NONE))
)

;;;; Presentacion para el usuario sepa que esta haciendo
;;;;

(defrule Presentacion
(declare (salience 9999))
=>
(printout t"Hola usuario, Este es un sistema experto para aconsejarte de la rama correcta que deberias elegir, le haremos algunas preguntas a continuacion" crlf)
)

;;;; Pregunta si la nota media es ALTA|MEDIA|baja
;;;; la estructara de estas deducciones es para que vaya preguntando las primera preguntas
;;;;

(defrule pregunta_nota
(declare (salience 9999))
?f <-(preguntar_Nota SI)
=>
(printout t"Cual es tu nota media? Alta(9,10)|Baja(5,6)|Media(7,8)" crlf)
(retract ?f)
(assert(nota_media(read)))
(assert (preguntar_Nota NO))
(assert (preguntar_mates SI))
)

;;;; preguntar gustar mates
;;;;

(defrule pregunta_gustarMates
(nota_media ?x)
(preguntar_mates SI)
?f <-(preguntar_mates SI)
=>
(printout t"Le gusta las matematicas Si|No" crlf)
(assert (gusta_matematicas(read)))
(retract ?f)
(assert (preguntar_mates NO))
(assert (preguntar_hardware SI))
)

;;;; preguntar gustar hardware
;;;;

(defrule pregunta_gustarHardware
(nota_media ?x)
(preguntar_hardware SI)
?f <-(preguntar_hardware SI)
=>
(printout t"Le interesa el hardware Si|No" crlf)
(assert (gusta_hardware(read)))
(retract ?f)
(assert (preguntar_hardware NO))
(assert (preguntar_IA SI))
)

;;;; preguntar gustar IA
;;;;

(defrule pregunta_gustarIA
(nota_media ?x)
(preguntar_IA SI)
?f <-(preguntar_IA SI)
=>
(printout t"Le interesa el ambito de la inteligencia artificial y sistemas inteligentes Si|No" crlf)
(assert (gusta_IA(read)))
(retract ?f)
(assert (preguntar_IA NO))
(assert (preguntar_DW SI))
)

;;;; preguntar gustar gustar DesarrolloWeb
;;;;

(defrule pregunta_gustarDW
(nota_media ?x)
(preguntar_DW SI)
?f <-(preguntar_DW SI)
=>
(printout t"Le interesa el ambito del desarrollo software Si|No" crlf)
(assert (gusta_DW(read)))
(retract ?f)
(assert (preguntar_DW NO))
(assert (preguntas_terminadas SI))
)

;;;; Estas preguntas no se responden siempre solo si los parametros introducidos de la persona
;;;; no coincide perfectamente con alguna carrera
;;;; practicamente son preguntas especiales para deducir finalmente la ideal
;;;;

(defrule pregunta_programar
?f <-(pregunta_programar SI)
=>
(printout t"Le gusta programar? Si|No" crlf)
(retract ?f)
(assert (gusta_programar(read)))
)

(defrule pregunta_buenanotasMates
?f <-(pregunta_buenanotasMates SI)
=>
(printout t"Tiene buenas notas en mates Si|No" crlf)
(retract ?f)
(assert (gusta_buenasnotasmates(read)))
)

(defrule preguntar_esfuerzo
?f <-(preguntar_esfuerzo SI)
=>
(printout t"Prefiriria estudiar lo que le gusta pero esforzarse mucho o poco y algo parecido? Mucho|Poco" crlf)
(retract ?f)
(assert (gusta_esfuerzo(read)))
)


;;;; deducciones para la rama primero las default que coinciden con todo y no necesitan mas preguntas 
;;;;

(defrule deduccion_CSI
?f <-(conclusion NONE)
(nota_media Alta)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW No)
=>
(retract ?f)
(assert (conclusion Computación_y_Sistemas_Inteligentes))
)

(defrule deduccion_IS
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Alta))
    (test (eq ?x Media))
    (test (eq ?x Baja)))
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware No)
(gusta_IA No)
(gusta_DW Si)

=>
(retract ?f)
(assert (conclusion Ingeniería_del_Software))
)

(defrule deduccion_IC
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Alta))
    (test (eq ?x Media))
    (test (eq ?x Baja)))
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW No)
=>
(retract ?f)
(assert (conclusion Ingeniería_de_Computadores))
)

(defrule deduccion_SI
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Alta))
    (test (eq ?x Media))
    (test (eq ?x Baja)))
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA No)
(gusta_DW No)
=>
(retract ?f)
(assert (conclusion Sistemas_de_Información))
)

(defrule deduccion_TI
?f <-(conclusion NONE)
(nota_media Alta)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW No)
=>
(retract ?f)
(assert (conclusion Tecnologías_de_la_Información))
)

;;;; no le gusta nada 
;;;;esta la puse por si alguien dice todo que no 
;;;; 

(defrule deduccion_NADA
?f <-(conclusion NONE)
(nota_media ?x)
(test (neq ?x (or Buena Media Baja)))
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware No)
(gusta_IA No)
(gusta_DW No)
=>
(retract ?f)
(assert (conclusion NADA))
)

;;;; casos todo si
;;;; 

(defrule deduccion_TODOSI
(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
=>
(assert (pregunta_programar SI))
(assert (pregunta_buenanotasMates SI))
(assert (preguntar_esfuerzo SI))
(assert (explicacion todo))
)

(defrule deduccion_TODOSI_CSI
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
(gusta_programar Si)
(gusta_esfuerzo Mucho)
=>
(retract ?f)
(assert (conclusion Computación_y_Sistemas_Inteligentes))
)

(defrule deduccion_TODOSI_TI
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
(gusta_programar No)
(gusta_esfuerzo Mucho)

=>
(retract ?f)
(assert (conclusion Tecnologías_de_la_Información))
)

(defrule deduccion_TODOSI_SI
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
(gusta_programar Si)
(gusta_buenasnotasmates Si)
(gusta_esfuerzo Poco)
=>
(retract ?f)
(assert (conclusion Sistemas_de_Información))
)

(defrule deduccion_TODOSI_IS
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
(gusta_programar Si)
(gusta_buenasnotasmates No)
(gusta_esfuerzo Poco)
=>
(retract ?f)
(assert (conclusion Ingeniería_del_Software))
)

(defrule deduccion_TODOSI_IC
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
(gusta_programar No)
(gusta_buenasnotasmates No)
(gusta_esfuerzo Poco)
=>
(retract ?f)
(assert (conclusion Ingeniería_de_Computadores))
)


;;;; combinaciones un poco diferentes
;;;;
;;;;para las ramas mas dificiles que no llegan a la nota
;;;;

(defrule deduccion_CSI_esfuerzo
(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media))
)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW No)
=>
(assert (preguntar_esfuerzo SI))
)

(defrule deduccion_CSI_esfuerzo_Mucho
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media))
)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW No)
(gusta_esfuerzo Mucho)
=>
(assert (conclusion Computación_y_Sistemas_Inteligentes))
(retract ?f)
)

(defrule deduccion_CSI_esfuerzo_Poco
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media))
)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW No)
(gusta_esfuerzo Poco)
=>
(assert (conclusion Sistemas_de_Información))
(retract ?f)
)


(defrule deduccion_TI_esfuerzo
(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media))
)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW No)
=>
(assert (preguntar_esfuerzo SI))
)

(defrule deduccion_TI_esfuerzo_Mucho
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media))
)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW No)
(gusta_esfuerzo Mucho)
=>
(assert (conclusion Tecnologías_de_la_Información))
(retract ?f)
)

(defrule deduccion_TI_esfuerzo_Poco
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media))
)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW No)
(gusta_esfuerzo Poco)
=>
(assert (conclusion Ingeniería_de_Computadores))
(retract ?f)
)


;;;; combinacion para hacer mas preguntas para elegir final
;;;;

(defrule deduccion_SI_MATES_DW
(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA No)
(gusta_DW Si)
=>
(assert (pregunta_buenanotasMates SI))
(assert (preguntar_esfuerzo SI))
)

(defrule deduccion_SI_MATES_DW_CSI
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA No)
(gusta_DW Si)
(gusta_esfuerzo Mucho)
(gusta_buenasnotasmates Si)
=>
(assert (conclusion Computación_y_Sistemas_Inteligentes))
(retract ?f)
)

(defrule deduccion_SI_MATES_DW_SI
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA No)
(gusta_DW Si)
(gusta_buenasnotasmates Si)
(gusta_esfuerzo Poco)
=>
(assert (conclusion Sistemas_de_Información))
(retract ?f)
)

(defrule deduccion_SI_MATES_DW_IS
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA No)
(gusta_DW Si)
(gusta_buenasnotasmates No)
(or 
    (gusta_esfuerzo Poco)
    (gusta_esfuerzo Mucho)
)
=>
(assert (conclusion Ingeniería_del_Software))
(retract ?f)
)

;;;;; otra combinacion
;;;;;

(defrule deduccion_SI_HARDWARE_DW
(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW Si)
=>
(assert (pregunta_programar  SI))
)

(defrule deduccion_SI_HARDWARE_DW_PROGRAMAR
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW Si)
(gusta_programar Si)
=>
(assert (conclusion Ingeniería_del_Software))
(retract ?f)
)

(defrule deduccion_SI_HARDWARE_DW_NO_PROGRAMAR
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW Si)
(gusta_programar No)
=>
(assert (conclusion Ingeniería_de_Computadores))
(retract ?f)
)


(defrule deduccion_SI_IA
(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW No)
=>
(assert (preguntar_esfuerzo SI))
(assert (pregunta_programar SI))
)

(defrule deduccion_SI_IA_Esfuerzo
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW No)
(gusta_esfuerzo Mucho)
=>
(retract ?f)
(assert (conclusion Computación_y_Sistemas_Inteligentes))
)

(defrule deduccion_SI_IA_EsfuerzoP
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW No)
(gusta_esfuerzo Poco)
(gusta_programar Si)
=>
(retract ?f)
(assert (conclusion Ingeniería_del_Software))
)

(defrule deduccion_SI_IA_EsfuerzoM
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW No)
(gusta_esfuerzo Poco)
(gusta_programar No)
=>
(retract ?f)
(assert (conclusion Ingeniería_de_Computadores))
)

(defrule deduccion_SI_IA_DW_IS
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media))
)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW Si)
=>
(assert (conclusion Ingeniería_del_Software))
(retract ?f)
)

(defrule deduccion_SI_IA_DW_CSI
?f <-(conclusion NONE)
(nota_media Alta)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW Si)
=>
(assert (conclusion Computación_y_Sistemas_Inteligentes))
(retract ?f)
)

(defrule deduccion_SI_IA_HARDWARE_CSI
?f <-(conclusion NONE)
(nota_media Alta)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW No)
=>
(assert (conclusion Computación_y_Sistemas_Inteligentes))
(retract ?f)
)

(defrule deduccion_SI_IA_HARDWARE_IC
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media)))
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW No)
=>
(assert (conclusion Ingeniería_de_Computadores))
(retract ?f)
)


;;;; otra
;;;;

(defrule deduccion_SI_MATES_HARDWARE_IA
?f <-(conclusion NONE)
(nota_media Alta)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW No)
=>
(retract ?f)
(assert (conclusion Computación_y_Sistemas_Inteligentes))
)

(defrule deduccion_SI_MATES_HARDWARE_IA2
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media)))
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW No)
=>
(retract ?f)
(assert (conclusion Ingeniería_de_Computadores))
)

(defrule deduccion_SI_MATES_HARDWARE_DW
?f <-(conclusion NONE)
(nota_media Alta)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW Si)
=>
(retract ?f)
(assert (conclusion Tecnologías_de_la_Información))
)


(defrule deduccion_SI_MATES_HARDWARE_DW_Notabaja
(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media)))
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW Si)
=>
(assert (pregunta_programar SI))
)

(defrule deduccion_SI_MATES_HARDWARE_DW_PROGRAMARS
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW Si)
(gusta_programar Si)
=>
(retract ?f)
(assert (conclusion Ingeniería_del_Software))
)

(defrule deduccion_SI_MATES_HARDWARE_DW_PROGRAMARN
?f <-(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware Si)
(gusta_IA No)
(gusta_DW Si)
(gusta_programar No)
=>
(retract ?f)
(assert (conclusion Ingeniería_de_Computadores))
)

(defrule deduccion_SI_MATES_IA_DW_BUENANOTA
?f <-(conclusion NONE)
(nota_media Alta)
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW Si)
=>
(retract ?f)
(assert (conclusion Computación_y_Sistemas_Inteligentes))
)


(defrule deduccion_SI_MATES_IA_DW_MALANOTA
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Baja))
    (test (eq ?x Media)))
(preguntas_terminadas SI)
(gusta_matematicas Si)
(gusta_hardware No)
(gusta_IA Si)
(gusta_DW Si)
=>
(retract ?f)
(assert (conclusion Ingeniería_del_Software))
)

(defrule deduccion_SI_HD_IA_DW
(conclusion NONE)
(preguntas_terminadas SI)
(gusta_matematicas No)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
=>
(assert (pregunta_programar SI))
)

(defrule deduccion_SI_HA_IA_DW_CSI
?f <-(conclusion NONE)
(nota_media Alta)
(preguntas_terminadas SI)
(gusta_matematicas  No)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
(gusta_programar ?x)
(or (test (eq ?x Si))
    (test (eq ?x No))
)
=>
(retract ?f)
(assert (conclusion Computación_y_Sistemas_Inteligentes))
)

(defrule deduccion_SI_HA_IA_DW2
?f <-(conclusion NONE)
(nota_media ?x)
(test (neq ?x Alta))
(preguntas_terminadas SI)
(gusta_matematicas  No)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
(gusta_programar Si)
=>
(retract ?f)
(assert (conclusion Ingeniería_del_Software))
)

(defrule deduccion_SI_HA_IA_DW3
?f <-(conclusion NONE)
(nota_media ?x)
(or (test (eq ?x Media))
    (test (eq ?x Baja))
)
(preguntas_terminadas SI)
(gusta_matematicas  No)
(gusta_hardware Si)
(gusta_IA Si)
(gusta_DW Si)
(gusta_programar No)
=>
(retract ?f)
(assert (conclusion Ingeniería_de_Computadores))
)

;;;;; conclusiones
;;;;;

(defrule ConclusionNada
(declare (salience -2))
?f <-(conclusion NADA)
=>
(retract ?f)
(printout t" le aconsejo que te salgas de la carrera" crlf)
)

(defrule ConclusionCSI
(declare (salience -2))
?f <-(conclusion Computación_y_Sistemas_Inteligentes)
=>
(retract ?f)
(printout t" le aconsejo la rama de Computacion y sistemas inteligentes " crlf)
)

(defrule ConclusionIS
(declare (salience -2))
?f <-(conclusion Ingeniería_del_Software)
=>
(retract ?f)
(printout t" le aconsejo la rama de Ingenieria del software " crlf)
)

(defrule ConclusionIC
(declare (salience -2))
?f <-(conclusion Ingeniería_de_Computadores)
=>
(retract ?f)
(printout t" le aconsejo la rama de Ingenieria de computadores " crlf)
)

(defrule ConclusionSI
(declare (salience -2))
?f <-(conclusion Sistemas_de_Información)
=>
(retract ?f)
(printout t" le aconsejo la rama de Sistemas de informacion" crlf)
)

(defrule ConclusionTI
(declare (salience -2))
?f <-(conclusion Tecnologías_de_la_Información)
=>
(retract ?f)
(printout t" le aconsejo la rama de Tecnologias de la informacion" crlf)
)

;;;; explicacion
;;;;

(defrule Notas_Media
(conclusion ?y)
(test (neq ?y NONE))
?f <-(nota_media ?x)
=>
(retract ?f)
(printout t" tiene " ?x " nota media")
)

(defrule explicacion_TODO
(declare (salience -2))
(conclusion ?y)
(test (neq ?y NONE))
?f <-(explicacion todo)
=>
(retract ?f)
(printout t" le gustaria todas las ramas pero " crlf)
)

(defrule explicacion_Matematicas
(conclusion ?y)
(test (neq ?y NONE))
?f <-(gusta_matematicas ?x)
=>
(retract ?f)
(printout t ?x " le gusta las matematicas ")
)

(defrule explicacion_Hardware
(conclusion ?y)
(test (neq ?y NONE))
?f <-(gusta_hardware ?x)
=>
(retract ?f)
(printout t ?x " le gusta el hardware ")
)

(defrule explicacion_IA
(conclusion ?y)
(test (neq ?y NONE)) 
?f <-(gusta_IA ?x)
=>
(retract ?f)
(printout t " " ?x " le gusta los sistemas inteligentes e Inteligencia artificial ")
)

(defrule explicacion_DW
(conclusion ?y)
(test (neq ?y NONE)) 
?f <-(gusta_DW ?x)
=>
(retract ?f)
(printout t ?x " le gusta el desarrollo web ")
)

(defrule explicacion_progamar
(conclusion ?y)
(test (neq ?y NONE))
?f <-(gusta_programar ?x)
=>
(retract ?f)
(printout t ?x " le gusta programar ")
)

(defrule explicacion_notasmates
(conclusion ?y)
(test (neq ?y NONE))
?f <-(gusta_buenasnotasmates ?x)
=>
(retract ?f)
(printout t ?x " buenas notas en mates ")
)

(defrule explicacion_notasmates
(conclusion ?y)
(test (neq ?y NONE))
?f <-(gusta_buenasnotasmates ?x)
=>
(retract ?f)
(printout t ?x " tienes buenas notas en mates ")
)

(defrule explicacion_esfuerzo
(conclusion ?y)
(test (neq ?y NONE))
?f <-(gusta_esfuerzo ?x)
=>
(retract ?f)
(printout t" prefiere esforzarse " ?x)
)

