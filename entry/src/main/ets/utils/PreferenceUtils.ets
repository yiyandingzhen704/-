import  Preferences from "@ohos.data.preferences";
import { common } from "@kit.AbilityKit";
export  class PreferenceUtils{
 static  async put(context:common.Context,storeName:string,key:string,value:Preferences.ValueType)
  {
    try {
      const dataPreferences = await Preferences.getPreferences(context,storeName)
      await dataPreferences.put(key,value)
      await dataPreferences.flush()
    }catch (error){
      console.error('PreferenceUtils put error:',JSON.stringify(error))
    }
  }
  static async get(context:common.Context,storeName:string,key:string):Promise<Preferences.ValueType|null>
  {
    try {
      const dataPreferences = await Preferences.getPreferences(context,storeName)
      return await dataPreferences.get(key,'')
    }catch (error){
      console.error('PreferenceUtils get error',JSON.stringify(error))
      return null
    }
  }
static async delete(context:common.Context,storeName:string,key:string){
   try {
     const dataPreferences = await Preferences.getPreferences(context,storeName)
     await dataPreferences.delete(key)
     await dataPreferences.flush()
   }catch (error){
     console.error('PreferenceUtils delete error:',JSON.stringify(error))
   }
}
}
