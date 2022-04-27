(define (problem structure-mapping)
(:domain sm0)
(:objects
    bluerov2-0 bluerov2-1 - robot
    wp0 wp10 wp11 wp12 wp13 wp14 wp15 wp16 wp17 wp18 wp19 wp20
    wp21 wp22 wp23 wp24 wp25 wp26 wp27 wp28 wp29 wp30 wp31 wp32
    wp33 wp34 wp35 wp36 wp37 wp38 wp39 wp40 wp41 wp42 wp43 wp44
    wp45 wp46 wp47 wp48 wp49 wp50 wp51 wp52  - waypoint
    sp0 sp1 sp2 sp3 sp4 sp5 sp6 sp7 sp8 sp9 sp10 sp11 sp12 sp13 sp14
    sp15 sp16 sp17 sp18 sp19 sp20 sp21 sp22 sp23 - poi
    c0 c1
    slam0 slam1
    s0 s1 - sensor
    arm0 arm1 - actuator
)

(:init
    (at bluerov2-0 wp0)
    (at bluerov2-1 wp0)

    (poi_at sp0 wp10)
    (poi_at sp1 wp11)
    (poi_at sp2 wp12)
    (poi_at sp3 wp13)
    (poi_at sp4 wp14)
    (poi_at sp5 wp15)
    (poi_at sp6 wp16)
    (poi_at sp7 wp17)
    (poi_at sp8 wp18)
    (poi_at sp9 wp19)
    (poi_at sp10 wp20)
    (poi_at sp11 wp21)
    (poi_at sp12 wp22)
    (poi_at sp13 wp23)
    (poi_at sp14 wp24)
    (poi_at sp15 wp25)
    (poi_at sp16 wp26)
    (poi_at sp17 wp27)
    (poi_at sp18 wp28)
    (poi_at sp19 wp29)
    (poi_at sp20 wp30)
    (poi_at sp21 wp31)
    (poi_at sp22 wp32)
    (poi_at sp23 wp33)

    (available bluerov2-0)
    (available bluerov2-1)

    (can_visualise bluerov2-0 c0)
    (can_visualise bluerov2-1 c1)

    (can_manipulate bluerov2-0 arm0)
    (can_manipulate bluerov2-1 arm1)

    (can_inspect bluerov2-0 s0)
    (can_inspect bluerov2-1 s1)

    (can_map bluerov2-0 slam0)
    (can_map bluerov2-1 slam1)

    (is_structure sp0)
    (is_structure sp1)
    (is_structure sp2)
    (is_structure sp3)
    (is_structure sp4)
    (is_structure sp5)
    (is_structure sp6)
    (is_structure sp7)
    (is_structure sp8)
    (is_structure sp9)
    (is_structure sp10)
    (is_structure sp11)
    (is_structure sp12)
    (is_structure sp13)
    (is_structure sp14)
    (is_structure sp15)
    (is_structure sp16)
    (is_structure sp17)
    (is_structure sp18)
    (is_structure sp19)
    (is_structure sp20)
    (is_structure sp21)
    (is_structure sp22)
    (is_structure sp23)

    (is_sensor sp5)
    (is_sensor sp10)
    (is_sensor sp15)
    (is_sensor sp20)
    (is_sensor sp23)

    (sensor_damaged sp5)
    (sensor_damaged sp10)
    (sensor_damaged sp15)
    (sensor_damaged sp20)
    (sensor_damaged sp23)

    ;(sensor_identified wp15)
    ;(sensor_identified wp20)
    ;(sensor_identified wp25)
    ;(sensor_identified wp30)
    ;(sensor_identified wp33)

    ;(low_visibility sp5)
    ;(low_visibility sp10)
    ;(low_visibility sp15)
    ;(low_visibility sp20)
    ;(low_visibility sp23)

     (strong_current sp5)
     (strong_current sp10)
     (strong_current sp15)
     (strong_current sp20)
     (strong_current sp23)

    (structure_ob_point wp10)
    (structure_ob_point wp11)
    (structure_ob_point wp12)
    (structure_ob_point wp13)
    (structure_ob_point wp14)
    (structure_ob_point wp15)
    (structure_ob_point wp16)
    (structure_ob_point wp17)
    (structure_ob_point wp18)
    (structure_ob_point wp19)
    (structure_ob_point wp20)
    (structure_ob_point wp21)
    (structure_ob_point wp22)
    (structure_ob_point wp23)
    (structure_ob_point wp24)
    (structure_ob_point wp25)
    (structure_ob_point wp26)
    (structure_ob_point wp27)
    (structure_ob_point wp28)
    (structure_ob_point wp29)
    (structure_ob_point wp30)
    (structure_ob_point wp31)
    (structure_ob_point wp32)
    (structure_ob_point wp33)

    (free_point wp0)
    (free_point wp34)
    (free_point wp35)
    (free_point wp36)
    (free_point wp37)
    (free_point wp38)
    (free_point wp39)
    (free_point wp40)
    (free_point wp41)
    (free_point wp42)
    (free_point wp43)
    (free_point wp44)
    (free_point wp45)
    (free_point wp46)

    (docking_point wp50)
    (docking_point wp51)
    (docking_point wp52)

    (docking_point_free wp50)
    (docking_point_free wp51)
    (docking_point_free wp52)


    (connected wp10 wp11)
    (connected wp11 wp12)
    (connected wp12 wp13)
    (connected wp13 wp14)
    (connected wp14 wp15)
    (connected wp15 wp16)
    (connected wp16 wp17)
    (connected wp17 wp18)
    (connected wp18 wp19)
    (connected wp19 wp20)
    (connected wp20 wp21)
    (connected wp21 wp22)
    (connected wp22 wp23)
    (connected wp23 wp24)
    (connected wp24 wp25)
    (connected wp25 wp26)
    (connected wp26 wp27)
    (connected wp27 wp28)
    (connected wp28 wp29)
    (connected wp29 wp30)
    (connected wp30 wp31)
    (connected wp31 wp32)
    (connected wp32 wp33)
    (connected wp33 wp34)
    (connected wp34 wp35)
    (connected wp35 wp36)
    (connected wp36 wp37)
    (connected wp37 wp38)
    (connected wp38 wp39)
    (connected wp39 wp40)
    (connected wp40 wp41)
    (connected wp41 wp40)
    (connected wp40 wp39)
    (connected wp39 wp38)
    (connected wp38 wp37)
    (connected wp37 wp36)
    (connected wp36 wp35)
    (connected wp35 wp34)
    (connected wp34 wp33)
    (connected wp33 wp32)
    (connected wp32 wp31)
    (connected wp31 wp30)
    (connected wp30 wp29)
    (connected wp29 wp28)
    (connected wp28 wp27)
    (connected wp27 wp26)
    (connected wp26 wp25)
    (connected wp25 wp24)
    (connected wp24 wp23)
    (connected wp23 wp22)
    (connected wp22 wp21)
    (connected wp21 wp20)
    (connected wp20 wp19)
    (connected wp19 wp18)
    (connected wp18 wp17)
    (connected wp17 wp16)
    (connected wp16 wp15)
    (connected wp15 wp14)
    (connected wp14 wp13)
    (connected wp13 wp12)
    (connected wp12 wp11)
    (connected wp11 wp10)
    (connected wp10 wp41)
    (connected wp41 wp10)
    (connected wp42 wp43)
    (connected wp43 wp44)
    (connected wp44 wp45)
    (connected wp45 wp46)
    (connected wp46 wp47)
    (connected wp47 wp48)
    (connected wp48 wp49)
    (connected wp49 wp48)
    (connected wp48 wp47)
    (connected wp47 wp46)
    (connected wp46 wp45)
    (connected wp45 wp44)
    (connected wp44 wp43)
    (connected wp43 wp42)
    (connected wp10 wp0)
    (connected wp0 wp10)
    (connected wp45 wp0)
    (connected wp0 wp45)

    (connected wp45 wp50)
    (connected wp50 wp45)
    (connected wp0 wp50)
    (connected wp50 wp0)
    (connected wp50 wp33)
    (connected wp33 wp50)
    (connected wp50 wp10)
    (connected wp10 wp50)
    (connected wp45 wp51)
    (connected wp51 wp45)
    (connected wp0 wp51)
    (connected wp51 wp0)
    (connected wp51 wp33)
    (connected wp33 wp51)
    (connected wp51 wp10)
    (connected wp10 wp51)
    (connected wp45 wp52)
    (connected wp52 wp45)
    (connected wp0 wp52)
    (connected wp52 wp0)
    (connected wp52 wp33)
    (connected wp33 wp52)
    (connected wp52 wp10)
    (connected wp10 wp52)

    (= (cr_rate_a  bluerov2-0) 0.055)
    (= (cr_rate_sd bluerov2-0) 0.054)
    (= (cr_rate_sc bluerov2-0) 0.002)

    (= (cr_rate_a  bluerov2-1) 0.055)
    (= (cr_rate_sd bluerov2-1) 0.054)
    (= (cr_rate_sc bluerov2-1) 0.002)


    (= (speed bluerov2-0) 0.5)
    (= (speed bluerov2-1) 0.5)

    (= (recharge_rate bluerov2-0) 0.5)
    (= (recharge_rate bluerov2-1) 0.5)

    (= (data_acquired bluerov2-0) 0)
    (= (data_acquired bluerov2-1) 0)

    (= (data_capacity bluerov2-0) 30)
    (= (data_capacity bluerov2-1) 30)

    (= (energy bluerov2-0) 100)
    (= (energy bluerov2-1) 100)

    (= (energy bluerov2-0) 100)
    (= (energy bluerov2-1) 100)

    (= (total-distance) 0)

    (= (sense_sensor_dur) 5)
    (= (replace_sensor_dur) 15)
    (= (sense_structure_dur) 10)
    (= (sense_valve_dur) 5)
    (= (broadcast_data_dur) 5)
    (= (recover_robot_dur) 2)
    (= (relocalisation_dur) 5)
    (= (increase_light_dur) 2)

    (= (distance wp10 wp11) 0.6)
    (= (distance wp11 wp12) 0.190301)
    (= (distance wp12 wp13) 0.6)
    (= (distance wp13 wp14) 1.84897)
    (= (distance wp14 wp15) 0.6)
    (= (distance wp15 wp16) 0.975452)
    (= (distance wp16 wp17) 0.6)
    (= (distance wp17 wp18) 0.975452)
    (= (distance wp18 wp19) 0.6)
    (= (distance wp19 wp20) 0.975452)
    (= (distance wp20 wp21) 0.6)
    (= (distance wp21 wp22) 0.975452)
    (= (distance wp22 wp23) 0.6)
    (= (distance wp23 wp24) 1.84897)
    (= (distance wp24 wp25) 0.6)
    (= (distance wp25 wp26) 0.190301)
    (= (distance wp26 wp27) 0.6)
    (= (distance wp27 wp28) 0.190301)
    (= (distance wp28 wp29) 0.6)
    (= (distance wp29 wp30) 1.84897)
    (= (distance wp30 wp31) 0.6)
    (= (distance wp31 wp32) 0.975452)
    (= (distance wp32 wp33) 0.6)
    (= (distance wp33 wp34) 0.975452)
    (= (distance wp34 wp35) 0.6)
    (= (distance wp35 wp36) 0.975452)
    (= (distance wp36 wp37) 0.6)
    (= (distance wp37 wp38) 0.975452)
    (= (distance wp38 wp39) 0.6)
    (= (distance wp39 wp40) 1.84897)
    (= (distance wp40 wp41) 0.6)
    (= (distance wp41 wp40) 0.6)
    (= (distance wp40 wp39) 0.190301)
    (= (distance wp39 wp38) 0.6)
    (= (distance wp38 wp37) 1.84897)
    (= (distance wp37 wp36) 0.6)
    (= (distance wp36 wp35) 0.975452)
    (= (distance wp35 wp34) 0.6)
    (= (distance wp34 wp33) 0.975452)
    (= (distance wp33 wp32) 0.6)
    (= (distance wp32 wp31) 0.975452)
    (= (distance wp31 wp30) 0.6)
    (= (distance wp30 wp29) 0.975452)
    (= (distance wp29 wp28) 0.6)
    (= (distance wp28 wp27) 1.84897)
    (= (distance wp27 wp26) 0.6)
    (= (distance wp26 wp25) 0.190301)
    (= (distance wp25 wp24) 0.6)
    (= (distance wp24 wp23) 0.190301)
    (= (distance wp23 wp22) 0.6)
    (= (distance wp22 wp21) 1.84897)
    (= (distance wp21 wp20) 0.6)
    (= (distance wp20 wp19) 0.975452)
    (= (distance wp19 wp18) 0.6)
    (= (distance wp18 wp17) 0.975452)
    (= (distance wp17 wp16) 0.6)
    (= (distance wp16 wp15) 0.975452)
    (= (distance wp15 wp14) 0.6)
    (= (distance wp14 wp13) 0.975452)
    (= (distance wp13 wp12) 0.6)
    (= (distance wp12 wp11) 1.84897)
    (= (distance wp11 wp10) 0.6)
    (= (distance wp10 wp41) 0.190301)
    (= (distance wp41 wp10) 0.190301)
    (= (distance wp42 wp43) 1)
    (= (distance wp43 wp44) 1)
    (= (distance wp44 wp45) 1)
    (= (distance wp45 wp46) 1)
    (= (distance wp46 wp47) 1)
    (= (distance wp47 wp48) 1)
    (= (distance wp48 wp49) 1)
    (= (distance wp49 wp48) 1)
    (= (distance wp48 wp47) 1)
    (= (distance wp47 wp46) 1)
    (= (distance wp46 wp45) 1)
    (= (distance wp45 wp44) 1)
    (= (distance wp44 wp43) 1)
    (= (distance wp43 wp42) 1)
    (= (distance wp10 wp0) 1.00499)
    (= (distance wp0 wp10) 1.00499)
    (= (distance wp45 wp0) 0.141421)
    (= (distance wp0 wp45) 0.141421)

    (= (distance wp45 wp50) 2)
    (= (distance wp50 wp45) 2)
    (= (distance wp0 wp50) 6)
    (= (distance wp50 wp0) 6)
    (= (distance wp50 wp33) 6)
    (= (distance wp33 wp50) 6)
    (= (distance wp50 wp10) 6)
    (= (distance wp10 wp50) 6)
    (= (distance wp45 wp51) 3)
    (= (distance wp51 wp45) 3)
    (= (distance wp0 wp51) 4)
    (= (distance wp51 wp0) 4)
    (= (distance wp51 wp33) 7)
    (= (distance wp33 wp51) 7)
    (= (distance wp51 wp10) 7)
    (= (distance wp10 wp51) 7)
    (= (distance wp45 wp52) 8)
    (= (distance wp52 wp45) 8)
    (= (distance wp0 wp52) 5)
    (= (distance wp52 wp0) 5)
    (= (distance wp52 wp33) 6)
    (= (distance wp33 wp52) 6)
    (= (distance wp52 wp10) 8)
    (= (distance wp10 wp52) 8)

    (= (total-distance) 0)

)
(:goal (and

  (section_mapped wp24)
  (section_mapped wp25)
  (section_mapped wp26)
  (section_mapped wp27)
  (section_mapped wp28)
  (section_mapped wp29)
  (section_mapped wp30)
  (section_mapped wp31)
  (section_mapped wp32)
  (section_mapped wp33)

  (recovered bluerov2-0 wp0)
  (recovered bluerov2-1 wp0)

))
)
