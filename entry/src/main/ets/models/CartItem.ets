import { Product } from "../types/Product"

export interface CartItemData{
  product: Product
  color: string
  version: string
  count: number
  checked: boolean
}


export class CartItem {
  product: Product
  color: string
  version: string
  count: number
  checked: boolean

  constructor(product: Product, color: string, version: string, count: number, checked: boolean) {
    this.product = product
    this.color = color
    this.version = version
    this.count = count
    this.checked = checked
  }
static fromJSON(data:CartItemData):CartItem{
    return new CartItem(
      data.product,
      data.color,
      data.version,
      data.count,
      data.checked
    )
}
static getTotalAmount(cartItems:CartItem[]):number{
    return cartItems.reduce((total:number,item:CartItem):number=>{
     return total+item.count
    },0)
}
}