//
//  AddExerciseVC.swift
//  GymApp
//
//  Created by Sam Sobell on 1/11/17.
//  Copyright © 2017 Sam Sobell. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddExerciseVC: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating {
    var workout : Workout?
    var exerciseName = ""
    var items : [String] = []
    var filteredData: [String] = []
    
    var searchController: UISearchController!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        Exercise.getExercises(){ exercises in
            self.items = exercises
            self.filteredData = exercises
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")! as UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? items : items.filter({(dataString: String) -> Bool in
                return dataString.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.exerciseName = filteredData[indexPath.row]
        self.performSegue(withIdentifier: "edit_exercise", sender: self)
    }
    
    @IBAction func cancelAddExercise(_ sender: Any) {
        self.dismiss(animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EditExerciseVC {
            dest.workout = self.workout
            dest.selectedExerciseName = self.exerciseName
            dest.transitionedFromCreate = true
        }
    }
}
