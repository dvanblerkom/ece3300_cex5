# Exercise: Finite State Machine (Alarm System)
## ECE3300

Add code to `src/alarm_fsm.v` to implement the finite state machine described in the comments.

If your code passes all testbench checks, you will see a **green check mark** on GitHub at the top of the repository. A failing design will show a **red X**.

---

## The Assignment

You are building a home alarm system controller with **four states**:

| State | Description |
|---|---|
| **IDLE** | System is disarmed. No outputs asserted. |
| **ARMED_HOME** | Armed in home mode. `alarm_armed` and `home_mode` high. Motion sensor ignored. |
| **ARMED_AWAY** | Armed in away mode. `alarm_armed` high. All sensors active. |
| **TRIGGERED** | Alarm is sounding. `alarm_active` high. |

### Inputs

| Signal | Description |
|---|---|
| `clk` | System clock |
| `rst` | Synchronous reset (active-high) — returns to IDLE |
| `arm_home` | Pulse high one cycle: arm in HOME mode (people are home) |
| `arm_away` | Pulse high one cycle: arm in AWAY mode (house is empty) |
| `disarm` | Pulse high one cycle: disarm or silence the alarm |
| `door_sensor` | High when a door is open |
| `window_sensor` | High when a window is open |
| `motion_sensor` | High when motion is detected |

### Outputs

| Signal | Description |
|---|---|
| `alarm_armed` | High when in ARMED_HOME or ARMED_AWAY |
| `alarm_active` | High when in TRIGGERED |
| `home_mode` | High only when in ARMED_HOME |


Key rule: **motion sensor only triggers the alarm in AWAY mode**, not HOME mode.

