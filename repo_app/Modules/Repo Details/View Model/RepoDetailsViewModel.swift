//
//  RepoDetailsViewModel.swift
//  repo_app
//
//  Created by Mohamed Gamal on 1/7/21.
//  Copyright © 2021 Me. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class RepoDetailsViewModel{
    //MARK: - Outputs
    var Contributers: BehaviorRelay<[Contributer]>? = .init(value: [])
    
    //MARK: - inputs
    func getContributers(url: String) {
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).response { (myResponse) in
            do{
                 let myReasult = try JSONDecoder().decode([Contributer].self, from: myResponse.data!)
                    self.Contributers?.accept(myReasult)
            } catch let error {
                print("error is :\(error)")
            }
           
        }
    }
}
