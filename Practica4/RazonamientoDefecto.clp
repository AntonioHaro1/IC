;;;;;;;;;;;;;;;;; Representación
; (ave ?x) representa "?x es un ave "
; (animal ?x) representa "?x es un animal"
; (vuela ?x si|noseguro|por_defecto)representa
;"?x vuela si|nocon esa certeza"


;Las aves y los mamíferos son animales
;Los gorriones, las palomas, las águilas y los pingüinos son aves
;La vaca, los perros y los caballos son mamíferos
;Los pingüinos no vuelan 
(deffacts datos
(ave gorrion) (ave paloma) (ave aguila) (ave pinguino) (mamifero vaca) (mamifero perro) (mamifero caballo) (vuela pinguino no seguro)
)
;;; REGLAS SEGURAS
; Las aves son animales 
(defrule aves_son_animales (ave ?x)
=>
(assert(animal ?x))
(bind ?expl (str-cat "sabemos que un " ?x " es un animal porque las aves son un tipo de animal"))
(assert(explicacion animal ?x ?expl)) 
)
; añadimos un hecho que contiene la explicación de la deducción


; Los mamiferosson animales (A3) 
(defrule mamiferos_son_animales 
(mamifero ?x)
=>
(assert(animal ?x))
(bind ?expl (str-cat "sabemos que un " ?x " es un animal porque los mamiferos son un tipo de animal"))
(assert(explicacion animal ?x ?expl)) 
)
; añadimos un hecho que contiene la explicación de la deducción

;; REGLAS POR DEFECTO 
;;; Casi todos las aves vuela --> puedo asumir por defecto que las aves vuelan
; Asumimos por defecto 
; para disminuir probabilidad de añadir erróneamente (ave ?x)
(defrule ave_vuela_por_defecto
(declare (salience -1)) 
(ave ?x)
=>
(assert(vuela ?x si por_defecto))
(bind ?expl (str-cat "asumo que un " ?x " vuela, porque casi todas las aves vuelan")) (assert(explicacion vuela ?x ?expl))
)


; Retractamos cuando hay algo en contra 
; para retractar antes de inferir cosas erroneamente
(defrule retracta_vuela_por_defecto
(declare (salience 1)) 
?f<-(vuela ?x ?r por_defecto) 
(vuela ?x ?s seguro)
=>
(retract ?f)
(bind ?expl (str-cat "retractamos que un " ?x ?r " vuela por defecto, porque sabemos seguro que " ?x ?s " vuela"))
(assert(explicacion retracta_vuela ?x ?expl))
)
;;; COMETARIO: esta regla también elimina los por defecto cuando ya esta seguro

;;; La mayor parte de los animales no vuelan --> puede interesarme asumir por defecto
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;que un animal no va a volar
;;;; es mas arriesgado, mejor después de otros razonamientos 
(defrule mayor_parte_animales_no_vuelan
(declare (salience -2)) 
(animal ?x)
(not (vuela ?x ? ?))
=>
(assert(vuela ?x no por_defecto))
(bind ?expl (str-cat "asumo que " ?x " no vuela, porque la mayor parte de los animales no vuelan"))
(assert(explicacion vuela ?x ?expl))
)



;;; Pregunta el animal que le interesa conocer la informacion
(defrule pregunta_animal
(declare (salience -10))
=>
(printout t "¿Sobre que animal te gustaria obtener informacion? ") 
(assert (nuevo_animal (read)))
(assert (animal_insertado desconocido))
)


;;; comprueba si ese animal esta en la base de conocimiento 
(defrule conozco_animal
(declare (salience -14))
?f <- (nuevo_animal ?x)
(animal ?x)
(explicacion animal ?x ?expl1) 
(explicacion vuela ?x ?expl2)
=>
(retract ?f)
(printout t ?expl1 crlf) 
(printout t ?expl2 crlf)
)


;;;si no es uno de los recogidos pregunte si es un ave o un mamífero y
;;;;según la respuesta indique si vuela o no.
(defrule no_conozco_animal
(declare (salience -15))
(nuevo_animal ?x)
=>
(printout t "El animal " ?x " es un ave o un mamifero? ave/mamifero/nose ") 
(assert (tipoAnimal ?x (read)))
)


;;; Si el usuario ha respondido al tipo de animal
(defrule aniadir_ave
(declare (salience -14)) 
(tipoAnimal ?x ?y)
(test (eq ave ?y))
=>
(assert (ave ?x))
)

(defrule aniadir_mamifero
(declare (salience -14)) 
(tipoAnimal ?x ?y)
(test (eq mamifero ?y))
=>
(assert (mamifero ?x))
)
;;; si el usuario no ha respondido al tipo de animal
(defrule aniadir_nose
(declare (salience -14)) 
(tipoAnimal ?x ?y)
(test (eq nose ?y))
=>
(assert (animal ?x))
)

;imprime la informacion obtenida
(defrule mostrar_informacion_nuevo_animal
(declare (salience -15))
?f<-(nuevo_animal ?x)
(animal ?x)
(explicacion vuela ?x ?expl2)

=>
(retract ?f)
(printout t ?expl2 crlf)
)
