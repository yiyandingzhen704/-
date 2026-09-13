import { UserService } from '../services/UserService'
import { UserInfo } from '../types/UserInfo'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct Login {
  @State phone:string=''
  @State password:string=''
  @State userInfo:UserInfo|null=null

  aboutToAppear(): void {
    this.loadUserInfo()
  }
  async loadUserInfo(){
    const context = this.getUIContext().getHostContext()
    if (context) {
      this.userInfo=await UserService.getUserInfo(context)
      if (this.userInfo) {

        if (this.userInfo.isLoggedIn) {
          router.pushUrl({
            url:'pages/Index'
          })
        }else {
          this.phone=this.userInfo.phone
          this.password=this.userInfo.password
        }
      }
    }
  }



  build() {
    Column({space:20}){
      Image($r('app.media.huawei')).width(60)
      Text('华为账号').fontSize(25).fontWeight(FontWeight.Bolder)
      Text('登录账号以使用更多服务').opacity(0.6)
      TextInput({placeholder:'手机号',text:$$this.phone}).type(InputType.PhoneNumber).borderRadius(0).backgroundColor(Color.Transparent)
        .border({width:{bottom:1}})
      TextInput({placeholder:'密码',text:$$this.password}).type(InputType.Password).borderRadius(0).backgroundColor(Color.Transparent)
        .border({width:{bottom:1}})
      Button('登录').width('90%')
        .onClick(()=>{
          if (this.userInfo&&this.phone===this.userInfo.phone&&this.password===this.userInfo.password) {
            this.userInfo.isLoggedIn=true
            const context=this.getUIContext().getHostContext()
            if (context) {
              UserService.setUserInfo(context,this.userInfo)
            }
            router.pushUrl({
              url:'pages/Index'
            })

            } else {
            this.getUIContext().getPromptAction().showToast({
              message:'账号或密码错误'
            })
          }
        })
      Button('注册账号').width('90%').backgroundColor('#ffdddddd').fontColor('#ff2695ff').onClick(()=>{
        router.pushUrl({
          url:'pages/RegisterPhone'
        })
      })

    }.padding(20).alignItems(HorizontalAlign.Center)
    .height('100%')
    .width('100%')
  }
}