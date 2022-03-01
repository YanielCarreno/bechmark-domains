(define (domain valve-manipulation)
(:requirements :strips :typing :fluents :negative-preconditions :disjunctive-preconditions :durative-actions :duration-inequalities :universal-preconditions :timed-initial-literals :time)
(:types

  robot
  waypoint
  sensor
  actuator
  state
)
(:predicates (at ?r - robot ?wp - waypoint)
             (available ?r - robot)
             (can_manipulate ?r - robot ?a - actuator)
             (can_visualise ?r - robot ?s - sensor) 
             (can_classify_rock ?r - robot ?s - sensor) 
             (can_collect ?r - robot ?a - actuator) 
             (can_classify_soil ?r - robot ?s - sensor) 
             (can_inspect ?r - robot ?s - sensor) 
             (can_identify ?r - robot ?s - sensor) 
             (can_map ?r - robot ?s - sensor) 

             (structure_point ?wp - waypoint)
             (surface_point ?wp - waypoint)
             (valve_at  ?wp - waypoint)
             (valve_state ?wp - waypoint ?s - state)

             (section_mapped ?wpf - waypoint)
             (explored ?wp - waypoint)
             (image_taken ?wp - waypoint)
             (rock_inspected ?wp - waypoint)
             (soil_inspected ?wp - waypoint)
             (structure_located  ?wp - waypoint)
             (valve_sensed ?wp - waypoint)
             (valve_manipulated ?wp - waypoint)
             (free_point ?wp - waypoint)
             (recharge_deliverable ?wp - waypoint)

             (allowed ?r - robot)
             (arm_positioned ?wp - waypoint)
             (can_coordinate_at ?r - robot ?wp - waypoint)
             (coordinated ?wp - waypoint)
             
             


      
)
(:functions 
            (cr_rate_a ?r - robot)
            (cr_rate_sd ?r - robot)
            (cr_rate_sc ?r - robot)
            (speed ?r - robot)
            (distance ?wpi ?wpf - waypoint)
            (total-distance)
            (data_capacity ?r - robot)
            (data_acquired ?r - robot)
            (energy ?r - robot)
            (recharge_rate ?r - robot)

            (take_image_dur)   
            (structure_id_dur)
            (sense_valve_dur)
            (broadcast_data_dur)

            ; static demanding
            (rock_inspection_dur)
            (soil_inspection_dur)
            (manipulate_valve_dur)

)

(:durative-action take-image
:parameters (?r - robot  ?wp - waypoint ?s - sensor)
:duration (= ?duration (take_image_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (can_visualise ?r ?s))
           (at start (available ?r))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) (* (take_image_dur) (cr_rate_sc ?r))))  
           )
:effect (and
        (at start (not (available ?r)))
        (at end (available ?r))
        (at end (increase (data_acquired ?r) 1))
        (at end (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
        (at end (image_taken ?wp))
        )
)

(:durative-action rock-inspection
:parameters (?r - robot ?wp - waypoint ?s - sensor ?a - actuator)
:duration (= ?duration (rock_inspection_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (can_classify_rock ?r ?s))
           (over all (can_collect ?r ?a))
           (at start (available ?r))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) (* (rock_inspection_dur) (cr_rate_sd ?r))))  
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (increase (data_acquired ?r) 3))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sd ?r))))
        (at end   (rock_inspected ?wp))
        )
)

(:durative-action soil-inspection
:parameters (?r - robot ?wp - waypoint ?s - sensor ?a - actuator)
:duration (= ?duration (soil_inspection_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (can_classify_soil ?r ?s))
           (over all (can_collect ?r ?a))
           (at start (available ?r))
           (at start (>= (energy ?r) (* (soil_inspection_dur) (cr_rate_sd ?r)))) 
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (increase (data_acquired ?r) 3))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sd ?r))))
        (at end   (soil_inspected ?wp))
        )
)

(:durative-action structure-id
  :parameters (?r - robot  ?wp - waypoint ?s - sensor)
  :duration ( = ?duration (structure_id_dur))
  :condition (and
             (over all (at ?r ?wp))
             (over all (can_inspect ?r ?s))
             (over all (structure_point ?wp))             
             (at start (available ?r))
             (at start (>= (energy ?r) (* (structure_id_dur) (cr_rate_sc ?r)))) 
             )
  :effect (and
          (at start (not (available ?r)))
          (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
          (at end   (available ?r))
          (at end   (structure_located ?wp))
          )
)

(:durative-action sense-valve
:parameters (?r - robot  ?wp - waypoint ?s - sensor)
:duration ( = ?duration (sense_valve_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (valve_at ?wp))
           (over all (structure_point ?wp))
           (over all (can_identify ?r ?s))
           (at start (available ?r))
           (at start (structure_located ?wp))
           (at start (>= (energy ?r) (* (sense_valve_dur) (cr_rate_sc ?r)))) 
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (increase (data_acquired ?r) 2))
        (at end   (valve_sensed ?wp))
        (at end   (available ?r))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
        )
)



(:durative-action manipulate-valve
:parameters (?r - robot  ?wp - waypoint ?a - actuator ?si ?sf - state)
:duration (= ?duration (manipulate_valve_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (can_manipulate ?r  ?a))
           (over all (structure_point ?wp))
           (over all (valve_at ?wp))
           (at start (valve_sensed ?wp))
           (over all (arm_positioned ?wp))
           (at start (valve_state ?wp ?si))
           (at start (available ?r))
           (at start (>= (energy ?r) (* (manipulate_valve_dur) (cr_rate_sd ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (valve_state ?wp ?si)))
        (at end   (valve_state ?wp ?sf))
        (at end   (available ?r))        
        (at end   (valve_manipulated ?wp))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sd ?r))))
        )
)




(:durative-action map
:parameters (?r - robot  ?wpi  ?wpf - waypoint ?s - sensor)
:duration ( = ?duration (+ (* (/ (distance ?wpi ?wpf) (speed ?r)) 2) 1))
:condition (and
           (over all (structure_point ?wpf))
           (over all (can_map ?r ?s))           
           (at start (available ?r))
           (at start (at ?r ?wpi))
           (at start (>= (energy ?r) (* (/ (distance ?wpi ?wpf) (speed ?r)) (cr_rate_a ?r))))           
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (at ?r ?wpi)))
        (at end (at ?r ?wpf))
        (at end (section_mapped ?wpf))
        (at end (available ?r))
        (at end (increase (total-distance) (distance ?wpi ?wpf)))
        (at end (decrease (energy ?r) (* ?duration (cr_rate_a ?r))))
        )
)


(:durative-action navigate
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration (+ (* (/ (distance ?wpi ?wpf) (speed ?r)) 2) 0.01))
:condition (and
           (at start (available ?r))
           ;(over all (allowed ?r))
           (at start (at ?r ?wpi))
           (at start (>= (energy ?r) (* (/ (distance ?wpi ?wpf) (speed ?r)) (cr_rate_a ?r))))
           )  
:effect (and
        (at start (not (available ?r)))
        (at start (not (at ?r ?wpi)))
        (at end   (at ?r ?wpf))
        (at end   (explored ?wpf))
        (at end   (available ?r))
        (at end   (increase (total-distance) (distance ?wpi ?wpf)))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_a ?r))))
        ;(decrease (energy ?r) (* #t (cr_rate_a ?r)))
        )
)

(:durative-action recharge
:parameters (?ru ?rs - robot  ?wp - waypoint)
:duration (= ?duration (/ (- 100 (energy ?ru)) (recharge_rate ?ru)))
:condition (and
          (over all (at ?ru ?wp))
          (over all (at ?rs ?wp))
          (over all (surface_point ?wp))
          (over all (recharge_deliverable ?wp))
          (at start (available ?ru))
          (at start (available ?rs))
          (at start (<= (energy ?ru) 80))
          )
:effect (and
        (at start (not (available ?ru)))
        (at start (not (available ?rs)))
        (at end   (available ?ru))
        (at end   (available ?rs))
        (at end   (increase (energy ?ru) (* ?duration (recharge_rate ?ru))))
        )
)


(:durative-action brodcast-data
:parameters (?r - robot   ?wp - waypoint)
:duration (= ?duration (broadcast_data_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (surface_point ?wp))
           (at start (available ?r))
           (at start (>= (data_acquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) (* (broadcast_data_dur) (cr_rate_sc ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
	)
)



(:durative-action coordinate
:parameters (?r - robot ?wp - waypoint)
:duration (= ?duration 10)
:condition (and
           (over all (at ?r ?wp))
           (over all (can_coordinate_at ?r ?wp))
           (at start (available ?r))
           (at start (>= (energy ?r) 5))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (decrease (energy ?r) 0.5))
        (at end   (available ?r))
        (at end   (coordinated ?wp))
        )
)



)
