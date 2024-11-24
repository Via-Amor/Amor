//
//  BaseViewModel.swift
//  Amor
//
//  Created by 김상규 on 10/28/24.
//

import Foundation

protocol BaseViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
