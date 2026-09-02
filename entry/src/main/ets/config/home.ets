import { Banner } from "../types/banner";
import { HttpService } from "../services/HttpService"
import { homeTabItem, homeTabList } from "./tabs";
import { NavigationMenu } from "../types/NavigationMenu";
import { Product } from "../types/Product";
import { Category } from "../types/Catefory";
import { RECOMMEND_PAGE_SIZE ,SCREEN_HEIGHT} from "../config/constants";
import {GuessYouLike  } from "../components/GuessYouLike";
import { router } from "@kit.ArkUI";
import { UserService } from "../services/UserService";
import { UserInfo } from "../types/UserInfo";

@Preview
@Component
export struct home {
  @State banner:Banner[]=[]
  @State navigationMenus:NavigationMenu[]=[]
  @State premiumProducts:Product[]=[]
  @State categories:Category[]=[]
  @State recommendedProducts:Product[]=[]
  @State recommendedProductsPage:number=1//当前加载到哪一页了
  @State hasMoreRecommendedProducts:boolean=true//是否有更多的猜你喜欢数据
  @State loadingMoreProducts:boolean=false //是否正在加载下一页踩你喜欢的数据
  @State showBackTop:boolean=false
  scroller:Scroller=new Scroller()


  aboutToAppear() {
    const context=this.getUIContext().getHostContext()
    if (context) {
      UserService.getUserInfo(context).then((userInfo:UserInfo|null)=>{
        if (userInfo) {
          this.isLoggedIn=userInfo.isLoggedIn
          this.userName=userInfo.phone
        }
      })
    }
    this.fetchBanner()
    this.fetchNavigationMenu()
    this.fetchPremiumProducts()
    this.fetchCategory()
    this.fetchRecommendedProducts()
  }

 async fetchRecommendedProducts(page:number=1){
    const response = await HttpService.get<Product[]>(`/products?isRecommended=true&_page=${page}&_limit=${RECOMMEND_PAGE_SIZE}`)
     if (response.success) {
       const newProducts=response.data
       if (page===1) {
         //如果是第一页则直接赋值，如果不是会第一页就和之前数据合并
         this.recommendedProducts=response.data
       }else {
         this.recommendedProducts=[...this.recommendedProducts,...response.data]
       }
       //如果没有取满一页的数据，则证明到底了，没有更多数据了
       if (newProducts.length<RECOMMEND_PAGE_SIZE) {
         this.hasMoreRecommendedProducts=false
       }
     } else{
      console.log('获取RecommendedProducts商品失败',response.message)
    }
  }
  loadMoreProducts = async  ()=>{
    //如果后面还有更多的数据，并且当前没有处于加载下一页的状态中
    if (this.hasMoreRecommendedProducts && !this.loadingMoreProducts) {
      this.loadingMoreProducts=true
      this.fetchRecommendedProducts(this.recommendedProductsPage+1).then(()=>{
        this.recommendedProductsPage++
        this.loadingMoreProducts=false
      })
    }
  }

  private async fetchCategory(){
    const response = await HttpService.get<Category[]>("/categories?_embed=products")
    if (response.success&&response.data) {
      this.categories=response.data
    }else{
      console.log('获取商品失败',response.message)
    }
  }
  private async fetchPremiumProducts(){
    const response = await HttpService.get<Product[]>("/premiumProducts")
    if (response.success&&response.data) {
      this.premiumProducts=response.data
    }else{
      console.log('获取推荐商品失败',response.message)
    }
  }
  private async fetchNavigationMenu(){
    const response = await HttpService.get<NavigationMenu[]>("/navigationMenus")
    if (response.success&&response.data) {
      this.navigationMenus=response.data
    }else{
      console.log('获取Menu失败',response.message)
    }
  }
  private async fetchBanner(){
    const response = await HttpService.get<Banner[]>("/banners")
    if (response.success&&response.data) {
      this.banner=response.data
    }else{
      console.log('获取banner失败',response.message)
    }
  }

  @State isLoggedIn:boolean=false
  @State userName:string=''


  @State currentIndex:number=0
  @Builder tabbuilder(title:string,index:number){
    Column(){
      Text(title).fontSize(16).fontWeight(this.currentIndex==index?FontWeight.Bold:FontWeight.Normal).fontColor(Color.Black)
      Row()
        .width(30)
        .height(this.currentIndex === index ? 3 : 1)  // 选中时变粗
        .backgroundColor(Color.Black)
        .borderRadius(2)
    }.width('100%').height(50)
  }
  @Builder buildhomeHeader(){
    Row(){
      Image($r('app.media.logo_app')).width(80).height(26).margin({right:16})
      Search({value:"mate60"}).width(135).height(40).margin({right:16})
      Image($r('app.media.message')).width(30).aspectRatio(1)
      if (this.isLoggedIn){
        Text(this.userName).margin({left:16}).fontSize(14)
      }else {
        Text('登录').margin({left:16}).fontSize(14)
          .onClick(()=>{
            router.pushUrl({
              url:'pages/Login'
            })
          })
      }

    }.width('100%').height(58).padding({left:16,right:16})
  }

@Builder buildNavigation(){
   Tabs({barPosition:BarPosition.Start}){
     ForEach(homeTabList,(item:homeTabItem,index:number)=>{
       TabContent(){

       }.tabBar(this.tabbuilder(item.title,index))
     })
   }.width('100%').margin({top:10
   }).height(50).onChange((index:number)=>{
     this.currentIndex=index
   }).animationDuration(0)
}

@Builder buildSwiper(){
    Row(){
      if (this.banner.length>0){
        Swiper(){
          ForEach(this.banner,(item:Banner)=>{
            Image(item.imageUrl)
          })

        }.width(328).borderRadius(20).indicator(Indicator.dot().selectedColor(Color.Gray)).autoPlay(true).loop(true).interval(3000)

      }
    }.width('100%').height(160).justifyContent(FlexAlign.Center).margin({top:10})
}
@Builder buildNavigationMenu(){
  Swiper(){
    Grid(){
      ForEach(this.navigationMenus.slice(0,10),(item:NavigationMenu)=>{
        GridItem(){
          Column({space:5}){
            Image(item.iconUrl).width(48).aspectRatio(1).borderRadius(10)
            Text(item.title).fontSize(12)
          }.alignItems(HorizontalAlign.Center).size({width:'100%',height:'100%'})
        }
      })
    }.columnsTemplate('1fr 1fr 1fr 1fr 1fr').rowsTemplate('1fr 1fr')
    Grid(){
      ForEach(this.navigationMenus.slice(10,20),(item:NavigationMenu)=>{
        GridItem(){
          Column({space:5}){
            Image(item.iconUrl).width(48).aspectRatio(1).borderRadius(10)
            Text(item.title).fontSize(12)
          }.alignItems(HorizontalAlign.Center).size({width:'100%',height:'100%'})
        }
      })
    }.columnsTemplate('1fr 1fr 1fr 1fr 1fr').rowsTemplate('1fr 1fr')
  }.width('100%').height(160).margin({top :10,}).indicator(Indicator.dot().selectedColor(Color.Gray))
}
@Builder buildNewcomerBenefits(){
    Row(){
      Image($r('app.media.swiper6')).width(327).height(170)
    }.width('100%').padding({left:16,right:16})
}
@Builder renderPremiumProduct(product:Product){
Column(){
  Image(product.imgUrl).width('100%').height(218).objectFit(ImageFit.ScaleDown)
  Text(product.title).fontWeight(FontWeight.Bold)
  Text(product.subtitle).fontColor(Color.Gray)
  Row(){
    Text(`￥${product.price}`)
    Button('立即购买').fontWeight(FontWeight.Bold).backgroundColor($r('app.color.primary_background_color'))
      .padding({top:8,bottom:8,left:16,right:16})
  }.width('100%').justifyContent(FlexAlign.SpaceBetween).onClick(() => {
    router.pushUrl({
      url: 'pages/ProductDetail',
      params: { product_id: product.productId }    })
  })
}.height(324).alignItems(HorizontalAlign.Start).padding({left:16,right:16}).onClick(() => {
  router.pushUrl({
    url: 'pages/ProductDetail',
    params: { product_id: product.productId }  })
})

  }
@Builder buildPremium(){
    Column(){
    Stack({alignContent:Alignment.TopStart}){
      if (this.premiumProducts.length>0){
        Swiper(){
          ForEach(this.premiumProducts,(item:Product)=>{
            this.renderPremiumProduct(item)
          })
        }.width('100%').backgroundColor(Color.White).borderRadius(20)
        Text('甄选推荐').fontWeight(FontWeight.Bold).margin({left:16,top:16})
      }

    }
    }.width('100%').margin({top:8}).padding({left:16,right:16})
  }
  @Builder renderAreaTitle(name:string){
    Row(){
      Text(`${name}专区`).fontWeight(FontWeight.Bold).margin({left:10})
      Row(){
        Text('更多')
        Image($r('app.media.right_arrow')).width(17).height(19)
      }
    }.width('100%').justifyContent(FlexAlign.SpaceBetween)
  }
  @Builder renderAreaProducts(products: Product[]) {
    Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceBetween }) {
      ForEach(products, (product: Product) => {
        Column() {
          Image(product.imgUrl)
            .width(102)
            .aspectRatio(1)
          Text(product.title)
            .fontSize(14)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          Text(`￥${product.price}`)
            .fontWeight(FontWeight.Bold)
        }
        .width('50%')
        .height(177)
        .justifyContent(FlexAlign.SpaceAround)
        .padding(5)
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/ProductDetail',
            params: { product_id: product.id }
          })
        })
      })
    }
    .width('100%')
  }
  @Builder buildArea() {
    ForEach(this.categories, (item: Category) => {
      Column() {
        this.renderAreaTitle(item.name)
        this.renderAreaProducts(item.products ?? [])
      }
      .width('90%')
      .padding({ left: 16, right: 16, top: 8, bottom: 8 })
      .borderRadius(16)
      .backgroundColor(Color.White)
      .margin({top:8, bottom: 8 })
    })
  }



@Builder buildGuessYouLike(){
GuessYouLike({recommendedProducts:$recommendedProducts})
}

  @Builder buildHomeContent(){
    Column(){
      Scroll(this.scroller){
        Column(){
          this.buildNavigation()
          this.buildSwiper()
          this.buildNavigationMenu()
          this.buildNewcomerBenefits()
          this.buildPremium()
          this.buildArea()
          this.buildGuessYouLike()
        }
      }.edgeEffect(EdgeEffect.None).onScrollEdge(this.loadMoreProducts)
      .onDidScroll((xOffset: number, yOffset: number, scrollState: ScrollState) => {
        // 使用 scrollState 参数可以获得更详细的滚动状态 (如 Fling, Scroll 等)
        this.showBackTop = this.scroller.currentOffset().yOffset > SCREEN_HEIGHT
      })
    }.width('100%').height('100%').padding({top:50})
  }

  backToTop=()=>{
    this.scroller.scrollTo({
      xOffset:0,
      yOffset:0
    })
  }
  @Builder buildBackTop(){
if (this.showBackTop){
  Row(){
    Image($r('app.media.back_top')).width(24).aspectRatio(1)
  }.width(40).aspectRatio(1).borderRadius(20)
  .backgroundColor(Color.White).justifyContent(FlexAlign.Center).position({x:'85%',y:'93%'})
  .onClick(this.backToTop)
}
  }
  build() {
   Stack({alignContent:Alignment.Top}) {
     this.buildHomeContent()
     this.buildhomeHeader()
     this.buildBackTop()
    }.width('100%').height('100%').backgroundColor($r('app.color.primary_background_color'))
  }
}
