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
    
    private var dataSource: DataSource!
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    

    private func addSubviews() {
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

}

extension VideoListView: UITableViewDelegate {
    enum Section: CaseIterable {
        case main
    }
    
    private func configureDataSource() {
        tableView.register(VideoListCell.self, forCellReuseIdentifier: VideoListCell.identifier)
        
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, video in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: VideoListCell.identifier,
                for: indexPath
            ) as? VideoListCell

            return cell
        })
    }
    
    private func applySnapshot() {

        var snapshot = SnapShot()
        snapshot.appendSections([.main])
        //snapshot.appendItems(diaries)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}
