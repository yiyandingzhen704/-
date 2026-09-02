import { USER_STORE , USER_INFO } from "../config/constants";
import { UserInfo } from "../types/UserInfo";
import { PreferenceUtils } from "../utils/PreferenceUtils";
import { JSON } from "@kit.ArkTS";
import { common } from "@kit.AbilityKit";


export class UserService{
static async setUserInfo(context:common.Context, userInfo:UserInfo){
    try {
      await PreferenceUtils.put(context,USER_STORE,USER_INFO,JSON.stringify(userInfo))
    }catch (error){
      console.error('UserService setUserInfo error:',JSON.stringify(error))
    }
  }
  static async getUserInfo(context:common.Context):Promise<UserInfo|null>{
    try {
      const userInfoStr= await PreferenceUtils.get(context,USER_STORE,USER_INFO) as string
      if (userInfoStr) {
        return await JSON.parse(userInfoStr) as UserInfo
      }
      return null
    }catch (error){
      console.error('UserService setUserInfo error:',JSON.stringify(error))
      return null
    }
  }

}
