***************************************************************
AAMAS-2020 repository                                       
***************************************************************

This repository contains the ROS-MRGA code, the domain and problems used in:

"Task Allocation Strategy for Heterogeneous Robot Teams in Offshore Missions"


1. TASK PLANNING

1.1 First folder (constrained_domain) contains the domain and problems that consider 
   the predicate "robot_can_act" to implement the plan which were generated using the 
   Multi-Role Goal Assignment (MRGA) strategy presented in the paper.

1.2 Second folder (non-constrained_domain) constains a version of the domain and problems
   in folder one without using the predicates generate by  the MRGA strategy.
   
   How to run it?
   
       --> Clone the repository
       --> Compile the planners:
       
                1) TemporAl, TFLAP & OPTIC IPC-2018 (https://ipc2018-temporal.bitbucket.io/)
       
                2) LPG (http://zeus.ing.unibs.it/lpg/) 
                
                3) TFD (http://gki.informatik.uni-freiburg.de/tools/tfd/)
                
                4) POPF (https://nms.kcl.ac.uk/planning/software/popf.html)
                
                
         --> Run the planners using the domain and problem required
                
