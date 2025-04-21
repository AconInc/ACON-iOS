//
//  AlbumTableViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/16/25.
//

import UIKit
import Photos

class AlbumTableViewController: BaseNavViewController {
    
    // MARK: - Properties
    
    let albumViewModel = AlbumViewModel()
    
    private var albumTableView: UITableView = UITableView()

    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        bindViewModel()
        albumViewModel.fetchAlbums()
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        self.contentView.addSubview(albumTableView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        albumTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setCenterTitleLabelStyle(title: "나의 앨범")
        self.setBackButton()
        
        albumTableView.do {
            $0.backgroundColor = .gray900
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.alwaysBounceVertical = true
        }
    }
    
    func setDelegate() {
        albumTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.cellIdentifier)
        }
    }

}

// MARK: - bindViewModel

extension AlbumTableViewController {
    
    func bindViewModel() {
        self.albumViewModel.onAlbumChange.bind { [weak self] onChange in
            guard let onChange = onChange else { return }
            if onChange {
                self?.albumTableView.reloadData()
                self?.albumViewModel.onAlbumChange.value = nil
            }
        }
        
        self.albumViewModel.fetchedAlbumIndex.bind { [weak self] index in
            guard let index = index else { return }
            let indexPath = IndexPath(row: index, section: 0)
            self?.albumTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
}

// MARK: - UITableViewDelegate & DataSource

extension AlbumTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumViewModel.albumInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.cellIdentifier, for: indexPath) as! AlbumTableViewCell
        let albumInfo = albumViewModel.albumInfo[indexPath.row]
        cell.configure(albumInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        albumViewModel.selectedAlbumIndex = indexPath.row
        let vc = PhotoCollectionViewController(albumViewModel)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
