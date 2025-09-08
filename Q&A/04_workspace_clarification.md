
# Question 4: Clarification on adding the Swift Package to the Workspace

**Your Question:** "ok, things are not working as we expected. specially step 2. unable to drag project folder under this project."

---

## Revised Instructions: Adding the Package without Drag-and-Drop

My apologies that the drag-and-drop method didn't work as expected. Let's use Xcode's menu, which is a more surefire way to add the package to your workspace.

Please try this alternative for **Step 2** and **Step 3** from the previous guide.

### Step 1: Create the Workspace (Same as before)

If you haven't already, create a new workspace and save it in the project's root directory (`/Users/klouderllc/Downloads/tunnelkit/`). If you have the workspace from the last attempt, just open it and make sure it's empty (or remove any items you added previously by selecting them and pressing the `delete` key).

### Step 2 (Revised): Add the Swift Package via Menu

1.  With the workspace open and selected in Xcode, go to the menu bar and choose **File > Add Files to "YourWorkspaceName"...** (where `YourWorkspaceName` is the name you chose, e.g., `TunnelKitDev`).
2.  A file selection dialog will appear.
3.  Navigate to the root directory: `/Users/klouderllc/Downloads/tunnelkit/`.
4.  **Instead of selecting a specific file, select the top-level `tunnelkit` folder itself.**
5.  Click the **Add** button.

Xcode will inspect the folder, find the `Package.swift` manifest, and add it to your workspace correctly. It will appear as a package dependency.

### Step 3 (Revised): Add the Demo Project via Menu

1.  Now, repeat the process for the demo project.
2.  Go to the menu bar and again choose **File > Add Files to "YourWorkspaceName"...**
3.  The file selection dialog will appear again.
4.  Navigate into the `Demo` folder and select the **`TunnelKit.xcodeproj`** file.
5.  Click the **Add** button.

### The Correct Result

After these steps, the result should be the same as intended before. Your Project Navigator on the left should have two top-level items:

- The `TunnelKit` Swift Package.
- The `TunnelKit` Xcode Project.

From here, you should be able to select the `Demo` scheme and build/run it as described in the previous answer. This method avoids the unreliability of drag-and-drop and should get you unblocked.
