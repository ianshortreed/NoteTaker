//
//  ViewController.swift
//  TableViewTest
//
//  Created by Juan on 2021/08/12.
//


import UIKit


public var currentindexpath: IndexPath!
public var currentnote: String!
public var currentimage: UIImage!
public var thenote: String!
public var attributedString = NSMutableAttributedString()
public var selectedImage: UIImage!

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var theimage: UIImage!
   
   
    @IBOutlet weak var tableView: UITableView!
  
    // Data model: These strings will be the data for the table view cells
    var note: [String] = ["This is note #0.", "This is note #1.", "This is note #2.", "This is note #3.", "This is note #4.","This is note #5.","This is note #6.","This is note #7.","This is note #8.","This is note #9."]
    
   
   
    // cell reuse id (cells that scroll out of view can be reused)
    let cellReuseIdentifier = "cell"
    
    // don't forget to hook this up from the storyboard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register the table view cell class and its reuse id
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
      

        // This view controller itself will provide the delegate methods and row data for the table view.
        
        tableView.delegate = self
        tableView.dataSource = self
       
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.note.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
        
        // set the text from the data model
        let thenote = self.note[indexPath.row]
       
        
        let font = UIFont.preferredFont(forTextStyle: .headline)
        let textColor = UIColor(red: 0.175, green: 0.458, blue: 0.831, alpha: 1)
        let attributes: [NSAttributedString.Key: Any] = [
          .foregroundColor: textColor, .font: font,]
        let attributedString = NSMutableAttributedString(string: thenote, attributes: attributes)
          
        cell.textLabel?.attributedText = attributedString
        cell.imageView!.tag = indexPath.row
        currentimage = cell.imageView?.image
        
        return cell
    }
    
 
    
    // this method handles row deletion
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

           if editingStyle == .delete {

               // remove the item from the data model
               note.remove(at: indexPath.row)

               // delete the table view row
               tableView.deleteRows(at: [indexPath], with: .fade)

           } else if editingStyle == .insert {
               // Not used in our example, but if you were adding a new row, this is where you would do it.
           }
       }
           
    
   
     
        // This function is called before the segue
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            // get a reference to the second view controller
            let secondViewController = segue.destination as! SecondViewController
            let path = self.tableView.indexPathForSelectedRow
            let cell = self.tableView.cellForRow(at: path!)
            currentnote = cell?.textLabel?.text
            currentimage = cell?.imageView?.image
            // set a variable in the second view controller with the data to pass
            
             secondViewController.noteData = "\(String(describing: currentnote!))"
        }


    // MARK: - UITableView Delegate Methods

   
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 currentindexpath = tableView.indexPathForSelectedRow
 
 thenote = self.note[indexPath.row]
    
 print("Selected row at \(String(describing: currentindexpath!))")
 print("Note#: \(String(describing: thenote!))")


     // Segue to the second view controller
     self.performSegue(withIdentifier: "noteSegue", sender: self)
 }
}
