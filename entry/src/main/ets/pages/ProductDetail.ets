import {  router } from '@kit.ArkUI'
import { SCREEN_HEIGHT } from '../config/constants'
import { CartItem } from '../models/CartItem'
import { CartService } from '../services/CartService'
import { HttpService } from '../services/HttpService'
import { MoreMenus } from '../types/MoreMenus'
import { Product } from '../types/Product'
import { ProductImages } from '../types/ProductImages'

const CHOOSE_SPEC_HEIGHT=315

@Entry
@Component
struct ProductDetail {
 @State productImages:ProductImages[]=[]
 @State MoreMenuList:MoreMenus[]=[
   new MoreMenus($r('app.media.home_white'),'首页',0),
   new MoreMenus($r('app.media.search_white'),'搜索',1),
   new MoreMenus($r('app.media.more_white'),'分类',2),
   new MoreMenus($r('app.media.cart_white'),'购物车',3),
   new MoreMenus($r('app.media.user_white'),'我的',4)
 ]
  @State isShowHeader:boolean=false
  @State isShowMOreMenus:boolean=false
  @State selectedIndex:number=0
  @State selectedColorIndex:number=0
  @State selectedVersionIndex:number=0
  @State product:Product={productImages:[],colors:[],versions:[]}
  @State maxLines:number=1
  @State isShowFullProductPromotion:boolean=false
  @State count:number=1
  @State isShowMask:boolean=false
  @State isShowChooseSpec:boolean=false
  @State cartItems: CartItem[] = []
  aboutToAppear(): void {
    this.getProduct()
    this.loadCart()
  }
  async getProduct():Promise<void>{
    try {
      const params:Record<string,string>|undefined = router.getParams()as Record<string,string>
      const productId:string=params?(params['product_id']??'1'):'1'
      const response=await HttpService.get<Product>('/products/'+productId)
      if (response.success) {
        this.product=response.data as Product
        const imageList:ProductImages[]=this.product.productImages??[]
        this.productImages=this.product.productImages??[]
        console.log(`图片数量${this.productImages.length}`)
      }else {
        console.log('获取product数据失败',response.message)
        this.getUIContext().getPromptAction().showToast({
          message:response.message,
          duration:3000
        })
      }
    }catch (error){
      console.error('getProduct error'+JSON.stringify(error))
    }
  }
  async loadCart():Promise<void>{
   const  context=this.getUIContext().getHostContext()
    if (context) {
      this.cartItems=await CartService.getCart(context)
    }
  }

  @Builder buildOperationArea(){
    Row(){
      Row(){
        Column(){
          Image($r('app.media.home_icon')).width(20)
          Text('首页').fontSize(12)
        }.layoutWeight(1).onClick(()=>{
          router.pushUrl({
            url:'pages/Index',
            params:{targetTabIndex:0}
          })
        })
        Column(){
          Image($r('app.media.icon_kefu')).width(20)
          Text('客服').fontSize(12)
        }.layoutWeight(1).onClick(()=>{
          router.pushUrl({
            url:'pages/Index',
            params:{targetTabIndex:0}
          })
        })
        Column(){
          if (CartItem.getTotalAmount(this.cartItems)>0){
            Badge({
             count:CartItem.getTotalAmount(this.cartItems),
              position:BadgePosition.RightTop,
              style:{badgeColor:Color.Red,badgeSize:14}
            }){
              Image($r('app.media.cart_icon')).width(20)
            }
          }else {
            Image($r('app.media.cart_icon')).width(20)
          }

          Text('购物车').fontSize(12)
        }.layoutWeight(1).onClick(()=>{
          router.pushUrl({
            url:'pages/Index',
            params:{targetTabIndex:1}
          })
        })

      }.width(145)
      Row(){
        Button('加入购物车').fontColor(Color.White).backgroundColor('#FFF3A64B').borderRadius({topLeft:18,bottomLeft:18,topRight:0,bottomRight:0})
          .onClick(()=>{
            this.showChooseSpec()
          })
        Button('立即购买').fontColor(Color.White).backgroundColor('#FFE0362A').borderRadius({topLeft:0,bottomLeft:0,topRight:18,bottomRight:18})
      }
    }.width('100%').height(56).border({width:{top:1},color:'rgba(51,51,51,0.05)'})
  }
  @Builder buildProductDetailHeader(){
    if (this.isShowHeader) {
      Column(){
        Row(){
          Image($r('app.media.back')).width(24).onClick(()=>{
            router.back()
          })
          Search({value:'搜索'}).layoutWeight(1).margin({left:16,right:16}).backgroundColor(Color.White)
          Image($r('app.media.more')).width(24).onClick(()=>{
            this.isShowMOreMenus=!this.isShowMOreMenus
          })
        }.height(48)
        Tabs(){
          TabContent(){

          }.tabBar(SubTabBarStyle.of('商品').labelStyle({selectedColor: '#ffd03434' }).indicator({color: '#ffe04040',marginTop:1}))
          TabContent(){

          }.tabBar(SubTabBarStyle.of('评价').labelStyle({selectedColor:'#ffd03434'}).indicator({color: '#ffe04040',marginTop:1}))
          TabContent(){

          }.tabBar(SubTabBarStyle.of('参数').labelStyle({selectedColor:'#ffd03434'}).indicator({color: '#ffe04040',marginTop:1}))
          TabContent(){

          }.tabBar(SubTabBarStyle.of('详情').labelStyle({selectedColor:'#ffd03434'}).indicator({color: '#ffe04040',marginTop:1}))
        }.width('80%')
      }.width('100%').padding({left:16,right:16}).height(80).position({x:0,y:10}).justifyContent(FlexAlign.SpaceBetween).backgroundColor($r('app.color.primary_background_color'))
    }
  }
  @Builder buildMoreMenus(){
    if (this.isShowMOreMenus){
      Column({space:20}){
        Row(){
          Text('功能直达').fontColor(Color.White).fontSize(16).fontWeight(FontWeight.Bold)
          Image($r('app.media.Close_white')).width(24).onClick(()=>this.isShowMOreMenus=false)
        }.width('100%').justifyContent(FlexAlign.SpaceBetween)
        Grid(){

            ForEach(this.MoreMenuList,(item:MoreMenus,index:number)=>{
              GridItem(){
              Column({space:5}){
                Image(item.icon).width(24)
                Text(item.title).fontColor(Color.White).fontSize(13)
              }.backgroundColor('#FF252C2D').width(80).aspectRatio(1).alignItems(HorizontalAlign.Center).justifyContent(FlexAlign.Center).borderRadius(15)
              }.onClick(()=>{
                if (index===0) {
                  router.pushUrl({
                    url:'pages/Index'
                  })
                }else if (index===1) {
                  router.pushUrl({
                    url:'pages/'
                  })
                }
              })
            })

        }.columnsTemplate('1fr 1fr 1fr 1fr').columnsGap(20).rowsGap(20)
      }.width('100%').height(226).position({x:0,y:0}).backgroundColor('#FF596168')
      .borderRadius({bottomLeft:24,bottomRight:24}).padding({top:12,bottom:12,right:16,left:16})
    }
  }
  getProductImage():ProductImages[]{
   const colorList:string[]=this.product.colors??[]
    const color:string=colorList[this.selectedColorIndex]??''
   return(this.product.productImages??[]).filter((productImages:ProductImages):boolean=>{
     return productImages.colors===color
   })
  }
  @Builder buildImageGallery(){
   Stack({alignContent:Alignment.Top}){
     if (this.getProductImage().length>0){
       Swiper(){
         ForEach(this.getProductImage(),(item:ProductImages,index:number)=>{
           Image(item.imgUrl).width('100%').sharedTransition(item.id ?? '',{
             duration:1000
           })
             .onClick(()=>{
               router.pushUrl({
                 url:'pages/ProductImage',
                 params:{
                   selectedIndex:this.selectedIndex,
                   productImages:this.getProductImage()
                 }
               })
             })
         })
       }.width('100%').height('100%').indicator(Indicator.dot().selectedColor(Color.Gray)).backgroundColor(Color.White)
       .onChange((index:number)=>{
         this.selectedIndex=index
       })

       Text(`${this.selectedIndex+1}/${this.getProductImage().length}`).position({x:'88%',y:'92%'}).fontColor(Color.Black).backgroundColor('#EEEEEE').padding(4).borderRadius(12)
     }

   }.width('100%').height(360)
  }
  getVersion():string{
   const versionList:string[]=this.product.versions??[]
    return versionList[this.selectedVersionIndex]??''
  }
  getColor():string{
   const colorList:string[]=this.product.colors??[]
    return colorList[this.selectedColorIndex]??''
  }

  @Builder buildProductTitle(){
    Column(){
      Text(`￥${this.product.price}`).fontColor(Color.Red).fontSize(22)
      Text(`${this.product.title} ${this.getVersion()}${this.getColor()}`)
      Row(){
        Text(this.product.promotion ?? '')
          .fontColor(Color.Red)
          .fontSize(14)
          .layoutWeight(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(this.isShowFullProductPromotion ? 100 : 2)
        Image(this.isShowFullProductPromotion ? $r('app.media.up') : $r('app.media.down'))
          .width(14)
          .margin({ bottom: 5 })
          .onClick(() => {
            this.isShowFullProductPromotion = !this.isShowFullProductPromotion
          })
      }.alignItems(VerticalAlign.Bottom)
      Row({space:5}){
        Text('优惠').fontSize(14)
        Column({space:5}){
          Row({space:5}){
            Text('以旧换新补贴').border({width:1,color:Color.Red}).borderRadius(2).fontColor(Color.Red).padding({top:1,bottom:1,left:4,right:4}).fontSize(12)
            Text('以旧换新至高补1000').fontSize(14)
          }.width('100%')
          Row({space:5}){
            Text('支付成功赠券').border({width:1,color:Color.Red}).borderRadius(2).fontColor(Color.Red).padding({top:1,bottom:1,left:4,right:4}).fontSize(12)
            Text('支付成功赠好物券').fontSize(14)
          }.width('100%')
          Row({space:5}){
            Text('分区免息').border({width:1,color:Color.Red}).borderRadius(2).fontColor(Color.Red).padding({top:1,bottom:1,left:4,right:4}).fontSize(12)
            Text('赠送积分').border({width:1,color:Color.Red}).borderRadius(2).fontColor(Color.Red).padding({top:1,bottom:1,left:4,right:4}).fontSize(12)
          }.width('100%')
        }
      }.alignItems(VerticalAlign.Top).margin({top:10})
    }
    .width('100%')
    .padding({ top: 12, right: 16, bottom: 12, left: 16 })
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Color.White)
    .borderRadius(16)
  }

  @Builder buildSpecList(){

   Column({space:10}){
     Row({space:12}){
       Text('颜色')
       Row({space:12}) {
         ForEach(this.product.colors,(color:string,index:number)=>{
           Text(color).fontSize(14).padding({top: 4, bottom: 4, left: 12, right: 12}).margin(0).backgroundColor(
             '#fff5f5f5').borderRadius(5).onClick(()=>{
             this.selectedColorIndex=index
           })
             .fontColor(this.selectedColorIndex===index?Color.Red:Color.Black).border({width:1,color:this.selectedColorIndex===index?Color.Red:Color.Transparent})
         })
       }
     }.width('100%').justifyContent(FlexAlign.Start)
     Row({space:12}){
       Row(){
         Text('版本')
       }.alignItems(VerticalAlign.Top).margin({top:10})
       Flex({wrap:FlexWrap.Wrap}){
         ForEach(this.product.versions,(version:string,index:number)=>{
           Text(version).fontSize(14).padding({top: 4, bottom: 4, left: 12, right: 12}).margin({left:6,right:6,top:5,bottom:5}).backgroundColor('#fff5f5f5').borderRadius(5).onClick(()=>{
             this.selectedVersionIndex=index
           })
             .fontColor(this.selectedVersionIndex===index?Color.Red:Color.Black).border({width:1,color:this.selectedVersionIndex===index?Color.Red:Color.Transparent})
         })
       }
     }.width('100%').justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Top)
     Row({space:12}){
       Text('数量')
       Button('-').height(22).aspectRatio(1).backgroundColor('#fff5f5f5').padding(0).fontColor(Color.Black).onClick(()=>{this.count--}).enabled(this.count>1)
       Text(this.count.toString())
       Button('+').height(22).aspectRatio(1).backgroundColor('#fff5f5f5').padding(0).fontColor(Color.Black).onClick(()=>{this.count++})
     }.width('100%').justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Top)
   }.width('100%').backgroundColor(Color.White)
  }

  @Builder buildProductSpec(){
   Column(){
     this.buildSpecList()
     }.width('100%').padding({left:16,right:16,top:6,bottom:6}).margin({top:12}).backgroundColor(Color.White).borderRadius(16)
   }

  @Builder buildProductInfo(){
   Column(){
     this.buildProductTitle()
     this.buildProductSpec()
   }.width('100%').padding({left:16,right:16}).margin({top:12})
  }

  @Builder buildProductContent(){
   Column(){
     Scroll(){
       Column(){
         this.buildImageGallery()
         this.buildProductInfo()
       }
     }
   }.width('100%').height('100%').padding({bottom:56,top:10,})
  }
  @Builder buildNavigator(){
   if (!this.isShowHeader){
     Row(){
       Row(){
         Image($r('app.media.Back_White')).width(24).aspectRatio(1)
       }.width(32).height(32).padding(4).backgroundColor('rgba(0,0,0,0.4)').borderRadius(16).justifyContent(FlexAlign.Center)
       .onClick(()=>{
         router.back()
       })
       Row(){
         Image($r('app.media.more_white')).width(24).aspectRatio(1)
       }.width(32).height(32).padding(4).backgroundColor('rgba(0,0,0,0.4)').borderRadius(16).justifyContent(FlexAlign.Center)
       .onClick(()=>{
         this.isShowMOreMenus=!this.isShowMOreMenus
       })
     }.width('100%').height(56).padding({left:16,right:16}).justifyContent(FlexAlign.SpaceBetween)
     .position({x:0,y:0})
   }
  }

  getCurrentImageUrl(): string {
    const images: ProductImages[] = this.getProductImage()
    return images.length > 0 ? images[0].imgUrl : (this.product.imgUrl ?? '')
  }

  @Builder buildChooseSpecHeader(){
   Column(){
     Row(){
       Row().width(32).height(4).background('rgba(0,0,0,0.2)').borderRadius(2)
     }.width('100%').height(20).justifyContent(FlexAlign.Center)
     Stack({alignContent:Alignment.TopEnd}){
       Row(){
         Image(this.getCurrentImageUrl()).width(96).aspectRatio(1)
         Column(){
           Text(`￥${(this.product.price??0)*this.count}`).fontColor(Color.Red)
           Text(`已选: ${this.getColor()}  ${this.getVersion()}×${this.count}`)
         }.alignItems(HorizontalAlign.Start)
       }.width('100%').padding({top:20,right:16,bottom:8,left:16})
       Row(){
         Image($r('app.media.close')).width(14)
       }.width(32).height(32).borderRadius(16).justifyContent(FlexAlign.Center).margin({right:16})
       .onClick(()=>{
         this.hideChooseSpec()
       })
     }
   }.width('100%').position({x:0,y:0})
  }
  @Builder buildChooseSpecMain(){
    Column(){
      this.buildSpecList()
    }.width('100%').padding({top:144,right:16,bottom:56,left:16})
  }

  addToCart=async ():Promise<void>=>{
   const cartItem:CartItem=CartItem.fromJSON({
     product:this.product,
     color:this.getColor(),
     version:this.getVersion(),
     count:this.count,
     checked:true
   })
    const context=this.getUIContext().getHostContext()
    if (context) {
      const ok:boolean=await CartService.addToCart(context,cartItem)
      if (ok) {
        this.getUIContext().getPromptAction().showToast({
          message:'已加入购物车'
        })
        this.loadCart()
      }
    }
  }
  @Builder buildChooseSpecFooter(){
    Row(){
      Button('加入购物车').fontColor(Color.White).backgroundColor('#FFF3A64B').borderRadius({topLeft:18,bottomLeft:18,topRight:0,bottomRight:0}).width(170)
        .onClick(()=>{
          this.hideChooseSpec()
          this.addToCart()
        })
      Button('立即购买').fontColor(Color.White).backgroundColor('#FFE0362A').borderRadius({topLeft:0,bottomLeft:0,topRight:18,bottomRight:18}).width(170)
    }
  }

  @Builder buildChooseSpec(){
    if (this.isShowChooseSpec){
      Stack({alignContent:Alignment.Bottom}){
        this.buildChooseSpecMain()
        this.buildChooseSpecHeader()
        this.buildChooseSpecFooter()
      }.width('100%').backgroundColor(Color.White).borderRadius(16)
    }
  }
  hideChooseSpec=()=>{
    this.isShowMask=false
    this.isShowChooseSpec=false
  }
  showChooseSpec=()=>{
    this.isShowMask=true
    this.isShowChooseSpec=true
  }


  @Builder buildMask(){
   if (this.isShowMask){
     Row(){

     }.width('100%').height('100%').backgroundColor(Color.Gray).opacity(0.7)
     .onClick(()=>{
       this.hideChooseSpec()
     })
   }
  }

  build() {
    Stack({alignContent:Alignment.Bottom}){
      this.buildProductContent()
      this.buildOperationArea()
      this.buildProductDetailHeader()
      this.buildNavigator()
      this.buildMoreMenus()
      this.buildMask()
      this.buildChooseSpec()
    }.width('100%').height('100%').backgroundColor($r('app.color.primary_background_color'))
  }
  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: 0 })
    PageTransitionExit({ type: RouteType.None, duration: 0 })
  }
}
