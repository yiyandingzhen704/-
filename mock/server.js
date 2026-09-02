// json-server 中间件：把每个接口的返回包装成 App 期望的统一格式
// { code: 200, message: "success", data: <原数据>, success: true }
module.exports = (req, res, next) => {
  const originalSend = res.send.bind(res)
  res.send = (body) => {
    // 只包装成功的 JSON 数据响应；错误响应（如 404）原样返回，不伪装成成功
    if (res.statusCode >= 200 && res.statusCode < 300) {
      try {
        const data = JSON.parse(body)
        const wrapped = JSON.stringify({
          code: 200,
          message: 'success',
          data: data,
          success: true
        })
        originalSend(wrapped)
        return
      } catch (e) {
        // 非 JSON，走原样返回
      }
    }
    originalSend(body)
  }
  next()
}
