
import SwiftUI
import PhotosUI
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

struct UploadClothingView: View {
    @EnvironmentObject var clothingImageService: InduoClothingImage
    
    @Binding var isShowingUploadView: Bool
    @State private var selectedImage: UIImage? = nil
    @State private var stickerImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showItemTypeSelection = false // For item type selection
    @State private var clothingType: String = "" // Store selected clothing type
    
    var body: some View {
        VStack {
            if let image = stickerImage ?? selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .cornerRadius(10)
                Button("Upload Image") {
                    saveStickerImage()
                }
            } else {
                Text("No Image Selected")
                    .foregroundColor(.gray)
            }
            
            HStack {
                Button(action: {
                    imagePickerSource = .camera
                    showImagePicker = true
                }) {
                    Text("Take Photo")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    imagePickerSource = .photoLibrary
                    showImagePicker = true
                }) {
                    Text("Choose from Library")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            
            if stickerImage != nil {
                Button("Save and Select Item Type") {
                    saveStickerImage() // Save sticker image UUID
                    showItemTypeSelection = true // Show item type selection screen
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button(action: {
                isShowingUploadView = false
            }) {
                Text("Close")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .padding()
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imagePickerSource)
        }
        .sheet(isPresented: $showItemTypeSelection) {
            ClothingTypeSelectionView(selectedType: $clothingType) {
                isShowingUploadView = false // Dismiss after selection
            }
        }
        .onChange(of: selectedImage) {
            if let image = selectedImage {
                processImage(image)
            }
        }
    }
    
    // Process image for background removal
    private func processImage(_ image: UIImage) {
        selectedImage = image
        removeBackground(from: image) { backgroundRemovedImage in
            stickerImage = backgroundRemovedImage
        }
    }
    
    // Background removal
    private func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel = .accurate
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try handler.perform([request])
                if let mask = request.results?.first as? VNPixelBufferObservation {
                    let ciImage = CIImage(cvPixelBuffer: mask.pixelBuffer)
                    let output = self.applyMask(to: image, with: ciImage)
                    completion(output)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error in background removal: \(error)")
                completion(nil)
            }
        }
    }
    
    // Apply the generated mask to the original image to create the sticker effect
    private func applyMask(to image: UIImage, with mask: CIImage) -> UIImage? {
        let ciImage = CIImage(image: image)
        let maskedImage = ciImage?.applyingFilter("CIBlendWithMask", parameters: ["inputMaskImage": mask])
        if let outputCIImage = maskedImage {
            return UIImage(ciImage: outputCIImage)
        }
        return nil
    }
    
    // Save sticker image to local storage and store its UUID in the database
    private func saveStickerImage() {
        guard let stickerImage = stickerImage else { return }
        let imageUUID = UUID().uuidString
        if let data = stickerImage.pngData() {
            let filename = getDocumentsDirectory().appendingPathComponent("\(imageUUID).png")
            try? data.write(to: filename)
            saveToDatabase(imageUUID: imageUUID)
        }
    }
    
    // BREEA: save UUID to the database
    private func saveToDatabase(imageUUID: String) {
        // Database saving logic here; for example:
        print("Saved image UUID: \(imageUUID) as \(clothingType) in database")
        
        clothingImageService.uploadImage(userId: "12345", id: imageUUID, clothingType: "Shirt")
    }
    
    // Get documents directory path
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}

struct ClothingTypeSelectionView: View {
    @Binding var selectedType: String
    let onTypeSelected: () -> Void
    
    var body: some View {
        VStack {
            Text("Select Clothing Type")
                .font(.headline)
                .padding()
            
            ForEach(["Top", "Bottom", "Outerwear", "Footwear", "Accessory"], id: \.self) { type in
                Button(action: {
                    selectedType = type
                    onTypeSelected()
                }) {
                    Text(type)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.vertical, 5)
                }
            }
        }
        .padding()
    }
}
