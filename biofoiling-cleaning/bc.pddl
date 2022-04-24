(define (domain biofouling-cleaning)
(:requirements :strips :typing :fluents :disjunctive-preconditions :durative-actions :timed-initial-literals :duration-inequalities)
(:types
  robot
  waypoint
  sensor
  actuator
  poi
)

(:predicates (at ?r - robot ?wp - waypoint)
             (poi_at ?p - poi ?wp - waypoint)
             (near ?r - robot ?wp - waypoint)
             (available ?r - robot)
             (can_visualise ?r - robot ?s - sensor)
             (can_clean ?r - robot ?s - actuator)
             (can_identify ?r - robot ?s - sensor)
             (can_manipulate ?r - robot ?a - actuator)
             (is_structure ?p - poi)
             (is_valve ?p - poi)
             (robot_approached ?r - robot ?wp - waypoint)
             (is_surface_robot  ?r - robot)
             (is_underwater_robot  ?r - robot)
             (docking_point_free ?wp - waypoint)
             (sense_implemented_by ?r - robot ?wp - waypoint)
             (inspection_implemented_by ?r - robot ?wp - waypoint)




             (bla_obstructed  ?p - poi)
             (state_on  ?p - poi)
             (bla_inspected ?wp - waypoint)
             (bla_cleaned ?wp - waypoint)
             (valve_sensed ?wp - waypoint)
             (valve_closed ?wp - waypoint)
             (docking_point ?wp - waypoint)
             (communication_point ?wp - waypoint)
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

            (inspect_area_dur)
            (clean_biofouling_dur)
            (sense_valve_dur)
            (close-valve_dur)
            (broadcast_data_dur)
            (target_approach_dur)
            (recover_robot_dur)
)

(:durative-action inspect-area
 :parameters (?r - robot ?s - sensor ?p - poi ?wp - waypoint)
 :duration ( = ?duration (inspect_area_dur))
 :condition (and
             (over all (at ?r ?wp))
             (over all (poi_at ?p  ?wp))
             (over all (is_structure ?p))
             (over all (can_visualise ?r ?s))
             (at start (available ?r))
             (at start (< (data_acquired ?r) (data_capacity ?r)))
             (at start (>= (energy ?r) (* (inspect_area_dur) (cr_rate_sc ?r))))
             )
  :effect (and
          (at start (not (available ?r)))
          (at end   (available ?r))
          (at end   (inspection_implemented_by ?r ?wp))
          (at end   (bla_inspected ?wp))
          (at end   (increase (data_acquired ?r) 1))
          (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
          )
)

(:durative-action clean-biofouling
 :parameters (?r - robot  ?a - actuator ?p - poi ?wp - waypoint)
 :duration (= ?duration (clean_biofouling_dur))
 :condition (and
            (over all (at ?r ?wp))
            (over all (poi_at ?p  ?wp))
            (over all (is_structure ?p))
            (over all (can_clean ?r  ?a))
            (at start (inspection_implemented_by ?r ?wp))
            (at start (bla_obstructed ?p))
            (at start (available ?r))
            (at start (>= (energy ?r) (* (clean_biofouling_dur) (cr_rate_sd ?r))))
            )
 :effect (and
         (at start (not (available ?r)))
         (at end   (available ?r))
         (at end   (not (bla_obstructed ?p)))
         (at end   (bla_cleaned ?wp))
         (at end   (decrease (energy ?r) (* ?duration (cr_rate_sd ?r))))
         )
)

(:durative-action sense-valve
 :parameters (?r - robot ?s - sensor ?p - poi ?wp - waypoint)
 :duration ( = ?duration (sense_valve_dur))
 :condition (and
             (over all (at ?r ?wp))
             (over all (poi_at ?p  ?wp))
             (over all (is_valve ?p))
             (over all (can_identify ?r ?s))
             (at start (available ?r))
             (at start (< (data_acquired ?r) (data_capacity ?r)))
             (at start (>= (energy ?r) (* (sense_valve_dur) (cr_rate_sc ?r))))
             )
  :effect (and
          (at start (not (available ?r)))
          (at end   (available ?r))
          (at end   (sense_implemented_by ?r ?wp))
          (at end   (valve_sensed ?wp))
          (at end   (increase (data_acquired ?r) 1))
          (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
          )
)

(:durative-action close-valve
 :parameters (?r - robot  ?a - actuator ?p - poi ?wp - waypoint)
 :duration (= ?duration (close-valve_dur))
 :condition (and
            (over all (at ?r ?wp))
            (over all (poi_at ?p  ?wp))
            (over all (can_manipulate ?r ?a))
            (over all (sense_implemented_by ?r ?wp))
            (over all (is_valve ?p))
            (at start (state_on ?p))
            (at start (available ?r))
            (at start (>= (energy ?r) (* (close-valve_dur) (cr_rate_sd ?r))))
            )
 :effect (and
         (at start (not (available ?r)))
         (at end   (available ?r))
         (at end   (not (state_on ?p)))
         (at end   (valve_closed ?wp))
         (at end   (decrease (energy ?r) (* ?duration (cr_rate_sd ?r))))
         )
)

(:durative-action navigation
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration (+ (* (/ (distance ?wpi ?wpf) (speed ?r)) 2) 0.01))
:condition (and
           (at start (available ?r))
           (at start (at ?r ?wpi))
           (at start (>= (energy ?r) (* (/ (distance ?wpi ?wpf) (speed ?r)) (cr_rate_a ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (at ?r ?wpi)))
        (at end   (near ?r ?wpf))
        (at end   (available ?r))
        (at end   (increase (total-distance) (distance ?wpi ?wpf)))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_a ?r))))
        )
)

(:durative-action broadcast-data
:parameters (?ru ?rs - robot   ?wp - waypoint)
:duration (= ?duration (broadcast_data_dur))
:condition (and
           (over all (at ?ru ?wp))
           (over all (at ?rs ?wp))
           (over all (is_surface_robot  ?rs))
           (over all (is_underwater_robot  ?ru))
           (over all (communication_point ?wp))
           (at start (available ?rs))
           (at start (available ?ru))
           (at start (>= (data_acquired ?ru) (data_capacity ?ru)))
           (at start (>= (energy ?ru) (* (sense_valve_dur) (cr_rate_sc ?ru))))
           )
:effect (and
        (at start (not (available ?rs)))
        (at start (not (available ?ru)))
        (at end   (available ?rs))
        (at end   (available ?ru))
        (at end   (assign (data_acquired ?ru) 0))
        (at end   (decrease (energy ?ru) (* ?duration (cr_rate_sc ?ru))))
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

(:durative-action target-approach
  :parameters (?r - robot  ?wp - waypoint)
  :duration ( = ?duration (target_approach_dur))
  :condition (and
             (at start (near ?r ?wp))
             (at start (available ?r))
             (at start (>= (energy ?r) (* (inspect_area_dur) (cr_rate_sc ?r))))
             )
  :effect (and
          (at start (not (available ?r)))
          (at end   (not (near ?r ?wp)))
          (at end   (robot_approached ?r ?wp))
          (at end   (at ?r ?wp))
          (at end   (available ?r))
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
