import ArgumentParser
import Foundation

@main
struct SmollDB: ParsableCommand {

    @Option(help: "Interact with SmollDB using REPL.")
    var repl: Bool = true

    private func printPrompt() {
        print("db > ", terminator: "")
    }

    private func doMetaCommand(_ input: String) -> MetaCommandResult {
        if input == ".exit" {
            Foundation.exit(0)
        } else {
            return .unrecognizedCommand
        }
    }

    private func prepareStatement(_ input: String, _ statement: inout Statement) -> PrepareResult {
        if input == "insert" {
            statement.type = .insert
            return .success
        }
        if input == "select" {
            statement.type = .select
            return .success
        }
        return .unrecognizedStatement
    }

    private func executeStatement(_ statement: Statement) {
        switch statement.type {
        case .insert:
            print("insert statement")
        case .select:
            print("select statement")
        case .none:
            print("error")
        }
    }

    public func run() throws {
        if repl {
            while true {
                printPrompt()
                let input = readLine(strippingNewline: true)!

                if input.first == "." {
                    switch doMetaCommand(input) {
                    case .success:
                        continue
                    case .unrecognizedCommand:
                        print("Unrecognized command '\(input)'")
                        continue
                    }
                }

                var statement = Statement(type: nil)
                switch prepareStatement(input, &statement) {
                case .success:
                    break
                case .unrecognizedStatement:
                    print("Unrecognized keyword at start of '\(input)'")
                    continue
                }

                executeStatement(statement)
                print("Executed.")
            }
        }
    }
}
