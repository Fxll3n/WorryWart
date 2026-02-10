//
//  SchoologyViewModel.swift
//  WorryWart
//
//  Created by Angel Bitsov on 2/10/26.
//

import Foundation

@Observable
class SchoologyViewModel {
    var studentId: Int = 427028
    var courses: [Course] = []
    var assignments: [Assignment] = []
    
    init(){
        getData()
    }
    
    func getData() {
        let url = URL(string: "https://site.api.espn.com/apis/site/v2/sports/football/nfl/teams")!
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            guard let jsonData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            
            guard let studentsArray = jsonData["students"] as? NSArray else { return } // Dummy Array
            guard let sportsDict = studentsArray[self.studentId] as? [String: Any] else { return } // Dummy Dictionary
            
            var downloadedCourses: [Course] = []
            var downloadedAssignments: [Assignment] = []
            
            DispatchQueue.main.async(execute: {
                self.courses = downloadedCourses
                self.assignments = downloadedAssignments
            })
        }
        session.resume()
    }
    
}

