//
//  ViewController.swift
//  To Do List App
//
//  Created by Sebastian Hette on 19.11.2016.
//  Copyright © 2016 MAGNUMIUM. All rights reserved.
//

import UIKit
import CoreData

var titles:[String] = []
var subtitles:[String] = []
var coordinates:[String] = []

var thisItem = 0

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var editOutlet: UIBarButtonItem!
    @IBOutlet weak var myTableView: UITableView!
    
    // Allows reordering of cells: true
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // Moves then inserts items
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = titles[sourceIndexPath.row]
        titles.remove(at: sourceIndexPath.row)
        titles.insert(item, at: destinationIndexPath.row)
    }
    // Action to invoke editing ^2
    @IBAction func editAction(_ sender: Any) {
        myTableView.isEditing = !myTableView.isEditing
        
        switch myTableView.isEditing {
        case true:
            editOutlet.title = "Done"
        case false:
            editOutlet.title = "Edit"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row]
        cell.detailTextLabel?.text = subtitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            thisItem = indexPath.row
            deleteThis()
            getThis()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        thisItem = indexPath.row
        performSegue(withIdentifier: "show", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        getThis()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    //Retrieve Data
    func getThis()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        
        do
        {
            let results = try context.fetch(request)
            
            titles.removeAll()
            subtitles.removeAll()
            coordinates.removeAll()
            
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    //Get title
                    if let myTitle = result.value(forKey: "title") as? String
                    {
                        titles.append(myTitle)
                    }
                    else
                    {
                        titles.append(" ")
                    }
                    
                    //Get subtitle
                    if let mySubtitle = result.value(forKey: "subtitle") as? String
                    {
                        subtitles.append(mySubtitle)
                    }
                    else
                    {
                        subtitles.append(" ")
                    }
                    
                    //Get coordinate
                    if let myCoor = result.value(forKey: "coordinates") as? String
                    {
                        coordinates.append(myCoor)
                    }
                    else
                    {
                        coordinates.append(" ")
                    }
                }
            }
            
            myTableView.reloadData()
        }
        catch
        {
            
        }
    }
    
    //Delete fucntion
    func deleteThis()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDo")
        
        do
        {
            let results = try context.fetch(request)
            
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let myTitle = result.value(forKey: "title") as? String
                    {
                        if myTitle == titles[thisItem]
                        {
                            context.delete(result)
                            
                            do
                            {
                                try context.save()
                            }
                            catch
                            {
                                
                            }
                        }
                    }
                }
            }
        }
        catch
        {
            
        }
    }
}

