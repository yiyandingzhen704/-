import { router } from '@kit.ArkUI'
import { ProductImages } from '../types/ProductImages'

@Entry
@Component
struct ProductImage {
  @State selectedImageIndex:number=0
  @State productImages:ProductImages[]=[]
  aboutToAppear(): void {
    const params=router.getParams() as Record<string,object>|null
    if (params) {
      const images=params['productImages']
      if (Array.isArray(images)) {
        this.productImages=params['productImages'] as ProductImages[]
      }
      const idx=params['selectedIndex']
      if (typeof idx==='number') {
        this.selectedImageIndex=idx
      }
    }
  }

  build() {
   Column(){
     Row(){
       Button(){Image($r('app.media.back')).width(24)}.onClick(()=>{
         router.back()
       }).backgroundColor(Color.Transparent).position({x:0,y:10})
       Text(`${this.selectedImageIndex+1}/${this.productImages.length}`).position({x:160,y:10})
     }.width('100%').position({x:0,y:10})
     Swiper(){
       ForEach(this.productImages,(item:ProductImages)=>{
         Image(item.imgUrl).width('100%').height(400)
       })
     }.indicator(Indicator.dot().selectedColor(Color.Gray)).index($$this.selectedImageIndex)
   }.height('100%').justifyContent(FlexAlign.Center).padding({left:16,right:16,top:10})
  }
}