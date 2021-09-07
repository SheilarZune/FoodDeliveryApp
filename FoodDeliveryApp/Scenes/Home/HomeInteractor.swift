//
//  HomeInteractor.swift
//  FoodDeliveryApp
//
//  Created by Macbook Pro on 07/09/2021.
//

import RxSwift
import RxCocoa
import RxSwiftExt

protocol HomeInteractorLogic  {
    var inputs: HomeInteractorInput { get }
    var outputs: HomeInteractorOutput { get }
}

protocol HomeInteractorInput {
    
}

protocol HomeInteractorOutput {
    
}

class HomeInteractor: HomeInteractorLogic, HomeInteractorInput, HomeInteractorOutput {
    
    var inputs: HomeInteractorInput { return self }
    var outputs: HomeInteractorOutput { return self }
    // Input
    
    // Output
    
    var presenter: HomePresenterLogic?
    
    private let bag = DisposeBag()
    
    init() {
       
    }
}

