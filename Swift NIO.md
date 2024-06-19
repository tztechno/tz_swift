

---
4o

Swift NIOを使用してシンプルなHTTPサーバーを作成し、「Hello, World!」を返す手順を再度整理して説明します。

### 1. プロジェクトの作成

新しいディレクトリを作成し、その中にSwiftパッケージを初期化します。

```bash
mkdir HelloServer
cd HelloServer
swift package init --type executable
```

### 2. `Package.swift`の編集

`Package.swift`ファイルを開いて、`swift-nio`を依存関係に追加します。ファイル全体は以下のようになります。

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "HelloServer",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "HelloServer",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .product(name: "NIOHTTP1", package: "swift-nio")
            ]
        ),
    ]
)
```

### 3. サーバーコードの作成

`Sources/HelloServer/main.swift`ファイルを開いて、以下のコードを追加します。

```swift
import NIO
import NIOHTTP1

final class HTTPHandler: ChannelInboundHandler {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundOut = HTTPServerResponsePart

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let reqPart = self.unwrapInboundIn(data)

        switch reqPart {
        case .head:
            let responseHead = HTTPResponseHead(version: .http1_1, status: .ok)
            context.write(self.wrapOutboundOut(.head(responseHead)), promise: nil)
            
            var buffer = context.channel.allocator.buffer(capacity: 12)
            buffer.writeString("Hello, World!")
            let responseBody = HTTPServerResponsePart.body(.byteBuffer(buffer))
            context.write(self.wrapOutboundOut(responseBody), promise: nil)
            
            let responseEnd = HTTPServerResponsePart.end(nil)
            context.writeAndFlush(self.wrapOutboundOut(responseEnd), promise: nil).whenComplete { _ in
                context.close(promise: nil)
            }
        default:
            break
        }
    }
}

let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
defer {
    try! group.syncShutdownGracefully()
}

let bootstrap = ServerBootstrap(group: group)
    .serverChannelOption(ChannelOptions.backlog, value: 256)
    .serverChannelOption(ChannelOptions.socketOption(.soReuseaddr), value: 1)
    .childChannelInitializer { channel in
        channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
            channel.pipeline.addHandler(HTTPHandler())
        }
    }
    .childChannelOption(ChannelOptions.socketOption(.soReuseaddr), value: 1)
    .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
    .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
    .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

let channel = try! bootstrap.bind(host: "127.0.0.1", port: 8888).wait()
print("Server running on:", channel.localAddress!)

try! channel.closeFuture.wait()
```

### 4. ビルドと実行

プロジェクトをビルドして、サーバーを起動します。

```bash
swift build
.build/debug/HelloServer
```

これで、サーバーがポート8888で実行されます。ブラウザまたはcurlコマンドで`http://localhost:8888`にアクセスすると、「Hello, World!」が表示されるはずです。

```bash
curl http://localhost:8888
```

このコードは基本的なSwift NIOを使用したHTTPサーバーの例です。要求が来るたびに「Hello, World!」を返すシンプルなサーバーです。

---
