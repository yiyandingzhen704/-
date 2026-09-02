import { TabItem, tabList } from "ets/config/tabs";
import { cart } from "../config/cart"
import { home } from "../config/home"
import { user } from "../config/user"
import { router } from "@kit.ArkUI";
import { CartService } from "../services/CartService";
import { CartItem } from '../models/CartItem'
@Entry
@Component

struct Index {
  @State cartItems: CartItem[] = []
 tabscontroller:TabsController=new TabsController()
  @State slcIndex:number=0
  @Builder TabsBuilder(item:TabItem){
    Column({space:5}){
      if (item.index===1){
        Badge({
          count:CartItem.getTotalAmount(this.cartItems),
          position:BadgePosition.RightTop,
          style:{badgeSize:14,badgeColor:Color.Red}
        }){
          Image(this.slcIndex == item.index ? item.slcicon : item.icon).aspectRatio(1).height(25)
        }
      }else {
        Image(this.slcIndex==item.index?item.slcicon:item.icon).aspectRatio(1).height(25)

      }
    Text(item.title).fontColor(this.slcIndex==item.index?'#1677FF':Color.Black)
  }.width('100%').height('100%').justifyContent(FlexAlign.Center).backgroundColor($r('app.color.primary_background_color'))
  }
aboutToAppear(): void {
   this.loadCart()
  const params:Record<string,number>|undefined=router.getParams()as Record<string,number>
  if (params&&params['targetTabIndex']!==undefined) {
    this.slcIndex=params['targetTabIndex']
    setTimeout(()=>{
      this.tabscontroller.changeIndex(params['targetTabIndex'])
    },100)
  }
}

async loadCart():Promise<void>{
   const context=this.getUIContext().getHostContext()
  if (context) {
    this.cartItems=await CartService.getCart(context)
  }
}

@Builder getTabcontent(index:number){
    if (index==0){
      home()
    }else if (index==1) {
      cart()
    }else if (index==2) {
      user()
    }
}

  build() {
    Column(){
      Tabs({barPosition:BarPosition.End ,controller:this.tabscontroller}){
        ForEach(tabList,(item:TabItem)=>{
          TabContent(){
            this.getTabcontent(item.index)
          }.tabBar(this.TabsBuilder(item))
        })
      }.onChange((index:number)=>{
        this.slcIndex=index
      }).animationDuration(0)
    }.width('100%').height('100%')
  }
}
