//
//  LoginViewController.swift
//  LoginCritter
//
//  Created by Christopher Goldsby on 3/30/18.
//  Copyright © 2018 Christopher Goldsby. All rights reserved.
//

import UIKit

private let buttonFrame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
private let buttonHeight = textFieldHeight
private let buttonHorizontalMargin = textFieldHorizontalMargin / 2
private let buttonImageDimension: CGFloat = 25
private let buttonVerticalMargin = (buttonHeight - buttonImageDimension) / 2
private let buttonWidth = (textFieldHorizontalMargin / 2) + buttonImageDimension
private let critterViewDimension: CGFloat = 160
private let critterViewFrame = CGRect(x: 0, y: 0, width: critterViewDimension, height: critterViewDimension)
private let critterViewTopMargin: CGFloat = 70
private let textFieldHeight: CGFloat = 37
private let textFieldHorizontalMargin: CGFloat = 16.5
private let textFieldSpacing: CGFloat = 22
private let textFieldTopMargin: CGFloat = 38.8
private let textFieldWidth: CGFloat = 206

@available(iOS 11.0, *)
final class LoginViewController: UIViewController, UITextFieldDelegate {

    private let critterView = CritterView(frame: critterViewFrame)

    private lazy var emailTextField: UITextField = {
        let textField = createTextField(text: "请输入手机号码")
        textField.keyboardType = .numberPad
        textField.returnKeyType = .next
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = createTextField(text: "请输入密码")
        textField.isSecureTextEntry = true
        textField.returnKeyType = .go
        textField.rightView = showHidePasswordButton
        showHidePasswordButton.isHidden = true
        return textField
    }()

    private lazy var showHidePasswordButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageEdgeInsets = UIEdgeInsets(top: buttonVerticalMargin, left: 0, bottom: buttonVerticalMargin, right: buttonHorizontalMargin)
        button.frame = buttonFrame
        button.tintColor = .text
        button.setImage(#imageLiteral(resourceName: "Password-show"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "Password-hide"), for: .selected)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var closeBtn : UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 30, y: 30, width: 50, height: 50)
        button.setImage(UIImage(named: "title_bar_close_2"), for: .normal)
        button.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var titleL : UILabel = {
        let label = UILabel.init()
        label.frame = CGRect(x: (BSTScreenW-100)/2, y: 37.5, width: 100, height: 30)
        label.text = "登录/注册"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    @objc func closeClick(){
        self.dismiss(animated: true, completion: nil)
    }
    
    private let notificationCenter: NotificationCenter = .default

    deinit {
        notificationCenter.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        view.addSubview(closeBtn)
        view.addSubview(titleL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: - UITextFieldDelegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let deadlineTime = DispatchTime.now() + .milliseconds(100)

        if textField == emailTextField {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) { // 🎩✨ Magic to ensure animation starts
                let fractionComplete = self.fractionComplete(for: textField)
                self.critterView.startHeadRotation(startAt: fractionComplete)
                self.passwordDidResignAsFirstResponder()
            }
        }
        else if textField == passwordTextField {
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) { // 🎩✨ Magic to ensure animation starts
                self.critterView.isShy = true
                self.showHidePasswordButton.isHidden = false
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else {
            passwordTextField.resignFirstResponder()
            passwordDidResignAsFirstResponder()
        }
        
        
        if emailTextField.text!.isEmpty {
            YBProgressHUD.showErrorMessage("请输入手机号")
            return true
        }
        
        if passwordTextField.text!.isEmpty {
            YBProgressHUD.showErrorMessage("请输入密码")
            return true
        }
        
        let params = ["user_name":emailTextField.text!,"password":passwordTextField.text!]
        let api:String = "http://api.hesn.io/app/login"
        YBProgressHUD.showActivityMessage(inWindow: "正在登录")
        BSTNetworkManager.postRequestDataWithEncodingParams(params: params, url: api) { (jsonDic) -> (Void) in
            let status = jsonDic["status"] as! [NSString : Any]
            let code = status["err_code"] as! Int
            let message = status["err_msg"] as! String
            YBProgressHUD.hide()
            if code == 0 {
                print("Done Well")
                YBProgressHUD.showSuccessMessage("登录成功")
                self.dismiss(animated: false, completion: nil)
                UserDefaults.standard.set("success", forKey: BSTLoginSuccess)
            }else{
                YBProgressHUD.showErrorMessage(message)
                print(message)
            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            critterView.stopHeadRotation()
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard !critterView.isActiveStartAnimating, textField == emailTextField else { return }

        let fractionComplete = self.fractionComplete(for: textField)
        critterView.updateHeadRotation(to: fractionComplete)

        if let text = textField.text {
            critterView.isEcstatic = text.contains("@")
        }
    }
    // MARK: - Private

    private func setUpView() {
        view.backgroundColor = .dark

        view.addSubview(critterView)
        setUpCritterViewConstraints()

        view.addSubview(emailTextField)
        setUpEmailTextFieldConstraints()

        view.addSubview(passwordTextField)
        setUpPasswordTextFieldConstraints()

        setUpGestures()
        setUpNotification()

        debug_setUpDebugUI()
    }

    @available(iOS 11.0, *)
    private func setUpCritterViewConstraints() {
        critterView.translatesAutoresizingMaskIntoConstraints = false
        critterView.heightAnchor.constraint(equalToConstant: critterViewDimension).isActive = true
        critterView.widthAnchor.constraint(equalTo: critterView.heightAnchor).isActive = true
        critterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        critterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: critterViewTopMargin).isActive = true
    }

    private func setUpEmailTextFieldConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: critterView.bottomAnchor, constant: textFieldTopMargin).isActive = true
    }

    private func setUpPasswordTextFieldConstraints() {
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.heightAnchor.constraint(equalToConstant: textFieldHeight).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: textFieldWidth).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: textFieldSpacing).isActive = true
    }

    private func fractionComplete(for textField: UITextField) -> Float {
        guard let text = textField.text, let font = textField.font else { return 0 }
        let textFieldWidth = textField.bounds.width - (2 * textFieldHorizontalMargin)
        return min(Float(text.size(withAttributes: [NSAttributedString.Key.font : font]).width / textFieldWidth), 1)
    }

    private func stopHeadRotation() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        critterView.stopHeadRotation()
        passwordDidResignAsFirstResponder()
    }

    private func passwordDidResignAsFirstResponder() {
        critterView.isPeeking = false
        critterView.isShy = false
        showHidePasswordButton.isHidden = true
        showHidePasswordButton.isSelected = false
        passwordTextField.isSecureTextEntry = true
    }

    private func createTextField(text: String) -> UITextField {
        let view = UITextField(frame: CGRect(x: 0, y: 0, width: textFieldWidth, height: textFieldHeight))
        view.backgroundColor = BSTThemeCurrentColor
        view.layer.cornerRadius = 4.07
        view.tintColor = .dark
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        view.spellCheckingType = .no
        view.delegate = self
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let frame = CGRect(x: 0, y: 0, width: textFieldHorizontalMargin, height: textFieldHeight)
        view.leftView = UIView(frame: frame)
        view.leftViewMode = .always

        view.rightView = UIView(frame: frame)
        view.rightViewMode = .always

        view.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
        view.textColor = .text

        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.disabledText,
            .font : view.font!
        ]

        view.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)

        return view
    }

    // MARK: - Gestures

    private func setUpGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap() {
        stopHeadRotation()
    }

    // MARK: - Actions

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        let isPasswordVisible = sender.isSelected
        passwordTextField.isSecureTextEntry = !isPasswordVisible
        critterView.isPeeking = isPasswordVisible

        // 🎩✨ Magic to fix cursor position when toggling password visibility
        if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument), let password = passwordTextField.text {
            passwordTextField.replace(textRange, withText: password)
        }
    }

    // MARK: - Notifications

    private func setUpNotification() {
        notificationCenter.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    @objc private func applicationDidEnterBackground() {
        stopHeadRotation()
    }

    // MARK: - Debug Mode

    private let isDebugMode = false

    private lazy var dubug_activeAnimationSlider = UISlider()

    private func debug_setUpDebugUI() {
        guard isDebugMode else { return }

        let animateButton = UIButton(type: .system)
        animateButton.setTitle("Activate", for: .normal)
        animateButton.setTitleColor(.white, for: .normal)
        animateButton.addTarget(self, action: #selector(debug_activeAnimation), for: .touchUpInside)

        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Neutral", for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.addTarget(self, action: #selector(debug_neutralAnimation), for: .touchUpInside)

        let validateButton = UIButton(type: .system)
        validateButton.setTitle("Ecstatic", for: .normal)
        validateButton.setTitleColor(.white, for: .normal)
        validateButton.addTarget(self, action: #selector(debug_ecstaticAnimation), for: .touchUpInside)

        dubug_activeAnimationSlider.tintColor = .light
        dubug_activeAnimationSlider.isEnabled = false
        dubug_activeAnimationSlider.addTarget(self, action: #selector(debug_activeAnimationSliderValueChanged(sender:)), for: .valueChanged)

        let stackView = UIStackView(
            arrangedSubviews:
            [
                animateButton,
                resetButton,
                validateButton,
                dubug_activeAnimationSlider
            ]
        )
        stackView.axis = .vertical
        stackView.spacing = 5
        view.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @objc private func debug_activeAnimation() {
        critterView.startHeadRotation(startAt: dubug_activeAnimationSlider.value)
        dubug_activeAnimationSlider.isEnabled = true
    }

    @objc private func debug_neutralAnimation() {
        stopHeadRotation()
        dubug_activeAnimationSlider.isEnabled = false
    }

    @objc private func debug_ecstaticAnimation() {
        critterView.isEcstatic.toggle()
    }

    @objc private func debug_activeAnimationSliderValueChanged(sender: UISlider) {
        critterView.updateHeadRotation(to: sender.value)
    }
}
