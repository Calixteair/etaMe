import SwiftUI
struct DishRow: View {
    @ObservedObject var viewModel: DishRowViewModel
    var orderValided: Bool

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: viewModel.dish.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } placeholder: {
                Color.gray.frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading) {
                Text(viewModel.dish.name)
                    .font(.headline)
                Text(viewModel.dish.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack {
                Text("\(viewModel.dish.price * Double(viewModel.dish.quantity), specifier: "%.2f") $")
                    .font(.headline)
                if orderValided {
                    Text("x\(viewModel.dish.quantity)")
                        .font(.subheadline)
                        .padding(.horizontal, 5)
                }
                
                if !orderValided {
                    HStack {
                        Button(action: viewModel.decreaseQuantity) {
                            Image(systemName: "minus.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Text("x\(viewModel.dish.quantity)")
                            .font(.subheadline)
                            .padding(.horizontal, 5)
                        
                        Button(action: viewModel.increaseQuantity) {
                            Image(systemName: "plus.circle")
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    
                    Button(action: viewModel.removeDish) {
                        Text("Remove")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    .padding(.top, 5)
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .padding(.vertical, 5)
        .contentShape(Rectangle())
    }
}
