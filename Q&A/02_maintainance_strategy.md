
# Question 2: The project is abandoned. Should I develop a separate package or integrate it directly?

**Your Question:** "this project is not maintained any more. maintainer abandon this project. besides the `https://github.com/passepartoutvpn/openssl-apple` project is also very old and not maintained any more. from now on i have to manage myself. Now my question is what do you suggest me to do. develop a separate package or directly integrate it in xcode."

---

## My Recommendation: Fork and Maintain a Separate Package

Given that you must now manage this code yourself, the best long-term strategy is to **fork the project and maintain it as your own separate Swift Package.**

While my previous advice was based on you being a consumer of the library, your new role as the maintainer makes the separation of code even more critical.

Here’s the reasoning:

### 1. Treat It Like a Sub-Project, Not Just a Folder of Files

By keeping it as a separate package, you enforce a clean boundary between the complex networking code of TunnelKit and your application's primary logic. This separation is crucial for long-term sanity.

- **Reduces Complexity:** Your main application's Xcode project remains clean and focused on what your app does, not on the internal workings of a VPN library.
- **Promotes Modularity:** It prevents you from creating tightly coupled code. Your app will communicate with the TunnelKit fork through a well-defined API, just like any other package. This makes the code easier to reason about, test, and refactor.

### 2. The Critical `openssl-apple` Problem

Your first and most important task as the new maintainer is to **replace the abandoned `openssl-apple` dependency.** An unmaintained cryptography library is a major security risk.

Managing this is far easier within a standalone Swift Package:

- **In `Package.swift`:** You can simply edit the `dependencies` array to point to a modern and maintained crypto library (like [SwiftCrypto](https://github.com/apple/swift-crypto) from Apple, or another up-to-date OpenSSL wrapper).
- **Clear Scope:** You can then work on adapting the TunnelKit code to the new crypto library within the confines of the package, using its own test suite to verify that you haven't broken anything.

If you were to integrate directly, you would have to manually manage this C-library dependency within your main app's build settings, which is significantly more complex and error-prone.

### 3. Long-Term Maintainability

Directly integrating the code is a short-term shortcut that leads to long-term pain. Imagine a year from now:

- **Direct Integration:** The TunnelKit code is mixed in with your app's code. It's unclear which parts were original and which parts you've modified. If you ever want to replace it with a different VPN library, it will be a nightmare to untangle.
- **Separate Package:** The code is in its own repository. You have a clear version history of your changes. If you need to use this functionality in another project, you can easily reuse your forked package. Swapping it out, while still work, is a much cleaner process.

### Recommended Steps

1.  **Fork the Repository:** Create a fork of the `tunnelkit` repository on GitHub (or your Git provider of choice). You can even make it a private repository if you wish.
2.  **Update Your Project's `Package.swift`:** In your main application, change the SPM dependency to point to your new forked Git repository URL.
3.  **Address the `openssl-apple` Dependency:** This is your top priority. Research a replacement and update your forked package's `Package.swift`.
4.  **Fix and Adapt:** Modify the forked package's code to work with the new dependency and fix any other issues you find. You can do this work in a separate clone of the fork, and your main app will pull in the changes just by updating the package.

### Conclusion

Taking on an abandoned project is a significant task. The best way to manage the risk and complexity is to use the same tools that professional developers use: **modularity and clear separation of concerns.**

**Fork the project. Maintain it as a package. Your future self will thank you.**
