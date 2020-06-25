import UIKit

protocol Coffee {
    var cost: Int { get }
}

class SimpleCoffee: Coffee {
    var cost: Int {
        return 100
    }
}

protocol CoffeeDecorator: Coffee {
    var base: Coffee { get }
    init(base: Coffee)
}

class Milk: CoffeeDecorator {
    var base: Coffee
    var cost: Int {
        return base.cost + 30
    }
    
    required init(base: Coffee) {
        self.base = base
    }
}

class Whip: CoffeeDecorator {
    var base: Coffee
    var cost: Int {
        return base.cost + 20
    }
    
    required init(base: Coffee) {
        self.base = base
    }
}

class Sugar: CoffeeDecorator {
    var base: Coffee
    var cost: Int {
        return base.cost + 10
    }
    
    required init(base: Coffee) {
        self.base = base
    }
}

let coffee = SimpleCoffee()
let coffeeAndMilk = Milk(base: coffee)
let copuchino = Whip(base: coffeeAndMilk)

print(coffee.cost)
print(coffeeAndMilk.cost)
print(copuchino.cost)
