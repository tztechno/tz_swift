


---
# Swift NIOでhello
2024-06

```
Building for debugging...
error: type 'NIOBSDSocket.Option' has no member 'soReuseaddr'
    .serverChannelOption(ChannelOptions.socketOption(.soReuseaddr), value: 1)
                                                     ~^~~~~~~~~~~
error: value of tuple type '()' has no member 'whenComplete'
            context.writeAndFlush(self.wrapOutboundOut(responseEnd), promise: nil).whenComplete { _ in
            ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^~~~~~~~~~~~
zsh: no such file or directory: .build/debug/HelloServer
```
---
# hello on swift simple server
2024-06

```
% swift build
error: could not build Objective-C module 'NIO'
```
---
