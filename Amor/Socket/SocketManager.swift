//
//  SocketIOManager.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import UIKit
import SocketIO
import RxSwift
import RxCocoa

final class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private let baseURL = URL(string: apiUrl)!
    private let disposeBag = DisposeBag()
    
    override private init() {
        super.init()
        self.manager = SocketManager(socketURL: baseURL, config: [.compress])
        self.socket = self.manager.defaultSocket
        self.addListener()
        self.addSceneObserver()
    }
    
    private func addListener() {
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
    }
    
    private func addSceneObserver() {
        NotificationCenter.default.rx.notification(
            UIApplication.didEnterBackgroundNotification
        )
        .asDriver(onErrorRecover: { _ in .never() })
        .drive(with: self) { owner, _ in
            owner.closeConnection()
        }
        .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(
            UIApplication.didBecomeActiveNotification
        )
        .asDriver(onErrorRecover: { _ in .never() })
        .drive(with: self) { owner, _ in
            owner.openConnection()
        }
        .disposed(by: disposeBag)
        
    }
    
    func establishConnection(router: SocketRouter) {
        socket.disconnect()
        socket = self.manager.socket(forNamespace: router.route)
        socket.removeAllHandlers()
        openConnection()
    }
    
    func receive(chatType: ChatType) -> Observable<ChatResponseDTO> {
        let receiver = PublishRelay<ChatResponseDTO>()
        let socketType = chatType.event
        
        socket.on(socketType) { dataArray, ack in
            print("SOCKET RECEIVED", dataArray, ack)
            do {
                let data = dataArray[0] as! NSDictionary
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                switch chatType {
                case .channel:
                    let decodedData = try JSONDecoder().decode(
                        ChannelChatResponseDTO.self,
                        from: jsonData
                    ).toDTO()
                    receiver.accept(decodedData)
                case .dm:
                    let decodedData = try JSONDecoder().decode(
                        DMChatResponseDTO.self, from: jsonData
                    ).toDTO()
                    receiver.accept(decodedData)
                }
            } catch {
                print("RESPONSE DECODE FAILED")
            }
        }
        
        return receiver.asObservable()
    }
    
    func openConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
