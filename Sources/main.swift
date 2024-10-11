// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Vapor
import OpenAPIRuntime
import OpenAPIVapor

enum FortuneOutcome: String, CaseIterable {
    case daikichi = "大吉"
    case chukichi = "中吉"
    case shokichi = "小吉"
    case kyo = "凶"
}

struct GreetingServiceAPIImpl: APIProtocol {
    func getOmikuji(_ input: Operations.getOmikuji.Input) async throws -> Operations.getOmikuji.Output {
        let name = input.query.name
        let fortuneOutcome = FortuneOutcome.allCases.randomElement() ?? .kyo

        let message: String
        switch fortuneOutcome {
        case .daikichi:
            message = "\(name)さん、今日は最高の一日です！素晴らしいことが起こるでしょう。"
        case .chukichi:
            message = "\(name)さん、今日はいい日になりそうです。ちょっとした幸運が訪れるかも！"
        case .shokichi:
            message = "\(name)さん、今日は穏やかに過ごしましょう。小さな喜びがあるかもしれません。"
        case .kyo:
            message = "\(name)さん、今日は少し慎重に過ごしましょう。何か困難があるかもしれませんが、頑張ってください！"
        }

        let result = Components.Schemas.OmikujiResult(
            result: fortuneOutcome.rawValue,
            message: message
        )

        return .ok(.init(body: .json(result)))
    }
}

let app = Vapor.Application()

let transport = VaporTransport(routesBuilder: app)

let handler = GreetingServiceAPIImpl()

try handler.registerHandlers(on: transport, serverURL: Servers.server1())

try await app.execute()
