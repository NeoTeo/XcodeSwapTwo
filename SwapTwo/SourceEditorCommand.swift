//
//  SourceEditorCommand.swift
//  SwapTwo
//
//  Created by Teo Sartori on 14/06/2018.
//  Copyright © 2018 teos. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        _ = swapSelection(0, invocation)
        
        completionHandler(nil)
    }
    
    func swapSelection(_ index: Int, _ invocation: XCSourceEditorCommandInvocation) -> String? {
        guard index < invocation.buffer.selections.count else { return nil }
        let selection = invocation.buffer.selections[index] as! XCSourceTextRange
        let lines = invocation.buffer.lines as! [String]
        
        // Swap two requires the selection to be on the same line
        guard selection.start.line == selection.end.line else { return nil }
        
        var line = lines[selection.start.line]
        let original = line
        
        let start = line.index(line.startIndex, offsetBy: selection.start.column)
        let end = line.index(line.startIndex, offsetBy: selection.end.column)
        let selectionRange = start ..< end
        line = String(line[selectionRange])
        
        let components = line.split(separator: ",")
        
        // We only swap two comma separated strings
        guard components.count == 2 else { return nil }
        let swapString = String(components[1] + ", " + components[0]).trimmingCharacters(in: .whitespacesAndNewlines)
        invocation.buffer.lines[selection.start.line] = original.replacingCharacters(in: selectionRange, with: swapString)
        return swapString
    }
}
