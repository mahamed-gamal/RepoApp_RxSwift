//
//  RepoDetailsViewController.swift
//  repo_app
//
//  Created by Mohamed Gamal on 1/7/21.
//  Copyright © 2021 Me. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class RepoDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - Properties
    var data: Repo?
    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    let viewModel = RepoDetailsViewModel()
    var contributers: [Contributer] = []
    //MARK: - Outlets
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoDescription: UILabel!
    @IBOutlet weak var numberOfContributerLbl: UILabel!
    @IBOutlet weak var contributersTableView: UITableView!
    @IBOutlet weak var numberOfWatchers: UILabel!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        registerCell()
        setupPopularTableView()
        if let url = data?.countributerUrl {
            viewModel.getContributers(url: url)
        }
        
    }
    
    private func setupUI() {
        title = "Repo Details"
        contributersTableView.layer.cornerRadius = 10
        repoName.text = data?.name
        repoDescription.text = data?.description
        if let forks = data?.forksCount, let watchers = data?.watchers {
            numberOfContributerLbl.text = "forks: \(String(describing: forks))"
            numberOfWatchers.text = "watchers: \(String(describing: watchers))"
        }
        
    }
    
    private func registerCell() {
        contributersTableView.registerCellNib(cellClass: ContributerCell.self)
    }
    
    private func setupPopularTableView() {
       contributersTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
       viewModel.Contributers?.asObservable().bind(to: contributersTableView.rx.items(cellIdentifier: String(describing: ContributerCell.self), cellType: ContributerCell.self)){ index, model, cell in
            cell.contributerName.text = model.login
            cell.selectionStyle = .none
        let url = URL(string: model.avatarUrl!)
        cell.contibuterImageView.kf.setImage(with: url)
        }.disposed(by: disposeBag)

    }
    
    func bind(){
        viewModel.Contributers?.subscribe(onNext: { [weak self] (index) in
            self?.contributers.append(contentsOf: index)
        }).disposed(by: disposeBag)
    }

}

//MARK: - ExtensionTableViewDelegate
extension RepoDetailsViewController: UITableViewDelegate{    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

