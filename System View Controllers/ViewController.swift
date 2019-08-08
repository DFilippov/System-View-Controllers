//
//  ViewController.swift
//  System View Controllers
//
//  Created by Ayu Filippova on 06/08/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import MessageUI
import SafariServices
import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var imageView: UIImageView!
    
    // MARK: - UIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(with: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateUI(with: size)
    }
    
    // MARK: - UI Methods
    func updateUI(with size: CGSize) {
        let isVertical = size.width < size.height
        stackView.axis = isVertical ? .vertical : .horizontal
    }
    
    // MARK: - Actions
    @IBAction func shareButtonPressed (_ sender: UIButton) {
        guard let image = imageView.image else { return }
        
        /* ниже в массив applicationActivities ставим nil - система сама догадается (тк в массиве items только один объект - картинка) какие пункты меню показать, которые могут работать с картинкой
        */
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true)
        
    }
    
    @IBAction func safariButtonPressed (_ sender: UIButton) {
        let url = URL(string: "http://apple.com")!
        let safari = SFSafariViewController(url: url)
        present(safari, animated: true)
    }
    
    @IBAction func cameraButtonPressed (_ sender: UIButton) {
        let alert = UIAlertController(title: "Please Choose Image Source", message: nil, preferredStyle: .actionSheet)
       
        let imagePicker = UIImagePickerController()
        /* должен сообщить когда пользователь выберет фото либо нажмет отмену, для этого выбираем свойство .delegate
         далее присваиваем ему экземпляр класса, который бы удовлетворял протоколу UIImagePickerControllerDelegate
         а также протоколу UINavigationControllerDelegate (с последним протоколом ничего не делаем, просто укажем что мы ему удовлетворяем)
         это мы делаем в экстеншенах
         */
        imagePicker.delegate = self
        
        // создадим для alert-сообщения кнопку cancel (для cancel handler не указывается - nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //добавим в alert-сообщение кнопку cancel
        alert.addAction(cancelAction)
        
        // если доступна камера, то создаем cameraAction
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true)
            }
            alert.addAction(cameraAction)
        }
        
        // если есть доступ к фото галерее, то создаем функцию
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true)
            }
            alert.addAction(photoLibraryAction)
        }
        
        alert.popoverPresentationController?.sourceView = sender
        
        present(alert, animated: true)
    }
    
    @IBAction func emailButtonPressed (_ sender: UIButton) {
        // проверяет может ли утройство посылать сообщения
        guard MFMailComposeViewController.canSendMail() else {
            print(#line, #function, "Can't send mail")
            return
        }
        
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        
        mailComposer.setToRecipients(["support@learnSwift.ru"])
        mailComposer.setSubject("Ошибка \(Date())")
        mailComposer.setMessageBody("Помогите с Message Composer'ом", isHTML: false)
        
        present(mailComposer, animated: true)
    }

    @IBAction func messageButtonPressed(_ sender: UIButton) {
        guard MFMessageComposeViewController.canSendText() else {
            print(#line, #function, "Device is not set up to handle messages")
            return
        }
        guard MFMessageComposeViewController.canSendSubject() else {
            print(#line, #function, "Device is not set up to send subjects")
            return
        }
        guard MFMessageComposeViewController.canSendAttachments() else {
            print(#line, #function, "Device is not set up to send attachments")
            return
        }

        let messageComposer = MFMessageComposeViewController()
        messageComposer.messageComposeDelegate = self

        messageComposer.recipients = ["9021906316"]
        messageComposer.body = "Cheers! User!"

        present(messageComposer, animated: true)
    }
    
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    // сюда попадает по делегату когда пользователь выбрал фото и передает нам информацию о фото
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // здесь info[.originalImage]  это тоже самое что UIImagePickerController.InfoKey.originalImage
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        imageView.image = selectedImage
        dismiss(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {}

// MARK: - MFMailComposeViewControllerDelegate
extension ViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
}
// MARK: - MFMessageComposeViewControllerDelegate
extension ViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true)
    }
    
    
}
