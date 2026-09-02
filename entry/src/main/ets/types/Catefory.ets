import { Product } from "./Product";

export interface Category{
  id?:string
  imageUrl:string;
  name:string
  parent:string|Category
  order:number
  isActive:boolean
  products?:Product[]
}