export interface HttpResponse<T = ESObject> {
  code: number
  message: string
  data: T
  success?: boolean
}