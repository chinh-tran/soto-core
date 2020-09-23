//===----------------------------------------------------------------------===//
//
// This source file is part of the Soto for AWS open source project
//
// Copyright (c) 2017-2020 the Soto project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Soto project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Logging
import NIO

/// protocol for all AWSShapes that can be paginated.
/// Adds an initialiser that does a copy but inserts a new integer based pagination token
public protocol AWSPaginateToken: AWSShape {
    associatedtype Token
    func usingPaginationToken(_ token: Token) -> Self
}

extension AWSClient {
    /// If an AWS command is returning an arbituary sized array sometimes it adds support for paginating this array
    /// ie it will return the array in blocks of a defined size, each block also includes a token which can be used to access
    /// the next block. This function loads each block and calls a closure with each block as parameter.
    ///
    /// - Parameters:
    ///   - input: Input for request
    ///   - command: Command to be paginated
    ///   - tokenKey: The name of token in the response object to continue pagination
    ///   - onPage: closure called with each block of entries
    public func paginate<Input: AWSPaginateToken, Output: AWSShape>(
        input: Input,
        command: @escaping (Input, EventLoop?, Logger) -> EventLoopFuture<Output>,
        tokenKey: KeyPath<Output, Input.Token?>,
        on eventLoop: EventLoop? = nil,
        logger: Logger = AWSClient.loggingDisabled,
        onPage: @escaping (Output, EventLoop) -> EventLoopFuture<Bool>
    ) -> EventLoopFuture<Void> {
        let eventLoop = eventLoop ?? eventLoopGroup.next()
        let promise = eventLoop.makePromise(of: Void.self)

        func paginatePart(input: Input) {
            let responseFuture = command(input, eventLoop, logger)
                .flatMap { response in
                    return onPage(response, eventLoop)
                        .map { (rt) -> Void in
                            guard rt == true else { return promise.succeed(()) }
                            // get next block token and construct a new input with this token
                            guard let token = response[keyPath: tokenKey] else { return promise.succeed(()) }

                            let input = input.usingPaginationToken(token)
                            paginatePart(input: input)
                        }
                }
            responseFuture.whenFailure { error in
                promise.fail(error)
            }
        }

        paginatePart(input: input)

        return promise.futureResult
    }

    /// If an AWS command is returning an arbituary sized array sometimes it adds support for paginating this array
    /// ie it will return the array in blocks of a defined size, each block also includes a token which can be used to access
    /// the next block. This function loads each block and calls a closure with each block as parameter.
    ///
    /// - Parameters:
    ///   - input: Input for request
    ///   - command: Command to be paginated
    ///   - tokenKey: The name of token in the response object to continue pagination
    ///   - onPage: closure called with each block of entries
    public func paginate<Input: AWSPaginateToken, Output: AWSShape>(
        input: Input,
        command: @escaping (Input, EventLoop?, Logger) -> EventLoopFuture<Output>,
        tokenKey: KeyPath<Output, Input.Token?>,
        moreResultsKey: KeyPath<Output, Bool>,
        on eventLoop: EventLoop? = nil,
        logger: Logger = AWSClient.loggingDisabled,
        onPage: @escaping (Output, EventLoop) -> EventLoopFuture<Bool>
    ) -> EventLoopFuture<Void> {
        let eventLoop = eventLoop ?? eventLoopGroup.next()
        let promise = eventLoop.makePromise(of: Void.self)

        func paginatePart(input: Input) {
            let responseFuture = command(input, eventLoop, logger)
                .flatMap { response in
                    return onPage(response, eventLoop)
                        .map { (rt) -> Void in
                            guard rt == true else { return promise.succeed(()) }
                            // get next block token and construct a new input with this token
                            guard let token = response[keyPath: tokenKey],
                                response[keyPath: moreResultsKey] else { return promise.succeed(()) }

                            let input = input.usingPaginationToken(token)
                            paginatePart(input: input)
                        }
                }
            responseFuture.whenFailure { error in
                promise.fail(error)
            }
        }

        paginatePart(input: input)

        return promise.futureResult
    }

    /// If an AWS command is returning an arbituary sized array sometimes it adds support for paginating this array
    /// ie it will return the array in blocks of a defined size, each block also includes a token which can be used to access
    /// the next block. This function loads each block and calls a closure with each block as parameter.
    ///
    /// - Parameters:
    ///   - input: Input for request
    ///   - command: Command to be paginated
    ///   - tokenKey: The name of token in the response object to continue pagination
    ///   - onPage: closure called with each block of entries
    public func paginate<Input: AWSPaginateToken, Output: AWSShape>(
        input: Input,
        command: @escaping (Input, EventLoop?, Logger) -> EventLoopFuture<Output>,
        tokenKey: KeyPath<Output, Input.Token?>,
        moreResultsKey: KeyPath<Output, Bool?>,
        on eventLoop: EventLoop? = nil,
        logger: Logger = AWSClient.loggingDisabled,
        onPage: @escaping (Output, EventLoop) -> EventLoopFuture<Bool>
    ) -> EventLoopFuture<Void> {
        let eventLoop = eventLoop ?? eventLoopGroup.next()
        let promise = eventLoop.makePromise(of: Void.self)

        func paginatePart(input: Input) {
            let responseFuture = command(input, eventLoop, logger)
                .flatMap { response in
                    return onPage(response, eventLoop)
                        .map { (rt) -> Void in
                            guard rt == true else { return promise.succeed(()) }
                            // get next block token and construct a new input with this token
                            guard let token = response[keyPath: tokenKey],
                                response[keyPath: moreResultsKey] == true else { return promise.succeed(()) }

                            let input = input.usingPaginationToken(token)
                            paginatePart(input: input)
                        }
                }
            responseFuture.whenFailure { error in
                promise.fail(error)
            }
        }

        paginatePart(input: input)

        return promise.futureResult
    }
}