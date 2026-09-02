import { Category } from "./Catefory";
import { ProductImages } from "./ProductImages";

export interface Product{
  id?:string
  title?:string;
  subtitle?:string
  category?:string|Category
  price?:number
  crossedOutPrice?:number
  imgUrl?:string
  description?:string
  inNew?:boolean
  isRecommended?:boolean
  isPremium?:boolean
  order?:number
  isActive?:boolean
  promotion?:string
  colors?:string[]
  versions?:string[]
  productImages?:ProductImages[]
  productId?: string
}