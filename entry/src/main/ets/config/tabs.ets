export interface TabItem{
  title:string
  icon:Resource
  slcicon:Resource
  index:number
}
export interface homeTabItem{
  title:string
  index:number
}

export  const tabList:TabItem[]=[
  {
    title:'首页',
    icon:$r('app.media.home_icon'),
    slcicon:$r('app.media.home_icon_selected'),
    index:0
  },
  {
    title:'购物车',
    icon:$r('app.media.cart_icon'),
    slcicon:$r('app.media.cart_icon_selected'),
    index:1
  },
  {
    title:'我的',
    icon:$r('app.media.user_icon'),
    slcicon:$r('app.media.user_icon_selected'),
    index:2
  }

]

export const homeTabList: homeTabItem[] = [
  {title:'华为',index:0},
  {title:'鸿蒙智行',index:1},
  {title:'华为商城',index:2},
  {title:'更多生态',index:3},
]
