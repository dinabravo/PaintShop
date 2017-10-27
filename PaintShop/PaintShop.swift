import Foundation

class PaintShop
{
    var allCustomers: [Customer]
    var numberOfColors: Int
    var colorDict: [Int: String]
    let fileManager: FileManager = FileManager()
    
    init()
    {
        self.allCustomers = [Customer]()
        self.numberOfColors = 0
        self.colorDict = [:]
    }
    
    func makeColors(fileName: String)
    {
        if fileManager.parseInputFile(fileName: fileName, numberOfColors: &self.numberOfColors, customers: &self.allCustomers)
        {
            // create the dictionary slots
            for i in 1...self.numberOfColors
            {
                self.colorDict[i] = ""
            }
            
            // check if there are customers with one color
            self.makeOneColorCustomersHappy()
            self.makeOtherCustomersHappy()
            self.fillTheGaps()
            self.outputSolution()
        }
    }
    
    func makeOneColorCustomersHappy()
    {
        let customers = allCustomers.filter{$0.colorRequests.count == 1}
        
        for cust in customers
        {
            let color: Color = cust.colorRequests[0]
            colorDict[color.id] = color.colorType.rawValue
            cust.satisfied = true
        }
    }
    
    func makeOtherCustomersHappy()
    {
        let customers = allCustomers.filter{$0.colorRequests.count > 1}
        
        if customers.count == 0
        {
            return
        }
        
        for i in 0...customers.count-1
        {
            var cust = customers[i]
            
            // maybe the customer is already satisfied because his color preference matches the one color customer's
            if self.checkIfCustomerSatisfied(customer: cust)
            {
                continue
            }
            
            // take all gloss colors first and if its free in the dictionary or if it's the same value write it and set customer satisfied
            self.chooseColorsForCustomer(customer: &cust, colorType: .gloss)
            
            // now try all matte colors
            if cust.satisfied == false
            {
                self.chooseColorsForCustomer(customer: &cust, colorType: .matte)
            }
        }
    }
    
    func checkIfCustomerSatisfied(customer: Customer) -> Bool
    {
        for col in customer.colorRequests
        {
            if colorDict[col.id]! == col.colorType.rawValue
            {
                customer.satisfied = true
                return true
            }
        }
        
        return false
    }
    
    func chooseColorsForCustomer(customer: inout Customer, colorType: ColorType)
    {
        let colors = customer.colorRequests.filter{$0.colorType == colorType}
        
        for col in colors
        {
            if colorDict[col.id]!.isEmpty || colorDict[col.id]! == col.colorType.rawValue
            {
                colorDict[col.id] = col.colorType.rawValue
                customer.satisfied = true
                break
            }
        }
    }
    
    func fillTheGaps()
    {
        for i in 1...self.numberOfColors
        {
            if self.colorDict[i]!.isEmpty
            {
                self.colorDict[i] = "G"
            }
        }
    }
    
    func outputSolution()
    {
        var text: String = ""
        
        /*
         Because this was not specified in the document, I made an assumption that
         if we say there will be 4 colors, the id's will go 1 to 4, not some random numbers.
         If the id's would be something like 5, 12, 16, 28 then the dictionary would
         have to be sorted before the result file is saved
         */
        
        for i in 1...colorDict.count
        {
            text.append(colorDict[i]! + " ")
        }
        text.removeLast()

        print(text)
    }
}
