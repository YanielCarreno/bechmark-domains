(define (domain structure-mapping)
(:requirements :strips :typing :fluents :negative-preconditions :disjunctive-preconditions :durative-actions :duration-inequalities :universal-preconditions )
(:types
  robot
  waypoint
  poi
  sensor
  actuator
)
(:predicates (at ?r - robot ?wp - waypoint)
             (poi_at ?p - poi ?wp - waypoint)
             (available ?r - robot)
             (can_visualise ?r - robot ?s - sensor)
             (can_manipulate ?r - robot ?a - actuator)
             (can_inspect ?r - robot ?s - sensor)
             (can_map ?r - robot ?s - sensor)
             (is_structure ?p - poi)
             (is_sensor ?p - poi)
             (sensor_damaged ?p - poi)
             (structure_ob_point ?wp - waypoint)
             (free_point ?wp - waypoint)
             (docking_point ?wp - waypoint)
             (docking_point_free ?wp - waypoint)
             (connected ?wpi ?wpf - waypoint)
             (strong_current ?p - poi)
             (low_visibility ?p - poi)
             (inspection_implemented_by ?r - robot ?wp - waypoint)

             (sensor_inspected ?wp - waypoint)
             (sensor_replaced ?wp - waypoint)
             (structure_located ?wp - waypoint)
             (sensor_identified ?wp - waypoint)
             (explored ?wp - waypoint)
             (section_mapped  ?wp - waypoint)
             (recovered ?r - robot ?wp - waypoint)

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

         (sense_sensor_dur)
         (replace_sensor_dur)
         (sense_structure_dur)
         (sense_valve_dur)
         (broadcast_data_dur)
         (recover_robot_dur)
         (relocalisation_dur)
         (increase_light_dur)
)

(:durative-action sense-sensor
:parameters (?r - robot  ?s - sensor ?p - poi ?wp - waypoint )
:duration ( = ?duration (sense_valve_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (poi_at ?p ?wp))
           (over all (is_sensor ?p))
           (over all (can_visualise ?r ?s))
           (at start (available ?r))
           (at start (sensor_identified ?wp))
           (at start (structure_located ?wp))
           (at start (inspection_implemented_by ?r ?wp))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) (* (sense_sensor_dur) (cr_rate_sc ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (increase (data_acquired ?r) 2))
        (at end   (sensor_inspected ?wp))
        (at end   (available ?r))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
        )
)

(:durative-action replace-sensor
:parameters (?r - robot  ?a - actuator ?p - poi ?wp - waypoint)
:duration (= ?duration (replace_sensor_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (poi_at ?p ?wp))
           (over all (can_manipulate ?r  ?a))
           (over all (is_sensor ?p))
           (at start (available ?r))
           (at start (sensor_damaged ?p))
           (at start (sensor_inspected ?wp))
           (at start (>= (energy ?r) (* (replace_sensor_dur) (cr_rate_sd ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (sensor_replaced ?wp))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sd ?r))))
        )
)

(:durative-action sense-structure
  :parameters (?r - robot  ?ss ?sc - sensor ?p - poi ?wp - waypoint )
  :duration ( = ?duration (sense_structure_dur))
  :condition (and
             (over all (at ?r ?wp))
             ;(over all (can_inspect ?r ?ss))
             (over all (can_visualise ?r ?sc))
             (over all (poi_at ?p ?wp))
             (over all (is_structure ?p))
             (at start (available ?r))
             (at start (>= (energy ?r) (* (sense_structure_dur) (cr_rate_sc ?r))))
             )
  :effect (and
          (at start (not (available ?r)))
          (at end   (available ?r))
          (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
          (at end   (inspection_implemented_by ?r ?wp))
          (at end   (structure_located ?wp))
          )
)

(:durative-action map
:parameters (?r - robot ?s - sensor ?wpi  ?wpf - waypoint)
:duration ( = ?duration (+ (* (/ (distance ?wpi ?wpf) (speed ?r)) 2) 1))
:condition (and
           (over all (structure_ob_point ?wpf))
           (over all (connected ?wpi ?wpf))
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

(:durative-action relocalisation
  :parameters (?r - robot  ?p - poi ?wp - waypoint)
  :duration ( = ?duration (relocalisation_dur))
  :condition (and
             (over all (at ?r ?wp))
             (over all (poi_at ?p ?wp))
             (at start (available ?r))
             (at start (structure_located ?wp))
             (at start (strong_current ?p))
             (at start (>= (energy ?r) (* (relocalisation_dur) (cr_rate_sc ?r))))
             )
  :effect (and
          (at start (not (available ?r)))
          (at end   (sensor_identified ?wp))
          (at end   (available ?r))
          (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
          )
)

(:durative-action increase-light
  :parameters (?r - robot  ?p - poi ?wp - waypoint)
  :duration ( = ?duration (increase_light_dur))
  :condition (and
             (over all (at ?r ?wp))
             (over all (poi_at ?p ?wp))
             (at start (available ?r))
             (at start (structure_located ?wp))
             (at start (low_visibility ?p))
             (at start (>= (energy ?r) (* (increase_light_dur) (cr_rate_sc ?r))))
             )
  :effect (and
          (at start (not (available ?r)))
          (at end   (sensor_identified ?wp))
          (at end   (available ?r))
          (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
          )
)

(:durative-action navigate
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration (+ (* (/ (distance ?wpi ?wpf) (speed ?r)) 2) 0.01))
:condition (and
           (over all (free_point ?wpf))
           (over all (connected ?wpi ?wpf))
           (at start (available ?r))
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
        )
)

(:durative-action recharge-battery
:parameters (?r - robot  ?wp - waypoint)
:duration (= ?duration (/ (- 100 (energy ?r)) (recharge_rate ?r)))
:condition (and
           (over all (at ?r ?wp))
           (over all (docking_point ?wp))
           (at start (docking_point_free ?wp))
           (at start (available ?r))
           (at start (<= (energy ?r) 80))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (increase (energy ?r) (* ?duration (recharge_rate ?r))))
        )
)

(:durative-action broadcast-data
:parameters (?r - robot   ?wp - waypoint)
:duration (= ?duration (broadcast_data_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (docking_point ?wp))
           (at start (docking_point_free ?wp))
           (at start (available ?r))
           (at start (>= (data_acquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) (* (broadcast_data_dur) (cr_rate_sc ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (assign (data_acquired ?r) 0))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
	      )
)

(:durative-action recover-robot
:parameters (?r - robot  ?wp - waypoint)
:duration (= ?duration (recover_robot_dur))
:condition (and
           (over all (at ?r ?wp))
           (at start (available ?r))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (not (available ?r)))
        (at end   (recovered ?r ?wp))
        )
)
)
