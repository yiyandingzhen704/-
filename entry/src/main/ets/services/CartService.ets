import { common } from "@kit.AbilityKit";
import { CartItem, CartItemData } from "../models/CartItem";
import { CART_LIST, CART_STORE } from "../config/constants";
import { PreferenceUtils } from "../utils/PreferenceUtils";
import { JSON } from "@kit.ArkTS";


export class CartService{
  static async getCart(context:common.Context):Promise<CartItem[]>{
    try {
      const cartStr= await PreferenceUtils.get(context,CART_STORE,CART_LIST)as string
      if (cartStr) {
        const data=JSON.parse(cartStr) as CartItemData[]
        return data.map(item=>CartItem.fromJSON(item))
      }
      return []
    }catch (error){
      console.error('CartService getCart error:',JSON.stringify(error))
      return []
    }
  }
  static async saveCart(context:common.Context,cartItems:CartItem[]):Promise<void>{
    try {
      await PreferenceUtils.put(context,CART_STORE,CART_LIST,JSON.stringify(cartItems))
    }catch (error){
      console.error('CartService saveCart error:',JSON.stringify(error))
    }

  }
  static async addToCart(context:common.Context,item:CartItem):Promise<boolean>{
    let found=false
    try {
      const list=await CartService.getCart(context)
      for (let cartItem of list) {
        if (cartItem.product.id===item.product.id&&cartItem.color===item.color&&cartItem.version===item.version) {
          found=true
          cartItem.count++
        }
      }
      if (!found) {
        list.push(item)
      }
      await CartService.saveCart(context,list)
      return true
    }catch (error){
      console.error('CartService addToCart error:',JSON.stringify(error))
      return false
    }
  }
  static async updateCart(context:common.Context,index:number,item:CartItem):Promise<boolean>{
    try {
      const list=await CartService.getCart(context)
      if (index>=0&&index<list.length) {
        list[index]=item
        await CartService.saveCart(context,list)
        return true
      }
      return false
    }catch (error){
      console.error('CartService updateCart error:',JSON.stringify(error))
      return false
    }
  }
  static async deleteCart(context:common.Context,index:number):Promise<boolean>{
    try {
      const list=await CartService.getCart(context)
      if (index>=0&&index<list.length) {
        list.splice(index,1)
        await CartService.saveCart(context,list)
        return true
      }
      return false
    }catch (error){
      console.error('CartService deleteCart error:',JSON.stringify(error))
      return false
    }
  }
}
