import http from '@ohos.net.http';
import { HttpResponse } from "../types/HttpResponse";

const BASE_URL='http://192.168.1.117:3000'
const HTTP_CONNECT_TIMEOUT = 10000
const HTTP_READ_TIMEOUT = 10000
const SERVER_NET_ERROR = '请求数据失败'

// 请求头：Record<string, string> 是 ArkTS 允许的显式类型
const HTTP_HEADERS: Record<string, string> = {
  'Content-Type': 'application/json',
}

export class HttpService {
  private static async httpRequest<T, R>(
    method: http.RequestMethod,
    apiUrl: string,
    extraData?: T
  ): Promise<HttpResponse<R>> {

    const httpReq = http.createHttp()

    const requestOptions: http.HttpRequestOptions = {
      method,
      connectTimeout: HTTP_CONNECT_TIMEOUT,
      readTimeout: HTTP_READ_TIMEOUT,
      expectDataType: http.HttpDataType.OBJECT,
      header: HTTP_HEADERS,
    }

    if (method !== http.RequestMethod.GET && extraData) {
      requestOptions.extraData = JSON.stringify(extraData)
    }

    try {
      const response = await httpReq.request(BASE_URL + apiUrl, requestOptions)
      return response.result as HttpResponse<R>
    } catch (error) {
      console.error(`HttpService error: ${JSON.stringify(error)}`)
      // 创建错误响应对象（data 用 ESObject 显式断言，满足 ArkTS 字面量规则）
      return {
        code: -1,
        message: SERVER_NET_ERROR,
        data: {} as ESObject,
        success: false
      } as HttpResponse<R>
    } finally {
      httpReq.destroy()
    }
  }

  public static get<R>(apiUrl: string): Promise<HttpResponse<R>> {
    return HttpService.httpRequest<undefined, R>(http.RequestMethod.GET, apiUrl)
  }

  public static post<T, R>(apiUrl: string, extraData: T): Promise<HttpResponse<R>> {
    return HttpService.httpRequest<T, R>(http.RequestMethod.POST, apiUrl, extraData)
  }

  public static put<T, R>(apiUrl: string, extraData: T): Promise<HttpResponse<R>> {
    return HttpService.httpRequest<T, R>(http.RequestMethod.PUT, apiUrl, extraData)
  }

  public static delete<R>(apiUrl: string): Promise<HttpResponse<R>> {
    return HttpService.httpRequest<undefined, R>(http.RequestMethod.DELETE, apiUrl)
  }
}
