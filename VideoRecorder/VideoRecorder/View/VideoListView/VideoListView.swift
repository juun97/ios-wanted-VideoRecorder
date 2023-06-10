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
    
    private lazy var dataSource: DataSource = createDataSource()
    
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
        let imageView: UIImageView = {
            let image = UIImage(systemName: "list.triangle")?.withTintColor(.black)
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .black

            return imageView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Video List"
            label.font = .systemFont(ofSize: 24, weight: .heavy)
            
            return label
        }()
        
        let leftBarItem: UIBarButtonItem = {
            let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
            stackView.axis = .horizontal
            stackView.spacing = 4
            let barButton = UIBarButtonItem(customView: stackView)
            
            return barButton
            
        }()

        let rightBarItem: UIBarButtonItem = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "video.badge.plus"), for: .normal)
            button.addTarget(self,
                             action: #selector(presentAddingDiaryPage),
                             for: .touchUpInside)
            let barButton = UIBarButtonItem(customView: button)
            
            return barButton
        }()
        
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    @objc private func presentAddingDiaryPage() {
        
        
        navigationController?.pushViewController(RecordView(), animated: true)
    }
    
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.register(VideoListCell.self, forCellReuseIdentifier: VideoListCell.identifier)
    }
    
    private func createDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, video in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: VideoListCell.identifier,
                for: indexPath
            ) as? VideoListCell

            return cell
        })
        
        return dataSource
    }
    
    private func configureDataSource() {
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

extension VideoListView: UITableViewDelegate {
    enum Section: String {
        case main
    }
    
}
