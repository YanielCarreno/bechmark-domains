(define (domain auvs_inspection)
(:requirements :strips :typing :fluents :negative-preconditions :disjunctive-preconditions :durative-actions :duration-inequalities :universal-preconditions )
(:types
  robot
  waypoint
  sensor
  actuator

  component
  product
  machine
  valve
  flow
)
(:predicates (at ?r - robot ?wp - waypoint)
             (available ?r - robot)
             (can_manipulate ?r - robot ?a - actuator)
             (can_grasp ?r - robot ?a - actuator)
             (can_visualise ?r - robot ?s - sensor)


             (component_required ?c - component)
             (shelve_collected  ?r - robot ?c - component)
             (shelve_full ?c - component)
             (yellow_shelve_at ?c - component ?wp -waypoint)
             (green_shelve_at ?c - component ?wp -waypoint)
             (is_cap ?c - component)
             (is_label ?c - component)
             (is_bottle ?c - component)

             (product_packed ?p - product)
             (machine_available ?m - machine)
             (free_point ?wp - waypoint)
             (valve_at ?v - valve ?wp - waypoint)
             (valve_flow  ?v - valve ?f - flow)

             (communicated ?wp - waypoint)
             (explored ?wp - waypoint)
             (recharged ?wp - waypoint)
             (flow_acquired ?wp - waypoint)
             (valve_regulated  ?wp - valve)
             (parameters_checked ?wp - waypoint)
             (arm_positioned ?r - robot ?wp - waypoint)

             (charge_point_at ?wp - waypoint)
             (refilled ?c - component)
             (can_act ?r - robot ?wp - waypoint)

)
(:functions (battery_level ?r - robot)
            (battery_min_theshold ?r - robot)
            (battery_max_theshold ?r - robot)
            (consumption ?r - robot)
            (speed ?r - robot)
            (distance ?wpi ?wpf - waypoint)
            (total-distance)
            (data_acquired ?r - robot)
            (data_capacity ?r - robot)
            (energy ?r - robot)
            (recharge_rate ?r - robot)

            (cr_rate_a ?r - robot)
            (cr_rate_sd ?r - robot)
            (cr_rate_sc ?r - robot)
            (collect_shelve_dur)
            (deliver_shelve_dur)
            (process_dur)
            (check_parameters_dur)
            (sense_flow_dur)
            (regulate_flow_dur)
            (position_arm_dur)
            (communicate_dur)

)


(:durative-action collect-shelve
:parameters (?r - robot ?wp - waypoint ?a - actuator ?c - component)
:duration ( = ?duration 3)
:condition (and
           (over all (can_grasp ?r ?a))
           (over all (at ?r ?wp))
           (over all (yellow_shelve_at ?c ?wp))
           (at start (arm_positioned ?r ?wp))
           (at start (available ?r))
           (at start (component_required ?c))
           (at start (free_point ?wp))
           (at start (>= (energy ?r) 5))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (free_point ?wp)))
        (at end   (free_point ?wp))
        (at end   (available ?r))
        (at end   (not (arm_positioned ?r ?wp)))
        (at end   (not (component_required ?c)))
        (at end   (shelve_collected ?r ?c))
        (at end   (decrease (energy ?r) 0.8))
        )
)


(:durative-action deliver-shelve
:parameters (?r - robot ?wp - waypoint ?a - actuator ?c - component)
:duration ( = ?duration 3)
:condition (and
           (over all (at ?r ?wp))
           (over all (can_grasp ?r ?a))
           (over all (green_shelve_at ?c ?wp))
           (at start (arm_positioned ?r ?wp))
           (at start (available ?r))
           (at start (shelve_collected ?r ?c))
           (at start (free_point ?wp))
           (at start (>= (energy ?r) 5))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (shelve_collected ?r ?c))
        (at start (not (free_point ?wp)))
        (at end   (not (shelve_collected ?r ?c)))
        (at end   (not (arm_positioned ?r ?wp)))
        (at end   (available ?r))
        (at end   (free_point ?wp))
        (at end   (shelve_full ?c))
        (at end   (decrease (energy ?r) 0.8))
        )
)

(:durative-action process
:parameters (?c1 ?c2 ?c3 - component ?p - product ?m - machine)
:duration ( = ?duration 60)
:condition (and
           (at start (shelve_full ?c1))
           (at start (shelve_full ?c2))
           (at start (shelve_full ?c3))
           (at start (machine_available ?m))
           (over all (is_cap ?c1))
           (over all (is_label ?c2))
           (over all (is_bottle ?c3))

           )
:effect (and
        (at start (not (shelve_full ?c1)))
        (at start (not (shelve_full ?c2)))
        (at start (not (shelve_full ?c3)))
        (at start (component_required ?c1))
        (at start (component_required ?c2))
        (at start (component_required ?c3))
        (at start (not (machine_available ?m)))
        (at end   (machine_available ?m))
        (at end   (product_packed ?p))
        )
)

(:durative-action check-parameters
:parameters (?r - robot ?s - sensor ?wp - waypoint)
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
        (at end (parameters_checked ?wp))
        )
)

(:durative-action sense-flow
:parameters (?r - robot  ?wp - waypoint ?s - sensor ?v - valve)
:duration ( = ?duration 10)
:condition (and
           (over all (valve_at ?v  ?wp))
           (over all (available ?r))
           (over all (can_visualise ?r ?s))
           (over all (at ?r ?wp))
           (at start (>= (energy ?r) 5))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (free_point ?wp)))
        (at end   (free_point ?wp))
        (at end   (increase (data_acquired ?r) 2))
        (at end   (flow_acquired ?wp))
        (at end   (available ?r))
        (at end   (decrease (energy ?r) 0.5))
        )
)

(:durative-action regulate-flow
:parameters (?r - robot  ?wp - waypoint ?a - actuator ?v - valve ?f - flow)
:duration (= ?duration 10)
:condition (and
           (over all (can_manipulate ?r  ?a))
           (over all (valve_at ?v  ?wp))
           (over all (at ?r ?wp))
           (at start (arm_positioned ?r ?wp))
           (at start (valve_flow  ?v ?f))
           (at start (available ?r))
           (at start (>= (energy ?r) 5))
           (at start (free_point ?wp))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (free_point ?wp)))
        (at end   (free_point ?wp))
        (at end   (available ?r))
        (at end   (not (arm_positioned ?r ?wp)))
        (at end   (valve_regulated ?v))
        (at end   (decrease (energy ?r) 1))
        )
)

(:durative-action navigation
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration (+ (* (/ (distance ?wpi ?wpf) (speed ?r)) 2) 1))
:condition (and
           (at start (available ?r))
           (at start (at ?r ?wpi))
           (at start (free_point ?wpf))
          ; (at start (>= (energy ?r) (* (distance ?wpi ?wpf)(consumption ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (free_point ?wpf)))
        (at start (not (at ?r ?wpi)))
        (at end   (free_point ?wpf))
        (at end   (at ?r ?wpf))
        (at end   (explored ?wpf))
        (at end   (available ?r))
        (at end   (increase (total-distance) (distance ?wpi ?wpf)))
        ;(at end   (decrease (energy ?r) (* (distance ?wpi ?wpf)(consumption ?r))))
        )
)

(:durative-action position-arm
 :parameters (?r - robot ?v - valve ?wp - waypoint ?a - actuator)
 :duration ( = ?duration 10)
 :condition (and
            (over all (at ?r ?wp))
            (over all (can_manipulate ?r  ?a))
            (over all (can_grasp ?r  ?a))
            (at start (>= (energy ?r) 5))
            )
  :effect (and
          (at end (decrease (energy ?r) 0.3))
          (at end (arm_positioned ?r ?wp))
          )
)

(:durative-action communicate
:parameters (?r - robot   ?wp - waypoint)
:duration (= ?duration 3)
:condition (and
           (over all (at ?r ?wp))
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

(:durative-action recharge
:parameters (?r - robot  ?wp - waypoint)
:duration (= ?duration (/ (- 100 (energy ?r)) (recharge_rate ?r)))
:condition (and
          (over all (at ?r ?wp))
          (over all (charge_point_at ?wp))
          (at start (available ?r))
          (at start (<= (energy ?r) 80))
          (at start (free_point ?wp))
          )
:effect (and
        (at start (not (available ?r)))
        (at start (not (free_point ?wp)))
        (at end   (free_point ?wp))
        (at end   (available ?r))
        (at end   (increase (energy ?r) (* ?duration (recharge_rate ?r))))
        )
)

)
