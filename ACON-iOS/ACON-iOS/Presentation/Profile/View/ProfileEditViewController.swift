//
//  ProfileEditViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

class ProfileEditViewController: BaseNavViewController {
    
    // MARK: - Properties
    
    private let profileEditView = ProfileEditView()
    
    private let viewModel: ProfileViewModel
    
    private let acDebouncer = ACDebouncer(delay: 0.5)
    
    
    // MARK: - Life Cycle
    
    init(_ viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func setHierarchy() {
        super.setHierarchy()
        
        contentView.addSubview(profileEditView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        profileEditView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        super.setStyle()
        
        self.setCenterTitleLabelStyle(title: StringLiterals.Profile.profileEditPageTitle)
        self.setBackButton()
        
        // TODO: 인증동네 버튼 로직 연결
        profileEditView.setVerifiedAreaValidMessage(.none)
    }
    
    private func setDelegate() {
        profileEditView.nicknameTextField.delegate = self
        profileEditView.birthDateTextField.delegate = self
    }
    
}


// MARK: - bindViewModel

private extension ProfileEditViewController {
    
    func bindViewModel() {
        profileEditView.setProfileImage(viewModel.userInfo.profileImageURL)
        
        // TODO: 요소 추가
    }
    
}


// MARK: - TextFieldDelegate

extension ProfileEditViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // MARK: - 닉네임 텍스트필드
        
        if textField == profileEditView.nicknameTextField {
            // 기존 텍스트와 새로운 문자열을 결합하여 최종 문자열을 만든다.
            let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
            let koreanDeleted = isKoreanChar(textField.text?.last ?? " ") && range.length == 1
            let koreanAdded = isKoreanChar(textField.text?.last ?? " ") && range.length == 0
            
            let finalString: String = koreanDeleted ? textField.text ?? "" : newString
            
            print("👉org: \(textField.text), range: \(range), string: \(string), newString: \(newString), finalStr: \(finalString)")
            
            // NOTE: 유효성 체크
            let regex = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ._]*$"
            let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: newString)
            
            if isValid {
                // NOTE: 글자 수 체크
                let phonemeCount = countPhoneme(text: finalString)
                print("Character count: \(phonemeCount)")
                
                if phonemeCount == 0 {
                    profileEditView.setNicknameValidMessage(.nicknameMissing)
                } else if phonemeCount > 16 {
                    return false
                } else {
                    profileEditView.setNicknameValidMessage(.none)
                    // TODO: 빙글빙글 로띠 활성화
                    // TODO: 서버 요청
                    acDebouncer.call { [weak self] in
                        self?.profileEditView.setNicknameValidMessage(.nicknameOK)
                    }
                }
                
            } else {
                profileEditView.setNicknameValidMessage(.invalidChar)
            }
            return true
        
        
        // MARK: - 생년월일 텍스트필드
            
        } else if textField == profileEditView.birthDateTextField {
            
            // TODO: 판별 로직 추가
            profileEditView.setBirthdateValidMessage(.invalidDate)
            
            return true
        }
        
        print("❌ Invaild Textfield")
        return false
    }
    
}


// MARK: - TextField Delegate Helper

private extension ProfileEditViewController {
    
    // NOTE: 한글인지 확인하는 함수
    func isKorean(_ char: Character) -> Bool {
        return String(char).range(of: "[가-힣ㄱ-ㅎㅏ-ㅣ]", options: .regularExpression) != nil
    }
    
    func isKoreanChar(_ char: Character) -> Bool {
        return String(char).range(of: "[가-힣]", options: .regularExpression) != nil
    }
    
    // NOTE: 음소의 개수를 구하는 함수
    func getKoreanPhonemeCount(_ char: Character) -> Int {
        let syllable = String(char)
        guard let unicodeScalar = syllable.unicodeScalars.first else { return 1 }
        
        // 한글의 유니코드 범위 계산
        let base: UInt32 = 0xAC00
        let finalConsonantCount: UInt32 = 28
        
        let syllableValue = unicodeScalar.value - base
        
        let finalConsonantIndex = syllableValue % finalConsonantCount
        if finalConsonantIndex == 0 {
            return 2  // 종성이 없는 경우 자음+모음만
        } else {
            return 3  // 종성이 있는 경우 자음+모음+종성
        }
    }
    
    func countPhoneme(text: String) -> Int {
        var phonemeCount = 0
        
        for char in text {
            if isKoreanChar(char) {
                phonemeCount += getKoreanPhonemeCount(char)
            } else {
                phonemeCount += 1
            }
        }
        return phonemeCount
    }
    
}
