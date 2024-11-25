//
//  DependencyManager.swift
//  BookTrackerLite
//
//  Created by Olha Salii on 21.11.2024.
//
import Foundation

class DependencyManager {
    static let shared = DependencyManager()

    private var services: [String: Any] = [:]

    private init() {}

    func register<Service>(_ service: Service, for type: Service.Type) {
        let key = "\(type)"
        services[key] = service
    }

    func resolve<Service>(_ type: Service.Type) -> Service {
        let key = "\(type)"
        guard let service = services[key] as? Service else {
            fatalError("No registered service for type \(type)")
        }
        return service
    }
}

func resolve<Service>(_ type: Service.Type) -> Service {
    return DependencyManager.shared.resolve(type)
}
