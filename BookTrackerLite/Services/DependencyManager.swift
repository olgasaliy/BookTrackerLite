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
    private let queue = DispatchQueue(label: "com.dependencymanager.queue", attributes: .concurrent)

    private init() {}
    
    func register<Service>(_ service: Service, for type: Service.Type) {
        let key = "\(type)"
        queue.async(flags: .barrier) { [weak self] in
            self?.services[key] = service
        }
    }
    
    func resolve<Service>(_ type: Service.Type) -> Service {
        let key = "\(type)"
        return queue.sync {
            guard let service = services[key] as? Service else {
                fatalError("No registered service for type \(type)")
            }
            return service
        }
    }
}

func resolve<Service>(_ type: Service.Type) -> Service {
    return DependencyManager.shared.resolve(type)
}
