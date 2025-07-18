//
//  ProfileEditViewController.swift
//  ACON-iOS
//
//  Created by 김유림 on 2/8/25.
//

import UIKit

final class ProfileEditViewController: BaseNavViewController {

    // MARK: - Properties

    private let profileEditView = ProfileEditView()

    private let viewModel: ProfileViewModel

    private let validityTestDebouncer = ACDebouncer(delay: 0.5)
    private let validMsgHideDebouncer = ACDebouncer(delay: 2)
    
    private var keyboardWillShowObserver: NSObjectProtocol?
    private var keyboardWillHideObserver: NSObjectProtocol?

    private var isNicknameAvailable: Bool = true {
        didSet {
            // NOTE: 검증이 완료되었으므로 로딩 로띠 종료
            profileEditView.nicknameTextField.endCheckingAnimation()
            checkSaveAvailability()
        }
    }
    private var isBirthDateAvailable: Bool = true {
        didSet {
            checkSaveAvailability()
        }
    }

    private var profileImage: UIImage = .imgProfileBasic
    
    private var didFinishInitialSetup: Bool = false
    private var hasInitialValueChanged: Bool = false
    private var isDefaultImage: Bool = false


    // MARK: - Life Cycles

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

        hideKeyboard()
        setDelegate()
        addTarget()
        bindInitialData()
        observeViewModel()
        observeUserInputs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = true

        // NOTE: 생일 필드는 옵셔널이기 때문에, 데이터가 텍스트필드에 바인딩된 후 clearButton configure를 해줘야 합니다
        let birthDateTF = profileEditView.birthDateTextField
        birthDateTF.hideClearButton(isHidden: (birthDateTF.text ?? "").isEmpty)
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
        self.setButtonStyle(button: leftButton, image: .icLeft)
        self.setButtonAction(button: leftButton, target: self, action: #selector(profileBackButtonTapped))
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

        profileEditView.saveButton.addTarget(
            self,
            action: #selector(tappedSaveButton),
            for: .touchUpInside
        )
    }

}


// MARK: - ProfileIamge

extension ProfileEditViewController {

    func updateProfileImage(_ image: UIImage, _ isDefault: Bool = true) {
        profileImage = image
        isDefaultImage = isDefault
        profileEditView.setProfileImage(profileImage)
        hasInitialValueChanged = true
        checkSaveAvailability()
    }

}


// MARK: - Initial Data

private extension ProfileEditViewController {

    func bindInitialData() {
        profileEditView.do {
            $0.setProfileImageURL(viewModel.userInfo.profileImage)
            $0.nicknameTextField.text = viewModel.userInfo.nickname
            $0.setNicknameLengthLabel(viewModel.userInfo.nickname.count,
                                      viewModel.maxNicknameLength
            )
            $0.birthDateTextField.text = viewModel.userInfo.birthDate
        }
        isDefaultImage = viewModel.userInfo.profileImage == Config.basicProfileImage ? true : false
        print("❤️", isDefaultImage, viewModel.userInfo.profileImage, Config.basicProfileImage)

        DispatchQueue.main.async {
            self.didFinishInitialSetup = true
        }
    }

}


// MARK: - Observing

private extension ProfileEditViewController {

    // MARK: - ViewModel Observing

    func observeViewModel() {
        viewModel.onGetNicknameValiditySuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }

            if onSuccess {
                guard let nickname = profileEditView.nicknameTextField.text else { return }

                guard isNicknameEntered(text: nickname) else { return }

                guard isNicknameCharValid(text: nickname) else { return }
                
                profileEditView.setNicknameValidMessage(.nicknameOK)
                isNicknameAvailable = true

            } else {
                profileEditView.setNicknameValidMessage(viewModel.nicknameValidityMessageType)
                isNicknameAvailable = false
            }
            viewModel.onGetNicknameValiditySuccess.value = nil
        }

        viewModel.onSuccessGetPresignedURL.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }

            if onSuccess, !isDefaultImage {
                if let imageData: Data = profileImage.jpegData(compressionQuality: 0.5) {
                    viewModel.putProfileImageToPresignedURL(imageData: imageData)
                }
                viewModel.onSuccessGetPresignedURL.value = nil
            }
        }

        viewModel.onSuccessPutProfileImageToPresignedURL.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            if onSuccess {
                viewModel.patchProfile()
            }
            viewModel.onSuccessPutProfileImageToPresignedURL.value = nil
        }

        viewModel.onPatchProfileSuccess.bind { [weak self] onSuccess in
            guard let self = self,
                  let onSuccess = onSuccess else { return }
            if onSuccess {
                self.navigationController?.popViewController(animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    ACToastController.show(.profileSaved,
                                           bottomInset: 93,
                                           duration: 1)
                }
            }
            viewModel.onPatchProfileSuccess.value = nil
        }
    }


    // MARK: - User Input Observing

    func observeUserInputs() {
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

        observeNicknameTextField()

        observeBirthdateTextField()
    }

    func observeNicknameTextField() {
        profileEditView.nicknameTextField.observableText.bind { [weak self] text in
            guard let self = self,
                  let text = text,
                  didFinishInitialSetup else { return }

            hasInitialValueChanged = true

            // NOTE: 닉네임 필드 값이 변하면 일단 저장 막고 유효성 메시지 숨김
            isNicknameAvailable = false
            profileEditView.setNicknameValidMessage(.none)
            
            // NOTE: 글자 수 카운터 업데이트
            profileEditView.setNicknameLengthLabel(text.count,
                                                   viewModel.maxNicknameLength)


            // MARK: 글자 수, 문자 확인

            guard isNicknameEntered(text: text) else { return }

            guard text.count < viewModel.maxNicknameLength else {
                profileEditView.nicknameTextField.text?.removeLast()
                return
            }

            guard isNicknameCharValid(text: text) else { return }

            // MARK: 닉네임 중복 확인 (서버 통신)

            profileEditView.nicknameTextField.startCheckingAnimation()

            validityTestDebouncer.call { [weak self] in
                self?.viewModel.getNicknameValidity(nickname: text)
            }
        }
    }

    func observeBirthdateTextField() {
        profileEditView.birthDateTextField.observableText.bind { [weak self] text in
            guard let self = self,
                  didFinishInitialSetup else { return }
            let bindedText = text ?? ""

            hasInitialValueChanged = true

            profileEditView.birthDateTextField.hideClearButton(isHidden: bindedText.isEmpty)

            if bindedText.isEmpty {
                profileEditView.setBirthdateValidMessage(.none)
                isBirthDateAvailable = true
            }
        }
    }

}


// MARK: - @objc functions

private extension ProfileEditViewController {

    @objc
    func profileBackButtonTapped() {
        if !hasInitialValueChanged {
            navigationController?.popViewController(animated: true)
        } else {
            let rightAction = {
                if let navigationController = self.navigationController {
                    navigationController.popViewController(animated: true)
                }
            }
            self.presentACAlert(.changeNotSaved, rightAction: rightAction)
        }
    }
    
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
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.do {
            $0.addAction(UIAlertAction(title: "앨범에서 사진 업로드", style: .default, handler: { _ in
                let vc = AlbumTableViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            if isDefaultImage == false {
                $0.addAction(UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: { _ in
                    self.updateProfileImage(.imgProfileBasic, true)
                }))
            }
            $0.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        }
        present(alertController, animated: true)
    }

    @objc
    func tappedSaveButton() {
        guard let nickname: String = profileEditView.nicknameTextField.text else { return }
        
        let birthDateText = profileEditView.birthDateTextField.text
        viewModel.updateUserInfo(nickname: nickname,
                                 birthDate: birthDateText?.isEmpty ?? true ? nil : birthDateText)

        viewModel.userInfo.profileImage = isDefaultImage ? "" : viewModel.presignedURLInfo.fileName
        if isDefaultImage {
            viewModel.patchProfile()
        } else {
            viewModel.getProfilePresignedURL()
        }
    }

}


// MARK: - TextFieldDelegate

extension ProfileEditViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == profileEditView.nicknameTextField.textField {
            return nicknameTextFieldChange(
                textField,
                shouldChangeCharactersIn: range,
                replacementString: string
            )
        } else if textField == profileEditView.birthDateTextField.textField {
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

    // NOTE: 닉네임
    func nicknameTextFieldChange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // NOTE: 대문자 -> 소문자로 변환
        let regex = "^[A-Z]*$"
        let isCapital = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: string)
        if isCapital {
            let lowerCased = string.lowercased()
            if let text = textField.text,
               let textRange = Range(range, in: text) {
                let updatedText = text.replacingCharacters(in: textRange, with: lowerCased)
                textField.text = updatedText
                profileEditView.nicknameTextField.textField.sendActions(for: .editingChanged)
                return false
            }
        }
        return true
    }

    // NOTE: 생년월일
    func birthDateTextFieldChange(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentString = textField.text else { return true }
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
            isBirthDateAvailable = false
        } else if newRawString.count == 8 {
            // NOTE: Validity 체크
            validateBirthDate(dateString: newRawString)
        }

        return newRawString.count > 8 ? false : true
    }

}


// MARK: - Validity Test Helper

private extension ProfileEditViewController {

    // MARK: - 저장 가능 여부 확인

    func checkSaveAvailability() {
        guard hasInitialValueChanged else {
            profileEditView.saveButton.updateGlassButtonState(state: .disabled)
            return
        }
        let canSave: Bool = isNicknameAvailable && isBirthDateAvailable
        if canSave {
            profileEditView.saveButton.updateGlassButtonState(state: .default)
        } else {
            profileEditView.saveButton.updateGlassButtonState(state: .disabled)
        }
    }


    // MARK: - 닉네임 유효성 검사

    func isNicknameEntered(text: String) -> Bool {
        let isEntered: Bool = text.count > 0
        if !isEntered {
            profileEditView.setNicknameValidMessage(.nicknameMissing)
            profileEditView.nicknameTextField.hideClearButton(isHidden: true)
        }
        return isEntered
    }

    func isNicknameCharValid(text: String) -> Bool {
        let regex = "^[a-z0-9._]*$"
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
        if !isValid { profileEditView.setNicknameValidMessage(.invalidChar) }
        return isValid
    }


    // MARK: - 생년월일 유효성 검사

    func validateBirthDate(dateString: String) {
        guard dateString.count == 8,
              let year = Int(String(Array(dateString)[0..<4])),
              let month = Int(String(Array(dateString)[4..<6])),
              let day = Int(String(Array(dateString)[6...])),
              let date = makeDate(year: year, month: month, day: day),
              isValidDate(year: year, month: month, day: day),
              isBeforeToday(date: date)
        else {
            profileEditView.setBirthdateValidMessage(.invalidDate)
            isBirthDateAvailable = false
            return
        }

        profileEditView.setBirthdateValidMessage(.none)
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
        var calendar = Calendar.current
        if let koreaTimeZone = TimeZone(identifier: "Asia/Seoul") {
            calendar.timeZone = koreaTimeZone
        }
        
        let today = Date()
        let dateOnly = calendar.startOfDay(for: date)
        let todayOnly = calendar.startOfDay(for: today)
        
        return dateOnly < todayOnly
    }

}
