import Foundation

class FileManager
{
    var colorDict: [Int: String]
    
    init()
    {
        colorDict = [:]
    }
    
    func parseInputFile(fileName: String, numberOfColors: inout Int, customers: inout [Customer]) -> Bool
    {
        colorDict = [:]
        let url: URL = URL(fileURLWithPath: fileName)

        do
        {
            let text: String = try String(contentsOf: url)
            if text.count == 0
            {
                print("The file is empty")
                return false
            }

            // create a string array out of all the lines in the file
            let lineArray = text.components(separatedBy: .newlines)
            if let numOfColors = Int(lineArray[0])
            {
                numberOfColors = numOfColors
                
                // parse each line to create a new customer
                for i in 1...lineArray.count-1
                {
                    var customer: Customer = Customer(id: i-1)
                    
                    var properties: [String] = lineArray[i].components(separatedBy: " ")
                    
                    // extract color id and type as a pair
                    let pairs = stride(from: 0, to: properties.count, by: 2).map {
                        (properties[$0], $0 < properties.count-1 ? properties[$0.advanced(by: 1)] : nil)
                    }

                    // create all color preferences for customer
                    if self.createColorsForCustomer(pairs: pairs, customer: &customer) == false
                    {
                        return false
                    }
                    
                    // check if there are 2 or more single color customers with different preferences
                    if pairs.count == 1 && self.checkForNoSolution(pairs: pairs)
                    {
                        return false
                    }
 
                    customers.append(customer)
                }
            }
            else
            {
                print("Wrong file format - missing number of colors")
                return false
            }
        }
        catch
        {
            print("Unable to read file")
            return false
        }
        
        return true
    }
    
    func checkForNoSolution(pairs: [(String, String?)]) -> Bool
    {
        // check with dictionary for customers with one color
        if let id: Int = Int(pairs[0].0)
        {
            // if there already is a color with the same id but different type, mark as no solution
            if colorDict[id]?.isEmpty == false && colorDict[id] != pairs[0].1
            {
                print("No solution exists")
                return true
            }
            else
            {
                colorDict[id] = pairs[0].1
            }
        }
 
        return false
    }
    
    func createColorsForCustomer(pairs: [(String, String?)], customer: inout Customer) -> Bool
    {
        for pair in pairs
        {
            if let id: Int = Int(pair.0)
            {
                // check if we have the right type
                let type: String = pair.1!
                
                if (type != "M" && type != "G")
                {
                    print("Wrong file format - missing right color type")
                    return false
                }
                
                var colType: ColorType = .gloss
                if (type == "M")
                {
                    colType = .matte
                }
                
                // create the new color
                let color: Color = Color(id: id, type: colType)
                customer.addColor(color: color)
            }
            else
            {
                print("Wrong file format - missing color id")
                return false
            }
        }
        return true
    }
}
