//
//  ArtAddViewController.swift
//  TestProject
//
//  Created by 공지원 on 18/02/2019.
//  Copyright © 2019 공지원. All rights reserved.
//

import UIKit

protocol ArtAddViewControllerDelegate: class {
    func uploadArtwork(_ controller: ArtAddViewController, image: UIImage, title: String)
}

class ArtAddViewController: UIViewController {
    
    weak var delegate: ArtAddViewControllerDelegate?
    
    var isReadyUpload: Bool = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        return picker
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "cancel"), for: UIControl.State.normal)
        return button
    }()
    
    let uploadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("업로드", for: UIControl.State.normal)
        button.titleLabel?.tintColor = .white
        return button
    }()
    
     let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        //imageView.backgroundColor = #colorLiteral(red: 0.003921568627, green: 0.3411764706, blue: 1, alpha: 1)
        imageView.isUserInteractionEnabled = true
        //imageView.layer.cornerRadius = 5.0
        return imageView
    }()
    
     let plusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "iconPlusButton"), for: UIControl.State.normal)
        return button
    }()
    
    let orientationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.isHidden = true
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.masksToBounds = false
        return label
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.isHidden = true
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.masksToBounds = false
        return label
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.isHidden = true
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 3.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 4, height: 4)
        label.layer.masksToBounds = false
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.text = "작품 제목을 입력해주세요."
        return label
    }()
    
    public let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "작품 제목"

        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.backgroundColor = .white
        textField.tag = 100
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "작품 설명을 입력해주세요."
        label.textColor = .white
        return label
    }()
    
    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "작품의 설명"
        textField.font = UIFont.boldSystemFont(ofSize: 25)
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.tag = 101
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
        setTapGestureRecognizer()
        
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(uploadButtonDidTap), for: .touchUpInside)
        titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        descriptionTextField.addTarget(self, action: #selector(descTextFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        self.view.frame.origin.y = -keyboardFrame.height // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @objc func titleTextFieldDidChange(_ sender: UITextField) {
        if sender.text?.isEmpty == true {
            inactivateUploadButton()
        } else if descriptionTextField.text?.isEmpty == true {
            inactivateUploadButton()
        } else if imageView.image == nil {
            inactivateUploadButton()
        } else {
            activateUpload()
        }
    }
    
    @objc func descTextFieldDidChange(_ sender: UITextField) {
        if sender.text?.isEmpty == true {
            inactivateUploadButton()
        } else if titleTextField.text?.isEmpty == true {
            inactivateUploadButton()
        } else if imageView.image == nil {
            inactivateUploadButton()
        } else {
            activateUpload()
        }
    }
    
    @objc func cancelButtonDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadButtonDidTap() {
        
        guard let image = imageView.image, let title = titleTextField.text else { return }
        
        dismiss(animated: true) {
            self.delegate?.uploadArtwork(self, image: image, title: title)
        }
    }
    
    func activateUpload() {
        print("업로드가 가능합니다.")
        isReadyUpload = true
        uploadButton.setTitleColor(#colorLiteral(red: 0.003921568627, green: 0.3411764706, blue: 1, alpha: 1), for: .normal)
    }
    
    func inactivateUploadButton() {
        print("업로드가 불가능합니다. 정보를 다 입력해주세요")
        isReadyUpload = false
        uploadButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
    }
    
    func presentImagePicker() {
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        orientationLabel.isHidden = true
        colorLabel.isHidden = true
        temperatureLabel.isHidden = true
    }
    
    private func setTapGestureRecognizer() {
        let imageViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewDidTap))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imageViewTapGesture)
    }
    
    @objc func imageViewDidTap() {
        presentImagePicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if titleTextField.isFirstResponder == true {
            titleTextField.resignFirstResponder()
        } else {
            descriptionTextField.resignFirstResponder()
        }
    }
    
    private func setUpViews() {
        
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(uploadButton)
        scrollView.addSubview(imageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(titleTextField)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(descriptionTextField)
        
        imageView.addSubview(plusButton)
        imageView.addSubview(orientationLabel)
        imageView.addSubview(colorLabel)
        imageView.addSubview(temperatureLabel)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        cancelButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 15).isActive = true
        cancelButton.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        
        uploadButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor).isActive = true
        uploadButton.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        
        imageView.topAnchor.constraint(equalTo: cancelButton.topAnchor, constant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.height * 0.5).isActive = true
        
        plusButton.widthAnchor.constraint(equalToConstant: imageView.frame.width * 0.2).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: imageView.frame.height * 0.2).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        orientationLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -10).isActive = true
        orientationLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -130).isActive = true
        
        colorLabel.bottomAnchor.constraint(equalTo: orientationLabel.bottomAnchor).isActive = true
        colorLabel.leadingAnchor.constraint(equalTo: orientationLabel.trailingAnchor, constant: 10).isActive = true
        
        temperatureLabel.bottomAnchor.constraint(equalTo: colorLabel.bottomAnchor).isActive = true
        temperatureLabel.leadingAnchor.constraint(equalTo: colorLabel.trailingAnchor, constant: 10).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
        
        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        //titleTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20).isActive = true
        
        descriptionLabel.leadingAnchor.constraint(equalTo: titleTextField.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20).isActive = true
        
        descriptionTextField.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor).isActive = true
        descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        descriptionTextField.trailingAnchor.constraint(equalTo: titleTextField.trailingAnchor).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.5)
        scrollView.contentSize.height = self.view.frame.height * 1.5
        
    }
}

extension ArtAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ArtAddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func showImageSortResultLabel() {
        orientationLabel.isHidden = false
        colorLabel.isHidden = false
        temperatureLabel.isHidden = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[.editedImage] as? UIImage
        
        imageView.image = editedImage
        plusButton.isHidden = true
        
        dismiss(animated: true) {
            print(self.imageView.image) //제거
            DispatchQueue.global().async {
                var imageSort = ImageSort(input: editedImage)
                
                guard let r1 = imageSort.orientationSort(), let r2 = imageSort.colorSort(), let r3 = imageSort.temperatureSort() else { return }
                
                let orientation = r1 ? "#가로" : "#세로"
                let color = r2 ? "#컬러" : "#흑백"
                let temperature = r3 ? "#차가움" : "#따뜻함"
                
                DispatchQueue.main.async {
                    self.showImageSortResultLabel()
                    
                    self.orientationLabel.text = orientation
                    self.colorLabel.text = color
                    self.temperatureLabel.text = temperature
                    
                    if self.titleTextField.text?.isEmpty == false && self.descriptionTextField.text?.isEmpty == false {
                        self.uploadButton.setTitleColor(#colorLiteral(red: 0.003921568627, green: 0.3411764706, blue: 1, alpha: 1), for: .normal)
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        showImageSortResultLabel()
        dismiss(animated: true, completion: nil)
    }
}
