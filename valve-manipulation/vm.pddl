(define (domain auvs_inspection)
(:requirements :strips :typing :fluents :negative-preconditions :disjunctive-preconditions :durative-actions :duration-inequalities :universal-preconditions :timed-initial-literals )
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
             (can_collect_rock ?r - robot ?s - sensor) 
             (can_collect_soil ?r - robot ?s - sensor) 
             (can_inspect_structure ?r - robot ?s - sensor) 
             (can_inspect_valve ?r - robot ?s - sensor) 
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
             (valve_inspected ?wp - waypoint)
             (valve_manipulated ?wp - waypoint)
             (free_point ?wp - waypoint)
             (recharge_deliverable ?wp - waypoint)
             

      
)
(:functions 
            (consumption ?r - robot)
            (speed ?r - robot)
            (distance ?wpi ?wpf - waypoint)
            (total-distance)
            (data_capacity ?r - robot)
            (data_acquired ?r - robot)
            (energy ?r - robot)
            (recharge_rate ?r - robot)
            
)

(:durative-action take-image
:parameters (?r - robot  ?wp - waypoint ?s - sensor)
:duration (= ?duration 2)
:condition (and
           (over all (at ?r ?wp))
           (over all (can_visualise ?r ?s))
           (at start (available ?r))
           (at start (>= (energy ?r) 5))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at end (decrease (energy ?r) 0.5))
        (at end (available ?r))
        (at end (increase (data_acquired ?r) 1))
        (at end (image_taken ?wp))
        )
)

(:durative-action rock-inspection
:parameters (?r - robot ?wp - waypoint ?s - sensor)
:duration (= ?duration 10)
:condition (and
           (over all (at ?r ?wp))
           (over all (can_collect_rock ?r ?s))
           (at start (available ?r))
           (at start (>= (energy ?r) 5))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (decrease (energy ?r) 0.5))
        (at end   (available ?r))
        (at end   (increase (data_acquired ?r) 3))
        (at end   (rock_inspected ?wp))
        )
)

(:durative-action soil-inspection
:parameters (?r - robot ?wp - waypoint ?s - sensor)
:duration (= ?duration 10)
:condition (and
           (over all (at ?r ?wp))
           (over all (can_collect_soil ?r ?s))
           (at start (available ?r))
           (at start (>= (energy ?r) 5))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (decrease (energy ?r) 0.5))
        (at end   (available ?r))
        (at end   (increase (data_acquired ?r) 3))
        (at end   (soil_inspected ?wp))
        )
)

(:durative-action structure-id
  :parameters (?r - robot  ?wp - waypoint ?s - sensor)
  :duration ( = ?duration 5)
  :condition (and
             (over all (at ?r ?wp))
             (over all (can_inspect_structure ?r ?s))
             (over all (structure_point ?wp))             
             (at start (available ?r))
             (at start (>= (energy ?r) 5))
             )
  :effect (and
          (at start (not (available ?r)))
          (at end   (decrease (energy ?r) 0.5))
          (at end   (available ?r))
          (at end   (structure_located ?wp))
          )
)

(:durative-action valve-inspection
:parameters (?r - robot  ?wp - waypoint ?s - sensor)
:duration ( = ?duration 10)
:condition (and
           (over all (at ?r ?wp))
           (over all (valve_at ?wp))
           (over all (structure_point ?wp))
           (over all (can_inspect_valve ?r ?s))
           (at start (available ?r))
           (at start (structure_located ?wp))
           (at start (>= (energy ?r) 5))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (increase (data_acquired ?r) 2))
        (at end   (valve_inspected ?wp))
        (at end   (available ?r))
        (at end   (decrease (energy ?r) 0.5))
        )
)

(:durative-action manipulate-valve
:parameters (?r - robot  ?wp - waypoint ?a - actuator ?si ?sf - state)
:duration (= ?duration 15)
:condition (and
           (over all (at ?r ?wp))
           (over all (can_manipulate ?r  ?a))
           (over all (structure_point ?wp))
           (over all (valve_at ?wp))
           (at start (valve_inspected ?wp))
           (at start (valve_state ?wp ?si))
           (at start (available ?r))
           (at start (>= (energy ?r) 5))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (valve_state ?wp ?si)))
        (at end   (valve_state ?wp ?sf))
        (at end   (available ?r))        
        (at end   (valve_manipulated ?wp))
        (at end   (decrease (energy ?r) 1))
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
           (at start (>= (energy ?r) (* (distance ?wpi ?wpf)(consumption ?r))))           
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (at ?r ?wpi)))
        (at end (at ?r ?wpf))
        (at end (section_mapped ?wpf))
        (at end (available ?r))
        (at end (increase (total-distance) (distance ?wpi ?wpf)))
        )
)


(:durative-action navigate
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration (+ (* (/ (distance ?wpi ?wpf) (speed ?r)) 2) 1))
:condition (and
           (over all (free_point ?wpf))
           (at start (available ?r))
           (at start (at ?r ?wpi))
           (at start (>= (energy ?r) (* (distance ?wpi ?wpf)(consumption ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (at ?r ?wpi)))
        (at end   (at ?r ?wpf))
        (at end   (explored ?wpf))
        (at end   (available ?r))
        (at end   (increase (total-distance) (distance ?wpi ?wpf)))
        (at end   (decrease (energy ?r) (* (distance ?wpi ?wpf)(consumption ?r))))
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
:duration (= ?duration 3)
:condition (and
           (over all (at ?r ?wp))
           (over all (surface_point ?wp))
           (at start (available ?r))
           (at start (>= (data_acquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) 5))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (decrease (energy ?r) 0.1))
        (at end   (assign (data_acquired ?r) 0))
	)
)



)
