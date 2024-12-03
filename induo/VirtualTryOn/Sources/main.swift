import Foundation
import FalClient

@main
struct VirtualTryOn {
    static func main() async {
        do {
            var instance = VirtualTryOn()
            try await instance.run()
        } catch {
            print("Error: \(error)")
        }
    }
    
    mutating func run() async throws {        
        let human = "profile_image.png"
        let garment = "uppers/tank.png"
        let clothType = "upper"
        let apiKey = "e037423f-5506-4946-a95b-28ad74f4616a:725255ba3a3b60834b037079aad809d1"
        //stylepromt should either be "" or text:
        //let stylePrompt = "My style is colorful, feminine, and preppy."  //retruns file "#_UUID"
        let stylePrompt = "" //returns file "X_UUID"
        
        let startTime = Date()
        let falClient = FalClient.withCredentials(.keyPair(apiKey))
        
        do {
            // Read image files
            let humanImageData = try Data(contentsOf: URL(fileURLWithPath: human))
            let garmentImageData = try Data(contentsOf: URL(fileURLWithPath: garment))
            
            // Upload human image
            let humanImageUrl = try await falClient.storage.upload(data: humanImageData)
            //print("Uploaded human image to URL: \(humanImageUrl)")
            
            // Upload garment image
            let garmentImageUrl = try await falClient.storage.upload(data: garmentImageData)
            //print("Uploaded garment image to URL: \(garmentImageUrl)")
            
            // Perform Virtual Try-On
            let tryOnResult = try await falClient.subscribe(
                to: "fal-ai/cat-vton",
                input: [
                    "human_image_url": Payload.string(humanImageUrl),
                    "garment_image_url": Payload.string(garmentImageUrl),
                    "num_inference_steps": Payload.int(23),
                    "guidance_scale": Payload.double(3.0),
                    "seed": Payload.int(100),
                    "cloth_type": Payload.string(clothType)
                ]
            )
            //print("Try-On Result: \(tryOnResult)")
            //print("Test: \(tryOnResult["image"])")
            let imageResult = tryOnResult["image"]
            
            if let tryOnImageUrl = imageResult["url"].stringValue {
                //print("Try-On Image URL: \(tryOnImageUrl)")
                
                // Download the try-on image
                let imageData = try Data(contentsOf: URL(string: tryOnImageUrl)!)
                
                var styleResult = "X"
                if !stylePrompt.isEmpty {
                    // Evaluate Style
                    let styleResponse = try await falClient.subscribe(
                        to: "fal-ai/any-llm/vision",
                        input: [
                            "model": Payload.string("google/gemini-flash-1.5"),
                            "prompt": Payload.string("My personal fashion style: " + stylePrompt + ". On a scale from 1 to 9, with 1 being the worst, and 9 being the best, rank how well this outfit fits my personal style."),
                            "system_prompt": Payload.string("Only answer the question with a numerical value of 1-9, do not provide any additional information or add any prefix/suffix other than the answer of the original question. Don't use markdown."),
                            "image_url": Payload.string(tryOnImageUrl)
                        ]
                    )
                    // Extract style evaluation result
                    if let output = styleResponse["output"].stringValue {
                        styleResult = output.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                }
                
                    // Extract style evaluation result
                    print("Style Evaluation Result: \(styleResult)")

                    // Save the image to file with UUID and style evaluation in the filename
                    let uuid = UUID().uuidString
                    let fileName = "\(styleResult)_score_\(uuid).png"

                    // Determine the directory based on the first character of the file name
                    let folderName = fileName.first == "X" ? "singles" : "outfits"
                    let folderURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent(folderName)

                    // Construct the full file path
                    let fileURL = folderURL.appendingPathComponent(fileName)

                    // Write the image data to the file
                    try imageData.write(to: fileURL)
                    print("Image saved to file: \(fileURL.path)")
            }
                
        } catch {
            print("Error encountered: \(error)")
        }
        
        // Measure elapsed time
        let elapsedTime = Date().timeIntervalSince(startTime)
        print("Process completed in \(elapsedTime) seconds.")
    }
}
