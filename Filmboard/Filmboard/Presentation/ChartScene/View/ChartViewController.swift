//
//  ChartViewController.swift
//  Filmboard
//
//  Created by Daehoon Lee on 7/26/24.
//

import RxSwift
import SnapKit
import Then
import UIKit

class ChartViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = ChartViewModel()
    private let disposeBag = DisposeBag()
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .background
        $0.register(ChartTableViewCell.self)
    }
    
    private let navigationAppearance = UINavigationBarAppearance().then {
        $0.backgroundColor = .background
        $0.titleTextAttributes = [.foregroundColor: UIColor.white]
        $0.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationItem()
        configureTableView()
        configureUI()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Helpers
    
    private func configureView() {
        title = "Charts"
        view.backgroundColor = .background
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = navigationAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationAppearance
        
        viewModel.requestData(category: .popular)
    }
    
    private func configureNavigationItem() {
        let categoryMenuItem = [
            UIAction(title: "Popular", image: UIImage(systemName: "flame.fill"), handler: { [weak self] _ in
                self?.onCategoryChanged(.popular)
            }),
            UIAction(title: "Top Rated", image: UIImage(systemName: "star.fill"), handler: { [weak self] _ in
                self?.onCategoryChanged(.topRated)
            }),
            UIAction(title: "Now Playing", image: UIImage(systemName: "theatermasks.fill"), handler: { [weak self] _ in
                self?.onCategoryChanged(.nowPlaying)
            })
        ]
        
        let categoryMenu = UIMenu(children: categoryMenuItem)
        let categoryButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.circle"), menu: categoryMenu)
        
        navigationItem.rightBarButtonItem = categoryButton
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl().then { $0.tintColor = .white }
        tableView.refreshControl = refreshControl
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindData() {
        viewModel.movieListData
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        viewModel.listTitle
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.navigationItem.title = $0
            }
            .disposed(by: disposeBag)
    }
    
    private func onCategoryChanged(_ category: MovieListCategory) {
        guard viewModel.currentCategory != category else { return }
        
        viewModel.requestData(category: category)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    // MARK: - Selectors
    
    @objc private func refreshData() {
        viewModel.refreshData()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDataSource

extension ChartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movieListData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(ChartTableViewCell.self, for: indexPath) else { return UITableViewCell() }
        
        cell.setData(rank: indexPath.row, movie: viewModel.movieListData.value[indexPath.row])
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ChartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath) is ChartTableViewCell else { return }
        
        let id = viewModel.movieListData.value[indexPath.row].id
        navigationController?.pushViewController(DetailViewController(id: id), animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            viewModel.requestMoreData()
        }
    }
}

// MARK: - Preview

#Preview {
    ChartViewController()
}
