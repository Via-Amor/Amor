//
//  SocketIOManager.swift
//  Amor
//
//  Created by 홍정민 on 11/24/24.
//

import Foundation
import SocketIO

final class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private let baseURL = URL(string: apiUrl)!
    
    override init() {
        super.init()
        self.manager = SocketManager(socketURL: baseURL, config: [.compress])
        self.socket = self.manager.defaultSocket
        
        // 연결에 대해 감지할 콜백 등록
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
        socket.connect()
    }
    
    // 소켓 응답
    func receive() {
        socket.on("channel") { dataArray, ack in
            print("CHANNEL RECEIVED", dataArray, ack)
        }
    }
    
    // 소켓 해제
    func closeConnection() {
        socket.disconnect()
    }
}

