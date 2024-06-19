

---
# hello on swift simple server
2024-06

---
```
 % swift build
warning: could not determine XCTest paths: terminated(1): /usr/bin/xcrun --sdk macosx --show-sdk-platform-path output:
    xcrun: error: unable to lookup item 'PlatformPath' from command line tools installation
    xcrun: error: unable to lookup item 'PlatformPath' in SDK '/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk'
    
warning: 'helloserver': dependency 'swift-nio' is not used by any target
Building for debugging...
/Users/shun_ishii/Projects/pj1/HelloServer/.build/x86_64-apple-macosx/debug/NIO.build/module.modulemap:2:12: error: header '/Users/shun_ishii/Projects/pj1/HelloServer/.build/x86_64-apple-macosx/debug/NIO.build/NIO-Swift.h' not found
    header "/Users/shun_ishii/Projects/pj1/HelloServer/.build/x86_64-apple-macosx/debug/NIO.build/NIO-Swift.h"
           ^
/Users/shun_ishii/Projects/pj1/HelloServer/Sources/main.swift:2:8: error: could not build Objective-C module 'NIO'
import NIO
       ^
```
---
