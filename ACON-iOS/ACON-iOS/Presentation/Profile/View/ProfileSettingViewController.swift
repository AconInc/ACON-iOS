//
//  ProfileSettingViewController.swift
//  ACON-iOS
//
//  Created by 이수민 on 2/13/25.
//

import UIKit

final class ProfileSettingViewController: BaseNavViewController {

    // MARK: - UI Properties

    private let settingTableView: UITableView = UITableView(frame: .zero, style: .grouped)


    // MARK: - Properties

    private let settingViewModel: SettingViewModel = SettingViewModel()


    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        setDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = true
    }

    override func setHierarchy() {
        super.setHierarchy()

        self.contentView.addSubview(settingTableView)
    }
    
    override func setLayout() {
        super.setLayout()

        settingTableView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }

    override func setStyle() {
        super.setStyle()

        self.setCenterTitleLabelStyle(title: "설정")
        self.setBackButton()
        
        settingTableView.do {
            $0.backgroundColor = .gray9
            $0.sectionHeaderTopPadding = 0
            $0.separatorInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
            $0.separatorStyle = .none
        }
    }

}


// MARK: - TableView Setting Methods

extension ProfileSettingViewController {

    func registerCell() {
        settingTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.cellIdentifier)
    }

    func setDelegate() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
    }

}

extension ProfileSettingViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return AuthManager.shared.hasToken ? 4 : 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1, 2, 3:
            return 2
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // 빈 footer로 마지막 셀 아래 여백 추가
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        /// 커스텀 레이블 사용
        headerView.textLabel?.isHidden = true
        
        let titleLabel = UILabel()
        headerView.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        titleLabel.setLabel(text: SettingType.sectionTitles[section],
                           style: .s2,
                           color: .gray5)
        return headerView
    }

}

extension ProfileSettingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.cellIdentifier, for: indexPath) as? SettingTableViewCell
        else { return UITableViewCell() }

        let cellModel: SettingCellModel

        switch indexPath.section {
        case 0:
            let items = SettingType.allSections[0] as! [SettingType.Info]
            cellModel = items[indexPath.row].cellModel
            cell.bindVersionData()
        case 1:
            let items = SettingType.allSections[1] as! [SettingType.Policy]
            cellModel = items[indexPath.row].cellModel
        case 2:
            let items = SettingType.allSections[2] as! [SettingType.PersonalSetting]
            cellModel = items[indexPath.row].cellModel
        case 3:
            let items = SettingType.allSections[3] as! [SettingType.Account]
            cellModel = items[indexPath.row].cellModel
        default:
            return cell
        }

        cell.configure(with: cellModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let items = SettingType.allSections[0] as! [SettingType.Info]
            switch items[indexPath.row] {
            case .version:
                Task {
                    let isLatestVersion = await AppVersionManager.shared.checkExactVersion()
                    if !isLatestVersion {
                        AppVersionManager.shared.openAppStore()
                    }
                }
            }
        case 1:
            let items = SettingType.allSections[1] as! [SettingType.Policy]
            switch items[indexPath.row] {
            case .termsOfUse:
                let termsOfUseVC = DRWebViewController(urlString: StringLiterals.WebView.termsOfUseLink)
                self.present(termsOfUseVC, animated: true)
            case .privacyPolicy:
                let privacyPolicyVC = DRWebViewController(urlString: StringLiterals.WebView.privacyPolicyLink)
                self.present(privacyPolicyVC, animated: true)
            }
        case 2:
            let items = SettingType.allSections[2] as! [SettingType.PersonalSetting]
            switch items[indexPath.row] {
            case .onboarding:
                if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                    sceneDelegate.window?.rootViewController = OnboardingViewController()
                    // TODO: - 어떤 경로인지 알려주는 플래그 필요
                    AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.onboarding, properties: ["retry_onboarding?": true])
                }
            case .localVerification:
                let vc = VerifiedAreasEditViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 3:
            let items = SettingType.allSections[3] as! [SettingType.Account]
            switch items[indexPath.row] {
            case .logout:
                let alertHandler = AlertHandler()
                alertHandler.showLogoutAlert(from: self) { [weak self] in
                    AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.serviceLogout, properties: ["click_logout?": true])
                    self?.settingViewModel.logout()
                }
                return
            case .withdrawal:
                AmplitudeManager.shared.trackEventWithProperties(AmplitudeLiterals.EventName.serviceWithdraw, properties: ["click_exit_service?": true])
                let vc = WithdrawalViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default:
            return
        }
    }

}
