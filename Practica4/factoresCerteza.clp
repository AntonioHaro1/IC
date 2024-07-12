;;;;Implementar en CLISP un sistema que haga un diagnóstico sobre la avería
;;;;de coche que no arranca de acuerdo a las siguientes reglas:
;;;;R1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas con las bujías
;;;;con certeza 0,7
;;;;R2: SI NO gira el motor ENTONCES problema con el starter con certeza 0,8
;;;;R3: SI NO encienden las luces ENTONCES problemas con la batería con certeza 0,9
;;;;R4: SI hay gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0,9
;;;;R5: SI hace intentos de arrancar ENTONCES problema con el starter con certeza -0,6
;;;;R6: SI hace intentos de arrancar ENTONCES problema con la batería 0,5 


;(FactorCerteza ?h si|no ?f) representa que ?h se ha deducido con factor de certeza ?factor
;?h podra_ser:
; -problema_starter
; -problema_bujias
; -problema_bateria
; -motor_llega_gasolina
;(Evidencia ?e si|no) representa el hecho de si evidencia ?e se dato
; ?e podra 
; -hace_intentos_arrancar
; -hay_gasolina_en_deposito
; -enciende_las_luces
; -gira_motor


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
(deffunction encadenado (?fc_antecedente ?fc_regla)
(if (> ?fc_antecedente 0)
then
(bind ?rv (* ?fc_antecedente ?fc_regla))
else
(bind ?rv 0) )
?rv)

(deffunction combinacion (?fc1 ?fc2)
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

;;;R1: SI el motor obtiene gasolina Y el motor gira ENTONCES problemas
;;con las bujías con certeza 0,7
(defrule R1
(FactorCerteza motor_llega_gasolina si ?f1)
(FactorCerteza gira_motor si ?f2)
(test (and (> ?f1 0) (> ?f2 0)))
=>
(assert (FactorCerteza problema_bujias si (encadenado (* ?f1 ?f2) 0.7))))

;;;;R2: SI NO gira el motor ENTONCES problema con el starter con certeza 0,8

(defrule R2
(FactorCerteza gira_motor no ?f1)
(test(> ?f1 0))
=>
(assert (FactorCerteza problema_starter si (encadenado ?f1 0.8)))
)

;R3: SI NO encienden las luces ENTONCES problemas con la batería con certeza 0,9

(defrule R3
(FactorCerteza enciende_las_luces no ?f1)
(test(> ?f1 0))
=>
(assert (FactorCerteza problema_bateria si (encadenado ?f1 0.9)))
)

;;;;R4: SI hay gasolina en el deposito ENTONCES el motor obtiene gasolina con certeza 0,9

(defrule R4
(FactorCerteza hay_gasolina_en_deposito si ?f1)
(test(> ?f1 0))
=>
(assert (FactorCerteza motor_llega_gasolina si(encadenado ?f1 0.9)))
)

;;;;R5: SI hace intentos de arrancar ENTONCES problema con el starter con certeza -0,6

(defrule R5
(FactorCerteza hace_intentos_arrancar si ?f1)
(test(> ?f1 0))
=>
(assert (FactorCerteza problema_starter si(encadenado ?f1 -0.6)))
)

;;;;R6: SI hace intentos de arrancar ENTONCES problema con la batería 0,5 

(defrule R6
(FactorCerteza hace_intentos_arrancar si ?f1)
(test(> ?f1 0))
=>
(assert (FactorCerteza problema_bateria si(encadenado ?f1 0.5)))
)

;;; preguntas 


(defrule pregunta_gira_motor
(declare (salience 10))
=>
(printout t "¿Gira el motor?si/no" crlf)
(assert (Evidencia gira_motor (read)))
)

(defrule pregunta_enciende_luces
(declare (salience 10))
=>
(printout t "¿Se encienden las luces?si/no" crlf)
(assert (Evidencia enciende_las_luces (read)))
)

(defrule preguntar_gasolina_deposito
(declare (salience 10))
=>
(printout t "¿Tiene gasolina el deposito?si/no" crlf)
(assert (Evidencia hay_gasolina_en_deposito (read)))
)

(defrule preguntar_intentos_arrancar
(declare (salience 10))
=>
(printout t "¿Hacen intentos al arrancar?si/no" crlf)
(assert (Evidencia hace_intentos_arrancar (read)))
)

;;;;; añado una variable para elegir la hipotesis con mas certeza que
;;;;; se inicializa a 0 al principio
;;;;; sigue la estructura Max_hipotesis ?x ?f --> donde la ?x es el problema y ?f la certeza

(defrule Max_hipotesis_inicializacion
(declare (salience 11))
=>
(assert (Max_hipotesis desconocido 0))
)

;;;; elecciones de las hipotesis cuando son Max_hipotesis

(defrule hipotesis_starter
?f<-(FactorCerteza problema_starter si ?f1)
?g<-(Max_hipotesis ?X ?f2)
(test (> ?f1 ?f2))
=>
(retract ?f ?g)
(assert (Max_hipotesis problema_starter ?f1))
)

(defrule hipotesis_bujias
?f<-(FactorCerteza problema_bujias si ?f1)
?g<-(Max_hipotesis ?X ?f2)
(test (> ?f1 ?f2))
=>
(retract ?f ?g)
(assert (Max_hipotesis problema_bujias ?f1))
)

(defrule hipotesis_bateria
?f<-(FactorCerteza problema_bateria si ?f1)
?g<-(Max_hipotesis ?X ?f2)
(test (> ?f1 ?f2))
=>
(retract ?f ?g)
(assert (Max_hipotesis problema_bateria ?f1))
)

;;;; cuando ya no hay mas cambios en Max_hipotesis pues se decide un problema FINALMENTE

(defrule decision_bujias
(declare (salience -4))
?f<-(Max_hipotesis ?hip ?x)
(test (and (> ?x 0)(eq ?hip problema_bujias)))
=>
(retract ?f)
(assert (hipotesis_final "El problema es de las bujias" ?x))
)

(defrule decision_starte
(declare (salience -4))
?f<-(Max_hipotesis ?hip ?x)
(test (and (> ?x 0)(eq ?hip problema_starter)))
=>
(retract ?f)
(assert (hipotesis_final "El problema es del starter" ?x))
)

(defrule decision_bateria
(declare (salience -4))
?f<-(Max_hipotesis ?hip ?x)
(test (and (> ?x 0)(eq ?hip problema_bateria)))
=>
(retract ?f)
(assert (hipotesis_final "El problema es de la bateria" ?x))
)

;;;; imprimimos la decision FINALMENTE

(defrule decision_final
(declare (salience -6))
(hipotesis_final ?hip ?x)
(test (> ?x 0))
=>
(printout t "El sistema ha deducido que " ?hip " con un "(* ?x 100)"% de certeza")
)


