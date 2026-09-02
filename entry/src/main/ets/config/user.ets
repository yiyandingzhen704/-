import { router } from "@kit.ArkUI"
import { UserService } from '../services/UserService'
import { UserInfo } from '../types/UserInfo'

@Component
export  struct user {
  aboutToAppear() {
    const context = this.getUIContext().getHostContext()
    if (context) {
      UserService.getUserInfo(context).then((userInfo: UserInfo | null) => {
        if (userInfo) {
          this.isLoggedIn = userInfo.isLoggedIn
          this.userName = userInfo.phone
        }
      })
    }
  }
  @State isLoggedIn: boolean = false
  @State userName: string = ''
@State showNavigator:boolean=false
scroller:Scroller=new Scroller()
  @Builder buildPersonalNavigator(){
  if (this.showNavigator){
    Stack({alignContent:Alignment.Top}){
      Image($r('app.media.navigator_Bg')).width('100%').height('100%').objectFit(ImageFit.Cover)
      Row(){
        Row(){
          Image($r('app.media.ic_avatar')).width(32).aspectRatio(1)
          Text('登录/注册').fontColor(Color.White).fontSize(18).margin({left:12})
        }.margin({left:12})
        .onClick(()=>{
          router.pushUrl(({
            url:'pages/RegisterPhone'

          }))
        })
        Row(){
          Image($r('app.media.icon_setting')).width(24).aspectRatio(1)
          Image($r('app.media.message')).width(24).aspectRatio(1).margin({left:12})
        }.margin({right:12})
      }.width('100%').height('100%').justifyContent(FlexAlign.SpaceBetween)
    }.width('100%').height(56)
  }
  }
  @Builder buildPersonalHeader(){
  Stack({alignContent:Alignment.Top}){
    Image($r('app.media.head_bg')).width('100%').height(200).objectFit(ImageFit.Cover)
    Column(){
      Row(){
        Image($r('app.media.icon_setting')).width(24).aspectRatio(1)
        Image($r('app.media.message')).width(24).aspectRatio(1).margin({left:12})
      }.width(328).padding({top:16}).justifyContent(FlexAlign.End)
      Row(){
        Image($r('app.media.ic_avatar')).width(48).aspectRatio(1)
        if (this.isLoggedIn) {
          Text(this.userName).fontColor(Color.White).fontSize(18).margin({ left: 12 })
        } else {
          Text('登录/注册').fontColor(Color.White).fontSize(18).margin({ left: 12 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/RegisterPhone' })
            })
        }
      }.width(328)

      Row(){
        Column(){
          Text('--').fontColor(Color.White)
          Text('积分').fontColor(Color.White).opacity(.6)
        }
        Column(){
          Text('--').fontColor(Color.White)
          Text('优惠券').fontColor(Color.White).opacity(.6)
        }
        Column(){
          Text('--').fontColor(Color.White)
          Text('代金券').fontColor(Color.White).opacity(.6)
        }

      }.width(328).height(35).padding({left:20,right:20}).justifyContent(FlexAlign.SpaceEvenly)
      .margin({top :12})
    }

  }
  }

  @Builder buildOrders(){
  Row(){
    Column(){
      Row(){
        Text('我的订单').fontSize(18).fontWeight(FontWeight.Bold)
        Text('全部订单>').fontSize(14).opacity(.6)
      }.width('100%').justifyContent(FlexAlign.SpaceBetween).padding(12)
      Row(){
        Column({space:10}){
          Image($r('app.media.icon_payment')).width(24).aspectRatio(1)
          Text('待付款').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
        Column({space:10}){
          Image($r('app.media.icon_pending')).width(24).aspectRatio(1)
          Text('待收货').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
        Column({space:10}){
          Image($r('app.media.icon_review')).width(24).aspectRatio(1)
          Text('待评价').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
        Column({space:10}){
          Image($r('app.media.icon_return')).width(24).aspectRatio(1)
          Text('退换退款').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
        Column({space:10}){
          Image($r('app.media.icon_reycle')).width(24).aspectRatio(1)
          Text('回收单').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
      }.width('100%').justifyContent(FlexAlign.SpaceAround).padding(12).margin({bottom:12})
    }.width(328).backgroundColor(Color.White).borderRadius(16)
  }.width('100%').padding({left:16,right:16})
  }
@Builder buildServices(){
  Row(){
    Column(){
      Row(){
        Text('我的服务').fontSize(18).fontWeight(FontWeight.Bold)
        Text('在线咨询>').fontSize(14).opacity(.6)
      }.justifyContent(FlexAlign.SpaceBetween).backgroundColor(Color.White).width('100%').padding(12)
      Row(){
        Column({space:10}){
          Image($r('app.media.icon_shouhou')).width(24).aspectRatio(1)
          Text('待付款').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
        Column({space:10}){
          Image($r('app.media.icon_kefu')).width(24).aspectRatio(1)
          Text('待收货').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
        Column({space:10}){
          Image($r('app.media.icon_shangdian')).width(24).aspectRatio(1)
          Text('待评价').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
        Column({space:10}){
          Image($r('app.media.icon_huanxin')).width(24).aspectRatio(1)
          Text('退换退款').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
        Column({space:10}){
          Image($r('app.media.icon_weixiu')).width(24).aspectRatio(1)
          Text('回收单').fontSize(14)
        }.alignItems(HorizontalAlign.Center)
      }.width('100%').justifyContent(FlexAlign.SpaceAround).padding(12).margin({bottom:12})
    }.width(328).backgroundColor(Color.White).borderRadius(16)
  }.width('100%').padding({left:16,right:16})
}

@Builder buildCommonlyUsed(){
  Row(){
    List({space:8}){
      ListItem(){
        Column({space:10}){
          Image($r('app.media.icon_mypoint')).width(24).aspectRatio(1)
          Text('我的积分').fontSize(14)
        }.alignItems(HorizontalAlign.Center).padding({top:8,bottom:8}).margin({left:12})
      }.width(72)
      ListItem(){
        Column({space:10}){
          Image($r('app.media.icon_gonggao')).width(24).aspectRatio(1)
          Text('商城公告').fontSize(14)
        }.alignItems(HorizontalAlign.Center).padding({top:8,bottom:8}).margin({left:12})
      }.width(72)
      ListItem(){
        Column({space:10}){
          Image($r('app.media.icon_fankui')).width(24).aspectRatio(1)
          Text('体验反馈').fontSize(14)
        }.alignItems(HorizontalAlign.Center).padding({top:8,bottom:8}).margin({left:12})
      }.width(72)
      ListItem(){
        Column({space:10}){
          Image($r('app.media.icon_youhui')).width(24).aspectRatio(1)
          Text('优购码').fontSize(14)
        }.alignItems(HorizontalAlign.Center).padding({top:8,bottom:8}).margin({left:12})
      }.width(72)
      ListItem(){
        Column({space:10}){
          Image($r('app.media.icon_huiyuan')).width(24).aspectRatio(1)
          Text('会员频道').fontSize(14)
        }.alignItems(HorizontalAlign.Center).padding({top:8,bottom:8}).margin({left:12})
      }.width(72)
      ListItem(){
        Column({space:10}){
          Image($r('app.media.icon_jiaoyu')).width(24).aspectRatio(1)
          Text('教育购').fontSize(14)
        }.alignItems(HorizontalAlign.Center).padding({top:8,bottom:8}).margin({left:12})
      }.width(72)
      ListItem(){
        Column({space:10}){
          Image($r('app.media.icon_card')).width(24).aspectRatio(1)
          Text('HWCard').fontSize(14)
        }.alignItems(HorizontalAlign.Center).padding({top:8,bottom:8}).margin({left:12})
      }.width(72)
    }.scrollBar(BarState.Off).edgeEffect(EdgeEffect.None).listDirection(Axis.Horizontal).backgroundColor(Color.White)
    .borderRadius(16).width('100%')
  }.padding({left:16,right:16}).width('100%')
}

@Builder buildQiandaoAndDiaoyan(){
  Row(){
    Image($r('app.media.qiandao')).width(50).aspectRatio(1)
    Column(){
      Text('签到赚积分').fontWeight(FontWeight.Bold).fontSize(16)
      Text('连续签到7天最高可获得291积分').fontSize(11).opacity(0.6)
    }.alignItems(HorizontalAlign.Start).height(40).justifyContent(FlexAlign.SpaceBetween)
Blank()
    Button('去签到').backgroundColor(Color.Transparent).fontColor(Color.Black).border({color:Color.Black,width:1}).fontSize(12).padding({top:5,bottom:5,left:10,right:10})
  }.width(328).backgroundColor(Color.White).borderRadius(16).padding(10)
  Row(){
    Image($r('app.media.diaoyan')).width(30).aspectRatio(1).margin({left:10,right:10})
    Column(){
      Text('用户体验调研').fontWeight(FontWeight.Bold).fontSize(16)
      Text('您是否愿意向亲友推荐华为商城').fontSize(11).opacity(0.6)
    }.alignItems(HorizontalAlign.Start).height(40).justifyContent(FlexAlign.SpaceBetween)
    Blank()
    Button('去打分').backgroundColor(Color.Transparent).fontColor(Color.Black).border({color:Color.Black,width:1}).fontSize(12).padding({top:5,bottom:5,left:10,right:10})
  }.width(328).backgroundColor(Color.White).borderRadius(16).padding(10)

}

  @Builder buildPersonalContent(){
  Column(){
    Scroll(this.scroller){
      Column({space:12}){
        this.buildPersonalHeader()
        this.buildOrders()
        this.buildServices()
        this.buildCommonlyUsed()
        this.buildQiandaoAndDiaoyan()
      }
    }
  }.width('100%').height('100%')
  }
  build() {
    Stack({alignContent:Alignment.Top}){
      this.buildPersonalNavigator()
      this.buildPersonalContent()
    }.width('100%').height('100%').backgroundColor($r('app.color.primary_background_color'))
  }
}