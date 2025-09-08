
# Question 5: Which specific folders and files should I add to the workspace?

**Your Question:** "please do `ls` on folder `/Users/klouderllc/Downloads/tunnelkit/` and tell me which folders and files to add."

---

## The Two Items to Add to Your Workspace

Based on the file list, you need to add exactly two items to your empty workspace using the **File > Add Files to...** menu. 

Here they are:

### 1. The Swift Package (identified by `Package.swift`)

- **What to Add:** The main Swift Package.
- **How to Add it:**
    1. Go to **File > Add Files to "TunnelKitDev"...**
    2. From the list of files in the `/Users/klouderllc/Downloads/tunnelkit/` directory, select the file named **`Package.swift`**.
    3. Click **Add**.

    *(Xcode will see this file and understand that you want to add the entire Swift Package it defines.)*

### 2. The Demo Xcode Project

- **What to Add:** The Xcode project for the demo application.
- **How to Add it:**
    1. Go to **File > Add Files to "TunnelKitDev"...** again.
    2. In the file dialog, first double-click on the **`Demo/`** folder to enter it.
    3. Select the file named **`TunnelKit.xcodeproj`**.
    4. Click **Add**.

### Final Check

After adding these two items, your Xcode Project Navigator (the sidebar on the left) should have two distinct top-level entries. It will look conceptually like this:

```
▼ TunnelKitDev (Workspace)
  ▼ TunnelKit (The Swift Package you added via Package.swift)
    ► Sources
    ► Package Dependencies
    ► ...etc
  ▼ TunnelKit (The Demo Project you added via TunnelKit.xcodeproj)
    ► Demo
    ► Products
    ► ...etc
```

Adding `Package.swift` tells Xcode to manage the entire library, and adding `TunnelKit.xcodeproj` tells Xcode to manage the demo app that uses the library. The workspace makes them aware of each other.
