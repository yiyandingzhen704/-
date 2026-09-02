import { router } from '@kit.ArkUI'
import { UserService } from '../services/UserService'
import { RegisterInfo } from '../types/RegisterInfo'
import { UserInfo } from '../types/UserInfo'

@Entry
@Component
struct RegisterPassword {

  @StorageLink('registerInfo') registerInfo:RegisterInfo = {
    phone:'',
    password:''
  }
  @State isPasswordValid:boolean=false
  @State PasswordConfirm:string=''
  @State isPasswordConfirmed:boolean=false

  validatePassword(value:string):boolean {
    const PasswordReg= new RegExp('^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z0-9]{8,}$')
    return PasswordReg.test(value)
  }
  validateConfirmPassword():boolean{
    return this.registerInfo.password===this.PasswordConfirm&&this.PasswordConfirm.length>0
  }
  build() {
    Column({space:10}){
      Text('设置密码').fontSize(22)
      Text('设置安全系数高的密码，以保护您的账号安全').opacity(0.6)

      Column(){
        TextInput({placeholder:'密码'}).borderRadius(0).backgroundColor(Color.Transparent).margin({left:-12,top:40})
          .border({width:{bottom:1}}).type(InputType.Password)
          .onChange((value:string)=>{
            this.registerInfo.password=value
            this.isPasswordValid=this.validatePassword(value)
            console.log(`${this.isPasswordValid}`)
          })
        TextInput({placeholder:'确认密码'}).borderRadius(0).backgroundColor(Color.Transparent).margin({left:-12,top:20,bottom:20})
          .type(InputType.Password).border({width:{bottom:1}})
          .onChange((value:string)=>{
            this.PasswordConfirm=value
            const isMatch=this.validateConfirmPassword()
            if (this.PasswordConfirm.length>=this.registerInfo.password.length&&!isMatch) {
              this.getUIContext().getPromptAction().showToast({
                message:'两遍密码不一致'
              })
            }
            this.isPasswordConfirmed=isMatch
            console.log(`${this.isPasswordConfirmed}`)
          })
      }.width('100%').padding(12)
      Column(){
          Text('密码需满足以下要求:').fontSize(18).opacity(0.6)
        Row(){
          Image(this.registerInfo.password.length>=8?$r('app.media.confirm'):$r('app.media.unconfirmed')).width(20)
          Text('至少八个字符').opacity(0.6)
        }.margin({top:10})
        Row(){
          Image(this.isPasswordValid?$r('app.media.confirm'):$r('app.media.unconfirmed')).width(20)
          Text('至少包含数字和字母，且不能包含空格等特殊符号').opacity(0.6).padding({right:12})
        }.alignItems(VerticalAlign.Top).margin({top:10})
      }.width('100%').alignItems(HorizontalAlign.Start).padding(12)
      Blank()
      Row(){
        Button('<上一步').fontSize(18).backgroundColor(Color.Transparent).fontColor(Color.Black)
          .onClick(()=>{
            router.back()
        })
        Button('下一步>').fontSize(18).backgroundColor(Color.Transparent).fontColor(Color.Black).enabled(this.isPasswordValid&&this.isPasswordConfirmed)
          .onClick(()=>{
            if (!this.isPasswordValid||!this.isPasswordConfirmed) {
              this.getUIContext().getPromptAction().showToast({
                message:'密码不符合要求'
              })
              return
            }
            const userInfo:UserInfo={
              phone:this.registerInfo.phone,
              password:this.registerInfo.password,
              nickname:'',
              isLoggedIn:false,
              token:''
            }
            const context=this.getUIContext().getHostContext()
            if (context) {
              UserService.setUserInfo(context,userInfo)
            }
            router.pushUrl({
              url:'pages/Login'
            })
          })
      }.width('100%').justifyContent(FlexAlign.End).padding(12).justifyContent(FlexAlign.SpaceBetween)
    }.width('100%').height('100%').alignItems(HorizontalAlign.Center).padding(12)

  }
}