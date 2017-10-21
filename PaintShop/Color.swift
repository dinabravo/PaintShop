enum ColorType: String
{
    case gloss = "G"
    case matte = "M"
}

class Color
{
    let id: Int
    var colorType: ColorType
    
    init(id: Int, type: ColorType)
    {
        self.id = id
        self.colorType = type
    }
}
