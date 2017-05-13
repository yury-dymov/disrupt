//
//  TypesTableTableViewController.swift
//  Ersi
//
//  Created by Alexander Sivura on 5/13/17.
//  Copyright © 2017 Unisonio. All rights reserved.
//

import UIKit
import ArcGIS

class TypesTableTableViewController: UITableViewController {

    var types: [AGSBasemapType] = [
        .imagery,
        .imageryWithLabels,
        .streets,
        .topographic,
        .terrainWithLabels,
        .lightGrayCanvas,
        .nationalGeographic,
        .oceans,
        .imageryWithLabelsVector,
        .streetsVector,
        .topographicVector,
        .terrainWithLabelsVector,
        .lightGrayCanvasVector,
        .navigationVector,
        .streetsNightVector,
        .streetsWithReliefVector,
        .darkGrayCanvasVector,
    ];
    
    var typeNames: [String] = [
    "imagery",
    "imageryWithLabels",
    "streets",
    "topographic",
    "terrainWithLabels",
    "lightGrayCanvas",
    "nationalGeographic",
    "oceans",
    "imageryWithLabelsVector",
    "streetsVector",
    "topographicVector",
    "terrainWithLabelsVector",
    "lightGrayCanvasVector",
    "navigationVector",
    "streetsNightVector",
    "streetsWithReliefVector",
    "darkGrayCanvasVector",
    ];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }



    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let name = self.typeNames[indexPath.row];
        cell?.textLabel?.text = name;
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.mapType = self.types[(self.tableView.indexPathForSelectedRow?.row)!];
    }

 

}
