class Customer
{
    let id: Int
    var satisfied: Bool
    var colorRequests: [Color]
    
    init(id: Int)
    {
        self.id = id
        self.satisfied = false
        self.colorRequests = [Color]()
    }
    
    func addColor(color: Color)
    {
        self.colorRequests.append(color)
    }
}
