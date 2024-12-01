//
//  DIContainer.swift
//  Amor
//
//  Created by 김상규 on 11/23/24.
//

import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    private let assembler: Assembler
    
    private init() {
        assembler = Assembler([
            DataAssembly(),
            PresentAssembly(),
            DomainAssembly()
                ])
    }
    
    func resolve<T>() -> T {
        guard let dependency = assembler.resolver.resolve(T.self) else {
            fatalError("Failed to resolve dependency: \(T.self)")
        }
        return dependency
    }
    
    
    func resolve<T, Arg>(arg: Arg) -> T {
        guard let dependency = assembler.resolver.resolve(T.self, argument: arg) else {
            fatalError("Failed to resolve dependency: \(T.self)")
        }
        return dependency
    }
}
