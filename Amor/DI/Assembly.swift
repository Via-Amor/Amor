//
//  Assembly.swift
//  Amor
//
//  Created by 김상규 on 11/23/24.
//

import Foundation
import Swinject

final class DataAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ChannelRepository.self) { _ in
            return DefaultChannelRepository()
        }.inObjectScope(.container)
        
        container.register(SpaceRepository.self) { _ in
            return DefaultSpaceRepository()
        }.inObjectScope(.container)
        
        container.register(DMRepository.self) { _ in
            return DefaultDMRepository()
        }.inObjectScope(.container)
    }
}

final class DomainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeUseCase.self) { resolver in
            return DefaultHomeUseCase(channelRepository: resolver.resolve(ChannelRepository.self)!, spaceRepository: resolver.resolve(SpaceRepository.self)!, dmRepository: resolver.resolve(DMRepository.self)!)
        }.inObjectScope(.container)
    }
}

final class PresentAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewModel.self) { resolver in
            return HomeViewModel(useCase: resolver.resolve(HomeUseCase.self)!)
        }.inObjectScope(.container)
        
        container.register(HomeViewController.self) { resolver in
            return HomeViewController(viewModel: resolver.resolve(HomeViewModel.self)!)
        }.inObjectScope(.container)
    }
}
