//
//  RegistrationViewController.swift
//  InstagramKloneApp
//
//  Created by Dieter Bergmann on 28.11.18.
//  Copyright © 2018 Dieter Bergmann. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegistrationViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var profilImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var haveAnAccountButton: UIButton!
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        addTargetToTextField()
        addTapGestureToImageView()
        
    }
    
    // MARK: - Methoden
    func setupView() {
        profilImageView.layer.cornerRadius = profilImageView.frame.width / 2
        profilImageView.layer.borderColor = UIColor.white.cgColor
        profilImageView.layer.borderWidth = 2
        
        usernameTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!,
                                                                     attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        emailTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        emailTextField.borderStyle = .roundedRect
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!,
                                                                     attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])

        passwordTextField.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!,
                                                                     attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
        
        createAccountButton.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        createAccountButton.layer.cornerRadius = 5
        createAccountButton.isEnabled = false
        
        let attributeText = NSMutableAttributedString(string: "Du hast einen Account", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white])
        attributeText.append(NSMutableAttributedString(string: " " + "Login", attributes : [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.white]))
        haveAnAccountButton.setAttributedTitle(attributeText, for: UIControl.State.normal)
    }
    
    func addTargetToTextField() {
        usernameTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)

    }
    
    @objc func textFieldDidChange() {
        let isText = (usernameTextField.text?.count ?? 0) > 0 && (emailTextField.text?.count ?? 0) > 0 && (passwordTextField.text?.count ?? 0) > 0
        
        if isText {
            createAccountButton.backgroundColor = UIColor(white: 1.0, alpha: 0.8)
            createAccountButton.layer.cornerRadius = 5
            createAccountButton.isEnabled = true
        } else {
            createAccountButton.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
            createAccountButton.layer.cornerRadius = 5
            createAccountButton.isEnabled = false
        }
    }
    
    
    // MARK: - Action
    @IBAction func createButtonTapped(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (data, error) in
            if let err = error {
                print(err.localizedDescription)
                return
            } else {
                print("User mit email: \(data?.user.email ?? "")")
                
                guard let newUser = data?.user else { return }
                let uid = newUser.uid
                
                // Ermittlung Datenbankadresse und hinzufügen des users und der id
                let ref = Database.database().reference().child("users").child(uid)
                print("Datenbankadresse: ", ref)
                
                // Daten hinzufügen über ein Dictionary
                ref.setValue(["username" : self.usernameTextField.text!, "email" : self.emailTextField.text!])
            }
        }

    }
    
    // MARK: - Choose Photo
    func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectProfilPhoto))
        
        profilImageView.addGestureRecognizer(tapGesture)
        profilImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectProfilPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profilImageView.image = editImage
            print("editImage")
        } else if let originalImage = info[.originalImage] as? UIImage {
            profilImageView.image = originalImage
            print("originalImage")
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Navigation
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
