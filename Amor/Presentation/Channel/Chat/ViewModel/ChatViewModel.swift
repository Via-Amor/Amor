//
//  ChatViewModel.swift
//  Amor
//
//  Created by 김상규 on 11/24/24.
//

import Foundation

final class ChatViewModel: BaseViewModel {
    let channel: Channel
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(channel: Channel) {
        self.channel = channel
    }
    
    func transform(_ input: Input) -> Output {
        
        return Output()
    }
}
