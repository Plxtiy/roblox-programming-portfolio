# Interaction System 
### Modular Interaction System supporting animated doors & tool pickups 

Objects are configured using tags and attributes, allowing multiple doors and pickups to use the same server script.

## Features
* Doors that tween to open and close.
* Tool pickups cloned from ServerStorage to player backpack.
* Serverside Checks.
* Separate modules for interactions types.
* Connection Cleanup on interaction removal.

## Installation
Inside studio, create the following and paste the corresponding source code.

src/server/InterationServer.server.luau // ServerScriptService --> InteractionServer (Script)

src/server/modules/DoorHnalder.luau // ServerScriptService --> InteractionHandlers --> DoorHandler (ModuleScript)

src/server/modules/PickupHandler.luau // ServerScriptService --> InteractionHandlers --> PickupHandler (ModuleScript)

src/shared/InteractionConfig.luau // ReplicatedStorage --> InteractionConfig (ModuleScript)

!! Create InteractionHandlers as a **Folder** inside ServerScriptService. !!

### Door Setup

1. Create a Model in Workspace containing an anchored door part and an anchored hinge part.
2. Position the hinge at the edge where the door should rotate.
3. Set the hinge's Transparency to 1 and CanCollide to false.
4. Set the model's PrimaryPart to the hinge.
5. Add the Interactable tag to the model.
6. Add a String attribute named InteractionType with the value Door.
   !! The system creates the ProximityPrompt automatically. !!

### Pickup Setup

1. Create a Folder named InteractionTools in ServerStorage.
2. Place the Tool template inside that folder.
3. Create an anchored Part in Workspace to represent the pickup.
4. Add the Interactable tag to the pickup part.
5. Add these String attributes:
   **Name: InteractionType // Type: String // Value: Pickup**
   **Name: ToolName // Type: String // Value: "Name of tool"**


### Configuration
For configuring the system, edit the Configuration file inside of ReplicatedStorage.

### How It Works
InteractionServer finds tagged objects through CollectionService and selects a handler using the InteractionType attribute.

Before calling the handler, it checks that the object is in Workspace and still tagged, the prompt is enabled, and the player is alive, within range, and outside the cooldown.

DoorHandler stores each door's closed pivot and movement state. It tweens a CFrameValue and applies its changes using Model:PivotTo().

PickupHandler checks the Tool template, marks the pickup as collected, and clones the Tool into the player's Backpack without yielding between the claim check and claim assignment.

### Limitations
* Pickups do not respawn or persist through player deaths or rejoins.
* Line of sight controls prompt visibility; there is no separate server obstruction raycast.
* Tags and interaction attributes should be configured before starting the game. Changing InteractionType during play does not switch an existing handler.
* Doors do not detect players or objects blocking their movement.
