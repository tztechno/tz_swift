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
            let promise: EventLoopPromise<Void> = context.eventLoop.makePromise()
            context.writeAndFlush(self.wrapOutboundOut(responseEnd), promise: promise)
            
            promise.futureResult.whenComplete { result in
                switch result {
                case .success:
                    context.close(promise: nil)
                case .failure(let error):
                    print("Failed to write response: \(error)")
                    context.close(promise: nil)
                }
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
    .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    .childChannelInitializer { channel in
        channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
            channel.pipeline.addHandler(HTTPHandler())
        }
    }
    .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
    .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 16)
    .childChannelOption(ChannelOptions.recvAllocator, value: AdaptiveRecvByteBufferAllocator())

let channel = try! bootstrap.bind(host: "127.0.0.1", port: 8888).wait()
print("Server running on:", channel.localAddress!)

try! channel.closeFuture.wait()
