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
    
    private let validityTestDebouncer = ACDebouncer(delay: 0.5)
    private let validMsgHideDebouncer = ACDebouncer(delay: 2)
    
    private var keyboardWillShowObserver: NSObjectProtocol?
    private var keyboardWillHideObserver: NSObjectProtocol?
    
    
    // MARK: - Life Cycle
    
    init(_ viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        if let keyboardWillShowObserver = keyboardWillShowObserver {
            NotificationCenter.default.removeObserver(keyboardWillShowObserver)
        }
        
        if let keyboardWillHideObserver = keyboardWillHideObserver {
            NotificationCenter.default.removeObserver(keyboardWillHideObserver)
        }
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        addTarget()
        bindViewModel()
        bindObservable()
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
    
    private func addTarget() {
        profileEditView.profileImageEditButton.addTarget(
            self,
            action: #selector(tappedProfileImageEditButton),
            for: .touchUpInside
        )
        
        profileEditView.verifiedAreaAddButton.addTarget(
            self,
            action: #selector(tappedVerifiedAreaAddButton),
            for: .touchUpInside
        )
        
        profileEditView.verifiedAreaBox.addTarget(
            self,
            action: #selector(deleteVerifiedArea),
            for: .touchUpInside
        )
    }
    
}


// MARK: - Bindings

private extension ProfileEditViewController {
    
    func bindViewModel() {
        // NOTE: 기본 데이터 바인딩
        profileEditView.do {
            $0.setProfileImage(viewModel.userInfo.profileImageURL)
            $0.nicknameTextField.text = viewModel.userInfo.nickname
            $0.setNicknameLengthLabel(
                countPhoneme(text: viewModel.userInfo.nickname),
                viewModel.maxNicknameLength
                )
            $0.birthDateTextField.text = viewModel.userInfo.birthDate
        }
        
        viewModel.verifiedAreaEditing.bind { [weak self] area in
            guard let self = self else { return }
            if area == nil {
                profileEditView.hideVerifiedAreaAddButton(false)
            } else {
                profileEditView.hideVerifiedAreaAddButton(true)
                profileEditView.addVerifiedArea(viewModel.verifiedAreaEditing.value ?? "")
            }
        }
    }
    
    func bindObservable() {
        // NOTE: Keyboard
        keyboardWillShowObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillShow(notification)
        }
        
        keyboardWillHideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            self?.keyboardWillHide(notification)
        }
        
        // NOTE: 닉네임 TextField - 글자 수, 중복 확인(서버)
        profileEditView.nicknameTextField.observableText.bind { [weak self] text in
            guard let self = self,
                  let text = text else { return }
            
            // NOTE: 텍스트 변하면 유효성 메시지 숨김
            profileEditView.setNicknameValidMessage(.none)
            
            // NOTE: UI 업데이트 - 글자 수 label
            let phonemeCount = countPhoneme(text: text)
            profileEditView.setNicknameLengthLabel(phonemeCount,
                                                   viewModel.maxNicknameLength)
            
            // NOTE: 0.5초 뒤 유효성 검사
            validityTestDebouncer.call { [weak self] in
                guard let self = self else { return }
                testNicknameValidity()
            }
        }
    }
    
}


// MARK: - @objc functions

private extension ProfileEditViewController {
    
    // NOTE: 스크롤뷰의 contentInset을 조정하여 텍스트필드가 키보드에 가려지지 않도록 함
    @objc
    func keyboardWillShow(_ notification: Notification) {
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
    @objc
    func keyboardWillHide(_ notification: Notification) {
        var contentInset = profileEditView.scrollView.contentInset
        contentInset.bottom = 0
        profileEditView.scrollView.contentInset = contentInset
        profileEditView.scrollView.scrollIndicatorInsets = contentInset
    }
    
    @objc
    func tappedProfileImageEditButton() {
        print("profileImageEditButtonTapped")
    }
    
    @objc
    func tappedVerifiedAreaAddButton() {
        // TODO: 수정
        viewModel.verifiedAreaEditing.value = "바뀐 유림동"
    }
    
    @objc
    func deleteVerifiedArea() {
        viewModel.verifiedAreaEditing.value = nil
        profileEditView.removeVerifiedArea()
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
    
    // MARK: - 닉네임 (입력마스크, 글자 수 넘기면 입력 막기)
    
    func nicknameTextfieldChange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let koreanDeleted = isKoreanChar(textField.text?.last ?? " ") && range.length == 1
        let finalString: String = koreanDeleted ? textField.text ?? "" : newString
        
        // NOTE: 문자 유효성 체크 (입력마스크)
        let regex = "^[a-zA-Z0-9가-힣ㄱ-ㅎㅏ-ㅣ._]*$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: finalString)
        let phonemeCount = countPhoneme(text: finalString)
        
        if isValid {
            // NOTE: PASS -> 글자 수 체크(음소), max 넘으면 입력 X
            return phonemeCount > viewModel.maxNicknameLength ? false : true
        } else {
            // NOTE: FAIL -> 입력 X
            if phonemeCount <= viewModel.maxNicknameLength {
                // NOTE: 16자 미만인 경우 유효성 메시지 n초간 띄움
                profileEditView.setNicknameValidMessage(.invalidChar)
                validMsgHideDebouncer.call { [weak self] in
                    guard let self = self else { return }
                    self.testNicknameValidity()
                }
            }
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
        if rawText.count < 8 {
            profileEditView.setBirthdateValidMessage(.invalidDate)
        } else if rawText.count == 8 {
            // NOTE: Validity 체크
            checkDateValidity(dateString: rawText)
        }
        
        return rawText.count > 8 ? false : true
    }
    
}


// MARK: - Validity Test Helper

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
    
    func testNicknameValidity() {
        let text = profileEditView.nicknameTextField.text ?? ""
        let phonemeCount = countPhoneme(text: text)
        
        // TODO: 빙글빙글 로띠 활성화
        
        // NOTE: 닉네임을 입력해주세요.
        if phonemeCount == 0 {
            profileEditView.setNicknameValidMessage(.nicknameMissing)
        }
        // NOTE: 중복된 닉네임 OR 사용할 수 있는 닉네임
        else {
            // TODO: 서버 요청
            profileEditView.setNicknameValidMessage(.nicknameOK)
//            profileEditView.setNicknameValidMessage(.nicknameTaken)
        }
    }
    
}
