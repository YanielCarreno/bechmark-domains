(define (domain domain_surface_auvs)

(:requirements :strips :typing :fluents :disjunctive-preconditions :durative-actions :universal-preconditions)

(:types
  waypoint
  observation_point  ;the observation points are points of interest were the rexrov implement circular trajectory
  rexrov             ;robots in the misssion
  robot-surface
  sensors            ;predicate associated with the sensors on the rexrov
)

(:predicates

;===== robot-surface predicates ======
  (robot_surface_at ?asv_wamv - robot-surface ?wp - waypoint)
  (robot_surface_available ?asv_wamv - robot-surface)
  (robot_surface_deployed ?asv_wamv -robot-surface ?wp - waypoint)

;===== rexrov predicates =============
  (rexrov_at ?rov - rexrov ?wp - waypoint)
  (rexrov_available ?rov - rexrov)
  (rexrov_capable  ?rov - rexrov)
  (rexrov_camera_free ?s - sensors)
  (rexrov_can_act ?rov - rexrov ?wp - waypoint)
  (rexrov_perception_sensor_free ?s - sensors)
  (rexrov_point_inspected ?wp - waypoint)
  (rexrov_docked ?rov - rexrov)
  (rexrov_undocked ?rov - rexrov)
  (rexrov_data_transmitted ?wp - waypoint)
  (rexrov_rotated ?rov - rexrov ?o - observation_point)
  (rexrov_approached ?rov - rexrov ?o - observation_point)
  (rexrov_ob_explored ?wp - waypoint ?o - observation_point)
  (rexrov_image_observed ?wp - waypoint ?o - observation_point)
  (rexrov_target_inquired ?wp - waypoint ?o - observation_point)
  (rexrov_samples_adquired ?wp - waypoint ?o - observation_point)
  (rexrov_on_board ?s - sensors ?rov - rexrov)
  (close_to ?wp - waypoint ?wp - waypoint)

;===== general predicates =============
  (control_centre_at ?wp - waypoint)
  (observation_at ?o - observation_point ?wp - waypoint)
  (channel_free ?wp - waypoint)
  (rexrov_dock_at ?wp - waypoint)

  (dock_pos1 ?wp - waypoint)
  (dock_pos2 ?wp - waypoint)
  (dock_pos3 ?wp - waypoint)

)
(:functions
;===== robot-surface functions =======
  (robot_surface_energy_capacity ?asv_wamv - robot-surface)      ; the initial energy capacity of the robot-surface is 100%
  (robot_surface_consumption_rate ?asv_wamv - robot-surface)     ; const to define the speed of energy consumption
  (robot_surface_recharge_rate ?asv_wamv - robot-surface)        ; to define robot-surface's recharging time
  (robot_surface_avg_forward_speed ?asv_wamv - robot-surface)    ; the value of the avg_forward_speed is 1/3 considering the robot-surface max_forward_speed can be 1/2
  (robot_surface_energy ?asv_wamv - robot-surface)

;===== rexrov functions =======
  (rexrov_energy_capacity ?rov - rexrov)      ; the initial energy capacity of the rexrov is 100%
  (rexrov_consumption_rate ?rov - rexrov)     ; const to define the speed of energy consumption
  (rexrov_recharge_rate ?rov - rexrov)        ; to define rexrov's recharging time
  (rexrov_avg_forward_speed ?rov - rexrov)    ; the value of the avg_forward_speed is 1/3 considering the rexrov max_forward_speed can be 1/2
  (rexrov_energy ?rov - rexrov)               ; actual rexrov's energy
  (rexrov_sample_data ?rov - rexrov)          ; actual number perception reading adquired (number of ob points inspected to get data)
  (rexrov_sample_data_capacity ?rov - rexrov) ; total number of data to stored (max number of ob points the rexrov can visit to get data)
  (rexrov_image_data ?rov - rexrov)           ; actual number image reading adquired (number of ob points inspected to get image)
  (rexrov_image_data_capacity ?rov -rexrov)   ; total number of pictures to stored (max number of ob points the rexrov can visit to get pictures)

;===== general functions =======
  (distance ?wp1 ?wp2 - waypoint)              ; distance between the points
  (circle-perimeter)                           ; the perimeter of the circle made by the robots during explore-ob action
  (total-distance)                             ; to keep traking of the distance traveled, it can be used as a cost function later
  (ob_sample_inspection ?o -observation_point) ;ob points where we get data (imu, dvl, echo sounder information)
  (ob_image_capture ?o -observation_point)     ;ob points where we get picture
)
;===================================================================
;============== robot-surface actions ==============================
;===================================================================

(:durative-action asv_wamv_navigate
  :parameters (?asv_wamv - robot-surface ?from ?to - waypoint)
  :duration ( = ?duration (* (/ (distance ?from ?to) (robot_surface_avg_forward_speed ?asv_wamv)) 3))
  :condition (and
             (at start (robot_surface_at ?asv_wamv ?from))
             (at start (robot_surface_available ?asv_wamv)))
  :effect (and
          (at start (not (robot_surface_at ?asv_wamv ?from)))
          (at start (not (robot_surface_available ?asv_wamv)))
          (at end (robot_surface_deployed ?asv_wamv ?to))
          (at end (robot_surface_available ?asv_wamv))
          (at end (robot_surface_at ?asv_wamv ?to))
          (at end (increase (total-distance) (distance ?from ?to))))
)


;===================================================================
;============== rexrov actions =====================================
;===================================================================

(:durative-action rexrov_navigate
  :parameters (?rov - rexrov ?from ?to - waypoint)
  :duration ( = ?duration (* (/ (distance ?from ?to) (rexrov_avg_forward_speed ?rov)) 3))
  :condition (and
             (over all (rexrov_can_act ?rov  ?to))
             (at start (rexrov_at ?rov ?from))
             (at start (rexrov_undocked ?rov))
             (at start (rexrov_available ?rov))
             (at start (>= (rexrov_energy ?rov) (+ (* (distance ?from ?to)(rexrov_consumption_rate ?rov)) 10))))
  :effect (and
          (at end (rexrov_point_inspected ?to))
          (at end (rexrov_at ?rov ?to))
          (at end (rexrov_available ?rov))
          (at start (not (rexrov_available ?rov)))
          (at start (not (rexrov_at ?rov ?from)))
          (at end (decrease (rexrov_energy ?rov)(* (distance ?from ?to)(rexrov_consumption_rate ?rov))))
          (at end (increase (total-distance) (distance ?from ?to))))
)

(:durative-action rexrov_refuelling
  :parameters (?asv_wamv - robot-surface ?rov - rexrov ?from ?to - waypoint)
  :duration ( = ?duration (+ (* (/ (distance ?from ?to) (rexrov_avg_forward_speed ?rov)) 3) (/ 30 (rexrov_recharge_rate ?rov))))
  :condition (and
             (over all (close_to ?from ?to))
             (over all (rexrov_can_act ?rov  ?to))
             (at start (rexrov_at ?rov ?from))
             (at start (rexrov_undocked ?rov))
             (at start (robot_surface_deployed ?asv_wamv ?to))
             (at start (>= (rexrov_energy ?rov)(*(distance ?from ?to)(rexrov_consumption_rate ?rov))))
             (at start (<= (rexrov_energy ?rov)(* (rexrov_energy_capacity ?rov) 0.3))))
  :effect (and
          (at start (not (rexrov_undocked ?rov)))
          (at start (not (rexrov_at ?rov ?from)))
          (at end (rexrov_at ?rov ?to))
          (at end (robot_surface_at ?asv_wamv ?to))
          (at end (not (robot_surface_deployed ?asv_wamv ?to)))
          (at end (rexrov_docked ?rov))
          (at end (rexrov_dock_at ?to))
          (at end (assign (rexrov_energy ?rov)(rexrov_energy_capacity ?rov))))
)

(:durative-action rexrov_undock
  :parameters (?rov - rexrov ?wp - waypoint)
  :duration ( = ?duration 10)
  :condition (and
             (over all (rexrov_can_act ?rov  ?wp))
             (at start (rexrov_dock_at ?wp))
             (at start (rexrov_docked ?rov)))
  :effect (and
          (at start (not (rexrov_docked ?rov)))
          (at end (decrease (rexrov_energy ?rov) 0.1))
          (at end (not (rexrov_dock_at ?wp)))
          (at end (rexrov_undocked ?rov)))
)

(:durative-action rexrov_explore_ob
  :parameters (?rov - rexrov  ?wp - waypoint ?o - observation_point)
  :duration ( = ?duration (* (/ (circle-perimeter) (rexrov_avg_forward_speed ?rov)) 2))
  :condition (and
             (over all (rexrov_can_act ?rov  ?wp))
             (over all (observation_at ?o  ?wp))
             (over all (rexrov_at ?rov ?wp))
             (at start (rexrov_available ?rov))
             (at start (rexrov_point_inspected ?wp))
             (at start (>= (rexrov_energy ?rov) (+ (* (circle-perimeter)(rexrov_consumption_rate ?rov)) 10))))
  :effect (and
          (at end (rexrov_ob_explored ?wp ?o))
          (at end (rexrov_rotated ?rov ?o))
          (at end (rexrov_available ?rov))
          (at start (not (rexrov_available ?rov)))
          (at end (rexrov_at ?rov ?wp))
          (at end (decrease (rexrov_energy ?rov)(* (circle-perimeter)(rexrov_consumption_rate ?rov))))
          (at end (increase (total-distance) (circle-perimeter))))
)

(:durative-action rexrov_send_sample_data
  :parameters (?rov - rexrov ?wp - waypoint)
  :duration ( = ?duration 30)
  :condition (and
             (over all (rexrov_can_act ?rov  ?wp))
             (over all (rexrov_at ?rov ?wp))
             (over all (control_centre_at ?wp))
             (at start (>= (rexrov_sample_data ?rov) (- (rexrov_sample_data_capacity ?rov) 0)))
             (at start (rexrov_available ?rov))
             (at start (>= (rexrov_energy ?rov) 2))
             (at start (channel_free ?wp)))
  :effect (and
          (at end (assign (rexrov_sample_data ?rov) 0))
          (at start (not (rexrov_available ?rov)))
          (at start (not (channel_free ?wp)))
          (at end (channel_free ?wp))
          (at end (rexrov_available ?rov))
          (at end (rexrov_data_transmitted ?wp ))
          (at end (decrease (rexrov_energy ?rov) 0.2)))
)

(:durative-action rexrov_send_image_data
  :parameters (?rov - rexrov ?wp - waypoint)
  :duration ( = ?duration 30)
  :condition (and
             (over all (rexrov_can_act ?rov  ?wp))
             (over all (rexrov_at ?rov ?wp))
             (over all (control_centre_at ?wp))
             (at start (>= (rexrov_image_data ?rov)(- (rexrov_image_data_capacity ?rov) 0)))
             (at start (rexrov_available ?rov))
             (at start (>= (rexrov_energy ?rov) 10))
             (at start (channel_free ?wp)))
  :effect (and
          (at start (not (rexrov_available ?rov)))
          (at start (not (channel_free ?wp)))
          (at end (assign (rexrov_image_data ?rov) 0))
          (at end (channel_free ?wp))
          (at end (rexrov_available ?rov))
          (at end (rexrov_data_transmitted ?wp ))
          (at end (decrease (rexrov_energy ?rov) 0.2)))
)

(:durative-action rexrov_take_image
  :parameters (?rov - rexrov ?o - observation_point ?wp - waypoint ?s - sensors)
  :duration ( = ?duration 20)
  :condition (and
             (over all (rexrov_can_act ?rov  ?wp))
             (over all (rexrov_at ?rov ?wp))
             (over all (observation_at ?o  ?wp))
             (over all (rexrov_capable ?rov))
             (at start (rexrov_on_board ?s  ?rov))
             (at start (rexrov_available ?rov))
             (at start (>= (rexrov_energy ?rov) 2))
             (at start (rexrov_camera_free ?s))
             (at start (> (ob_image_capture ?o) 0))
             (at start (< (rexrov_image_data ?rov) (rexrov_image_data_capacity ?rov))))
  :effect (and
          (at start (not (rexrov_available ?rov)))
          (at start (not (rexrov_camera_free ?s)))
          (at end (rexrov_available ?rov))
          (at end (rexrov_camera_free ?s))
          (at end (rexrov_image_observed ?wp ?o))
          (at end (decrease (rexrov_energy ?rov) 0.2))
          (at end (increase (rexrov_image_data ?rov) (ob_image_capture ?o))))
)

(:durative-action rexrov_target_approach
  :parameters (?rov - rexrov ?o - observation_point ?wp - waypoint)
  :duration ( = ?duration 50)
  :condition (and
             (over all (rexrov_can_act ?rov  ?wp))
             (over all (rexrov_at ?rov ?wp))
             (over all (observation_at ?o  ?wp))
             (at start (rexrov_available ?rov))
             (at start (>= (rexrov_energy ?rov) 2)))
  :effect (and
          (at start (not (rexrov_available ?rov)))
          (at end (rexrov_approached ?rov ?o))
          (at end (rexrov_available ?rov))
          (at end (decrease (rexrov_energy ?rov) 0.2)))
)

(:durative-action rexrov_target_id
  :parameters (?rov - rexrov ?o - observation_point ?wp - waypoint ?s - sensors)
  :duration ( = ?duration 50)
  :condition (and
             (over all (rexrov_can_act ?rov  ?wp))
             (over all (rexrov_at ?rov ?wp))
             (over all (observation_at ?o  ?wp))
             (over all (rexrov_capable ?rov))
             (at start (rexrov_approached ?rov ?o))
             (at start (rexrov_on_board ?s  ?rov))
             (at start (rexrov_available ?rov))
             (at start (>= (rexrov_energy ?rov) 2))
             (at start (rexrov_camera_free ?s))
             (at start (< (rexrov_image_data ?rov)(rexrov_image_data_capacity ?rov))))
  :effect (and
          (at start (not (rexrov_available ?rov)))
          (at start (not (rexrov_camera_free ?s)))
          (at end (rexrov_available ?rov))
          (at end (decrease (rexrov_energy ?rov) 0.2))
          (at end (rexrov_camera_free ?s))
          (at end (rexrov_target_inquired ?wp ?o))
          (at end (increase (rexrov_image_data ?rov) 1)))
)

(:durative-action rexrov_take_sample_data
  :parameters (?rov - rexrov ?o - observation_point ?wp - waypoint ?s - sensors)
  :duration ( = ?duration 30)
  :condition (and
             (over all (rexrov_can_act ?rov  ?wp))
             (over all (rexrov_at ?rov ?wp))
             (over all (observation_at ?o  ?wp))
             (over all (rexrov_capable ?rov))
             (at start (rexrov_on_board ?s  ?rov))
             (at start (rexrov_available ?rov))
             (at start (>= (rexrov_energy ?rov) 2))
             (at start (rexrov_perception_sensor_free ?s))
             (at start (> (ob_sample_inspection ?o) 0))
             (at start (< (rexrov_sample_data ?rov)(- (rexrov_sample_data_capacity ?rov) 0))))
  :effect (and
          (at start (not (rexrov_available ?rov)))
          (at start (not (rexrov_perception_sensor_free ?s)))
          (at end (rexrov_available ?rov))
          (at end (rexrov_perception_sensor_free ?s))
          (at end (decrease (rexrov_energy ?rov) 0.2))
          (at end (rexrov_samples_adquired ?wp ?o))
          (at end (increase (rexrov_sample_data ?rov) (ob_sample_inspection ?o))))
)
)
