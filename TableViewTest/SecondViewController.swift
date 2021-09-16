//
//  SecondViewController.swift
//  TableViewTest
//
//  Created by Juan on 2021/08/12.
//

import Foundation
import UIKit
import MobileCoreServices
import Foundation
import AVFoundation
import NaturalLanguage


var textStorage: NSTextStorage!

var imagePicker = UIImagePickerController()
var fileURL: URL!




class SecondViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
   
    
    // This variable will hold the data being passed from the ViewController to the SecondViwConroller
    var noteData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString ("Insert Image", comment: "Insert Image"), style: .plain, target: self, action: #selector(photoTapped))
        textView.text = "\(noteData)"

        let layoutManager = NSLayoutManager()
        textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        
        //Attributed string created here
      
        
        //let text = textView.text
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),  .foregroundColor: UIColor.label]
        let attributedString = NSMutableAttributedString(string: thenote!, attributes: attrs)
        let attachment = NSTextAttachment()
        attachment.image = currentimage
        
        let photoString = NSMutableAttributedString(attachment: attachment)
        attributedString.append(photoString)
        textView.attributedText = attributedString
       if fileURL != nil {
         let path:String = fileURL.path
         print(path)
            
               do {
                
                // here we read-in the attributed text saved from the imagePickerController function below
                
                 let path:String = fileURL.path
                 let dataRead = try Data(contentsOf: URL(fileURLWithPath: path))
               
                let loadedAttributedString = try NSAttributedString(data: dataRead,
                                                                options: [.documentType:
                                                                             NSAttributedString.DocumentType.rtfd],
                                                                 documentAttributes: nil)
                print("Successfully loaded attributed string with NSAttachment" )
                attributedString.append(loadedAttributedString)
                textView.attributedText = attributedString
                
                self.textView.font = UIFont.systemFont(ofSize: 17)
        
               } catch let error {
                    print("Got an error \(error)")
                }
                
                }

        textStorage = NSTextStorage()
        textStorage.append(attributedString)
      
        view.addSubview(textView)
        
        textView.becomeFirstResponder()
        textView.isScrollEnabled = true
        navigationController?.navigationBar.barStyle = .black
        textView.adjustsFontForContentSizeCategory = true
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        
        let notificationCenter = NotificationCenter.default
             notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
             notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    
       
      }
    
   
 
   
    // this is where we import the image into the SecondViewController textView window
 // The problem here is we want to import only into the curreentNote indexpath rather than all notes
    
    @objc func photoTapped() {
                     
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        imagePicker.allowsEditing = false
         
      
           self.present(imagePicker, animated: true, completion: nil)
          
       }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
            picker.dismiss(animated: true, completion: nil)
        
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                      let imgName = imgUrl.lastPathComponent
                      let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                      let localPath = documentDirectory?.appending(imgName)
                  
                   
                    let photoURL = URL.init(fileURLWithPath: localPath!)
                           
                let alert = UIAlertController(title: "Insert Image", message: "Do you wish to insert the selected image?", preferredStyle: UIAlertController.Style.alert)
               
                let defaultAction = UIAlertAction(title: "Insert Image", style: UIAlertAction.Style.default, handler: { [self]
                    (action:UIAlertAction!) -> Void in
                let attachment = NSTextAttachment()
                attachment.image = pickedImage
                    currentimage = pickedImage
                    print(currentimage! as Any)
                    //let imageview:UIImageView=UIImageView(frame: CGRect(x: 50, y: 50, width: 200, height: 200));
                   
                    //imageview.image = selectedImage
                    //textView.addSubview(imageview)
                    let imageattributedText = NSMutableAttributedString(attachment: attachment)
                    if let selectedRange = textView.selectedTextRange {
                        let cursorPosition = textView.offset(from: textView.beginningOfDocument, to: selectedRange.start)
                        
                        textView.textStorage.insert(imageattributedText, at:cursorPosition)
                        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),  .foregroundColor: UIColor.label]
                      
                       let attrtext = NSMutableAttributedString(string: "\n", attributes: attrs)
                       attrtext.append(imageattributedText)
                        //attrtext.insert(imageattributedText, at: 0)
                        self.textView.font = UIFont.systemFont(ofSize: 17)
                        
                        
                        do {
                            
                           
                            // note that fileURL is a global vaiable so that it can read back the saved rtfd document data created below
                            fileURL = photoURL
                            
                             // convert URL! to String
                            let path:String = fileURL.path
                            
                            // convert global variable attrString to data
                            let data = try attrtext.data(from: NSRange(location: 0, length: attrtext.length),
                                                                 documentAttributes: [.documentType:
                                                                                        NSAttributedString.DocumentType.rtfd])
                           // write data to the local app directory
                            try data.write(to: URL(fileURLWithPath: path))
                            
                            // print the path for debugging reference to make sure it is saved in Xcode Simulator
                            print("File was saved to:\(path)")

                            
                        } catch {
                            print("\(error.localizedDescription)")
                        }
                     
                        
                        
                    }
                   
                   
        })
                    
                    
                    
                    
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                    (action:UIAlertAction!) -> Void in
                    print("Cancel")
                })
             
               
                alert.addAction(cancelAction)
                alert.addAction(defaultAction)
                    
                     present(alert, animated: true, completion: nil)
                    
             
                    
                }
                
    
            
            }

       
        
    }
    
    
// these functions are used for auto-scrolling data in the active window
    
    func updateTextViewSizeForKeyboardHeight(keyboardHeight: CGFloat) {
      textView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardHeight)
    }
     
    @objc func keyboardDidShow(notification: NSNotification) {
      if let rectValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
        let keyboardSize = rectValue.cgRectValue.size
        updateTextViewSizeForKeyboardHeight(keyboardHeight: keyboardSize.height)
      }
    }
    
    @objc func keyboardDidHide(notification: NSNotification) {
      updateTextViewSizeForKeyboardHeight(keyboardHeight: 0)
    }
      
      @objc func adjustForKeyboard(notification: Notification) {
            guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
          
            let keyboardScreenEndFrame = keyboardValue.cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
               
            if notification.name == UIResponder.keyboardWillHideNotification {
                textView.contentInset = .zero
            } else {
                textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
              
            }

            textView.scrollIndicatorInsets = textView.contentInset

            let selectedRange = textView.selectedRange
            textView.scrollRangeToVisible(selectedRange)
          
        }
      
      
  }

   
    
     


     
            
    

         
        
