//
//  MockChat.swift
//  Amor
//
//  Created by 홍정민 on 11/23/24.
//

import Foundation

struct MockChat {
    let content: String
    let files: [String]
    let user: MockUser
}

struct MockUser {
    let nickname: String
    let profileImage: String
}

let chatList = [
    MockChat(
        content: "",
        files: ["https://picsum.photos/200/300"
                ],
        user: MockUser(nickname: "홍루피", profileImage: "https://picsum.photos/200/300")
    ),
    MockChat(
        content: "ㅋㅋ",
        files: [],
        user: MockUser(nickname: "홍루피", profileImage: "https://picsum.photos/200/300")
    ),
    MockChat(
        content: "안녕하세요? 저는 Test를 하는 홍루피인데요. 만나서 반갑고...예 졸리네용",
        files: ["https://picsum.photos/200/300"
                ],
        user: MockUser(nickname: "홍루피", profileImage: "https://picsum.photos/200/300")
    ),
    MockChat(
        content: "안녕하세요? 저는 Test를 하는 홍로로인데요.\n너무 졸리네용",
        files: ["https://picsum.photos/200/300",
                "https://picsum.photos/200/300"
                ],
        user: MockUser(nickname: "홍로로", profileImage: "https://picsum.photos/200/300")
    ),
    MockChat(
        content: "안녕하세요?! 저는 홍롱입니다",
        files: ["https://picsum.photos/200/300",
                "https://picsum.photos/200/300",
                "https://picsum.photos/200/300"
                ],
        user: MockUser(nickname: "홍롱", profileImage: "https://picsum.photos/200/300")
    ),
    MockChat(
        content: "안녕하세요? 저는 Test를 하는 황금두더지라고 합니다. 만나서 반갑고...반갑고 반갑습니다",
        files: ["https://picsum.photos/200/300",
                "https://picsum.photos/200/300",
                "https://picsum.photos/200/300",
                "https://picsum.photos/200/300",
                ],
        user: MockUser(nickname: "황금두더지", profileImage: "https://picsum.photos/200/300")
    ),
    MockChat(
        content: "안녕하세요? 저는 Test를 하는 홍곰인데용. 만나서 반갑고...예 졸리네용",
        files: ["https://picsum.photos/200/300",
                "https://picsum.photos/200/300",
                "https://picsum.photos/200/300",
                "https://picsum.photos/200/300",
                "https://picsum.photos/200/300"
                ],
        user: MockUser(nickname: "홍곰", profileImage: "https://picsum.photos/200/300")
    )
]
