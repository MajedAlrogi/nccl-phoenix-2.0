This readme will explain the files in the emulator folder. The associated header is /src/include/emulator.h

# helper.cc and helper.h
These files contain the function Info2Task which will fill a given TaskInfo struct based on the provided ncclInfo struct

# global.cc
This file implements the getAllEnvVars() that was described in emulator.h . 

# topology.cc
This file contains the fuctions that init, update, and destroy our topology struct

# coordinator.cc
This file has the following objectives:
 1. Initialize the coordinator and collective operations
 2. Simulate communication WITHOUT GPU computation
 3. ensure that data is transmitted in the correct order and that collective communication operations follow the appropriate workflow. It manages the send and receive progress (tracked by sendtail and recvtail) for each channel and rank, ensuring that messages are sent and received in the correct order, even in the absence of real computation.


## SECTION 1: HELPER METHODS
 This section contains 2 main parts:
 
 Part A: Sending/Recieving helper methods
 Part B: Synchronization helper methods


## SECTION 2: Coordinator Initialization
 The main functions here are: 
 .. coordinatorInit
 .. coordinatorDestroy
 
 CoordinatorInit: The main initialization function for the coordinator. It calls metaInit to set up the task metadata,  then uses sendrecvInit to initialize the sending and receiving ranks and their respective channels. This function essentially sets up the entire communication framework for the task.

 CoordinatorDestroy: Resets and cleans up the coordinator once the task is completed, ensuring that resources are released, and the system can be prepared for the next task.


## SECTION 3: Communication Functions
 
coordinatorGetSendSize: Retrieves the size of the data to be sent for a specific channel. It checks that the sendtail (which tracks progress through the send buffer) is not ahead of the recvtail (tracking the received data) to ensure proper synchronization. 

coordinatorSend & coordinatorRecv: Handle sending and receiving data for a specific channel. These functions update the sendtail and recvtail to reflect progress in data transmission and ensure that the communication task proceeds correctly.  They also call update_done to check if the entire task has been completed.

# controller.cc
 This file represents the controller. The controller is responsible for the creation and tracking of tasks (Collective Communications). These tasks are given to the coordinator to coordinate the communication among ranks.
 
 The controller also handles proxy communication