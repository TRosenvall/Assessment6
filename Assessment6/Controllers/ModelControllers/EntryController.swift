//
//  EntryController.swift
//  Assessment6
//
//  Created by Timothy Rosenvall on 7/19/19.
//  Copyright © 2019 Timothy Rosenvall. All rights reserved.
//

import Foundation

class EntryController {
    // Mark: - Properties
    // Singleton
    static let sharedInstance = EntryController()
    
    // SourceOfTruth + Helper
    var entries: [Entry] = []
    var groups: [String] = []
    
    // Initializer to Load Data
    private init () {
        loadFromPersistentStore()
    }
    
    // Mark: - CRUD Functions
    // Create
    func createEntry (name: String) {
        // Initialize a new Entry from the name property passed into it.
        let entry = Entry(name: name)
        // Set the groups
        setGroups()
        // Append the initilized Entry to the Source Of Truth
        entries.append(entry)
        // Save
        saveToPersistentStore()
    }
    
    func setGroups () {
        // Set a shortcut for the number of entries
        let numberOfEntries = self.entries.count
        // Pull an integer number of groups to have
        let numberOfGroups = numberOfEntries / 2 + numberOfEntries % 2
        // Check if the number of groups needs to be reset
        if self.groups.count != numberOfGroups {
            // Empty the groups array
            self.groups = []
            // Iterate through the number of groups needed and reset the groups.
            for group in 1...numberOfGroups {
                self.groups.append("Group \(group)")
            }
        }
    }
    
    // Read - Save and Load Functions
    func saveToPersistentStore() {
        // Set a JSON Encoder
        let jsonEncoder = JSONEncoder()
        
        do {
            // Encode the entries property
            let data = try jsonEncoder.encode(entries)
            // Write the encoded property to the correct URL
            try data.write(to: fileURL())
        } catch let error {
            // If we get an error, handle it.
            print("Error saving to persistent store: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStore() {
        // Set a JSON Decoder
        let jsonDecoder = JSONDecoder()
        
        do {
            // Pull the data out of the fileURL
            let data = try Data(contentsOf: fileURL())
            // Decode the JSON data
            let decodedEntries = try jsonDecoder.decode([Entry].self, from: data)
            // Set the Source Of Truth from the decoded data.
            EntryController.sharedInstance.entries = decodedEntries
            // Set the groups to the correct amount.
            setGroups()
        } catch let error {
            // If we get an error, handle it.
            print("Error loading from persistent store: \(error.localizedDescription)")
        }
    }
    
    // Delete
    func deleteEntry (entry: Entry) {
        // Find the index of the entry to remove and remove that entry.
        guard let index = entries.firstIndex(of: entry) else {return}
        entries.remove(at: index)
        
        // Keep the groups array set to the correct amount, one group for every two people.
        if entries.count % 2 == 0 {
            groups.removeLast()
        }
        
        // Save
        saveToPersistentStore()
    }
    
    // Mark: - URL Path For Persistance
    func fileURL() -> URL {
        // Pull the initial path where data will be stored.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // Get the folder in which the data will be saved.
        let documentDirectory = paths[0]
        // Choose what the file will be called.
        let fileName = "entries.json"
        // Set the URL to the full path and file name
        let url = documentDirectory.appendingPathComponent(fileName)
        // Return the URL
        return url
    }
    
    // Mark: - Randomizer Function
    func randomizeEntries () {
        // Setup a variable array equal to the Source Of Truth
        var entriesToRandomize = self.entries
        // Setup a variable to hold the randomized Entries.
        var entriesRandomized: [Entry] = []
        // Go until the entriesToRandomize array is empty
        while entriesToRandomize.count != 0 {
            // Generate a random integer between 0 and the number of entriesToRandomize array
            let randomEntryIndex = Int.random(in: 0...entriesToRandomize.count-1)
            // Append that entry to the entriesRandomized array
            entriesRandomized.append(entriesToRandomize[randomEntryIndex])
            // Pull that entry from the entriesToRandomize array
            entriesToRandomize.remove(at: randomEntryIndex)
        }
        // Reset the Source Of Truth to the new randomized entries array.
        self.entries = entriesRandomized
    }
}
