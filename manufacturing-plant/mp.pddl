(define (domain manufacturing-plant)
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
             (shelve_full ?wp - waypoint ?c - component)
             (yellow_shelve_at ?c - component ?wp -waypoint)
             (green_shelve_at ?c - component ?wp -waypoint)
             (is_cap ?c - component)
             (is_label ?c - component)
             (is_bottle ?c - component)
             (charge_point_at ?wp - waypoint)
             (machine_available ?m - machine)
             (free_point ?wp - waypoint)
             (valve_at ?v - valve ?wp - waypoint)
             (valve_flow  ?v - valve ?f - flow)

             (communicated ?wp - waypoint)
             (explored ?wp - waypoint)
             (recharged ?wp - waypoint)
             (flow_acquired ?wp - waypoint)
             (valve_regulated  ?wp - waypoint)
             (parameters_checked ?wp - waypoint)
             (arm_positioned ?r - robot ?wp - waypoint)
             (component_required ?c - component)
             (shelve_collected  ?r - robot ?c - component)
             (product_packed ?p - product)
)

(:functions (battery_level ?r - robot)
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
:duration ( = ?duration (collect_shelve_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (can_grasp ?r ?a))
           (over all (yellow_shelve_at ?c ?wp))
           (over all (component_required ?c))
           (at start (arm_positioned ?r ?wp))
           (at start (available ?r))
           (at start (>= (energy ?r) (* (collect_shelve_dur) (cr_rate_sc ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (not (arm_positioned ?r ?wp)))
        (at end   (shelve_collected ?r ?c))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
        )
)

(:durative-action deliver-shelve
:parameters (?r - robot ?wp - waypoint ?a - actuator ?c - component)
:duration ( = ?duration (deliver_shelve_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (can_grasp ?r ?a))
           (over all (green_shelve_at ?c ?wp))
           (at start (component_required ?c))
           (at start (arm_positioned ?r ?wp))
           (at start (available ?r))
           (at start (shelve_collected ?r ?c))
           (at start (>= (energy ?r) (* (deliver_shelve_dur) (cr_rate_sc ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (shelve_collected ?r ?c)))
        (at end   (not (shelve_collected ?r ?c)))
        (at end   (not (component_required ?c)))
        (at end   (not (arm_positioned ?r ?wp)))
        (at end   (available ?r))
        (at end   (shelve_full ?wp ?c))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
        )
)

(:durative-action process
:parameters (?c1 ?c2 ?c3 - component ?wp1 ?wp2 ?wp3 - waypoint ?p - product ?m - machine)
:duration ( = ?duration (process_dur))
:condition (and
           (over all (is_cap ?c1))
           (over all (is_label ?c2))
           (over all (is_bottle ?c3))
           (at start (shelve_full ?wp1 ?c1))
           (at start (shelve_full ?wp2 ?c2))
           (at start (shelve_full ?wp3 ?c3))
           (at start (machine_available ?m))
           )
:effect (and
        (at start (not (machine_available ?m)))
        (at end (machine_available ?m))
        (at end (not (shelve_full ?wp1 ?c1)))
        (at end (not (shelve_full ?wp2 ?c2)))
        (at end (not (shelve_full ?wp3 ?c3)))
        (at end (component_required ?c1))
        (at end (component_required ?c2))
        (at end (component_required ?c3))
        (at end (product_packed ?p))
        )
)

(:durative-action check-parameters
:parameters (?r - robot ?s - sensor ?wp - waypoint)
:duration (= ?duration (check_parameters_dur))
:condition (and
           (over all (at ?r ?wp))
           (over all (can_visualise ?r ?s))
           (at start (available ?r))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) (* (check_parameters_dur) (cr_rate_sc ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at end (available ?r))
        (at end (increase (data_acquired ?r) 1))
        (at end (parameters_checked ?wp))
        (at end (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
        )
)

(:durative-action sense-flow
:parameters (?r - robot  ?wp - waypoint ?s - sensor ?v - valve)
:duration ( = ?duration (sense_flow_dur))
:condition (and
           (over all (valve_at ?v  ?wp))
           (over all (available ?r))
           (over all (can_visualise ?r ?s))
           (over all (at ?r ?wp))
           (at start (< (data_acquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) (* (sense_flow_dur) (cr_rate_sc ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (flow_acquired ?wp))
        (at end   (available ?r))
        (at end   (increase (data_acquired ?r) 1))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
        )
)

(:durative-action regulate-flow
:parameters (?r - robot  ?wp - waypoint ?a - actuator ?v - valve ?f - flow)
:duration (= ?duration (regulate_flow_dur))
:condition (and
           (over all (can_manipulate ?r  ?a))
           (over all (valve_at ?v  ?wp))
           (over all (at ?r ?wp))
           (at start (arm_positioned ?r ?wp))
           (at start (valve_flow  ?v ?f))
           (at start (available ?r))
           (at start (>= (energy ?r) (* (regulate_flow_dur) (cr_rate_sd ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (not (arm_positioned ?r ?wp)))
        (at end   (valve_regulated ?wp))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sd ?r))))
        )
)

(:durative-action navigation
:parameters (?r - robot ?wpi  ?wpf - waypoint)
:duration ( = ?duration (+ (* (/ (distance ?wpi ?wpf) (speed ?r)) 2) 1))
:condition (and
           (at start (available ?r))
           (at start (at ?r ?wpi))
           (at start (free_point ?wpf))
           (at start (>= (energy ?r) (* (/ (distance ?wpi ?wpf) (speed ?r)) (cr_rate_a ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at start (not (at ?r ?wpi)))
        (at start (free_point ?wpi))
        (at end   (free_point ?wpi))
        (at end   (not (free_point ?wpf)))
        (at end   (at ?r ?wpf))
        (at end   (explored ?wpf))
        (at end   (available ?r))
        (at end   (increase (total-distance) (distance ?wpi ?wpf)))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_a ?r))))
        )
)

(:durative-action position-arm
 :parameters (?r - robot ?v - valve ?wp - waypoint ?a - actuator)
 :duration ( = ?duration (position_arm_dur))
 :condition (and
            (over all (at ?r ?wp))
            (over all (can_manipulate ?r  ?a))
            (over all (can_grasp ?r  ?a))
            (at start (>= (energy ?r) (* (position_arm_dur) (cr_rate_sd ?r))))
            )
  :effect (and
          (at end (decrease (energy ?r) (* ?duration (cr_rate_sd ?r))))
          (at end (arm_positioned ?r ?wp))
          )
)

(:durative-action communicate
:parameters (?r - robot   ?wp - waypoint)
:duration (= ?duration (communicate_dur))
:condition (and
           (over all (at ?r ?wp))
           (at start (available ?r))
           (at start (>= (data_acquired ?r) (data_capacity ?r)))
           (at start (>= (energy ?r) (* (communicate_dur) (cr_rate_sc ?r))))
           )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (assign (data_acquired ?r) 0))
        (at end   (decrease (energy ?r) (* ?duration (cr_rate_sc ?r))))
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
          )
:effect (and
        (at start (not (available ?r)))
        (at end   (available ?r))
        (at end   (increase (energy ?r) (* ?duration (recharge_rate ?r))))
        )
)
)
