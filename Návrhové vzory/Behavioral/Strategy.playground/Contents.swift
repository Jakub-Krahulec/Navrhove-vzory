import Foundation

// MARK: - Strategy

// Dynamic Strategy (statický by měl akorát generický textprocessor a tím pádem by se nastavoval už při kompilaci..)
// Během běhu palikace můžu vyměnit algoritmus za jiný bez změny kódu programu. Algoritmy si přehledně zabalím jako moduly.

enum OutputFormat{
    case markdown
    case html
}

protocol ListStrategy{
    init()
    func start(_ buffer: inout String)
    func end(_ buffer: inout String)
    func addListItem(buffer: inout String, item: String)
}

class MarkdownListStrategy: ListStrategy{
    required init() {}
    func start(_ buffer: inout String) {}
    func end(_ buffer: inout String) {}
    func addListItem(buffer: inout String, item: String) {
        buffer.append(" * \(item)\n")
    }
}

class HtmlListStrategy: ListStrategy{
    required init(){}
    func start(_ buffer: inout String) {
        buffer.append("<ul>\n")
    }
    
    func end(_ buffer: inout String) {
        buffer.append("</ul>\n")
    }
    
    func addListItem(buffer: inout String, item: String) {
        buffer.append("<li>\(item)</li>\n")
    }
    
    
}

class TextProcessor: CustomStringConvertible{
    private var buffer = ""
    private var listStrategy: ListStrategy
    
    init(_ outputFormat: OutputFormat){
        switch outputFormat {
            case .markdown:
                listStrategy = MarkdownListStrategy()
            case .html:
                listStrategy = HtmlListStrategy()
        }
    }
    
    func setOutputFormat(_ outputFormat: OutputFormat){
        switch outputFormat {
            case .markdown:
                listStrategy = MarkdownListStrategy()
            case .html:
                listStrategy = HtmlListStrategy()
        }
    }
    
    func appendList(_ items: [String]){
        listStrategy.start(&buffer)
        for item in items{
            listStrategy.addListItem(buffer: &buffer, item: item)
        }
        listStrategy.end(&buffer)
    }
    
    func clear(){
        buffer = ""
    }
    
    var description: String{
        return buffer
    }
}

let tp = TextProcessor(.html)

tp.appendList(["neco", "neco jineho", "salkdmal"])
print(tp)

tp.clear()
tp.setOutputFormat(.markdown)
tp.appendList(["neco", "neco jineho", "salkdmal"])
print(tp)
