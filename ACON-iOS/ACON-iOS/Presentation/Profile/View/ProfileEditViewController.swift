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
        addObserver()
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
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
}


// MARK: - @objc functions

private extension ProfileEditViewController {
    
    // NOTE: 스크롤뷰의 contentInset을 조정하여 텍스트필드가 키보드에 가려지지 않도록 함
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            
            var contentInset = profileEditView.scrollView.contentInset
            contentInset.bottom = keyboardHeight
            profileEditView.scrollView.contentInset = contentInset
            profileEditView.scrollView.scrollIndicatorInsets = contentInset
        }
    }
    
    // NOTE: contentInset을 원래 상태로 복원
    @objc func keyboardWillHide(_ notification: Notification) {
        var contentInset = profileEditView.scrollView.contentInset
        contentInset.bottom = 0
        profileEditView.scrollView.contentInset = contentInset
        profileEditView.scrollView.scrollIndicatorInsets = contentInset
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
        
        if textField == profileEditView.nicknameTextField {
            return nicknameTextfieldChange(
                textField,
                shouldChangeCharactersIn: range,
                replacementString: string
            )
        } else if textField == profileEditView.birthDateTextField {
            return birthDateTextFieldChange(
                textField,
                shouldChangeCharactersIn: range,
                replacementString: string
            )
        }
        
        print("❌ Invaild Textfield")
        return false
    }
    
}


// MARK: - TextField별 Delegate Method

private extension ProfileEditViewController {
    
    // MARK: - 닉네임
    // TODO: 한글 음소 수 오류 수정 - 텍스트필드 자체 문제라 어쩔 수 없을지도ㅜㅜ
    func nicknameTextfieldChange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let koreanDeleted = isKoreanChar(textField.text?.last ?? " ") && range.length == 1
        //            let koreanAdded = isKoreanChar(textField.text?.last ?? " ") && range.length == 0
        let finalString: String = koreanDeleted ? textField.text ?? "" : newString
        print("👉org: \(textField.text), range: \(range), string: \(string), newString: \(newString), finalStr: \(finalString)")
        
        // NOTE: 유효성 체크
        let regex = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ._]*$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: newString)
        
        if isValid {
            // NOTE: 유효성 체크 PASS -> 글자 수 체크 (음소)
            let phonemeCount = countPhoneme(text: finalString)
            print("Character count: \(phonemeCount)")
            
            if phonemeCount == 0 {
                profileEditView.setNicknameValidMessage(.nicknameMissing)
                return true
            }
            else if phonemeCount > 16 {
                return false
            }
            else {
                profileEditView.setNicknameValidMessage(.none)
                // TODO: 빙글빙글 로띠 활성화
                // TODO: 서버 요청
                acDebouncer.call { [weak self] in
                    self?.profileEditView.setNicknameValidMessage(.nicknameOK)
                }
                return true
            }
        }
        
        // NOTE: 유효성 검사 FAIL
        else {
            profileEditView.setNicknameValidMessage(.invalidChar)
            return false
        }
    }
    
    
    // MARK: - 생년월일
    
    func birthDateTextFieldChange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        // 백스페이스 처리
        if string.isEmpty,
           currentText.last == "." {
            let newRange = NSRange(location: range.location - 1,
                                   length: range.length + 1)
            let newString = (textField.text as NSString?)?.replacingCharacters(
                in: newRange, with: string) ?? string
            textField.text = newString
            return false
        }
        
        // NOTE: 8자리 제한
        let rawText = (currentText.replacingOccurrences(of: ".", with: "") + string)
        print("rawText: \(rawText)")
        if rawText.count < 8 {
            profileEditView.setBirthdateValidMessage(.invalidDate)
        } else if rawText.count == 8 {
            // NOTE: Validity 체크
            checkDateValidity(dateString: rawText)
        }
        
        return rawText.count > 8 ? false : true
    }
    
}


// MARK: - TextField Helper

private extension ProfileEditViewController {
    
    // MARK: - 닉네임
    
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
    
    
    // MARK: - 생년월일
    
    // NOTE: 생년월일 유효성 검사
    func checkDateValidity(dateString: String) {
        guard dateString.count == 8,
              let year = Int(String(Array(dateString)[0..<4])),
              let month = Int(String(Array(dateString)[4..<6])),
              let day = Int(String(Array(dateString)[6...])),
              let date = makeDate(year: year, month: month, day: day),
              isValidDate(year: year, month: month, day: day),
              isBeforeToday(date: date)
        else {
            profileEditView.setBirthdateValidMessage(.invalidDate)
            return
        }
        profileEditView.setBirthdateValidMessage(.none)
    }
    
    func makeDate(year: Int, month: Int, day: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let calendar = Calendar.current
        return calendar.date(from: dateComponents)
    }
    
    func isValidDate(year: Int, month: Int, day: Int) -> Bool {
        guard let monthEnum = DayOfMonthType(rawValue: month) else { return false }
        return (1...monthEnum.days(in: year)).contains(day)
    }
    
    func isBeforeToday(date: Date) -> Bool {
        let today = Date()
        return date < today
    }
    
}
