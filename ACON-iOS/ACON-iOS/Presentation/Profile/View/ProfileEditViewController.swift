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
    private let localVerificationVM = LocalVerificationViewModel(flowType: .profileEdit)
    
    private let validityTestDebouncer = ACDebouncer(delay: 0.5)
    private let validMsgHideDebouncer = ACDebouncer(delay: 2)
    
    private var keyboardWillShowObserver: NSObjectProtocol?
    private var keyboardWillHideObserver: NSObjectProtocol?
    
    private var isNicknameAvailable: Bool = true
    private var isBirthDateAvailable: Bool = true
    private var isVerifiedAreaAvailable: Bool = true
    
    
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
        bindData()
        bindViewModel()
        bindObservable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        // NOTE: 생일 필드는 옵셔널이기 때문에, 데이터가 텍스트필드에 바인딩된 후 clearButton configure를 해줘야 합니다
        let birthDateTF = profileEditView.birthDateTextField
        birthDateTF.hideClearButton(isHidden: (birthDateTF.text ?? "").isEmpty)
        
        checkSaveAvailability()
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
        
        profileEditView.saveButton.addTarget(
            self,
            action: #selector(tappedSaveButton),
            for: .touchUpInside
        )
    }
    
}


// MARK: - Bindings

private extension ProfileEditViewController {
    
    func bindData() {
        // NOTE: 기본 데이터 바인딩
        guard let userInfo = viewModel.userInfo.value else { return }
        profileEditView.do {
            $0.setProfileImage(userInfo.profileImageURL)
            $0.nicknameTextField.text = userInfo.nickname
            $0.setNicknameLengthLabel(
                countPhoneme(text: userInfo.nickname),
                viewModel.maxNicknameLength
                )
            $0.birthDateTextField.text = userInfo.birthDate
        }
    }
    
    func bindViewModel() {
        viewModel.verifiedAreaListEditing.bind { [weak self] areas in
            guard let self = self,
                  let areas = areas else { return }
            print("new areas: \(areas)")
            
            if areas.isEmpty {
                profileEditView.hideVerifiedAreaAddButton(false)
                isVerifiedAreaAvailable = false
            } else {
                profileEditView.hideVerifiedAreaAddButton(true)
                profileEditView.addVerifiedArea(areas)
                isVerifiedAreaAvailable = true
            }
            
            checkSaveAvailability()
        }
        
        localVerificationVM.localArea.bind { [weak self] area in
            guard let self = self,
                  let area = area else { return }
            
            var newAreas = viewModel.verifiedAreaListEditing.value ?? []
            // TODO: VerifiedArea id 수정
            newAreas.append(VerifiedAreaModel(id: 1, name: area))
            viewModel.verifiedAreaListEditing.value = newAreas
        }
    }
    
    func bindObservable() {
        
        // MARK: - Keyboard
        
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
        
        
        // MARK: - 닉네임 TextField
        
        // NOTE: 글자 수, 중복 확인(서버)
        profileEditView.nicknameTextField.observableText.bind { [weak self] text in
            guard let self = self,
                  let text = text else { return }
            
            // NOTE: 닉네임 필드 값이 변하면 일단 막기 (유효성검사를 0.5초 뒤에 하기 때문에)
            isNicknameAvailable = false
            checkSaveAvailability()
            
            profileEditView.nicknameTextField.hideClearButton(isHidden: text.isEmpty)
            
            // NOTE: 텍스트 변하면 유효성 메시지 숨김, 텍스트필드 UI 변경
            profileEditView.setNicknameValidMessage(.none)
            profileEditView.nicknameTextField.changeBorderColor(toRed: false)
            
            // NOTE: UI 업데이트 - 글자 수 label
            let phonemeCount = countPhoneme(text: text)
            profileEditView.setNicknameLengthLabel(phonemeCount,
                                                   viewModel.maxNicknameLength)
            
            // NOTE: 0.5초 뒤 유효성 검사
            validityTestDebouncer.call { [weak self] in
                guard let self = self else { return }
                checkNicknameValidity()
                checkSaveAvailability()
            }
        }
        
        
        // MARK: - 생년월일 TextField
        
        profileEditView.birthDateTextField.observableText.bind { [weak self] text in
            guard let self = self else { return }
            let bindedText = text ?? ""
            
            profileEditView.birthDateTextField.hideClearButton(isHidden: bindedText.isEmpty)
            
            if bindedText.isEmpty {
                profileEditView.setBirthdateValidMessage(.none)
                profileEditView.birthDateTextField.changeBorderColor(toRed: false)
                isBirthDateAvailable = true
            }
            
            checkSaveAvailability()
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
        // TODO: 수정
        print("profileImageEditButtonTapped")
    }
    
    @objc
    func tappedVerifiedAreaAddButton() {
        localVerificationVM.isLocationChecked.value = nil
        localVerificationVM.onSuccessPostLocalArea.value = nil
        
        let vc = LocalVerificationViewController(viewModel: localVerificationVM)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func deleteVerifiedArea() {
        // TODO: 특정 인덱스만 날리도록 수정 (Sprint3)
        viewModel.verifiedAreaListEditing.value?.removeAll()
        profileEditView.removeVerifiedArea()
    }
    
    @objc
    func tappedSaveButton() {
        guard let nickname: String = profileEditView.nicknameTextField.text,
              let verifiedAreaList = viewModel.verifiedAreaListEditing.value else { return }
        
        viewModel.updateUserInfo(
            newUserInfo: UserInfoEditModel(
                profileImageURL: "newProfileImageURL", // TODO: 수정
                nickname: nickname,
                birthDate: profileEditView.birthDateTextField.text,
                verifiedAreaList: verifiedAreaList
            )
        )
        
        // TODO: 서버 Post
        
        self.navigationController?.popViewController(animated: true)
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
                // NOTE: 16자 미만인 경우 유효성 메시지 2초간 띄움
                profileEditView.setNicknameValidMessage(.invalidChar)
                textField.layer.borderColor = UIColor.red1.cgColor
                validMsgHideDebouncer.call { [weak self] in
                    guard let self = self else { return }
                    self.checkNicknameValidity()
                }
            }
            return false
        }
    }
    
    
    // MARK: - 생년월일
    
    func birthDateTextFieldChange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentString = textField.text else { print("date = nil"); return true }
        let newString = (currentString as NSString).replacingCharacters(in: range, with: string)
        let newRawString = (newString.replacingOccurrences(of: ".", with: ""))
        
        // NOTE: 백스페이스 처리
        if string.isEmpty,
           currentString.last == "." {
            let newRange = NSRange(location: range.location - 1,
                                   length: range.length + 1)
            let newString = (textField.text as NSString?)?.replacingCharacters(
                in: newRange, with: string) ?? string
            textField.text = newString
            return false
        }
        
        // NOTE: 8자리 제한
        // NOTE: 길이 0인 경우 ObservableBinding에서 .none처리
        if newRawString.count < 8 {
            profileEditView.setBirthdateValidMessage(.invalidDate)
            profileEditView.birthDateTextField.changeBorderColor(toRed: true)
            isBirthDateAvailable = false
        } else if newRawString.count == 8 {
            // NOTE: Validity 체크
            checkBirthDateValidity(dateString: newRawString)
        }
        
        return newRawString.count > 8 ? false : true
    }
    
}


// MARK: - Validity Test Helper

private extension ProfileEditViewController {
    
    // MARK: - 저장 가능 여부
    
    func checkSaveAvailability() {
        let canSave: Bool = isNicknameAvailable && isBirthDateAvailable && isVerifiedAreaAvailable
        profileEditView.saveButton.isEnabled = canSave
    }
    
    
    // MARK: - 닉네임
    
    func checkNicknameValidity() {
        let text = profileEditView.nicknameTextField.text ?? ""
        let phonemeCount = countPhoneme(text: text)
        
        // TODO: 빙글빙글 로띠 활성화
        
        // NOTE: 닉네임을 입력해주세요.
        if phonemeCount == 0 {
            profileEditView.setNicknameValidMessage(.nicknameMissing)
            profileEditView.nicknameTextField.changeBorderColor(toRed: true)
            isNicknameAvailable = false
        }
        
        // NOTE: 중복된 닉네임 OR 사용할 수 있는 닉네임
        else {
            // TODO: 서버 요청
            profileEditView.setNicknameValidMessage(.nicknameOK)
            profileEditView.nicknameTextField.changeBorderColor(toRed: false)
            isNicknameAvailable = true
//            profileEditView.setNicknameValidMessage(.nicknameTaken)
        }
    }
    
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
    func checkBirthDateValidity(dateString: String) {
        guard dateString.count == 8,
              let year = Int(String(Array(dateString)[0..<4])),
              let month = Int(String(Array(dateString)[4..<6])),
              let day = Int(String(Array(dateString)[6...])),
              let date = makeDate(year: year, month: month, day: day),
              isValidDate(year: year, month: month, day: day),
              isBeforeToday(date: date)
        else {
            profileEditView.setBirthdateValidMessage(.invalidDate)
            profileEditView.birthDateTextField.changeBorderColor(toRed: true)
            isBirthDateAvailable = false
            return
        }
        profileEditView.setBirthdateValidMessage(.none)
        profileEditView.birthDateTextField.changeBorderColor(toRed: false)
        isBirthDateAvailable = true
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
