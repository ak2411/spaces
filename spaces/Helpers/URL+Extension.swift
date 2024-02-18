//
//  URL+Extension.swift
//  spaces
//
//  Created by Angelica Kosasih on 2/17/24.
//

import Foundation

//add a filecacheurl extension since we cannot add
extension URL {
    var usdzFileCacheURL: URL? {
        guard
            let urlComps = URLComponents(url: self, resolvingAgainstBaseURL: false),
            let cacheDirURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        // find the query key that is called token
        //token is the identifier of the file cache
        let token =  urlComps.queryItems?.first(where: {$0.name == "token"})?.value ?? UUID().uuidString
        let fileCacheURL = cacheDirURL.appending(
            path: "\(token)_\(lastPathComponent)")
        return fileCacheURL
    }
}
