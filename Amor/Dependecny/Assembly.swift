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
        container.register(UserRepository.self) { resolver in
            return DefaultUserRepository(resolver.resolve(NetworkType.self)!)
        }.inObjectScope(.container)
        
        container.register(ChannelRepository.self) { resolver in
            return DefaultChannelRepository(resolver.resolve(NetworkType.self)!)
        }.inObjectScope(.container)
        
        container.register(SpaceRepository.self) { resolver in
            return DefaultSpaceRepository(resolver.resolve(NetworkType.self)!)
        }.inObjectScope(.container)
        
        container.register(DMRepository.self) { resolver in
            return DefaultDMRepository(resolver.resolve(NetworkType.self)!)
        }.inObjectScope(.container)
        
        container.register(NetworkType.self) { _ in
            return NetworkManager.shared
        }.inObjectScope(.container)
        
        container.register(ChatRepository.self) { (resolver, chatType: ChatType) in
            switch chatType {
            case .channel:
                return resolver.resolve(ChannelRepository.self)!
            case .dm:
                return resolver.resolve(DMRepository.self)!
            }
        }
        
        container.register(DataBase.self) { (resolver, chatType: ChatType) in
            switch chatType {
            case .channel:
                return resolver.resolve(ChannelChatDatabase.self)!
            case .dm:
                return resolver.resolve(DMChatDataBase.self)!
            }
        }
        
        container.register(ChannelChatDatabase.self) { _ in
            return ChannelChatStorage()
        }.inObjectScope(.container)
        
        container.register(DMChatDataBase.self) { _ in
            return DMChatStorage()
        }.inObjectScope(.container)
        
        container.register(SocketIOManager.self) { _ in
            return SocketIOManager.shared
        }.inObjectScope(.container)
        
    }
}

final class DomainAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ChatUseCase.self) { (resolver, chatType: ChatType) in
            return DefaultChatUseCase(
                chatDataBase: resolver.resolve(DataBase.self, argument: chatType)!,
                chatRepository: resolver.resolve(ChatRepository.self, argument: chatType)!,
                socketIOManager: resolver.resolve(SocketIOManager.self)!
            )
        }
        
        container.register(UserUseCase.self) { resolver in
            return DefaultUserUseCase(
                repository: resolver.resolve(UserRepository.self)!
            )
        }
        
        container.register(DMUseCase.self) { resolver in
            return DefaultDMUseCase(
                dmRepository: resolver.resolve(DMRepository.self)!
            )
        }
        
        container.register(SpaceUseCase.self) { resolver in
            return DefaultSpaceUseCase(
                spaceRepository: resolver.resolve(SpaceRepository.self)!
            )
        }
        
        container.register(ChannelUseCase.self) { resolver in
            return DefaultChannelUseCase(
                channelRepository: resolver.resolve(ChannelRepository.self)!
            )
        }
    }
}

final class PresentAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeViewModel.self) { resolver in
            return HomeViewModel(
                userUseCase: resolver.resolve(UserUseCase.self)!,
                spaceUseCase: resolver.resolve(SpaceUseCase.self)!,
                channelUseCase: resolver.resolve(ChannelUseCase.self)!,
                dmUseCase: resolver.resolve(DMUseCase.self)!
            )
        }
        
        container.register(HomeViewController.self) { resolver in
            return HomeViewController(
                viewModel: resolver.resolve(HomeViewModel.self)!
            )
        }
        
        container.register(ChatViewModel.self) { (resolver, data: ChatType) in
            return ChatViewModel(
                chatType: data,
                useCase: resolver.resolve(ChatUseCase.self, argument: data)!
            )
        }
        
        container.register(ChatViewController.self) { (resolver, data: ChatViewModel) in
            return ChatViewController(
                viewModel: resolver.resolve(ChatViewModel.self, argument: data)!
            )
        }
        
        container.register(AddChannelViewModel.self) { resolver in
            return AddChannelViewModel(
                useCase: resolver.resolve(ChannelUseCase.self)!
            )
        }
        
        container.register(AddChannelViewController.self) { resolver in
            return AddChannelViewController(
                viewModel: resolver.resolve(AddChannelViewModel.self)!
            )
        }
        
        container.register(EditChannelViewModel.self) { (resolver, editChannel: EditChannel) in
            return EditChannelViewModel(
                editChannel: editChannel,
                useCase: resolver.resolve(ChannelUseCase.self)!
            )
        }
        
        container.register(EditChannelViewController.self) { (resolver, editChannel: EditChannel) in
            return EditChannelViewController(
                viewModel: resolver.resolve(EditChannelViewModel.self, argument: editChannel)!
            )
        }
        
        container.register(SideSpaceMenuViewModel.self) { resolver in
            return SideSpaceMenuViewModel(
                useCase: resolver.resolve(SpaceUseCase.self)!
            )
        }
        
        container.register(SideSpaceMenuViewController.self) { resolver in
            return SideSpaceMenuViewController(
                viewModel: resolver.resolve(SideSpaceMenuViewModel.self)!)
        }
        
        container.register(SpaceActiveViewModel.self) { (resolver, data: SpaceActiveViewType) in
            return SpaceActiveViewModel(
                viewType: data, useCase: resolver.resolve(SpaceUseCase.self)!
            )
        }
        
        container.register(SpaceActiveViewController.self) { (resolver, data: SpaceActiveViewType) in
            return SpaceActiveViewController(
                viewModel: resolver.resolve(SpaceActiveViewModel.self, argument: data)!
            )
        }
        
        container.register(DMListViewModel.self) { resolver in
            return DMListViewModel(userUseCase: resolver.resolve(UserUseCase.self)!, spaceUseCase: resolver.resolve(SpaceUseCase.self)!, dmUseCase: resolver.resolve(DMUseCase.self)!
            )
        }
        
        container.register(DMListViewController.self) { resolver in
            return DMListViewController(
                viewModel: resolver.resolve(DMListViewModel.self)!
            )
        }

        container.register(ChannelSettingViewModel.self) { (resolver, channel: Channel) in
            return ChannelSettingViewModel(
                channelUseCase: resolver.resolve(ChannelUseCase.self)!,
                chatUseCase: resolver.resolve(ChatUseCase.self, argument: ChatType.channel(channel))!,
                channel: channel
            )
        }
        
        container.register(ChannelSettingViewController.self) { (resolver, channel: Channel) in
            return ChannelSettingViewController(
                viewModel: resolver.resolve(ChannelSettingViewModel.self, argument: channel)!
            )
        }
        
        container.register(ChangeSpaceOwnerViewModel.self) { resolver in
            return ChangeSpaceOwnerViewModel(
                useCase: resolver.resolve(SpaceUseCase.self)!
            )
        }
        
        container.register(ChangeSpaceOwnerViewController.self) { resolver in
            return ChangeSpaceOwnerViewController(
                viewModel: resolver.resolve(ChangeSpaceOwnerViewModel.self)!
            )
        }
    }
}
