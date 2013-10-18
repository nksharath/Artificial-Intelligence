;**********************************************************;
;                                                          ;
; bus.clp                                                  ;
; Contains set of rules used to find the best possible     ;
; Route for a Bus to travel.                               ;
;                                                          ;
; @author: Siddharth Rangaishenvi                          ;
; @author: Sharath Navalpakkam Krishnan     			   ;
;                                                          ;                    									
;														   ;
;**********************************************************; 

(import java.awt.*)
(import jess.*)
(import jess.awt.TextAreaWriter)


(bind ?ta (new TextArea 10 50))
(bind ?taw (new TextAreaWriter ?ta))
(bind ?frame (new Frame))
(call ?frame add ?ta)
(call ?frame pack)
(set ?frame visible TRUE)

(bind ?re (engine))

(call ?re addOutputRouter "t" ?taw)

; deftemplate is used to define a template for Bus containing unordered set of facts. ;
(deftemplate Bus (slot timeA) (slot timeB) (slot timeC) (slot isNotAvailableA) (slot isNotAvailableB)(slot isNotAvailableC))

; Rule Chaining has been used to predict the rules accurately on the basis of a number of conditions. ;


; defrule A is used to define a rule for checking if Route A is the shortest route on the basis of driving time ;
(defrule A
    "This will determine the shortest route based on time"
    (Bus {timeA < timeB && timeA < timeC}) ; timeA is compared with timeB and timeC to check if it is the smallest. 
	=>
    (assert(AvailableA))) ; Chain the rule AvailableA to A in order to check whether or not Route A is available. ; 


; defrule B is used to define a rule for checking if Route B is the shortest route on the basis of driving time ;
(defrule B
    "This will determine the shortest route based on time"
    (Bus {timeB < timeA && timeB < timeC}) ; timeB is compared with timeA and timeC to check if it is the smallest. ;  
	=>
    (assert(AvailableB))) ; Chain the rule AvailableB to B in order to check whether or not Route B is available. ; 


; defrule C is used to define a rule for checking if Route C is the shortest route on the basis of driving time ;
(defrule C
    "This will determine the shortest route based on time"
    (Bus {timeC < timeA && timeC < timeB}) ; timeC is compared with timeA and timeB to check if it is the smallest. ; 
	=>
    (assert(AvailableC))) ; Chain the rule AvailableC to C in order to check whether or not Route C is available. ; 


; defrule AvailableA is used to define a rule for checking if Route A is available or not. ;
(defrule AvailableA
    "Checks if Route A is available or not"
    (AvailableA)
    (Bus {isNotAvailableA == TRUE}) ; Used to check if Route A is not available. ;
    =>
     (assert(CheckB)) ; Chain the rule CheckB in order to suggest the next shortest route. ;
    (printout t "Route A was not available." crlf))


; defrule AvailableA1 is used to define a rule for checking if Route A is available. ;
(defrule AvailableA1
    "If A is available"
    (AvailableA)
    (Bus {isNotAvailableA == FALSE}) ; Used to check if Route A is available. ;
    =>
    (printout t "Route A is selected as the best possible route." crlf)) ; A is selected as it is the shortest and most feasible route. ;


; defrule CheckB is used to check if Route B is the next shortest path if Route A is not available. ;
(defrule CheckB
    (CheckB)
    (Bus {timeB < timeC}) ; timeB is compared with timeC to see if it is the shortest route. ;
    =>
    (assert(AvailableB))) ; Chain the rule AvailableB to CheckB in order to check whether or not Route B is available. ; 


; defrule CheckB1 is used to check if Route C is the next shortest route if Route A is not available. ;
(defrule CheckB1
    (CheckB)
    (Bus {timeB > timeC}) ; timeC is compared with timeB to see if it is the shortest route. ;
    =>
    (assert(AvailableC))) ; Chain the rule AvailableC to CheckB1 in order to check whether or not Route C is available. ; 


; defrule AvailableB is used to define a rule for checking if Route B is available or not. ;
(defrule AvailableB
    "Checks if Route B is available or not"
    (AvailableB)
    (Bus {isNotAvailableB == TRUE}) ; Used to check if Route B is not available. ;
    =>
        (assert(AvailableC)) ; Chain the rule AvailableC in order to check if Route C is available or not. ;
    (printout t "Route B was not available." crlf))


; defrule AvailableB1 is used to define a rule for checking if Route B is available. ;
(defrule AvailableB1
    "If B is available"
    (AvailableB)
    (Bus {isNotAvailableB == FALSE}) ; Used to check if Route B is available. ;
    =>
    (printout t "Route B is selected as the best possible route." crlf)) ; B is selected as it is the shortest and most feasible route. ; 


; defrule AvailableC is used to define a rule for checking if Route C is available or not. ;
(defrule AvailableC
    "Checks if Route C is available or not"
    (AvailableC)
    (Bus {isNotAvailableC == TRUE}) ; Used to check if Route C is not available. ;
    =>
    (printout t "Route C was not available." crlf)
    (printout t "No Suitable Route as all possible routes were not available." crlf)) ; No suitable route as all routes are unavailable. ;


; defrule AvailableC1 is used to define a rule for checking if Route C is available. ;
(defrule AvailableC1
   	"If C is available"
    (AvailableC)
    (Bus {isNotAvailableC == FALSE}) ; Used to check if Route C is available. ;
    =>
    (printout t "Route C is selected as the best possible route." crlf)) ; C is selected as it is the shortest and most feasible route. ; 


; ********** TEST CASE 1 ********** ;
;(assert (Bus (timeA 482) (timeB 653) (timeC 728)(isNotAvailableA FALSE)(isNotAvailableB FALSE)(isNotAvailableC FALSE)))
;(run)

; ********** TEST CASE 2 ********** ;
;(assert (Bus (timeA 482) (timeB 653) (timeC 728)(isNotAvailableA TRUE)(isNotAvailableB FALSE)(isNotAvailableC FALSE)))
;(run)    

; ********** TEST CASE 3 ********** ;
(assert (Bus (timeA 482) (timeB 653) (timeC 728)(isNotAvailableA TRUE)(isNotAvailableB TRUE)(isNotAvailableC FALSE)))
(run)    

; ********** TEST CASE 4 ********** ;
;(assert (Bus (timeA 482) (timeB 653) (timeC 728)(isNotAvailableA TRUE)(isNotAvailableB TRUE)(isNotAvailableC TRUE)))
;(run)    

; ********** TEST CASE 5 ********** ;
;(assert (Bus (timeA 482) (timeB 124) (timeC 728)(isNotAvailableA FALSE)(isNotAvailableB FALSE)(isNotAvailableC FALSE)))
;(run)    

; ********** TEST CASE 6 ********** ;
;(assert (Bus (timeA 482) (timeB 124) (timeC 728)(isNotAvailableA TRUE)(isNotAvailableB FALSE)(isNotAvailableC FALSE)))
;(run)    

; ********** TEST CASE 7 ********** ;
;(assert (Bus (timeA 482) (timeB 124) (timeC 728)(isNotAvailableA TRUE)(isNotAvailableB TRUE)(isNotAvailableC FALSE)))
;(run)    

; ********** TEST CASE 8 ********** ;
;(assert (Bus (timeA 482) (timeB 124) (timeC 728)(isNotAvailableA TRUE)(isNotAvailableB TRUE)(isNotAvailableC TRUE)))
;(run)    

; ********** TEST CASE 9 ********** ;
;(assert (Bus (timeA 482) (timeB 653) (timeC 236)(isNotAvailableA FALSE)(isNotAvailableB FALSE)(isNotAvailableC FALSE)))
;(run)

; ********** TEST CASE 10 ********** ;
;(assert (Bus (timeA 482) (timeB 653) (timeC 236)(isNotAvailableA TRUE)(isNotAvailableB FALSE)(isNotAvailableC FALSE)))
;(run)

; ********** TEST CASE 11 ********** ;
;(assert (Bus (timeA 482) (timeB 653) (timeC 236)(isNotAvailableA TRUE)(isNotAvailableB TRUE)(isNotAvailableC FALSE)))
;(run)

; ********** TEST CASE 12 ********** ;
;(assert (Bus (timeA 482) (timeB 653) (timeC 236)(isNotAvailableA TRUE)(isNotAvailableB TRUE)(isNotAvailableC TRUE)))
;(run)    
     