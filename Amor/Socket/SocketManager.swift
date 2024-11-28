//
//  SocketIOManager.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import SocketIO
import RxSwift
import RxCocoa

final class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private let baseURL = URL(string: apiUrl)!
    
    override init() {
        super.init()
        self.manager = SocketManager(socketURL: baseURL, config: [.compress])
        self.socket = self.manager.defaultSocket
        self.addListener()
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
    
    // 소켓 연결 생성
    func establishConnection(router: ChannelRouter) {
        socket = self.manager.socket(forNamespace: router.route)
        socket.removeAllHandlers()
        socket.connect()
    }
    
    // 소켓 응답
    func receive() -> Observable<ChatResponseDTO> {
        let receiver = PublishRelay<ChatResponseDTO>()
        socket.on("channel") { dataArray, ack in
            print("CHANNEL RECEIVED", dataArray, ack)
            do {
                let data = dataArray[0] as! NSDictionary
                let jsonData = try JSONSerialization.data(withJSONObject: data)
                let decodedData = try JSONDecoder().decode(ChatResponseDTO.self, from: jsonData)
                receiver.accept(decodedData)
            } catch {
                print("RESPONSE DECODE FAILED")
            }
        }
        
        return receiver.asObservable()
    }
    
    // 소켓 해제
    func closeConnection() {
        socket.disconnect()
    }
}
