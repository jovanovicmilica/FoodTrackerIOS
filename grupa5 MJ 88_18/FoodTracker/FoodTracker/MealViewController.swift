//
//  MealViewController.swift
//  FoodTracker
//
//  Created by student on 1/19/21.
//
import os.log
import UIKit

class MealViewController: UIViewController,UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    //MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    
    //@IBOutlet weak var mealNameLabel: UILabel!
    
    @IBOutlet weak var PhotoImageViewer: UIImageView!
    
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    
    //MARK: Navigation
    
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = PhotoImageViewer.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
        
        
        
        
    }
    
    
    var meal: Meal?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        nameTextField.delegate = self
        
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            
            PhotoImageViewer.image=meal.photo
        
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
        
    }

    //MARK: Actions
    
    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the keyboard
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //mealNameLabel.text = textField.text
        updateSaveButtonState()
        navigationItem.title = textField.text
        
        
        
    }
    
    
    
    //MARK:UIImagePickerControllerDelegate
    
    func imagePickControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ _picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]){
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //print("Button pressed 👍")
        PhotoImageViewer.image=selectedImage
        dismiss(animated:true,completion: nil)
    }
    
    //MARK: Button Action
    
    
    
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
    
}
