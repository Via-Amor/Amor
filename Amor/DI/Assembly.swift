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
        
        container.register(ChannelDatabase.self) { _ in
            return ChannelChatStorage()
        }.inObjectScope(.container)
        
        container.register(SocketIOManager.self) { _ in
            return SocketIOManager.shared
        }.inObjectScope(.container)
        
    }
}

final class DomainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeUseCase.self) { resolver in
            return DefaultHomeUseCase(
                channelRepository: resolver.resolve(ChannelRepository.self)!,
                spaceRepository: resolver.resolve(SpaceRepository.self)!,
                dmRepository: resolver.resolve(DMRepository.self)!
            )
        }.inObjectScope(.container)
        
        container.register(ChatUseCase.self) { resolver in
            return DefaultChatUseCase(
                channelChatDatabase: resolver.resolve(ChannelDatabase.self)!,
                channelRepository: resolver.resolve(ChannelRepository.self)!, 
                socketIOManager: resolver.resolve(SocketIOManager.self)!
            )
        }
    }
}

final class PresentAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewModel.self) { resolver in
            return HomeViewModel(useCase: resolver.resolve(HomeUseCase.self)!)
        }
        
        container.register(HomeViewController.self) { resolver in
            return HomeViewController(viewModel: resolver.resolve(HomeViewModel.self)!)
        }
        
        container.register(ChatViewModel.self) { resolver, data in
            return ChatViewModel(channel: data, useCase: resolver.resolve(ChatUseCase.self)!)
        }
        
        container.register(ChatViewController.self) { (resolver, data: ChatViewModel) in
            return ChatViewController(viewModel: resolver.resolve(ChatViewModel.self, argument: data)!)
        }
        
        container.register(AddChannelViewModel.self) { resolver in
            return AddChannelViewModel(useCase: resolver.resolve(HomeUseCase.self)!)
        }
        
        container.register(AddChannelViewController.self) { resolver in
            return AddChannelViewController(viewModel: resolver.resolve(AddChannelViewModel.self)!)
        }
        
        container.register(ChannelSettingViewModel.self) { resolver, channelID in
            return ChannelSettingViewModel(
                useCase: resolver.resolve(HomeUseCase.self)!,
                channelID: channelID
            )
        }
        
        container.register(ChannelSettingViewController.self) { (resolver, channelID: String) in
            return ChannelSettingViewController(
                viewModel: resolver.resolve(ChannelSettingViewModel.self, argument: channelID)!
            )
        }
        
    }
}
