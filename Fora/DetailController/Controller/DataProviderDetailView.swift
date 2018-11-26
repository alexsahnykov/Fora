//
//  DataProviderDetailView.swift
//  Fora
//
//  Created by Александр Сахнюков on 26/11/2018.
//  Copyright © 2018 Александр Сахнюков. All rights reserved.
//

import UIKit

class DataProviderDetailView: NSObject {
    var dataManager = DataManagerDetailView()
}

extension DataProviderDetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataManager.albumTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! TrackTableViewCell
            cell.updateCell(track: dataManager.albumTracks[indexPath.row])
            return cell
    }
}

extension DataProviderDetailView: UITableViewDelegate {
    
}
