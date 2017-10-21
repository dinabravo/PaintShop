import Foundation

let paintShop: PaintShop = PaintShop()

if CommandLine.arguments.count > 1
{
    paintShop.makeColors(fileName: CommandLine.arguments[1] as String)
}
else
{
    print("Please provide a file path")
}


