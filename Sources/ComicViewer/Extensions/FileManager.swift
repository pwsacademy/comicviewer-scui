import Foundation

extension FileManager {
    
    /// Creates a directory at the given URL if one does not exist.
    ///
    /// This method will create any intermediate directories as required.
    /// If a file exists at the given URL, it will be deleted.
    func createDirectoryIfNotExists(_ url: URL) throws {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory)
        if !exists {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        } else if exists && !isDirectory.boolValue {
            try FileManager.default.removeItem(at: url)
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
}
