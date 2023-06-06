//
//  ViewController.swift
//  VideoRecorder
//
//  Created by 김성준 on 2023/06/05.
//

import UIKit

final class VideoListView: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Section, Video>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Section, Video>
    
    // MARK: - Properties
    
    private lazy var dataSource: DataSource = configureDataSource()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLayout()
        configureNavigationBar()
        configureTableView()
    }
    

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        let buttonItem: UIBarButtonItem = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "video.badge.plus"), for: .normal)
            button.addTarget(self,
                             action: #selector(presentAddingDiaryPage),
                             for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: button)
            
            return barButton
        }()
        
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc private func presentAddingDiaryPage() {
        
        
        //navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.register(VideoListCell.self, forCellReuseIdentifier: VideoListCell.identifier)
    }
    
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, video in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: VideoListCell.identifier,
                for: indexPath
            ) as? VideoListCell

            return cell
        })
        
        return dataSource
    }
    
    private func applySnapshot() {

        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        //snapshot.appendItems(diaries)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }

}

extension VideoListView: UITableViewDelegate {
    enum Section: String, Hashable {
        case main = "Video List"
    }
    

    
}
