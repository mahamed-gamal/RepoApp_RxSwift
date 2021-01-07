//
//  RepoViewModel.swift
//  repo_app
//
//  Created by Mohamed Gamal on 1/6/21.
//  Copyright © 2021 Me. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class RepoViewModel{
    //MARK: - public Variables
    
    //MARK: - Outputs
    var repos: BehaviorRelay<[Repo]>? = .init(value: [])
    
    //MARK: - inputs
    func getRepos() {
        Alamofire.request("https://api.github.com/users/romannurik/repos", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).response { (myResponse) in
            do{
                 let myReasult = try JSONDecoder().decode([Repo].self, from: myResponse.data!)
                    self.repos?.accept(myReasult)
            } catch let error {
                print("error is :\(error)")
            }
           
        }
    }
}
