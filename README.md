# Model-Predictive-Control
System Identification &amp; Model Predictive Control of a Quarter Car Suspension System

### Objective
To model and estimate the parameters of a suspension system and then use LQR and MPC control techniques within simulation to tune for best performance against multiple benchmarking scenarios. Then implement the control techniques on the physical system.

### Method
* 1 - Collect frequency response of a physical Quarter Car Suspension System by inputting a chirp signal to perturb the model
* 2 - Model the physical system, including Free-Body Diagrams, Equations of Motion, and State Space
* 3 - Use system identification to estimate parameters and/or get a starting point for a model of the system with explicit coefficient values
* 4 - Construct LQR and MPC controllers for the simulink system simulation, enabling a dynamic suspension approach
* 5 - Compare results for different benchmark scenarios: Rider comfort, Suspension Longevity, Road Traction
* 6 - Implement on the physical system using LabVIEW VI's

### Results
MPC performed far better than LQR. Despite LQR performing well, as it is considered an 'optimal' solution for what should be an LTI system, the physical system was subject to large non-linearities that were not included within simulation. MPC could account for the model-mismatch and produce a better-performing, albeit complex online predictive optimal control solution.
