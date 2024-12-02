//
//  Coordinator.swift
//  Amor
//
//  Created by 홍정민 on 11/13/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
