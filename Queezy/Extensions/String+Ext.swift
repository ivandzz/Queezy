//
//  String+Ext.swift
//  Queezy
//
//  Created by Іван Джулинський on 19.01.2025.
//

import Foundation

extension String {
    func decodeHTMLEntities() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        return (try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil).string) ?? self
    }
}
