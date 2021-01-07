//
//  RepoViewController.swift
//  repo_app
//
//  Created by Mohamed Gamal on 1/6/21.
//  Copyright © 2021 Me. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepoViewController: UIViewController, UIScrollViewDelegate {
    //MARK: - Outlets
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var repoTableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    //MARK: - Properties
    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    let viewModel = RepoViewModel()
    var repos: [Repo] = []
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        registerCell()
        setupPopularTableView()
        viewModel.getRepos()
        repoSelected()
    }
    
    private func setupUI() {
       title = "My Repos App"
        indicator.isHidden = false
        //indicator.startAnimating()
       navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
       headerImage.layer.cornerRadius = 10
       repoTableView.layer.cornerRadius = 10
    }
    
    private func registerCell() {
        repoTableView.registerCellNib(cellClass: RepoCell.self)
    }
    
    private func setupPopularTableView() {
        repoTableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.repos?.asObservable().bind(to: repoTableView.rx.items(cellIdentifier: String(describing: RepoCell.self), cellType: RepoCell.self)){ index, model, cell in
            cell.repoName.text = model.name
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
     }
     
    func repoSelected(){
        repoTableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
            let repoDetails = self?.repos[indexPath.row]
            let vc = RepoDetailsViewController()
            vc.data = repoDetails
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
    }
    
    func bind(){
        viewModel.repos?.subscribe(onNext: { [weak self] (index) in
            //self?.indicator.stopAnimating()
            self?.indicator.isHidden = true
            self?.repos.append(contentsOf: index)
        }).disposed(by: disposeBag)
    }
}

//MARK: - ExtensionsTableViewDelegate
extension RepoViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
