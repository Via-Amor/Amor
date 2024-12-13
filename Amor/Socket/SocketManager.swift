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
    
    // 연결에 대해 감지할 콜백 등록
    private func addListener() {
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
    }
    
    // 앱 생명주기에 대한 옵저버 등록
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
    
    // 소켓 연결 생성
    func establishConnection(router: SocketRouter) {
        // 기존 소켓 연결 해제
        socket.disconnect()
        
        // 새로운 소켓 네임스페이스로 연결
        socket = self.manager.socket(forNamespace: router.route)
        
        // 모든 핸들러 제거 후 다시 추가
        socket.removeAllHandlers()
        
        // 연결 시도
        openConnection()
    }
    
    // 소켓 응답
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
    
    // 소켓 연결
    func openConnection() {
        socket.connect()
    }
    
    // 소켓 해제
    func closeConnection() {
        socket.disconnect()
    }
    
}
