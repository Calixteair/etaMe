import SwiftUI

class DishRowViewModel: ObservableObject {
    @Published var dish: DishOrder

    var onQuantityChange: ((DishOrder) -> Void)?
    var onUpdateQuantity: ((Int, Int) -> Void)?
    var onRemoveDish: ((Int) -> Void)?

    init(dish: DishOrder,
         onQuantityChange: ((DishOrder) -> Void)? = nil,
         onUpdateQuantity: ((Int, Int) -> Void)? = nil,
         onRemoveDish: ((Int) -> Void)? = nil) {
        self.dish = dish
        self.onQuantityChange = onQuantityChange
        self.onUpdateQuantity = onUpdateQuantity
        self.onRemoveDish = onRemoveDish
    }

    func decreaseQuantity() {
        if dish.quantity > 1 {
            dish.quantity -= 1
            onQuantityChange?(dish)
            onUpdateQuantity?(dish.id, -1)
        }
    }

    func increaseQuantity() {
        dish.quantity += 1
        onQuantityChange?(dish)
        onUpdateQuantity?(dish.id, +1)
    }

    func removeDish() {
        onRemoveDish?(dish.id)
    }
}
