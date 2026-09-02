import { CartItem } from "../models/CartItem";
import { CartService } from "../services/CartService";
import { router } from "@kit.ArkUI";

@Component
export struct cart {
 @State cartItems: CartItem[] = []

 aboutToAppear(): void {
  this.loadCart()
 }

 async loadCart(): Promise<void> {
  const context = this.getUIContext().getHostContext()
  if (context) {
   this.cartItems = await CartService.getCart(context)
  }
 }

 toggleCheck(index: number, value: boolean): void {
  const context = this.getUIContext().getHostContext()
  if (context && index < this.cartItems.length) {
   const updated: CartItem[] = [...this.cartItems]
   updated[index].checked = value
   this.cartItems = updated
   CartService.updateCart(context, index, this.cartItems[index])
  }
 }

 changeCount(index: number, delta: number): void {
  const context = this.getUIContext().getHostContext()
  if (context && index < this.cartItems.length) {
   const newCount: number = this.cartItems[index].count + delta
   if (newCount >= 1) {
    const updated: CartItem[] = [...this.cartItems]
    updated[index].count = newCount
    this.cartItems = updated
    CartService.updateCart(context, index, this.cartItems[index])
   }
  }
 }

 setAllChecked(value: boolean): void {
  const context = this.getUIContext().getHostContext()
  if (context) {
   const updated: CartItem[] = this.cartItems.map((item: CartItem): CartItem => {
    item.checked = value
    return item
   })
   this.cartItems = updated
   CartService.saveCart(context, this.cartItems)
  }
 }

 isAllCheck(): boolean {
  if (this.cartItems.length === 0) {
   return false
  }
  return this.cartItems.every((item: CartItem): boolean => item.checked)
 }

 getTotalPrice(): number {
  let total: number = 0
  this.cartItems.forEach((item: CartItem) => {
   if (item.checked) {
    total += (item.product.price ?? 0) * item.count
   }
  })
  return total
 }

 @Builder buildCartHeader() {
  Row() {
   Text('购物车').fontSize(24).fontWeight(FontWeight.Bold)
   Text('编辑').fontSize(14)
  }
  .width('100%').height(56).padding({ left: 16, right: 16 })
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.SpaceBetween)
 }

 @Builder buildCartItem(item: CartItem, index: number) {
  Row({ space: 10 }) {
   Checkbox({ name: 'cartItem_' + index })
    .select(item.checked)
    .shape(CheckBoxShape.CIRCLE)
    .selectedColor('#ffe0362a')
    .onChange((value: boolean) => {
     this.toggleCheck(index, value)
    })

   Image(item.product.imgUrl ?? '')
    .width(80).height(80).borderRadius(8).backgroundColor('#F5F5F5')

   Column({ space: 4 }) {
    Text(item.product.title ?? '').fontSize(15).maxLines(1)
    Text(`${item.color} ${item.version}`).fontSize(12).fontColor(Color.Gray)
    Row({ space: 8 }) {
     Text(`￥${(item.product.price ?? 0) * item.count}`)
      .fontSize(16).fontColor(Color.Red).fontWeight(FontWeight.Bold)
     Blank()
     Button('-').height(24).aspectRatio(1).padding(0)
      .onClick(() => {
       this.changeCount(index, -1)
      })
     Text(`${item.count}`).fontSize(14)
     Button('+').height(24).aspectRatio(1).padding(0)
      .onClick(() => {
       this.changeCount(index, 1)
      })
    }
   }
   .layoutWeight(1)
   .alignItems(HorizontalAlign.Start)
  }
  .width('100%').padding(10).backgroundColor(Color.White).borderRadius(12)
 }

 @Builder buildCartItems() {
  List({ space: 12 }) {
   ForEach(this.cartItems, (item: CartItem, index: number) => {
    ListItem() {
     this.buildCartItem(item, index)
    }
   }, (item: CartItem): string => (item.product.id ?? '') + item.color + item.version)
  }
  .width('100%')
  .layoutWeight(1)
  .padding(12)
 }

 @Builder buildCartFooter() {
  Row() {
   Checkbox({ name: 'cartAll' })
    .select(this.isAllCheck())
    .selectedColor(Color.Red)
    .shape(CheckBoxShape.ROUNDED_SQUARE)
    .onChange((value: boolean) => {
     this.setAllChecked(value)
    })

   Text('全选')
   Text('总计:')
   Text(`￥${this.getTotalPrice()}`)
    .fontColor(Color.Red)
    .fontWeight(FontWeight.Bold)
    .layoutWeight(1)
   Button(`结算(${CartItem.getTotalAmount(this.cartItems)})`)
    .backgroundColor(Color.Red)
    .onClick(() => {
     const checkedItems: CartItem[] = this.cartItems.filter((item: CartItem): boolean => item.checked)
     if (checkedItems.length > 0) {
      router.pushUrl({
       url: 'pages/ConfirmOrder',
       params: { cartItems: checkedItems }
      })
     } else {
      this.getUIContext().getPromptAction().showToast({
       message: '没有待结算的商品',
       duration: 3000
      })
     }
    })
  }
  .width('100%').height(56).padding({ left: 16, right: 16 })
  .backgroundColor(Color.White)
 }

 build() {
  Column() {
   this.buildCartHeader()
   this.buildCartItems()
   this.buildCartFooter()
  }
  .width('100%').height('100%')
  .backgroundColor($r('app.color.primary_background_color'))
 }
}