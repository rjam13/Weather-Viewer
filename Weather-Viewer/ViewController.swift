//
//  ViewController.swift
//  Weather-Viewer
//
//  Created by Rey Jairus Marasigan on 9/18/21.
//

import UIKit

class ViewController: UITableViewController {
    var pictures = [String]()
    var appearances = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //replaces title and back button
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let fm = FileManager.default // works with file system
        let path = Bundle.main.resourcePath! //declare resource path for our bundle, essential
        let items = try! fm.contentsOfDirectory(atPath : path) // set the directory from the path, perfectly fine because contentsofdirectory will never fail
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        for item in items {
            if item.hasPrefix("nssl") {
                // this is a picture to load!
                pictures.append(item)
                appearances.append(0);
            }
        }
        
        pictures.sort()
        
        let defaults = UserDefaults.standard
        
        if let savedAppearances = defaults.object(forKey: "appearances") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                appearances.removeAll()
                appearances = try jsonDecoder.decode([Int].self, from: savedAppearances)
            } catch {
                print("Failed to load appearances")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView- asks how many rows should appear
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //IndexPath- shows section number
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        //dequeues existing cell and reuses them
        cell.textLabel?.text = pictures[indexPath.row]
        cell.detailTextLabel?.text = "Shown \(String(appearances[indexPath.row])) times."
        //this is the style and text label
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            // if the code after if let fail this wont run
            vc.selectedPictureNumber = indexPath.row + 1
            vc.totalPictures = pictures.count
            vc.selectedImage = pictures[indexPath.row]
            
            appearances[indexPath.row] += 1
            save()
            tableView.reloadData();
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareTapped() {
        
        let vc = UIActivityViewController(activityItems: ["You should check out Storm Viewer!"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let savedData = try? encoder.encode(appearances) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "appearances")
        } else {
            print("Failed to save appearances")
        }
    }
}



