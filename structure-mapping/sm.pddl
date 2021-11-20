(define (domain auvs_inspection)
(:requirements :strips :typing :fluents :negative-preconditions :disjunctive-preconditions :durative-actions :duration-inequalities :universal-preconditions )
(:types
  robot
  waypoint
  robot_sensor
  robot_actuator
)
(:predicates (at ?r - robot ?wp - waypoint)
             (available ?r - robot)
             (near ?r - robot ?wp - waypoint)
             (surface_point_at ?r -robot ?wp - waypoint)
             (dvl_equipped ?r - robot ?s - robot_sensor)
             (camera_equipped ?r - robot ?s - robot_sensor)
             (sonar_equipped ?r - robot ?s - robot_sensor)
             (arm_equipped ?r - robot ?a - robot_actuator)
             (recharge_point ?wp - waypoint)
             (connected ?wpi ?wpf - waypoint)
             (localised ?r - robot)
             (communicated ?wp - waypoint)


             (explored ?wp - waypoint)
             (recharged ?wp - waypoint)
             (poi_inspected ?wp - waypoint)
             (recovered ?wp - waypoint)
             (ligh_off ?wp - waypoint)
             (ligh_on ?wp - waypoint)

)
(:functions (battery_level ?r - robot)
            (battery_min_theshold ?r - robot)
            (battery_max_theshold ?r - robot)
            (consumption ?r - robot)
            (speed ?r - robot)
            (distance ?wpi ?wpf - waypoint)
            (total-distance)
)

(:durative-action navigation
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration (* (/ (distance ?wpi ?wpf) (speed ?r)) 20))
:condition (and
           (over all (connected ?wpi ?wpf))
           (over all (localised ?r))
           (at start (available ?r))
           (at start (at ?r ?wpi))
           (at start (> (battery_level ?r) (battery_min_theshold ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (at ?r ?wpi)))
        (at end (at ?r ?wpf))
        (at end (explored ?wpf))
        (at end (available ?r))
        (at end (increase (total-distance) (distance ?wpi ?wpf)))
        )
)


(:durative-action turnon-light
:parameters (?r - robot ?wp - waypoint)
:duration ( = ?duration 2)
:condition (and
           (over all (at ?r ?wp))
           (at start (available ?r))
           (at start (> (battery_level ?r) (battery_min_theshold ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at end (ligh_on ?wp))
        (at end (available ?r))
        )
)

(:durative-action turnoff-light
:parameters (?r - robot ?wp - waypoint)
:duration ( = ?duration 2)
:condition (and
           (over all (at ?r ?wp))
           (at start (available ?r))
           (at start (> (battery_level ?r) (battery_min_theshold ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at end (ligh_off ?wp))
        (at end (available ?r))
        )
)

(:durative-action recover
:parameters (?r - robot  ?wp - waypoint)
:duration (= ?duration 1)
:condition (and
           (over all (at ?r ?wp))
           (at start (available ?r))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (not (available ?r)))
        (at end   (recovered ?wp))
        )
)

;===============================================================================
; Domain Actions Associated to Issues with Hardware

(:durative-action retrieve
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration (* (/ (distance ?wpi ?wpf) (speed ?r)) 100))
:condition (and
           (over all (connected ?wpi ?wpf))
           (at start (available ?r))
           (at start (at ?r ?wpi))
           (at start (< (battery_level ?r) (battery_min_theshold ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (at ?r ?wpi)))
        (at end (at ?r ?wpf))
        (at end (available ?r))
        (at end (increase (total-distance) (distance ?wpi ?wpf)))
        )
)

(:durative-action communicate
:parameters (?r - robot  ?wp - waypoint)
:duration (= ?duration 10)
:condition (and
           (over all (at ?r ?wp))
           (over all (recharge_point ?wp))
           (at start (available ?r))
           (at start (< (battery_level ?r) (battery_min_theshold ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (communicated ?wp))
        )
)

(:durative-action recharge
:parameters (?r - robot  ?wp - waypoint)
:duration (= ?duration 50)
:condition (and
           (over all (at ?r ?wp))
           (over all (recharge_point ?wp))
           (at start (communicated ?wp))
           (at start (available ?r))
           (at start (< (battery_level ?r) (battery_min_theshold ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (assign (battery_level ?r) (battery_max_theshold ?r)))
        (at end   (available ?r))
        (at end   (recharged ?wp))
        (at end   (not (communicated ?wp)))
        )
)

)

