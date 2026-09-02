import { RegisterInfo } from '../types/RegisterInfo'
import { router, Router } from '@kit.ArkUI'

@Entry
@Component
struct RegisterPhone {

  @StorageLink('registerInfo') registerInfo:RegisterInfo = {
    phone:'',
    password:''
  }
  @State isPhoneValid:boolean=false
  validatePhone(value:string):boolean {
    const phoneReg= new RegExp('^1[3-9]\\d{9}$')
    return phoneReg.test(value)
  }

  validateCode(input:string):boolean{
    return input.length===6&&input==this.generatedCode
  }

  @State generatedCode:string=''
  @State verificationCode:string=''
  @State verificationButtonText:string='获取验证码'
  @State isCountDown:boolean=false
  private countdownSeconds:number=60
  private countdownTimer:number=1
  startCountdown(){
    if (this.isCountDown)return
    this.isCountDown=true
    this.countdownSeconds=60
    this.verificationButtonText=this.countdownSeconds+`秒后重试`
    this.countdownTimer=setInterval(()=>{
      this.countdownSeconds--
      if (this.countdownSeconds<=0) {
        clearInterval(this.countdownTimer)
        this.countdownTimer=-1

this.isCountDown=false
      this.verificationButtonText='获取验证码'}
      else {
        this.verificationButtonText=this.countdownSeconds + `秒后重试`
      }
    },1000)
  }

@State selectedCountry:string='中国(+86)'
  @State selectedIndex:number=0
  @State CountryList:SelectOption[]=[
    {value: '中国 (+86)', },
    { value: '中国香港 (+852)' },
    { value: '中国澳门 (+853)' },
    { value: '中国台湾 (+886)' },
    { value: '美国 (+1)' },
    { value: '英国 (+44)' },
    { value: '日本 (+81)' },
    { value: '韩国 (+82)' },
  ]
  build() {
    Column({space:10}){
      Text('手机号').fontSize(22)
      Text('输入您可用作华为账号的手机号').opacity(0.6)
      Row(){
        Text('国家/地区').fontSize(18)
        Blank()
        Select(this.CountryList).selected(this.selectedIndex) .value(this.selectedCountry)
          .onSelect((index:number,value?:string)=>{
            this.selectedIndex=index
            this.selectedCountry=value??''
          })
      }.width('100%').padding(12)
      Column(){
        TextInput({placeholder:'手机号'}).borderRadius(0).backgroundColor(Color.Transparent).margin({left:-12,})
          .type(InputType.PhoneNumber).maxLength(11)
          .onChange((value:string)=>{
            this.registerInfo.phone=value
            this.isPhoneValid = this.validatePhone(value)
            console.log(`value:${value}---longth:${value.length}---${this.isPhoneValid}`)
          })
          Divider()
        Row(){
          TextInput({placeholder:'短信验证码'}).borderRadius(0).backgroundColor(Color.Transparent).width(200).margin({left:-12,top:10})
            .maxLength(6).type(InputType.Number)
            .onChange((value:string)=>{
              this.verificationCode=value
            })
          Button(this.verificationButtonText).backgroundColor(Color.Transparent).fontColor('#ff2588f8')
            .enabled(!this.isCountDown)
            .onClick((event: ClickEvent) => {
              if (!this.isPhoneValid) {
                this.getUIContext().getPromptAction().showToast({
                  message:'请输入正确的手机号',
                  duration:3000
                })
                return
              }
              this.getUIContext().getPromptAction().showToast({
                message:'验证码已发送'

              })
              this.startCountdown()
              const code=Math.floor(100000+Math.random()*900000).toString()
              console.log('本次验证码',code)
              this.generatedCode=code
              this.startCountdown()
            })

        }.width('100%').justifyContent(FlexAlign.SpaceBetween)
        Divider()


      }.width('100%').padding(12).height(120)
      Blank()
      Row(){
        Button('下一步>').fontSize(18).backgroundColor(Color.Transparent).fontColor(this.isPhoneValid?Color.Black:Color.Gray).enabled(this.isPhoneValid)
      }.width('100%').justifyContent(FlexAlign.End).padding(12)
      .onClick(()=>{
        if(!this.isPhoneValid){
          this.getUIContext().getPromptAction().showToast({
            message:'请输入正确的手机号'
          })
          return
        }
        if(!this.validateCode(this.verificationCode)){
          this.getUIContext().getPromptAction().showToast({
            message:'验证码错误'
          })
          return
        }
        router.pushUrl({
          url:"pages/RegisterPassword"
        })
      })
    }.width('100%').height('100%').alignItems(HorizontalAlign.Center).padding(12)
  }
}