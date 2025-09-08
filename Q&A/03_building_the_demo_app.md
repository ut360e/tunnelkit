
# Question 3: How do I resolve the 'Missing package product' error and build the Demo app?

**Your Question:** "i have open the file Demo/TunnelKit.xcodeproj using xcode and now i am facing error like `/Users/klouderllc/Downloads/tunnelkit/Demo/TunnelKit.xcodeproj Missing package product 'TunnelKitOpenVPN'`, `/Users/klouderllc/Downloads/tunnelkit/Demo/TunnelKit.xcodeproj Missing package product 'TunnelKitOpenVPNAppExtension'` ...... what do you think. how i should build the library then include on demo app. what should be my approach."

---

## The Problem: Lost Connection Between Project and Package

The `Demo/TunnelKit.xcodeproj` is a standalone Xcode project that is configured to use the `TunnelKit` Swift Package from its parent directory. When you open the `.xcodeproj` file directly, Xcode only sees the project and fails to automatically resolve and build the local Swift Package it depends on. This causes the "Missing package product" linker errors.

## The Solution: Use an Xcode Workspace

The correct approach is to create an Xcode Workspace (`.xcworkspace`). A workspace can contain multiple projects and packages, and it explicitly tells Xcode how they relate to each other.

Here is the step-by-step guide:

### Step 1: Create the Workspace

1.  Open Xcode.
2.  From the menu bar, choose **File > New > Workspace...**
3.  Name the workspace something like `TunnelKitDev` and, importantly, **save it in the root directory** of the project (`/Users/klouderllc/Downloads/tunnelkit/`).

### Step 2: Add the Swift Package

1.  With your new, empty workspace open, locate the `tunnelkit` root folder in Finder.
2.  **Drag the entire `tunnelkit` folder** from Finder into the Project Navigator (the left-hand sidebar) of your Xcode workspace.
3.  Xcode will recognize the `Package.swift` file and load it as a Swift Package. You will see all the source files and dependencies under a "Swift Package Dependencies" section.

### Step 3: Add the Demo Project

1.  Now, locate the `TunnelKit.xcodeproj` file inside the `Demo` folder in Finder.
2.  **Drag the `TunnelKit.xcodeproj` file** from Finder into the Project Navigator of your workspace, right below the package you just added.

### The Final Result

Your Xcode Project Navigator should now look something like this:

```
▼ TunnelKitDev (Workspace)
  ▼ TunnelKit (Package)
    ► Sources
    ► ...etc
  ▼ TunnelKit (Project)
    ► Demo
    ► Products
    ► ...etc
```

### Step 4: Build and Run

Now, from the scheme selector at the top of the Xcode window, you can select the "Demo" scheme and choose a target simulator or device. When you click **Build** or **Run (▶)**:

- Xcode, understanding the workspace structure, will first build the necessary products from the `TunnelKit` Swift Package.
- Then, it will link those freshly built products to the `Demo` app.
- The "Missing package product" errors will be resolved.

This workspace-based approach is the standard and most reliable method for developing a Swift Package that has an accompanying example or demo application. It correctly separates the library from the app that uses it while ensuring they can be built and tested together.
